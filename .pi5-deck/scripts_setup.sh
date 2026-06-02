#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Scripts / Automation Scaffolding =="

mkdir -p scripts

# ---------------------------------------------------------
# Scripts README
# ---------------------------------------------------------
cat << 'README_EOF' > scripts/README.md
# Pi5-Deck Utility Scripts

This directory contains automation and maintenance scripts for the Pi5-Deck.

Included scripts:

- **backup.sh**  
  Creates a timestamped backup of important directories using rsync.

- **diagnostics.sh**  
  Prints system information, Pi hardware details, and health metrics.

- **update-system.sh**  
  Safe wrapper for updating packages and firmware.

- **nvme-migrate.sh**  
  (Moved from repo root if present) Migrates the OS to NVMe storage.

Add additional scripts as needed for:
- provisioning
- flashing firmware
- log collection
- hardware testing
README_EOF

# ---------------------------------------------------------
# Backup Script
# ---------------------------------------------------------
cat << 'BACKUP_EOF' > scripts/backup.sh
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="\$HOME/pi5deck-backups"
TIMESTAMP=\$(date +"%Y-%m-%d_%H-%M-%S")
DEST="\$BACKUP_DIR/backup-\$TIMESTAMP"

mkdir -p "\$DEST"

echo "[*] Backing up Pi5-Deck data to: \$DEST"

rsync -av --progress \
  /etc \
  /home \
  /boot \
  "\$DEST"

echo "[*] Backup complete."
BACKUP_EOF

chmod +x scripts/backup.sh

# ---------------------------------------------------------
# Diagnostics Script
# ---------------------------------------------------------
cat << 'DIAG_EOF' > scripts/diagnostics.sh
#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Diagnostics =="

echo "[*] System Information:"
uname -a
echo

echo "[*] CPU Info:"
lscpu
echo

echo "[*] Memory:"
free -h
echo

echo "[*] Disk Usage:"
df -h
echo

echo "[*] Temperature:"
vcgencmd measure_temp || echo "vcgencmd not available"
echo

echo "[*] Voltage:"
vcgencmd measure_volts || echo "vcgencmd not available"
echo

echo "[*] Throttling Status:"
vcgencmd get_throttled || echo "vcgencmd not available"
echo

echo "Diagnostics complete."
DIAG_EOF

chmod +x scripts/diagnostics.sh

# ---------------------------------------------------------
# System Update Script
# ---------------------------------------------------------
cat << 'UPDATE_EOF' > scripts/update-system.sh
#!/usr/bin/env bash
set -euo pipefail

echo "== Updating Pi5-Deck System =="

echo "[*] Updating package lists..."
sudo apt update

echo "[*] Upgrading packages..."
sudo apt full-upgrade -y

echo "[*] Updating firmware (if applicable)..."
sudo rpi-eeprom-update -a || echo "EEPROM update not available"

echo "[*] Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "System update complete."
UPDATE_EOF

chmod +x scripts/update-system.sh

# ---------------------------------------------------------
# .gitkeep for safety
# ---------------------------------------------------------
[ -f scripts/.gitkeep ] || touch scripts/.gitkeep

echo "== Scripts scaffolding complete =="
