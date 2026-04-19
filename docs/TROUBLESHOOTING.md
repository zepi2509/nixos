# Troubleshooting Guide

This guide covers common issues and their solutions.

## Build and Configuration Issues

### Build Failures

**Problem**: `sudo nixos-rebuild switch` fails with various errors

**Solutions**:

1. **Check for syntax errors**:
   ```bash
   nix flake check
   ```

2. **Update flake lock file** (may fix dependency issues):
   ```bash
   nix flake update
   ```

3. **Get more verbose output** to identify the problem:
   ```bash
   sudo nixos-rebuild switch --flake . --show-trace
   ```

4. **Check available disk space** (NixOS can require significant space during builds):
   ```bash
   df -h
   nix-store --gc  # Run garbage collection if needed
   ```

### Dotfiles Not Found Error

**Problem**: Error about missing helix config, starship config, or other dotfiles

**Cause**: Dotfiles repository hasn't been cloned yet or is in wrong location

**Solution**:
```bash
# Clone dotfiles to the expected location
git clone git@github.com:zepi2509/dotfiles.git ~/.dotfiles

# Then rebuild
sudo nixos-rebuild switch --flake .
```

### SSH Key Not Available

**Problem**: Dotfiles cloning fails with SSH errors during activation

**Cause**: SSH key isn't loaded or not configured properly

**Solution**:
```bash
# Check if SSH key is loaded
ssh-add -l

# If not, add it
ssh-add ~/.ssh/github_key  # or your key path

# Test connection
ssh -T git@github.com

# Try rebuild again
sudo nixos-rebuild switch --flake .
```

### Flake Lock Conflicts

**Problem**: `git diff flake.lock` shows many changes after build

**Cause**: Flake lock file got updated unexpectedly

**Solution**:
```bash
# Review changes carefully
git diff flake.lock

# If changes are unwanted, revert
git checkout flake.lock

# If you want to update (intentionally), commit the changes
git add flake.lock
git commit -m "chore: update flake lock file"
```

---

## Runtime Issues

### System Won't Boot

**Problem**: System hangs at boot or shows initrd errors

**Cause**: Usually related to kernel modules, boot configuration, or filesystem setup

**Solution**:

1. **Boot into previous generation**:
   - During boot, select an older generation from GRUB menu
   - Or from command line: `nixos-rebuild switch --rollback`

2. **Test before switching** in future:
   ```bash
   sudo nixos-rebuild test --flake .
   ```

3. **Check boot configuration**:
   ```bash
   nix eval .#nixosConfigurations.ZEPI-Notebook.config.boot
   ```

### Services Won't Start

**Problem**: Systemd service fails on startup

**Solution**:

1. **Check service status**:
   ```bash
   systemctl status service-name
   journalctl -u service-name -n 50  # Last 50 lines
   ```

2. **For user services**:
   ```bash
   systemctl --user status service-name
   journalctl --user -u service-name -n 50
   ```

3. **Check service configuration**:
   ```bash
   nix eval .#nixosConfigurations.ZEPI-Notebook.config.systemd.services.service-name
   ```

### Auto-Commit Service Issues

**Problem**: Dotfiles not being auto-committed

**Solution**:

1. **Check if service is running**:
   ```bash
   systemctl --user status dotfiles-auto-commit
   ```

2. **View service logs**:
   ```bash
   journalctl --user -u dotfiles-auto-commit -n 100
   ```

3. **Manually start the service**:
   ```bash
   systemctl --user start dotfiles-auto-commit
   ```

4. **Ensure watch directory exists**:
   ```bash
   ls -la ~/.dotfiles
   ```

### Permission Denied Errors

**Problem**: Permission errors when accessing files or running commands

**Common causes**:
- User not in required group (wheel, video, libvirt, etc.)
- File permissions too restrictive
- sops key file permissions

**Solution**:

1. **Check user groups**:
   ```bash
   groups $USER
   ```

2. **Add to group** (requires logout/login or use `newgrp`):
   ```bash
   sudo usermod -aG groupname $USER
   newgrp groupname
   ```

3. **Fix sops key permissions**:
   ```bash
   sudo chmod 600 /var/lib/sops-nix/key.txt
   ```

---

## Secrets and Security Issues

### Cannot Decrypt Secrets

**Problem**: `sops: error decrypting file` when trying to edit secrets

**Cause**: Age key not accessible or not configured

**Solution**:

1. **Check age key exists**:
   ```bash
   ls -la /var/lib/sops-nix/key.txt
   ```

2. **Fix permissions** (must be 0600):
   ```bash
   sudo chmod 600 /var/lib/sops-nix/key.txt
   ```

3. **Verify key in .sops.yaml matches**:
   ```bash
   cat /var/lib/sops-nix/key.txt | grep "public key:"
   # Should match the key in .sops.yaml
   ```

4. **If key is missing**, generate new one:
   ```bash
   mkdir -p /var/lib/sops-nix
   age-keygen -o /var/lib/sops-nix/key.txt
   sudo chmod 600 /var/lib/sops-nix/key.txt
   ```

### Plaintext Secrets in Git

