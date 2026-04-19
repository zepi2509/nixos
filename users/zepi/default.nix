{pkgs, ...}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "uwsm start hyprland-uwsm.desktop";
  username = "zepi";
in {
  users.groups.zepi = {};

  users.users.zepi = {
    isNormalUser = true;
    description = "Noah Zepner";
    group = "zepi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    hashedPassword = "$6$JSUkvlw6GA/6dWmo$ChmSvlv0LRX.zS5ddxZE7icQkYsyLbNu6yQ6BmPo55UYeUev6MEJk20Q1S4dIroofOsI6/KBxwrytSzvd5fEA.";
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

  # Dotfiles auto-commit service with improved error handling and logging
  systemd.user.services.dotfiles-auto-commit = {
    description = "Auto-commit dotfiles changes";
    after = ["default.target"];
    wantedBy = ["default.target"];

    path = with pkgs; [git inotify-tools coreutils bash systemd];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "10s";
      # Improve logging and debugging
      StandardOutput = "journal";
      StandardError = "journal";
      SyslogIdentifier = "dotfiles-auto-commit";
    };

    script = ''
      #!/usr/bin/env bash
      set -euo pipefail

      # Configuration
      WATCH_DIR="''${HOME}/.dotfiles"
      DEBOUNCE_SECONDS=30
      LOG_TAG="dotfiles-auto-commit"
      LOG_FILE="''${HOME}/.local/state/dotfiles-auto-commit.log"

      # Logging helper
      log() {
        local level="$1"
        shift
        local message="$*"
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
        systemd-cat -t "$LOG_TAG" -p "''${level,,}" <<< "$message" 2>/dev/null || true
      }

      # Ensure watch directory exists
      if [[ ! -d "$WATCH_DIR" ]]; then
        log "ERROR" "Watch directory does not exist: $WATCH_DIR"
        log "INFO" "Auto-commit disabled until directory is created"
        exit 1
      fi

      log "INFO" "Starting dotfiles auto-commit service"
      log "INFO" "Watching directory: $WATCH_DIR"
      log "INFO" "Debounce time: $DEBOUNCE_SECONDS seconds"

      cd "$WATCH_DIR" || {
        log "ERROR" "Failed to change directory to: $WATCH_DIR"
        exit 1
      }

      # Verify this is a git repository
      if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log "ERROR" "Not a git repository: $WATCH_DIR"
        exit 1
      fi

      log "INFO" "Git repository verified"

      while true; do
        # Wait for file changes (create, modify, delete, move)
        if ! inotifywait -r -q -e modify,create,delete,move "$WATCH_DIR" 2>/dev/null; then
          log "WARN" "inotifywait encountered an error, restarting watch..."
          sleep 5
          continue
        fi

        # Debounce: wait for activity to settle
        sleep $DEBOUNCE_SECONDS

        # Check for changes and commit with error handling
        if [[ -n $(git status --porcelain) ]]; then
          # Get list of changed files for descriptive message
          CHANGED_FILES=$(git status --porcelain | awk '{print $2}' | head -5 | tr '\n' ' ')
          FILE_COUNT=$(git status --porcelain | wc -l)
          TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

          log "INFO" "Detected $FILE_COUNT file(s) changed"

          # Stage all changes
          if ! git add -A 2>/dev/null; then
            log "ERROR" "Failed to stage changes"
            continue
          fi

          # Build commit message
          if [[ $FILE_COUNT -eq 1 ]]; then
            COMMIT_MSG="chore: update dotfiles ($TIMESTAMP)"
          else
            COMMIT_MSG="chore: update dotfiles - $FILE_COUNT files ($TIMESTAMP)"
          fi

          # Attempt commit with error handling
          if git commit -m "$COMMIT_MSG" 2>/dev/null; then
            log "INFO" "Committed: $COMMIT_MSG"
          else
            log "WARN" "Commit failed or no changes to commit"
          fi
        fi
      done
    '';
  };
}
