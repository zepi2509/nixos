{ pkgs, ... }:

{
  programs.virt-manager.enable = true;

  users.users."zepi" = {
    extraGroups = [
      "libvirtd"
      "podman"
    ];
  };

  environment.systemPackages = with pkgs; [
    (devcontainer.overrideAttrs (oldAttrs: {
      postInstall = ''
        makeWrapper "${lib.getExe nodejs}" "$out/bin/devcontainer" \
          --add-flags "$out/libexec/devcontainer.js" \
          --prefix PATH : ${
            lib.makeBinPath [
              git
              podman
              podman-compose
            ]
          }
      '';
    }))
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;

    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
