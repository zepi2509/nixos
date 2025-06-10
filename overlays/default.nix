final: prev:
let
  # zen = import ./zen.nix final prev;
  onedrive = import ./onedrive.nix final prev;
in
{
  # inherit (zen) zen-browser;
  inherit (onedrive) onedrive;
}
