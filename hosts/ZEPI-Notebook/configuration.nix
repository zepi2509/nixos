# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    ../../modules
    ../../modules/home-manager.nix
    ../../modules/services
    ../../modules/services/virtualisation.nix
    ../../modules/desktop
    ../../modules/languages
    ../../users/zepi
  ];
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };

    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "ZEPI-Notebook";
    networkmanager.enable = true;
    extraHosts = ''
      192.168.178.25 dyndns.zepner.dev
    '';
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };


  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  system.stateVersion = "25.05";
}
