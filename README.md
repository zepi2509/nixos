# NixOS Configuration

A comprehensive, modular NixOS system configuration using Nix Flakes with Home Manager, featuring declarative desktop environment setup, secret management, and automated dotfiles synchronization.

## Features

- **Modular Architecture**: Organized modules for desktop, services, languages, and applications
- **Flake-based**: Modern reproducible builds with Nix Flakes and lock file pinning
- **Home Manager Integration**: User environment and dotfiles management
- **Secret Management**: sops-nix encrypted secrets for sensitive data
- **Ephemeral Systems**: Impermanence support for stateless root filesystem
- **Multiple Hosts**: Support for laptop, VM, and server configurations
- **Desktop Environment**: Hyprland window manager with Stylix theming
- **Automated Dotfiles Sync**: Service to keep dotfiles repository in sync

## System Configurations

### ZEPI-Notebook
Main laptop configuration with full desktop environment, applications, and services.

### ZEPI-Notebook-VM
Virtual machine variant of the notebook configuration for testing.

### ZEPI-Server
Minimal server configuration without desktop environment (incomplete - extend as needed).

## Quick Start

### Prerequisites

- Fresh NixOS installation (23.11 or later)
- Flakes enabled in nix.conf
- SSH key configured for GitHub access (for dotfiles cloning)

### Installation

1. **Clone this repository to `/etc/nixos` or preferred location:**

```bash
git clone https://github.com/zepi2509/nixos.git /home/zepi/.nixos
cd /home/zepi/.nixos
```

2. **Clone your dotfiles repository** (required for many configurations):

```bash
git clone git@github.com:zepi2509/dotfiles.git ~/.dotfiles
```

3. **Rebuild your system:**

```bash
sudo nixos-rebuild switch --flake .#ZEPI-Notebook
```

