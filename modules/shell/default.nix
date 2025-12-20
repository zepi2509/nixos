{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      starship
      blesh
      zoxide
      fastfetch
      eza
      atuin
    ];

    etc = {
      inputrc.source = ./inputrc;
      "starship.toml".source = ./starship.toml;
      blerc.source = ./blerc;
    };

    shellAliases = {
      l = null;
      ls = "eza -1 --color=auto --icons=auto";
      ll = "ls -lao";
      tree = "ls -T";
      lg = "lazygit";
      v = "nvim";
      off = "poweroff";
      wifi = "impala";
      bt = "bluetui";
    };
  };

  programs = {
    starship = {
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

    bash = {
      interactiveShellInit = ''
        fastfetch

        export STARSHIP_CONFIG=/etc/starship.toml
        eval "$(starship init bash)"

        [[ $- == *i* ]] &&
          source "${pkgs.blesh}/share/blesh/ble.sh" --rcfile "/etc/blerc"

        [[ ! $\{BLE_VERSION-} ]] || ble-attach


        export _ZO_DOCTOR=0
        eval "$(atuin init bash)"
        eval "$(zoxide init --cmd cd bash)"
      '';
    };

    fzf = {
      fuzzyCompletion = true;
      keybindings = false;
    };

    bat = {
      enable = true;
    };
  };
}
