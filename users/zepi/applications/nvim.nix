{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfiles = config.lib.file.mkOutOfStoreSymlink ../.dotfiles;
in
{
  programs.neovim = {
    enable = true;
    extraLuaConfig = lib.fileContents "${dotfiles}/nvim/init.lua";
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
    "nvim".source = "${dotfiles}/nvim";
    "nvim/init.lua".enable = false;
  };
}
