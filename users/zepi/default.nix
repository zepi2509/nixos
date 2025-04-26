{ ... }:

{
  users.users.zepi = {
    isNormalUser = true;
    description = "Noah Zepner";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  services.getty.autologinUser = "zepi";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "zepi";
        command = "uwsm start default";
      };
    };
  };
}
