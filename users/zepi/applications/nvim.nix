{
  config,
  lib,
  mkDotfiles,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    extraLuaConfig = lib.fileContents (mkDotfiles "nvim/init.lua");
    extraLuaPackages =
      extraPkgs: with extraPkgs; [
        luarocks
      ];
    extraPackages = with pkgs; [
      nil
      nixfmt
      statix
    ];
  };

  xdg.configFile = {
    "nvim".source = mkDotfiles "nvim";
    "nvim/init.lua".enable = false;
  };
}
