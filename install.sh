#!/usr/bin/env bash
set -euo pipefail

# Configuration
FLAKE_URL="github:zepi2509/nixos"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Global variables
SELECTED_DISK=""
SELECTED_HOST=""
AGE_KEY=""
NIX_ACCESS_TOKENS=""
NIX_OPTS=()

# ─────────────────────────────────────────────────────────────
# Step 1: Dashlane Authentication and Secret Retrieval
# ─────────────────────────────────────────────────────────────
fetch_secrets() {
  echo ""
  info "--- Dashlane Vault Authentication ---"
  
  local dcli_bin="/tmp/dcli"
  
  # Download dashlane-cli if not present
  if [[ ! -x "$dcli_bin" ]]; then
    info "Downloading dashlane-cli from GitHub..."
    
    local dcli_url="https://github.com/Dashlane/dashlane-cli/releases/latest/download/dcli-linux-x64"
    
    if ! curl -fsSL "$dcli_url" -o "$dcli_bin"; then
      error "Failed to download dashlane-cli"
    fi
    
    chmod +x "$dcli_bin"
    success "dashlane-cli downloaded."
  fi

  # Build FHS environment
  info "Building FHS environment..."
  local fhs_run
  fhs_run=$(nix build --no-link --print-out-paths --impure \
    --extra-experimental-features "nix-command flakes" \
    --expr '(import <nixpkgs> {}).buildFHSUserEnv {
      name = "fhs";
      targetPkgs = p: with p; [ glibc stdenv.cc.cc.lib zlib ];
      runScript = "bash";
    }')/bin/fhs

  # Wrapper function that runs dcli in FHS environment
  dcli() {
    "$fhs_run" -c "$dcli_bin $*"
  }

  local dl_email
  read -rp "Enter Dashlane Email: " dl_email < /dev/tty
  if [[ -z "$dl_email" ]]; then
    error "Email is required to access the vault."
  fi

  info "Logging in to Dashlane..."
  if ! dcli login "$dl_email" < /dev/tty; then
    error "Failed to login to Dashlane."
  fi

  # Fetch GitHub Token FIRST (needed for flake access)
  info "Fetching 'github-token' from Secure Notes..."
  local raw_token
  raw_token=$(dcli note "github-token" --output raw 2>/dev/null || echo "")
  
  if [[ -n "$raw_token" ]]; then
    NIX_ACCESS_TOKENS="github.com=$(echo "$raw_token" | xargs)"
    success "GitHub token retrieved."
  else
    error "No 'github-token' note found. Required to access the flake."
  fi

  # Build NIX_OPTS array for reuse
  NIX_OPTS=(--extra-experimental-features "nix-command flakes")
  NIX_OPTS+=(--option access-tokens "$NIX_ACCESS_TOKENS")

  # Fetch Age Key
  info "Fetching 'sops-age-key' from Secure Notes..."
  AGE_KEY=$(dcli note "sops-age-key" --output raw 2>/dev/null || true)

  if [[ -z "$AGE_KEY" ]]; then
    error "Could not find a Secure Note named 'sops-age-key' in your vault."
  fi
  success "Age key retrieved."
}

# ─────────────────────────────────────────────────────────────
# Step 2: Select Disk
# ─────────────────────────────────────────────────────────────
select_disk() {
  info "Available disks:"
  echo ""
  lsblk -d -o NAME,SIZE,MODEL | grep -v -E "loop|sr" || true
  echo ""

  mapfile -t disks < <(lsblk -d -n -o NAME | grep -v -E "loop|sr" || true)

  if [[ ${#disks[@]} -eq 0 ]]; then
    error "No suitable disks found."
  fi

  PS3="Select disk number (1-${#disks[@]}): "
  select choice in "${disks[@]}"; do
    if [[ -n "$choice" ]]; then
      SELECTED_DISK="/dev/$choice"
      success "Selected: $SELECTED_DISK"
      break
    else
      echo "Invalid selection. Please pick a number from the list."
    fi
  done < /dev/tty
}

# ─────────────────────────────────────────────────────────────
# Step 3: Select Host from Flake
# ─────────────────────────────────────────────────────────────
select_host() {
  info "Fetching available hosts from flake..."

  local host_json
  if ! host_json=$(nix flake show "$FLAKE_URL" --json "${NIX_OPTS[@]}" 2>&1); then
    error "Failed to fetch flake info: $host_json"
  fi

  mapfile -t hosts < <(echo "$host_json" | jq -r '.nixosConfigurations | keys[]')

  if [[ ${#hosts[@]} -eq 0 ]]; then
    error "No hosts found in flake: $FLAKE_URL"
  fi

  echo ""
  PS3="Select host configuration (1-${#hosts[@]}): "
  select choice in "${hosts[@]}"; do
    if [[ -n "$choice" ]]; then
      SELECTED_HOST="$choice"
      success "Selected: $SELECTED_HOST"
      break
    else
      echo "Invalid selection. Please pick a number from the list."
    fi
  done < /dev/tty
}

# ─────────────────────────────────────────────────────────────
# Step 4: Run Disko and Install
# ─────────────────────────────────────────────────────────────
run_install() {
  info "Preparing installation..."

  info "Partitioning $SELECTED_DISK with disko..."
  nix run "${NIX_OPTS[@]}" \
    github:nix-community/disko -- \
    --mode disko \
    --flake "$FLAKE_URL#$SELECTED_HOST" \
    --arg disk "\"$SELECTED_DISK\""

  info "Installing Age key to target system..."
  install -d -m 700 /mnt/var/lib/sops-nix
  install -m 600 /dev/stdin /mnt/var/lib/sops-nix/key.txt <<< "$AGE_KEY"

  info "Running nixos-install..."
  nixos-install \
    --flake "$FLAKE_URL#$SELECTED_HOST" \
    --no-root-passwd \
    "${NIX_OPTS[@]}"

  success "Installation complete! You can now reboot, Noah."
}

# ─────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "╔════════════════════════════════════════════════════╗"
  echo "║           ZEPI-NixOS Bootstrap Installer           ║"
  echo "╚════════════════════════════════════════════════════╝"
  echo ""

  if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use sudo)"
  fi

  for cmd in jq nix lsblk; do
    command -v "$cmd" &>/dev/null || error "Required command not found: $cmd"
  done

  fetch_secrets   # Get token FIRST
  select_disk
  select_host     # Now authenticated
  
  echo ""
  echo "Summary:"
  echo "  Disk:  $SELECTED_DISK"
  echo "  Host:  $SELECTED_HOST"
  echo ""
  
  local confirm
  read -rp "Proceed with installation? This will WIPE $SELECTED_DISK [y/N]: " confirm < /dev/tty
  
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    run_install
  else
    info "Aborted."
  fi
}

main "$@"
