{ lib, ... }:
let
  files = lib.filterAttrs (
    name: type:
    type == "regular" && name != "default.nix" && !lib.hasPrefix "_" name && lib.hasSuffix ".nix" name
  ) (builtins.readDir ./.);

  imports = lib.mapAttrsToList (name: _: import (./. + "/${name}")) files;
in
{
  inherit imports;
}
