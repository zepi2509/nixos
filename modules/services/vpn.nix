{...}: {
  networking.wg-quick.interfaces.wg0 = {
    # Keep the imported WireGuard config outside the Nix store because it contains secrets.
    configFile = "/home/zepi/.dotfiles/wg_config.conf";
    autostart = true;
  };
}
