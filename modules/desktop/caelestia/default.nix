{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.caelestia.packages."${pkgs.stdenv.hostPlatform.system}".with-shell
  ];
}
