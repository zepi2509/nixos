{...}: 

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4321
      24727
    ];
    allowedUDPPorts = [
      4321
      24727
    ];
  };
}
