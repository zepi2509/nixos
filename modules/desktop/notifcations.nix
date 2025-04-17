{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dunst
  ];

  systemd.user.services.dunst = {
    description = "Dunst Notification Daemon";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst";
      Restart = "on-failure";
      RestartSec = "5";
    };
  };
}
