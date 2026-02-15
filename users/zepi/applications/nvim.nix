{
  lib,
  readDotfiles,
  mkDotfiles,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    initLua = readDotfiles "nvim/init.lua";
    extraLuaPackages = extraPkgs:
      with extraPkgs; [
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
