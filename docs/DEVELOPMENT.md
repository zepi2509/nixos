# Development Guide

This guide explains how to develop and maintain this NixOS configuration.

## Development Workflow

### 1. Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/description
   ```

2. **Edit configuration files** in your preferred editor

3. **Test your changes** (see Testing section below)

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: describe your change"
   ```

### 2. Testing

Before committing, always test your changes:

```bash
# Test without switching to new generation
sudo nixos-rebuild test --flake .#ZEPI-Notebook

# If test passes, build and switch
sudo nixos-rebuild switch --flake .#ZEPI-Notebook
```

**Common test scenarios:**

```bash
# Test boot configuration without loading
sudo nixos-rebuild boot --flake .#ZEPI-Notebook

# Check flake syntax and evaluation
nix flake check

# Validate specific configuration
nix eval --json .#nixosConfigurations.ZEPI-Notebook

# Show what would change (dry-run)
sudo nixos-rebuild dry-activate --flake .#ZEPI-Notebook
```

### 3. Debugging Build Failures

**General troubleshooting:**

```bash
# Get more verbose output
sudo nixos-rebuild switch --flake .#ZEPI-Notebook --show-trace

# Check for evaluation errors
nix eval --json .#nixosConfigurations.ZEPI-Notebook --show-trace

# Clear cache and rebuild
nix-store --gc
sudo nixos-rebuild switch --flake .#ZEPI-Notebook
```

**Common issues:**

- **Dotfiles missing**: Clone the dotfiles repository first
  ```bash
  git clone git@github.com:zepi2509/dotfiles.git ~/.dotfiles
  ```

- **SSH key issues**: Ensure SSH key is loaded
  ```bash
  ssh-add ~/.ssh/github_key
  ```

- **Flake lock issues**: Update lock file
  ```bash
  nix flake update
  ```

## Module Development

### Adding a New Module

1. **Create module directory** in `modules/`:
   ```bash
   mkdir -p modules/my-feature
   echo '{...}: {}' > modules/my-feature/default.nix
   ```

2. **Implement the module** in `modules/my-feature/default.nix`:
   ```nix
   {config, lib, pkgs, ...}: {
     options.myFeature = {
       enable = lib.mkEnableOption "my feature";
       option1 = lib.mkOption {
         type = lib.types.str;
         default = "default value";
       };
     };

     config = lib.mkIf config.myFeature.enable {
       # Configuration here
     };
   }
   ```

3. **Import in parent module** or host configuration:
   ```nix
   imports = [
     ./my-feature
   ];
   ```

### Module Structure

- **`./modules/default.nix`**: Core system settings (enable flakes, Nix settings)
- **`./modules/packages.nix`**: System-wide packages
- **`./modules/desktop/`**: Desktop environment modules
- **`./modules/services/`**: System services (networking, sound, etc.)
- **`./modules/languages/`**: Language toolchains
- **`./modules/impermanence.nix`**: Ephemeral filesystem setup
- **`./modules/home-manager.nix`**: Home Manager integration

## Managing Secrets

### Using sops-nix

sops-nix enables encrypted secret management with age encryption.

**Prerequisites:**
1. Age private key must exist at `/var/lib/sops-nix/key.txt`
2. Public key must be configured in `.sops.yaml`

**Setup (first time only):**

```bash
# Generate age key pair
mkdir -p /var/lib/sops-nix
age-keygen -o /var/lib/sops-nix/key.txt

# Extract public key and add to .sops.yaml
cat /var/lib/sops-nix/key.txt | grep "# public key:"

# Set permissions
sudo chmod 600 /var/lib/sops-nix/key.txt
```

**Adding Secrets:**

1. **Create/edit secrets file**:
   ```bash
   sops secrets/secrets.yaml
   ```

2. **Add encrypted secrets** (sops will auto-encrypt):
   ```yaml
   zepi:
     hashedPassword: your_hashed_password_here
     apiKey: your_api_key_here
   ```

3. **Reference in configuration**:
   ```nix
   users.users.zepi = {
     hashedPasswordFile = config.sops.secrets."zepi.hashedPassword".path;
   };
   ```

4. **Grant permissions** (if needed):
   ```nix
   sops.secrets."zepi.hashedPassword" = {
     owner = "root";
     mode = "0600";
   };
   ```

**Viewing encrypted secrets:**
```bash
# View decrypted content (requires age key)
sops -d secrets/secrets.yaml

# Edit secrets (auto-encrypts on save)
sops secrets/secrets.yaml
```

### Age Key Management

- **Public key**: In `.sops.yaml` (safe to commit)
- **Private key**: At `/var/lib/sops-nix/key.txt` (NEVER commit, already in .gitignore)
- **Permissions**: Must be `0600` (`chmod 600 /var/lib/sops-nix/key.txt`)
- **Backup**: Keep backup of private key in secure location

### Common Issues

**"Cannot decrypt secrets" error:**
- Age private key not found at `/var/lib/sops-nix/key.txt`
- Check file exists and permissions are 0600
- Verify public key in `.sops.yaml` matches private key

**"No encryption key found" when editing:**
- sops needs your age private key to encrypt
- Ensure `/var/lib/sops-nix/key.txt` exists and is readable

## Adding a New Host

1. **Create host directory:**
   ```bash
   mkdir -p hosts/MY-Host
   ```

