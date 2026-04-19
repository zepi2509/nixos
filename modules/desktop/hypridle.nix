{ ... }:

# Hypridle daemon - monitors system idle time and triggers actions
# Coordinates with hyprland window manager for power management
# Actions: lock screen → dim → blank screen → suspend

{
  services.hypridle = {
    enable = true;
  };

  environment.etc = {
    "hypridle.conf" = {
      mode = "0644";
      target = "hypr/hypridle.conf";
      text = ''
        general {
          # Lock script using caelestia shell
          lock_cmd = caelestia shell lock lock
          # Ensure session is locked before suspend
          before_sleep_cmd = loginctl lock-session
          # Restore display after resume
          after_sleep_cmd = hyprctl dispatch dpms on
        }

        # After 150 seconds (2.5 min): Dim display to 5%
        # This gives you time to notice before locking
        listener {
          timeout = 150
          on-timeout = light -O && light -S 5
          on-resume = light -I
        }
        
        # After 300 seconds (5 min): Lock screen
        # User must enter password to continue using system
        listener {
          timeout = 300
          on-timeout = loginctl lock-session
        }

        # After 330 seconds (5.5 min): Turn off display (DPMS)
        # Saves power while screen off; resume restores display
        listener {
          timeout = 330
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
        }

        # After 1800 seconds (30 min): Suspend to RAM
        # Significant power savings; session preserved; resume is fast
        # Note: Ensure suspend is configured in power module
        listener {
          timeout = 1800
          on-timeout = systemctl suspend
        }
      '';
    };
  };
}
