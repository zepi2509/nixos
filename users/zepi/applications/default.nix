{ lib, pkgs, ... }:
let
  files = lib.filterAttrs (
    name: type:
    type == "regular" && name != "default.nix" && !lib.hasPrefix "_" name && lib.hasSuffix ".nix" name
  ) (builtins.readDir ./.);

  imports = lib.mapAttrsToList (name: _: import (./. + "/${name}")) files;
in
{
  inherit imports;

  home.packages = with pkgs; [
    # Tools
    carapace
    yazi
    p7zip
    unzip
    ripgrep
    fd
    wget
    cliphist
    tree-sitter
    pnpm
    eyedropper
    onefetch
    typst

    # Apps
    jetbrains-toolbox
    spotify
    ausweisapp
    zathura
    nautilus
    zoom-us
    signal-desktop
    obsidian
    zotero

    # Languages
    typst
    tinymist
    zig
    cargo
    gcc
    go
    mermaid-cli
  ];
}
