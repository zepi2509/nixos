{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    goose-cli
  ];
}
