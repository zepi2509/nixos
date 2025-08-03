{ inputs, system, ... }:
{
  environment.systemPackages = [
    inputs.caelestia.packages."${system}".with-shell
  ];
}
