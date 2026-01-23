{ ... }:

{
  programs.virt-manager.enable = true;

  users.users."zepi" = {
    extraGroups = [
      "libvirtd"
      "podman"
    ];
  };

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
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
