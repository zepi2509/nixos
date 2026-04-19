# Module Documentation

This document describes all available modules in this NixOS configuration.

## Module Organization

Modules are organized into the following categories:

- **Core**: System-wide settings and core modules
- **Services**: System services (audio, networking, hardware, etc.)
- **Desktop**: Desktop environment and GUI applications
- **Languages**: Development language toolchains
- **Home Manager**: User environment configuration

## Core Modules

### `default.nix`
**Purpose**: Core system settings and global configuration

**Provides**:
- Nix flake settings
- NixOS system defaults
- Package management configuration
- Unfree package allowlist

**Options**:
- `nixpkgs.config.allowUnfree`: Allow unfree packages (default: true)

**Dependencies**: None (base module)

---

### `home-manager.nix`
**Purpose**: Integrates Home Manager for user environment management

**Provides**:
- Home Manager module loading
- User configuration context

**Requirements**:
- Home Manager input in flake.nix
- User configuration at `users/<username>/home.nix`

**Dependencies**: Imported by host configurations

---

### `impermanence.nix`
**Purpose**: Enables ephemeral root filesystem with selective persistence

**Provides**:
- Stateless system with only essential state persisted
- Automated cleanup and consistency

**Persistent Directories** (configurable):
- `/home` - User home directory
- `/etc/ssh` - SSH host keys
- `/var/lib/sops-nix` - Secrets keys
- `/var/cache/libvirt` - VM images
- And others (see module for full list)

**Usage**: Include in host configuration to enable stateless root

**Dependencies**: 
- `impermanence` flake input
- ZFS or btrfs filesystem (recommended)

---

### `overlays.nix`
**Purpose**: Package overlays for custom or patched packages

**Current State**: All overlays commented out (see module for details)

**Available Overlays** (disabled):
- `zen`: Zen Browser custom build
- `onedrive`: Microsoft OneDrive CLI

**To Enable**: Uncomment imports in this module

**Dependencies**: Custom overlay definitions in `overlays/` directory

---

## Service Modules

Services are located in `modules/services/` and provide system-level functionality.

### Audio (`audio.nix`)
**Purpose**: Sound system configuration

**Provides**:
- PipeWire audio server
- ALSA compatibility layer
- Bluetooth audio support

**Features**:
- Professional audio routing
- Low-latency configuration
- Device hotplug support

**Dependencies**: 
- `bluetooth.nix` (for Bluetooth audio)

---

### Bluetooth (`bluetooth.nix`)
**Purpose**: Bluetooth device support

**Provides**:
- BlueZ Bluetooth daemon
- Device pairing and management
- Audio codec support (SBC, AAC, aptX, LDAC)

**Configuration**:
- Hardware address randomization
- Fast connection
- BR/EDR and LE support

**Dependencies**: None

---

### Battery (`battery.nix`)
**Purpose**: Battery management for laptops

**Provides**:
- ACPI battery information
- Power profile daemon
- Battery threshold management

**Devices Supported**:
- Lenovo ThinkPad (native kernel support)
- Generic ACPI batteries

**Dependencies**: None

---

### Firewall (`firewall.nix`)
**Purpose**: Network firewall configuration

**Provides**:
- UFW-style firewall using nftables
- Port allowlisting
- Connection state tracking

**Open Ports**:
- TCP 4321: [TODO: Document service]
- TCP 24727: [TODO: Document service]
- UDP 4321: [TODO: Document service]
- UDP 24727: [TODO: Document service]

**Adding Ports**: Edit `allowedTCPPorts` and `allowedUDPPorts` arrays

**Dependencies**: None

---

### Git (`git.nix`)
**Purpose**: Git system configuration

**Provides**:
- Git installation
- Global git configuration
- SSH key management integration

**Configuration**:
```nix
user.name = "zepi"
user.email = "noah@zepner.dev"
core.editor = "vim"
```

**Dependencies**: SSH configuration (implicit)

---

### GVFS (`gvfs.nix`)
**Purpose**: Virtual filesystem abstraction

**Provides**:
- MTP device support (Android phones, tablets)
- SFTP mounting
- Cloud storage integration

**Use Cases**:
- File manager access to Android devices
- Remote mounting via SSH

**Dependencies**: None

---

### Keymap (`keymap.nix`)
**Purpose**: Keyboard layout configuration

**Provides**:
- X11 and Wayland keyboard layout
- Default keyboard model

**Configuration**:
- Layout: German (de)
- Model: Standard

**To Change**: Edit `xserver.layout` and `console.keyMap`

**Dependencies**: None

---

### OneDrive (`onedrive.nix`)
**Purpose**: OneDrive client integration

**Provides**:
- OneDrive CLI client
- Automatic sync service

**Setup Required**:
```bash
onedrive -a  # Authenticate
onedrive -m  # Monitor (daemon mode)
```

**Sync Directory**: `~/.onedrive/`

**Dependencies**: None (optional service)

---

