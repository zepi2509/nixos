{ ... }:
{
  imports = [
    ./firewall.nix
    ./secretservice.nix
    ./git.nix
    ./audio.nix
    ./bluetooth.nix
    ./battery.nix
    ./onedrive.nix
    ./vpn.nix
  ];
}
