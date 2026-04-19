# Nix package overlays
# 
# Overlays allow customizing or patching packages from nixpkgs.
# Add custom package definitions here using the pattern:
#
# final: prev:
# {
#   mypackage = prev.callPackage ./mypackage.nix {};
# }
#
# Currently empty - all packages sourced from nixpkgs directly.

final: prev:
{
  # Custom packages go here
}