Replace `ZEPI-Notebook` with your desired configuration (see [System Configurations](#system-configurations)).

### Post-Installation

- **Initialize secrets** (if using sops-nix):
  ```bash
  # Copy your age key to the system
  sudo cp /path/to/age/key /var/lib/sops-nix/key.txt
  ```

- **Enable auto-commit service** (dotfiles synchronization):
  The service automatically commits changes to your dotfiles repository. Ensure your SSH key is loaded:
  ```bash
  ssh-add ~/.ssh/github_key
  ```

- **Configure impermanence** (if enabled):
  The root filesystem is ephemeral. Persistent directories are configured in `modules/impermanence.nix`. Add directories to persist as needed.

## Usage

### Rebuilding After Changes

```bash
# Test changes without switching
sudo nixos-rebuild test --flake .#ZEPI-Notebook

# Apply changes and set as boot target
sudo nixos-rebuild switch --flake .#ZEPI-Notebook

# Only set as boot target (apply on next reboot)
sudo nixos-rebuild boot --flake .#ZEPI-Notebook
```

### Adding Packages

Edit `modules/packages.nix` or the appropriate host-specific configuration:

```nix
environment.systemPackages = with pkgs; [
  vim
  git
  # Add your packages here
];
```

### Customizing User Configuration

User-specific settings are in `users/zepi/home.nix`. Use Home Manager modules for declarative configuration:

```nix
programs.vim.enable = true;
programs.git.userName = "Your Name";
```

### Managing Secrets

Sensitive data (passwords, API keys) should be managed via sops-nix:

1. **Create or edit secrets:**
   ```bash
   sops secrets/secrets.yaml
   ```

2. **Reference in configuration:**
   ```nix
   config.sops.secrets."my-secret".path
   ```

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for detailed instructions.

## Repository Structure

```
.
├── flake.nix                    # Flake configuration and inputs
├── flake.lock                   # Locked versions of all inputs
├── README.md                    # This file
├── .sops.yaml                   # Sops-nix encryption configuration
├── secrets/                     # Encrypted secrets (sops-nix)
├── hosts/
│   ├── ZEPI-Notebook/           # Laptop configuration
│   │   ├── default.nix          # Main configuration
│   │   └── hardware-configuration.nix
│   ├── ZEPI-Notebook-VM/        # VM configuration (symlinked from ZEPI-Notebook)
│   └── ZEPI-Server/             # Server configuration
├── modules/                     # Shared system modules
│   ├── default.nix              # Core system settings
│   ├── packages.nix             # System packages
│   ├── desktop/                 # Desktop environment modules
│   ├── services/                # Service configurations
│   ├── languages/               # Language and development tools
│   ├── impermanence.nix         # Ephemeral filesystem setup
│   ├── home-manager.nix         # Home Manager integration
│   └── ...
├── users/                       # User configurations (Home Manager)
│   └── zepi/
│       ├── default.nix          # User account and services
│       ├── home.nix             # Home Manager configuration
│       ├── applications/        # Application configurations
│       └── services/            # User services
├── overlays/                    # Nix package overlays
└── docs/                        # Additional documentation
    ├── DEVELOPMENT.md           # Development guidelines
    ├── MODULES.md               # Module documentation
    └── TROUBLESHOOTING.md       # Common issues and solutions
```

## Key Modules

### Desktop Environment
- **Hyprland**: Modern Wayland window manager
- **Stylix**: Declarative theming for all applications
- **Notifications**: Desktop notification daemon

### Services
- **Network**: Networking, VPN, and firewall configuration
- **Sound**: PipeWire audio with ALSA support
- **Display**: Multi-monitor setup and brightness control
- **Auto-commit**: Git service for automatic dotfiles synchronization

### Languages
- **Nix**: Language tools and libraries
- **Node.js**: Runtime and development tools
- **Python**: Python environment with common tools
- **Rust**: Rust toolchain

### Applications
- **Browser**: Zen Browser with configuration
- **Editor**: Helix with custom configuration from dotfiles
- **Terminal**: Caelestia shell with advanced configuration
- **Development**: Git, GitHub CLI, and other tools

## Troubleshooting

### Build Failures

**Dotfiles not cloned yet:**
```bash
git clone git@github.com:zepi2509/dotfiles.git ~/.dotfiles
```

**SSH key not available:**
Ensure your SSH key is loaded:
```bash
ssh-add ~/.ssh/github_key
```

**Flake lock issues:**
```bash
nix flake update
```

For more help, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## Security Considerations

### Secrets Management
- **Passwords and API keys** must be encrypted with sops-nix
- Never commit plaintext secrets to git
- Use age encryption with proper key management

### SSH Configuration
- Dotfiles repository cloning requires SSH key verification
- Ensure `known_hosts` contains GitHub's SSH fingerprint
- Consider using SSH key passphrases for added security

### Firewall
- TCP/UDP ports 4321 and 24727 are open (see firewall module for purposes)
- Additional ports can be configured in `modules/services/firewall.nix`

## Development

For guidelines on modifying this configuration, extending modules, or adding new hosts, see [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## Contributing

1. Create a feature branch
2. Make your changes
3. Test with `sudo nixos-rebuild test --flake .`
4. Commit following conventional commit format
5. Push and create a pull request

## Dependencies

### Required
- NixOS 23.11 or later
- Nix with Flakes enabled

### Key Inputs
- `nixpkgs`: System packages and libraries
- `home-manager`: User environment management
- `nixos-hardware`: Hardware-specific configurations
- `sops-nix`: Secret management
- `hyprland`: Window manager
- `stylix`: Theme management
- `disko`: Declarative partitioning
- `impermanence`: Ephemeral filesystem support

See `flake.nix` for complete list of inputs.

## Useful Commands

```bash
# Check flake validity
nix flake check

# Show available configurations
nix flake show

# Update flake lock file
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Garbage collect old generations
sudo nix-collect-garbage -d

# Show system generation history
nix-env -p /nix/var/nix/profiles/system --list-generations
```

## License

Specify your license here (e.g., MIT, GPL-3.0, etc.)

## Author

zepi <noah@zepner.dev>

---

For more information, see the additional documentation in `docs/`.
