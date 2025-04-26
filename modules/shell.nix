{ ... }:

{
  programs.bash = {
    shellInit = ''
      eval "($starship init bash)"
    '';
  };

  programs.starship = {
    enable = true;
    interactiveOnly = false;
    settings = ''
      "$schema" = 'https://starship.rs/config-schema.json'

      add_newline = true

      [character]
      success_symbol = '[\$](green)'
      error_symbol = '[\$](red)'
    '';
  };
}
