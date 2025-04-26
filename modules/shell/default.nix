{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      zoxide
    ];
    
    etc.inputrc.source = ./inputrc;

    shellInit = ''
      eval "$(zoxide init --cmd cd bash)"
    '';
  };

  programs.bash = {
    blesh.enable = true;
     
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.starship = {
    enable = true;
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
}
