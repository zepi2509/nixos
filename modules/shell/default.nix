{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      starship
      blesh
      zoxide
      fastfetch
      eza
    ];

    etc.inputrc.source = ./inputrc;
    etc."starship.toml".source = ./starship.toml;
    etc.blerc.source = ./blerc;

    shellAliases = {
      l = null;
      ls = "eza -1 --color=auto --icons=auto";
      ll = "ls -lao";
      tree = "ls -T";
      lg = "lazygit";
    };
  };

  programs.starship = {
    enable = false;
    settings = {
      add_newline = false;
      character = {
        format = "$symbol ";
        success_symbol = "[>](green)";
        error_symbol = "[>](red)";
        vicmd_symbol = "[#](white)";
      };
    };
  };

  programs.bash = {
    interactiveShellInit = ''
      fastfetch

      export STARSHIP_CONFIG=/etc/starship.toml
      eval "$(starship init bash)"

      [[ $- == *i* ]] &&
        source "${pkgs.blesh}/share/blesh/ble.sh" --rcfile "/etc/blerc"

      [[ ! $\{BLE_VERSION-} ]] || ble-attach


      export _ZO_DOCTOR=0
      eval "$(zoxide init --cmd cd bash)"
    '';
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.bat = {
    enable = true;
  };
}
