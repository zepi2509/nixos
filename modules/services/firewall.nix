{...}: 

{
  networking.firewall = {
    enable = true;
    # TCP ports to allow through firewall
    # Port 4321: [TODO: Add service description]
    # Port 24727: [TODO: Add service description]
    allowedTCPPorts = [
      4321
      24727
    ];
    # UDP ports to allow through firewall
    # Port 4321: [TODO: Add service description]
    # Port 24727: [TODO: Add service description]
    allowedUDPPorts = [
      4321
      24727
    ];
  };
}
