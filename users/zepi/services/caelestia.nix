{
  config,
  inputs,
  mkDotfilesOutOfStore,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [];
    };
    cli = {
      enable = true;
    };
  };

  xdg.configFile = {
    "caelestia".source = mkDotfilesOutOfStore "caelestia";
  };

  home.file.".local/share/caelestia/schemes/stylix.txt".text = ''
    primary_paletteKeyColor ${colors.base0D}
    secondary_paletteKeyColor ${colors.base0E}
    tertiary_paletteKeyColor ${colors.base0C}
    neutral_paletteKeyColor ${colors.base03}
    neutral_variant_paletteKeyColor ${colors.base04}
    background ${colors.base00}
    onBackground ${colors.base05}
    surface ${colors.base00}
    surfaceDim ${colors.base01}
    surfaceBright ${colors.base02}
    surfaceContainerLowest ${colors.base00}
    surfaceContainerLow ${colors.base01}
    surfaceContainer ${colors.base01}
    surfaceContainerHigh ${colors.base02}
    surfaceContainerHighest ${colors.base03}
    onSurface ${colors.base05}
    surfaceVariant ${colors.base01}
    onSurfaceVariant ${colors.base04}
    inverseSurface ${colors.base05}
    inverseOnSurface ${colors.base00}
    outline ${colors.base03}
    outlineVariant ${colors.base02}
    shadow 000000
    scrim 000000
    surfaceTint ${colors.base0D}
    primary ${colors.base0D}
    onPrimary ${colors.base00}
    primaryContainer ${colors.base0E}
    onPrimaryContainer ${colors.base00}
    inversePrimary ${colors.base0D}
    secondary ${colors.base0E}
    onSecondary ${colors.base00}
    secondaryContainer ${colors.base02}
    onSecondaryContainer ${colors.base05}
    tertiary ${colors.base0C}
    onTertiary ${colors.base00}
    tertiaryContainer ${colors.base02}
    onTertiaryContainer ${colors.base05}
    error ${colors.base08}
    onError ${colors.base00}
    errorContainer ${colors.base08}
    onErrorContainer ${colors.base00}
    primaryFixed ${colors.base0D}
    primaryFixedDim ${colors.base0D}
    onPrimaryFixed ${colors.base00}
    onPrimaryFixedVariant ${colors.base03}
    secondaryFixed ${colors.base0E}
    secondaryFixedDim ${colors.base0E}
    onSecondaryFixed ${colors.base00}
    onSecondaryFixedVariant ${colors.base03}
    tertiaryFixed ${colors.base0C}
    tertiaryFixedDim ${colors.base0C}
    onTertiaryFixed ${colors.base00}
    onTertiaryFixedVariant ${colors.base03}
    term0 ${colors.base00}
    term1 ${colors.base08}
    term2 ${colors.base0B}
    term3 ${colors.base0A}
    term4 ${colors.base0D}
    term5 ${colors.base0E}
    term6 ${colors.base0C}
    term7 ${colors.base05}
    term8 ${colors.base03}
    term9 ${colors.base08}
    term10 ${colors.base0B}
    term11 ${colors.base0A}
    term12 ${colors.base0D}
    term13 ${colors.base0E}
    term14 ${colors.base0C}
    term15 ${colors.base07}
    rosewater ${colors.base06}
    flamingo ${colors.base0F}
    pink ${colors.base0F}
    mauve ${colors.base0E}
    red ${colors.base08}
    maroon ${colors.base08}
    peach ${colors.base09}
    yellow ${colors.base0A}
    green ${colors.base0B}
    teal ${colors.base0C}
    sky ${colors.base0C}
    sapphire ${colors.base0D}
    blue ${colors.base0D}
    lavender ${colors.base07}
    text ${colors.base05}
    subtext1 ${colors.base04}
    subtext0 ${colors.base03}
    overlay2 ${colors.base02}
    overlay1 ${colors.base01}
    overlay0 ${colors.base00}
    surface2 ${colors.base02}
    surface1 ${colors.base01}
    surface0 ${colors.base00}
    base ${colors.base00}
    mantle ${colors.base01}
    crust ${colors.base01}
    success ${colors.base0B}
    onSuccess ${colors.base00}
    successContainer ${colors.base01}
    onSuccessContainer ${colors.base0B}  '';
}