**Problem**: Worried that plaintext secrets were committed

**Check**:
```bash
# Search for hardcoded passwords or secrets
git log -p -S "password\|secret\|key" | grep -i "^+.*password"

# Check current files
git grep -i "password\|secret" -- '*.nix' '*.yaml'
```

**Prevention**:
- Use sops-nix for all sensitive data
- Never commit plaintext passwords
- Keep `.gitignore` updated to exclude secrets

---

## Package and Module Issues

### Package Not Found

**Problem**: Package not available in nixpkgs

**Solutions**:

1. **Search for correct package name**:
   ```bash
   nix search nixpkgs package-name
   ```

2. **Check if it's only in NUR** (Nix User Repository):
   - May need to add NUR input and overlay

3. **Create custom package/overlay**:
   ```nix
   # In overlays/custom.nix
   final: prev: {
     mypackage = prev.callPackage /path/to/package.nix {};
   }
   ```

### Module Import Errors

**Problem**: `undefined variable` or module not found

**Cause**: Module not imported or not exported properly

**Solution**:

1. **Check imports in default.nix**:
   ```bash
   grep -r "imports = " modules/
   ```

2. **Ensure module has correct structure**:
   ```nix
   {config, lib, pkgs, ...}: {
     # Configuration here
   }
   ```

3. **Check module exports** (for custom modules):
   ```bash
   nix eval -f <(cat module.nix) --apply "x: builtins.attrNames x"
   ```

### Conflicting Options

**Problem**: Configuration conflict - two modules setting same option

**Solution**:

1. **Identify which modules**:
   ```bash
   nix eval .#nixosConfigurations.ZEPI-Notebook.config.some.option --show-trace
   ```

2. **Use mkDefault/mkForce** to resolve:
   ```nix
   # First module
   myOption = lib.mkDefault "value";
   
   # Later module (overrides)
   myOption = lib.mkForce "override";
   ```

---

## Virtual Machine Issues

### VM Performance Problems

**Problem**: VM is slow or unresponsive

**Solutions**:

1. **Allocate more resources**:
   ```bash
   # Edit VM configuration (virt-manager GUI) or
   virsh edit ZEPI-Notebook-VM
   ```

2. **Enable nested virtualization** (if using VM on VM):
   ```xml
   <cpu mode='host-passthrough'>
     <feature policy='require' name='vmx'/>
   </cpu>
   ```

3. **Use virtio drivers**:
   - Already configured in flake.nix
   - Ensure `boot.initrd.availableKernelModules` includes virtio modules

### VM Network Disconnected

**Problem**: VM can't reach network or host

**Solutions**:

1. **Check network setup**:
   ```bash
   # In VM
   ip addr show
   ping 8.8.8.8
   ```

2. **Check virt network**:
   ```bash
   virsh net-list
   virsh net-autostart default
   ```

---

## Performance Optimization

### Slow Flake Evaluation

**Problem**: `nix flake check` or rebuild takes very long

**Solutions**:

1. **Profile evaluation**:
   ```bash
   nix flake check --timing-info | sort -k2 -rn | head -10
   ```

2. **Reduce dynamic loading** (modules/services/default.nix):
   - Consider explicit imports instead of `builtins.readDir`

3. **Check for infinite recursion**:
   ```bash
   nix eval . --show-trace 2>&1 | head -50
   ```

### Slow Builds

**Problem**: Packages take very long to build

**Solutions**:

1. **Use cached substituters**:
   ```bash
   cachix use nixpkgs  # Requires cachix account
   ```

2. **Only rebuild changed packages**:
   ```bash
   nix flake update --commit-lock-file  # Update specific inputs only
   ```

3. **Build in parallel**:
   ```bash
   sudo nixos-rebuild switch --flake . -j4
   ```

---

## Debugging Tips

### Enable Debug Output

```bash
# Very verbose output
set -x  # In shell scripts
sudo nixos-rebuild switch --show-trace --verbose

# Check specific module
nix eval --show-trace .#nixosConfigurations.ZEPI-Notebook.config.services.myservice
```

### View Generated Configuration

```bash
# See actual system configuration
nix eval --json .#nixosConfigurations.ZEPI-Notebook.config | jq '.services' | less

# Check specific setting
nix eval .#nixosConfigurations.ZEPI-Notebook.config.boot.loader.grub.enable
```

### Log Files

```bash
# System logs
journalctl -xe  # Errors and recent logs
journalctl -u service-name -n 50  # Specific service

# User logs (for Home Manager)
journalctl --user -n 100

# Build logs
tail -f /var/log/nixos-rebuild.log
```

---

## Getting Help

When reporting issues, provide:

1. **NixOS version and commit**:
   ```bash
   nixos-version
   nix flake metadata
   ```

2. **Error message** (full output with `--show-trace`)

3. **Configuration** (relevant nix files)

4. **Reproduction steps**

5. **Logs** (from `journalctl`, build output, etc.)

### Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)
- [GitHub Issues](https://github.com/nixos/nixpkgs/issues)
- [NixOS Discourse](https://discourse.nixos.org/)
