{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "zepi" ];
  # users.extraGroups.vboxusers.members = [ "zepi" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    # virtualbox.host.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
