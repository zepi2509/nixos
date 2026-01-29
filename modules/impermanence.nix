{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModule.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  home-manager.users.zepi = {
    imports = [ inputs.impermanence.homeManagerModules.impermanence ];

    home.persistence."/persist/home/zepi" = {
      directories = [
        ".nixos"
        ".dotfiles"
        ".onedrive"
        ".ssh"
        ".zen"
        ".config/chromium"
        ".local/share/keyrings"
      ];
      allowOther = true;
    };
  };
}
