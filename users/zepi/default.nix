{pkgs, ...}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "uwsm start hyprland-uwsm.desktop";
  username = "zepi";
in {
  users.users.zepi = {
    isNormalUser = true;
    description = "Noah Zepner";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    shell = pkgs.nushell;
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

  # Dotfiles auto-commit service
  systemd.user.services.dotfiles-auto-commit = {
    description = "Auto-commit dotfiles changes";
    after = ["default.target"];
    wantedBy = ["default.target"];

    path = with pkgs; [git inotify-tools coreutils bash];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    script = ''
      #!/usr/bin/env bash
      WATCH_DIR="/home/zepi/.dotfiles"
      DEBOUNCE_SECONDS=30

      cd "$WATCH_DIR" || exit 1

      while true; do
        # Wait for file changes (create, modify, delete, move)
        inotifywait -r -q -e modify,create,delete,move "$WATCH_DIR"

        # Debounce: wait for activity to settle
        sleep $DEBOUNCE_SECONDS

        # Check for changes and commit
        if [[ -n $(git status --porcelain) ]]; then
          # Get list of changed files for descriptive message
          CHANGED_FILES=$(git status --porcelain | awk '{print $2}' | head -5 | tr '\n' ' ')
          FILE_COUNT=$(git status --porcelain | wc -l)
          TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

          git add -A

          if [[ $FILE_COUNT -eq 1 ]]; then
            COMMIT_MSG="Auto-commit ($TIMESTAMP): Updated $CHANGED_FILES"
          else
            COMMIT_MSG="Auto-commit ($TIMESTAMP): Updated $FILE_COUNT files including $CHANGED_FILES"
          fi

          git commit -m "$COMMIT_MSG"
        fi
      done
    '';
  };
}