2. **Create hardware configuration:**
   ```bash
   sudo nixos-generate-config --root /mnt --dir hosts/MY-Host
   ```

3. **Create `default.nix`:**
   ```nix
   {...}: {
     imports = [
       ./hardware-configuration.nix
       ../../modules
       ../../modules/services
       # Add more imports as needed
     ];

     networking.hostName = "MY-Host";
     # Additional configuration
   }
   ```

4. **Add to flake.nix:**
   ```nix
   nixosConfigurations."MY-Host" = nixpkgs.lib.nixosSystem {
     specialArgs = {inherit inputs;};
     modules = [
       {_module.args.device = "/dev/sdX";}
       ./hosts/MY-Host
     ];
   };
   ```

5. **Test the new configuration:**
   ```bash
   sudo nixos-rebuild test --flake .#MY-Host
   ```

## Home Manager Configuration

User-specific settings are managed via Home Manager in `users/zepi/`.

### Adding User Applications

Edit `users/zepi/applications/default.nix`:

```nix
{config, lib, pkgs, ...}: {
  programs.vim.enable = true;
  programs.vim.settings = {
    number = true;
  };
}
```

### Adding User Services

Create `users/zepi/services/my-service.nix`:

```nix
{config, lib, ...}: {
  systemd.user.services.my-service = {
    Unit = {
      Description = "My Service";
    };
    Service = {
      ExecStart = "${pkgs.myservice}/bin/myservice";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
```

## Managing Dependencies

### Flake Inputs

Add new input to `flake.nix`:

```nix
inputs = {
  my-project = {
    url = "github:user/project";
    inputs.nixpkgs.follows = "nixpkgs";  # Share nixpkgs with main config
  };
};
```

### Pinning Versions

To use a specific version:

```nix
inputs.nixpkgs.url = "github:nixos/nixpkgs/commit/SPECIFIC_COMMIT";
```

### Updating Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Check what changed
git diff flake.lock
```

## Dotfiles Integration

This configuration reads from `~/.dotfiles/` for application configurations.

### Referencing Dotfiles

In Nix configurations:

```nix
# Safe read that returns placeholder if file doesn't exist
settings = fromTOML (readDotfiles "helix/config.toml");

# Or create symlink for live editing
home.file.".config/myapp/config".source = mkDotfilesOutOfStore "myapp/config";
```

## Git Workflow

### Commit Message Format

Follow Conventional Commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

**Examples:**
```
feat(desktop): add hyprland window manager
fix(firewall): document open ports
docs: improve README with installation steps
refactor(modules): simplify package organization
```

### Pull Request Process

1. Create feature branch from `main`
2. Make changes and test thoroughly
3. Push branch and create pull request
4. Ensure CI checks pass (once set up)
5. Request review if applicable
6. Merge when approved

## Performance Optimization

### Profile Evaluation Time

```bash
nix flake check --timing-info | sort -k2 -rn | head -20
```

### Reduce Build Time

1. **Use cachix for faster downloads:**
   ```bash
   cachix use nixpkgs-mozilla  # Example cache
   ```

2. **Garbage collect old generations:**
   ```bash
   sudo nix-collect-garbage -d
   ```

3. **Profile slow builds:**
   ```bash
   nix build .#nixosConfigurations.ZEPI-Notebook.config.system.build.toplevel --profile /tmp/profile
   ```

## Testing

### Manual Testing

```bash
# Test current configuration
sudo nixos-rebuild test --flake .#ZEPI-Notebook

# Switch to new generation
sudo nixos-rebuild switch --flake .#ZEPI-Notebook

# Rollback if needed
sudo nixos-rebuild switch --rollback
```

### Automated Testing (Future)

Tests should be added to `tests/` directory using nixos-lib:

```nix
# tests/modules/services-test.nix
{pkgs, ...}: {
  services.my-service.enable = true;

  # Test assertions here
}
```

## Common Commands Reference

```bash
# System
sudo nixos-rebuild test --flake .          # Test changes
sudo nixos-rebuild switch --flake .        # Apply changes
sudo nixos-rebuild boot --flake .          # Apply on next boot
sudo nixos-rebuild switch --rollback       # Rollback

# Flakes
nix flake show                              # Show configurations
nix flake check                             # Check validity
nix flake update                            # Update lock file
nix flake lock --update-input nixpkgs      # Update specific input

# Home Manager
home-manager switch --flake .               # Apply user config
home-manager generations                    # Show generations

# Secrets
sops secrets/secrets.yaml                   # Edit secrets
sops -d secrets/secrets.yaml                # Decrypt secrets

# Diagnostics
nixos-rebuild --help
nix flake --help
home-manager --help
```

## Troubleshooting

### Build Hangs

Press Ctrl+C and check logs:
```bash
journalctl -u system-rebuild
```

### Activator Script Fails

If activation fails during switch:
```bash
# Test activation without switching
sudo nixos-rebuild dry-activate --flake .
```

### Out of Disk Space

```bash
sudo nix-store --gc --max-freed 5G
```

### SSH Issues with Dotfiles

Ensure SSH key is loaded:
```bash
ssh-add ~/.ssh/github_key
ssh -T git@github.com  # Test connection
```

## Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [sops-nix](https://github.com/Mic92/sops-nix)

## Questions or Issues?

See [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common problems and solutions.
