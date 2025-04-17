{ pkgs, ... }:

{
  services.upower.enable = true;
  environment.systemPackages = with pkgs; [
    batsignal
  ];

  systemd.user.services.batsignal = {
    description = "Batsignal Battery Monitor";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.batsignal}/bin/batsignal -w 21 -c 10 -d 5 -W \"Battery at 20%\" -C \"Battery low at 10%\" -D \"Battery critical at 5%\"";
      Restart = "on-failure";
      RestartSec = "5";
    };
  };
}
