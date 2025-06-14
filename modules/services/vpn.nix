{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.fh-kiel-vpn.packages.${stdenv.hostPlatform.system}.fh-kiel-vpn
  ];
}
