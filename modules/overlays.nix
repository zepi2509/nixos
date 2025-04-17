{ config, lib, ... }:
with lib;
{
  options.customization.overlays = {
    enable = mkEnableOption "custom overlays";
  };

  config = mkIf config.customization.overlays.enable {
    nixpkgs.overlays = [
      (import ../overlays)
    ];
  };
}
