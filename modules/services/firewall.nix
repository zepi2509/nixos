{...}: 

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4321
    ];
    allowedUDPPorts = [
      4321
    ];
  };
}
