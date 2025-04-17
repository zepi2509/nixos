{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (lua51Packages.lua.withPackages (lua51Packages: with lua51Packages; [
      luarocks
    ]))
  ];
}
