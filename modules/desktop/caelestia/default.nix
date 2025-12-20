{ inputs, pkgs, ... }:
let
  caelestia = inputs.caelestia.packages."${pkgs.stdenv.hostPlatform.system}".with-shell;
in
{
  # environment.systemPackages = [
  #   caelestia
  # ];

  #   unitConfig = {
  #     Description = "Caelestia Desktop Shell";
  #     After = [ "graphical-session.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #
  #   path = with pkgs; [
  #     caelestia
  #     app2unit
  #
  #     "/run/current-system/sw"
  #     "/home/zepi/.nix-profile"
  #
  #     coreutils
  #     xdg-utils
  #   ];
  #
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${caelestia}/bin/caelestia shell";
  #     Restart = "on-failure";
  #     RestartSec = "2";
  #     PassEnvironment = [
  #       "PATH"
  #       "WAYLAND_DISPLAY"
  #       "DISPLAY"
  #       "XDG_RUNTIME_DIR"
  #       "XDG_CURRENT_DESKTOP"
  #       "XDG_SESSION_TYPE"
  #     ];
  #   };
  #
  #   wantedBy = [ "graphical-session.target" ];
  # };
}
