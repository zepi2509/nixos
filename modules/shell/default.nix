{pkgs, ...}: {
  # Shell configuration - bash, zsh, and utilities

  environment = {
    systemPackages = with pkgs; [
      starship  # Prompt - disabled below; using dotfiles config instead
      blesh     # Bash Line Editor - line editing enhancements
      zoxide    # Smart directory jumper (cd replacement)
      fastfetch # System info display (faster than neofetch)
      eza       # ls replacement with colors and icons
      atuin     # Shell history search and sync
    ];

    etc = {
      inputrc.source = ./inputrc;
      "starship.toml".source = ./starship.toml;
      blerc.source = ./blerc;
    };

    shellAliases = {
      z = "cd";
      l = null;
      ls = "eza -G -x --color=auto --icons=auto --hyperlink --group-directories-first";
      ll = "ls -lao";
      tree = "ls -T";
      lg = "lazygit";
      off = "poweroff";
      wifi = "impala";
      bt = "bluetui";
    };
  };

  programs = {
    starship = {
      # Disabled: Using starship config from dotfiles instead
      # To enable here, set to true and customize settings
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
        eval "$(zoxide init bash --no-aliases)"

        cd() {
          __zoxide_z "$@" && eza -G -x --color=auto --icons=auto --hyperlink --group-directories-first
        }
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
