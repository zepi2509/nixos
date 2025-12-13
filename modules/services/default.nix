{ ... }:
{
  imports = [
    ./firewall.nix
    ./secretservice.nix
    ./git.nix
    ./ai.nix
    ./audio.nix
    ./bluetooth.nix
    ./battery.nix
    ./onedrive.nix
    ./flatpak.nix
    ./printing.nix
    ./power.nix
    # ./vpn.nix
  ];
}
