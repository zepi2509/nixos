{ pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "uwsm start default";
  username = "zepi";
in
{
  users.users.zepi = {
    isNormalUser = true;
    description = "Noah Zepner";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
        user = "greeter";
      };
    };
  };
}
