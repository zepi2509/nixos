{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "com.github.iwalton3.jellyfin-media-player"
    ];
  };
}
