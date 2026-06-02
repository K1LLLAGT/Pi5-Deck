#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Tools & Docs Site Setup =="

mkdir -p tools build/os docs/site

# ---------------------------------------------------------
# OS Image Builder (file-based, safe)
# ---------------------------------------------------------
cat << 'OS_EOF' > tools/os-image-builder.sh
#!/usr/bin/env bash
set -euo pipefail

IMG_DIR="build/os"
IMG_NAME="${1:-pi5deck-os.img}"
IMG_PATH="$IMG_DIR/$IMG_NAME"
SIZE="${SIZE:-4G}"

mkdir -p "$IMG_DIR"

echo "[*] Creating sparse image: $IMG_PATH ($SIZE)"
truncate -s "$SIZE" "$IMG_PATH"

echo "[*] Initializing partition table..."
parted "$IMG_PATH" --script mklabel msdos
parted "$IMG_PATH" --script mkpart primary fat32 1MiB 256MiB
parted "$IMG_PATH" --script mkpart primary ext4 256MiB 100%

echo "[*] Setting up loop device..."
LOOP=$(losetup --show -fP "$IMG_PATH")

cleanup() {
  echo "[*] Cleaning up loop device..."
  sync || true
  losetup -d "$LOOP" || true
}
trap cleanup EXIT

BOOT_PART="${LOOP}p1"
ROOT_PART="${LOOP}p2"

echo "[*] Formatting partitions..."
mkfs.vfat -F32 "$BOOT_PART"
mkfs.ext4 "$ROOT_PART"

echo "[*] Mounting..."
mkdir -p build/os/mnt/boot build/os/mnt/root
mount "$BOOT_PART" build/os/mnt/boot
mount "$ROOT_PART" build/os/mnt/root

echo "[*] Copy your rootfs into build/os/mnt/root and boot files into build/os/mnt/boot"
echo "[*] When done, unmount manually:"
echo "    sudo umount build/os/mnt/boot build/os/mnt/root"
echo "    (image is at $IMG_PATH)"
OS_EOF

chmod +x tools/os-image-builder.sh

# ---------------------------------------------------------
# Flashing Tool (explicit device, confirmation)
# ---------------------------------------------------------
cat << 'FLASH_EOF' > tools/pi5deck-flash.sh
#!/usr/bin/env bash
set -euo pipefail

IMG="${1:-}"
DEV="${2:-}"

if [ -z "$IMG" ] || [ -z "$DEV" ]; then
  echo "Usage: $0 <image.img> </dev/sdX>"
  exit 1
fi

if [ ! -f "$IMG" ]; then
  echo "[ERROR] Image not found: $IMG"
  exit 1
fi

echo "About to flash:"
echo "  Image: $IMG"
echo "  Device: $DEV"
echo
read -rp "Type 'FLASH' to continue: " CONFIRM
[ "$CONFIRM" = "FLASH" ] || { echo "Aborted."; exit 1; }

echo "[*] Writing image..."
sudo dd if="$IMG" of="$DEV" bs=4M status=progress conv=fsync

echo "[*] Syncing..."
sync

echo "Flash complete."
FLASH_EOF

chmod +x tools/pi5deck-flash.sh

# ---------------------------------------------------------
# Pi5-Deck CLI Tool
# ---------------------------------------------------------
cat << 'CLI_EOF' > tools/pi5deck
#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"

case "$CMD" in
  status)
    echo "== Pi5-Deck Status =="
    uname -a
    echo
    echo "[*] Disk usage:"
    df -h
    ;;
  diag)
    echo "== Pi5-Deck Diagnostics =="
    if [ -x scripts/diagnostics.sh ]; then
      ./scripts/diagnostics.sh
    else
      echo "scripts/diagnostics.sh not found."
    fi
    ;;
  backup)
    echo "== Pi5-Deck Backup =="
    if [ -x scripts/backup.sh ]; then
      ./scripts/backup.sh
    else
      echo "scripts/backup.sh not found."
    fi
    ;;
  release)
    VERSION="${2:-0.1.0}"
    echo "== Pi5-Deck Release $VERSION =="
    if [ -x ./release_packaging.sh ]; then
      ./release_packaging.sh "$VERSION"
    else
      echo "release_packaging.sh not found."
    fi
    ;;
  help|*)
    echo "Pi5-Deck CLI"
    echo "Usage: pi5deck <command>"
    echo
    echo "Commands:"
    echo "  status      Show basic system status"
    echo "  diag        Run diagnostics script"
    echo "  backup      Run backup script"
    echo "  release [v] Build release package (default v=0.1.0)"
    ;;
esac
CLI_EOF

chmod +x tools/pi5deck

# ---------------------------------------------------------
# Docs Site Generator (MkDocs-style)
# ---------------------------------------------------------
cat << 'MKDOCS_EOF' > docs/site/mkdocs.yml
site_name: Pi5-Deck Documentation
nav:
  - Home: index.md
  - Build Guide: Pi5-DECK-Build-Guide.md
  - Wiring: Pi5-Deck-Wiring.md
  - Handheld Terminal: Pi5-Handheld-Terminal-Blueprint.md
  - CAD Handoff: Pi5-Deck-CAD-Handoff.md
docs_dir: ../
site_dir: ../../build/site
theme:
  name: readthedocs
MKDOCS_EOF

cat << 'INDEX_EOF' > docs/site/index.md
# Pi5-Deck

Welcome to the Pi5-Deck documentation site.

- Build guide
- Wiring
- CAD handoff
- Handheld terminal blueprint
INDEX_EOF

cat << 'BUILD_EOF' > docs/site/build-docs.sh
#!/usr/bin/env bash
set -euo pipefail

if ! command -v mkdocs >/dev/null 2>&1; then
  echo "[ERROR] mkdocs not found. Install with: pip install mkdocs"
  exit 1
fi

cd docs/site
mkdocs build -f mkdocs.yml
BUILD_EOF

chmod +x docs/site/build-docs.sh

echo "== Pi5-Deck tools & docs site setup complete =="
echo "Tools:"
echo "  tools/os-image-builder.sh"
echo "  tools/pi5deck-flash.sh"
echo "  tools/pi5deck"
echo "Docs site:"
echo "  docs/site/build-docs.sh (requires mkdocs)"
