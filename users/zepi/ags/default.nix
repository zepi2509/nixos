{ inputs, pkgs, ...}:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    configDir = ./conf;

    extraPackages = with pkgs; [
      inputs.ags.packages.${system}.battery
      inputs.ags.packages.${system}.wireplumber
      inputs.ags.packages.${system}.network
      inputs.ags.packages.${system}.bluetooth
    ];
  };
}