### Playerctl (`playerctl.nix`)
**Purpose**: Media player control

**Provides**:
- Cross-application media control
- Play/pause/next/previous support

**Supported Players**:
- Spotify
- MPRIS-compatible players
- YouTube (in browser)

**Usage**: `playerctl play-pause`, `playerctl next`, etc.

**Dependencies**: None

---

### Power (`power.nix`)
**Purpose**: Power management and sleep behavior

**Provides**:
- Suspend/hibernate configuration
- Lid close behavior
- Power button handling

**Behavior**:
- Lid close: suspend
- Power button: poweroff

**Dependencies**: systemd (automatic)

---

### Printing (`printing.nix`)
**Purpose**: CUPS printing support

**Provides**:
- CUPS daemon
- IPP Everywhere printer support
- Avahi printer discovery

**Setup**: 
1. Plug in or network printer
2. Access CUPS web interface at `http://localhost:631`
3. Add printer

**Dependencies**: Avahi (mDNS, implicit)

---

### Secret Service (`secretservice.nix`)
**Purpose**: Desktop secret storage integration

**Provides**:
- DBus secret service
- Password/credential storage
- GNOME Keyring compatibility

**Use Cases**:
- Store credentials for applications
- Git credential helper
- SSH key passphrases

**Dependencies**: dbus (automatic)

---

### sops-nix (`sops.nix`)
**Purpose**: Secrets management using age encryption

**Provides**:
- Declarative secrets
- Age encryption
- Automated secret injection at activation

**Configuration**:
- Secrets file: `secrets/secrets.yaml`
- Age key: `/var/lib/sops-nix/key.txt`

**Usage Example**:
```nix
config.sops.secrets."my-secret".path
```

**Dependencies**: 
- `sops-nix` flake input
- Age private key configured

---

### Virtualisation (`virtualisation.nix`)
**Purpose**: Virtual machine support

**Provides**:
- QEMU/KVM hypervisor
- Libvirt daemon
- Virt-manager GUI
- VirtualBox support

**Setup**:
```bash
# Add user to libvirt group
sudo usermod -aG libvirt zepi
newgrp libvirt
```

**Usage**: 
- `virt-manager` for GUI
- `virsh` for CLI

**Dependencies**: None (optional)

---

### XDG (`xdg.nix`)
**Purpose**: XDG Base Directory specification compliance

**Provides**:
- Standard directory paths
- User data locations
- Application config directories

**Standard Directories**:
- `~/.config` - Application configs
- `~/.local/share` - Application data
- `~/.local/state` - Application state
- `~/.cache` - Cache files

**Dependencies**: None

---

## Desktop Modules

Desktop environment modules located in `modules/desktop/`.

### Backlight (`backlight.nix`)
**Purpose**: Display brightness control

**Provides**:
- Backlight control service
- Automatic brightness adjustment
- Hardware brightness control

**Hardware Support**:
- Intel laptop backlight (ACPI)
- USB display adapters
- Generic PWM backlight

**Dependencies**: None

---

### Fonts (`fonts.nix`)
**Purpose**: Font configuration and installation

**Provides**:
- System-wide font packages
- CJK font support
- Monospace and sans-serif defaults

**Installed Fonts**:
- Noto Sans (sans-serif)
- JetBrains Mono (monospace)
- CJK support (Chinese, Japanese, Korean)
- Emoji fonts

**Default Font**: Noto Sans

**Dependencies**: Fontconfig (automatic)

---

### Hyprland (`hyprland.nix`)
**Purpose**: Hyprland window manager configuration

**Provides**:
- Wayland compositor
- Window management
- Keybindings
- Multi-monitor support

**Key Features**:
- Tiling window manager
- Virtual desktops
- Eye candy animations
- Performance optimized

**Configuration**: 
- Located in dotfiles (`.dotfiles/hyprland/`)
- Runtime config in `~/.config/hypr/hyprland.conf`

**Dependencies**: 
- `hyprland` flake input
- XDG Base Directory module

---

### Hypridle (`hypridle.nix`)
**Purpose**: Idle action daemon

**Provides**:
- Automatic lock on idle
- Screen blanking
- Suspend after idle

**Idle Timers**:
- 150s: Lock screen
- 300s: Screen blank
- 330s: Keyboard backlight off (if applicable)
- 1800s: Suspend to RAM

**Requires**: 
- GNOME Keyring (for lock)
- Hyprland session

**Dependencies**: Hyprland

---

### Notifications (`notifcations.nix`)
**Purpose**: Desktop notification daemon

**Provides**:
- Dunst notification server
- Notification display and layout
- Urgency levels

**Configuration**:
- Located in dotfiles (`.dotfiles/dunst/`)
- Window positioning and theming

**Supports**:
- Sound notifications
- Action buttons
- Notification history

**Dependencies**: None

---

### Steam (`steam.nix`)
**Purpose**: Gaming platform integration

**Provides**:
- Steam client
- Proton compatibility layer
- 32-bit library support

