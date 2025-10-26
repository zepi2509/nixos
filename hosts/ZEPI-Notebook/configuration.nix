# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

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
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = pkgs.minimal-grub-theme;
        splashImage = null;
        extraConfig = ''
          set timeout_style=hidden
        '';
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    plymouth = {
      enable = true;
      theme = "black_hud";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "black_hud" ];
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = false;
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "splash"
    ];
  };

  networking = {
    hostName = "ZEPI-Notebook";
    networkmanager = {
      enable = true;
    };
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
