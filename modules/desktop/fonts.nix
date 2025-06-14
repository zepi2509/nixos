{ pkgs, ...}:
{
  fonts = {
    fontconfig.enable = true;

    packages = with pkgs; [
      corefonts
      eb-garamond
      helvetica-neue-lt-std
    ];
  };
}
