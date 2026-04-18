{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/cups"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/NetworkManager"
      "/var/lib/flatpak"
      "/var/lib/containers/storage"
      "/var/lib/systemd"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/adjtime"
      "/etc/machine-id"
    ];
  };

  home-manager.users.zepi = {
    home.persistence."/persist" = {
      directories = [
        # System config (declarative)
        ".nixos"
        ".dotfiles"

        # Security (critical)
        ".ssh"
        ".gnupg"
        ".pki"
        ".mcp-auth"

        # User data (irreplaceable)
        ".onedrive"
        ".obsidian"
        ".qemu"
        "Projects"

        # Application data (user-created state)
        ".config/AusweisApp"
        ".config/chromium"
        ".config/JetBrains"
        ".config/spotify"
        ".local/share/atuin"
        ".local/share/containers"
        ".local/share/flatpak"
        ".local/share/goose"
        ".local/share/JetBrains"
        ".local/share/keyrings"
        ".local/share/nautilus"
        ".local/share/zoxide"
        ".local/state"
        ".local/bin"
        ".zen"
        ".mozilla"
        ".zoom"
        ".local/state/opencode"
        ".local/share/opencode"
      ];
      files = [
      ];
    };
  };
}
