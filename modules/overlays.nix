{
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  options.customization.overlays = {
    enable = mkEnableOption "custom overlays";
  };

  config = mkIf config.customization.overlays.enable {
    nixpkgs.overlays = [
      inputs.nur.overlays.default
      inputs.nix-cachyos-kernel.overlays.pinned
      (import ../overlays)
    ];
  };
}