**Features**:
- Native Linux games
- Windows game support via Proton
- Controller configuration

**Additional Setup**:
- Enable Proton in Steam settings
- Configure controller support

**Dependencies**: 
- Fontconfig
- OpenGL drivers (implicit)

---

### Stylix (`stylix.nix`)
**Purpose**: Declarative theming system

**Provides**:
- Unified color scheme across applications
- Theme generation from palette
- Automatic light/dark mode support

**Configuration**:
- Color scheme definition
- Wallpaper management
- Application theme overrides

**Features**:
- Regenerates themes on color change
- Gradual color transitions
- Per-application customization

**Dependencies**: 
- `stylix` flake input
- Image files for wallpaper

---

## Language Modules

Language support modules in `modules/languages/`.

### Node.js (`node.nix`)
**Purpose**: JavaScript/Node.js development

**Provides**:
- Node.js runtime
- npm package manager
- TypeScript support
- Development tools

**Installed Tools**:
- Node LTS version
- pnpm (faster package manager)
- npm (standard package manager)

**Optional Packages** (commented):
- TypeScript compiler
- ESLint
- Prettier

**Dependencies**: None

---

### Python (`python.nix`)
**Purpose**: Python development environment

**Provides**:
- Python 3.x runtime
- pip package manager
- Development tools

**Installed Tools**:
- Python 3
- Poetry (dependency management)
- Virtualenv (environment isolation)
- Common development tools

**Usage**:
```bash
poetry new my-project
poetry add package-name
poetry run python script.py
```

**Dependencies**: None

---

### Languages default (`languages/default.nix`)
**Purpose**: Language module aggregator

**Behavior**: Dynamically imports all language-specific modules

**Discovered Modules**: Node, Python, and others

**Extension**: Add new `<language>.nix` files to auto-import

---

## Shell Module

### Shell (`modules/shell/default.nix`)
**Purpose**: Shell configuration and tools

**Provides**:
- Shell aliases and functions
- Command-line tools
- Prompt configuration

**Shells Configured**:
- Nushell (default user shell)
- Bash (system shell)

**Tools Included**:
- Caelestia shell configuration
- Starship prompt (currently disabled)
- Common CLI utilities

**To Enable Starship**: Uncomment in module

**Dependencies**: 
- Caelestia shell input
- Appropriate shell packages

---

## Module Dependencies Map

```
default.nix (base)
├── services/
│   ├── sops.nix
│   ├── firewall.nix
│   ├── audio.nix
│   │   └── bluetooth.nix
│   ├── printing.nix
│   ├── onedrive.nix
│   ├── virtualisation.nix
│   └── ... (other services)
├── desktop/
│   ├── hyprland.nix
│   ├── hypridle.nix
│   ├── stylix.nix
│   ├── fonts.nix
│   ├── notifications.nix
│   ├── steam.nix
│   └── backlight.nix
├── languages/
│   ├── node.nix
│   ├── python.nix
│   └── ... (other languages)
├── home-manager.nix
├── impermanence.nix
└── overlays.nix
```

## Creating Custom Modules

To create a new module:

1. **Create module file** in appropriate directory:
   ```bash
   touch modules/myfeature/default.nix
   ```

2. **Define module structure**:
   ```nix
   {config, lib, pkgs, ...}: {
     options.myfeature = {
       enable = lib.mkEnableOption "my feature";
       option1 = lib.mkOption {
         type = lib.types.str;
         default = "value";
       };
     };

     config = lib.mkIf config.myfeature.enable {
       # Configuration implementation
     };
   }
   ```

3. **Import module** in parent:
   - For dynamic loading (recommended): Place in `default.nix` directory - auto-imported
   - For explicit: Add to host configuration imports

4. **Test the module**:
   ```bash
   sudo nixos-rebuild test --flake .
   ```

## Module Configuration Examples

### Enable a Service Module
```nix
# In host configuration or modules/default.nix
services.printing.enable = true;
```

### Override Module Options
```nix
# In host configuration
desktop.hyprland.enable = true;
programs.steam.enable = true;
```

### Disable a Module
```nix
# Explicitly disable (if using `mkDefault`)
services.onedrive.enable = lib.mkForce false;
```

## Debugging Modules

```bash
# Show module configuration
nix eval .#nixosConfigurations.ZEPI-Notebook.config.services.printing

# Check module dependencies
nix flake check

# Show evaluation errors
nix eval --show-trace .#nixosConfigurations.ZEPI-Notebook
```

## Best Practices

1. **Use meaningful names**: Module files should clearly indicate their purpose
2. **Document options**: Add descriptions to all `lib.mkOption` definitions
3. **Keep modules focused**: Single responsibility principle
4. **Use mkDefault**: Allow host-level overrides with `lib.mkDefault`
5. **Test changes**: Always test with `nixos-rebuild test` before switching
6. **Update documentation**: Keep this file in sync with module changes

---

For more information about specific modules, refer to inline comments in their configuration files.
