{
  pkgs,
  lib,
  readDotfiles,
  mkDotfilesOutOfStore,
  mkDotfiles,
  ...
}: {
  programs = {
    nushell = {
      enable = true;
      extraConfig = readDotfiles "nushell/config.nu";
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = fromTOML (readDotfiles "starship.toml");
    };
    zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
      enableNushellIntegration = true;
    };
    atuin = {
      enable = true;
      enableNushellIntegration = true;
    };
    eza = {
      enable = true;
      enableNushellIntegration = true;
      colors = "auto";
      icons = "auto";
      git = true;
      extraOptions = [
        "--hyperlink"
        "--group-directories-first"
      ];
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    fd.enable = true;
    ripgrep.enable = true;
    bat = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  home = {
    packages = with pkgs; [
      lazygit
      lazyjournal
    ];

    shellAliases = {
      l = "eza --grid";
      ll = "eza --long";
      lt = "eza --tree --level 3";

      lg = "lazygit";
      lj = "lazyjournal";

      cat = "bat";

      edit = "hx";
      e = "edit";

      nos = "nh os switch -- --impure";
    };
  };
}
