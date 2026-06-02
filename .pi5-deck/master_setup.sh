#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Master Setup =="

LOG="setup-log.txt"
echo "[*] Logging to $LOG"
echo "== Pi5-Deck Master Setup Log ==" > "$LOG"

run() {
  echo "[*] Running: $1" | tee -a "$LOG"
  bash "$1" 2>&1 | tee -a "$LOG"
  echo >> "$LOG"
}

# ---------------------------------------------------------
# Ensure subsystem scripts exist
# ---------------------------------------------------------
REQUIRED=(
  "setup_pi5_deck_repo.sh"
  "firmware_setup.sh"
  "cad_setup.sh"
  "electrical_setup.sh"
  "assets_setup.sh"
  "scripts_setup.sh"
)

for f in "${REQUIRED[@]}"; do
  if [ ! -f "$f" ]; then
    echo "[ERROR] Missing required script: $f"
    exit 1
  fi
done

# ---------------------------------------------------------
# Run scripts in correct order
# ---------------------------------------------------------
run "./setup_pi5_deck_repo.sh"
run "./firmware_setup.sh"
run "./cad_setup.sh"
run "./electrical_setup.sh"
run "./assets_setup.sh"
run "./scripts_setup.sh"

# ---------------------------------------------------------
# Create build directory
# ---------------------------------------------------------
mkdir -p build
echo "[*] Created build/ directory" | tee -a "$LOG"

echo "== Master setup complete =="
