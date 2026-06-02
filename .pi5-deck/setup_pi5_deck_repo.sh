#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck repo scaffolding =="

# ---------------------------------------------------------
# Create directory structure
# ---------------------------------------------------------
echo "[*] Creating directories..."
mkdir -p \
  docs \
  cad/stl \
  cad/step \
  cad/source \
  firmware/overlays \
  firmware/configs \
  firmware/scripts \
  electrical/schematics \
  electrical/harness \
  scripts \
  assets/renders \
  assets/photos \
  BOM

# ---------------------------------------------------------
# Move existing docs into docs/ if they exist
# ---------------------------------------------------------
echo "[*] Moving existing documentation into docs/ (if present)..."

for f in \
  "Pi5-DECK-Build-Guide.pdf" \
  "Pi5-Deck-CAD-Handoff.md" \
  "Pi5-Deck-Wiring.md" \
  "Pi5-Handheld-Terminal-Blueprint.md"
do
  if [ -f "$f" ]; then
    echo "    - Moving $f -> docs/"
    mv "$f" docs/
  else
    echo "    - Skipping $f (not found)"
  fi
done

# ---------------------------------------------------------
# Move nvme-migrate.sh into scripts/
# ---------------------------------------------------------
if [ -f "nvme-migrate.sh" ]; then
  echo "[*] Moving nvme-migrate.sh -> scripts/"
  mv nvme-migrate.sh scripts/
  chmod +x scripts/nvme-migrate.sh || true
else
  echo "[*] nvme-migrate.sh not found in root, skipping move."
fi

# ---------------------------------------------------------
# Create .gitignore (non-destructive)
# ---------------------------------------------------------
if [ -f ".gitignore" ]; then
  echo "[*] .gitignore already exists, leaving as-is."
else
  echo "[*] Creating .gitignore..."
  cat << 'GITIGNORE_EOF' > .gitignore
# Build artifacts
build/
dist/
out/
*.log

# OS cruft
.DS_Store
Thumbs.db

# CAD/EDA tool junk
*.bak
*.tmp
*.lock

# Python
__pycache__/
*.pyc

# Editor
.vscode/
.idea/
*.swp
GITIGNORE_EOF
fi

# ---------------------------------------------------------
# Create README.md (non-destructive)
# ---------------------------------------------------------
if [ -f "README.md" ]; then
  echo "[*] README.md already exists, leaving as-is."
else
  echo "[*] Creating README.md..."
  cat << 'README_EOF' > README.md
# Pi5-Deck Handheld Project

## Overview
Pi5-Deck is a Raspberry Pi 5–based handheld / deck-style terminal designed for:
- Portable Linux workflows
- Hardware hacking and diagnostics
- Tethered or standalone use with custom input and display

This repository contains:
- Mechanical design handoff and CAD structure
- Wiring and electrical documentation
- Firmware / OS configuration scaffolding
- Build guide and assembly notes
- Utility scripts (e.g., storage migration)

## Repository layout

- \`docs/\` — High-level documentation, build guides, wiring notes, and blueprints.
- \`cad/\` — Mechanical design files and exports.
- \`firmware/\` — Device tree overlays, configs, and OS scripts.
- \`electrical/\` — Schematics and wiring harness documentation.
- \`scripts/\` — Utility scripts (e.g., nvme-migrate.sh).
- \`assets/\` — Renders, photos, and visual assets.
- \`BOM/\` — Bill of Materials and sourcing information.

## Getting started

1. Clone the repository:
   \`\`\`bash
   git clone <your-repo-url>.git
   cd <your-repo-name>
   \`\`\`

2. Run the repo scaffolding script:
   \`\`\`bash
   chmod +x setup_pi5_deck_repo.sh
   ./setup_pi5_deck_repo.sh
   \`\`\`

3. Populate:
- \`cad/source/\` with native CAD files  
- \`electrical/schematics/\` with KiCad or EDA projects  
- \`firmware/\` with overlays, configs, and scripts  
- \`BOM/parts-list.csv\` with your parts and vendors  

## License
Add your chosen license here (MIT, CERN OHL, CC-BY-SA, etc.).
README_EOF
fi

# ---------------------------------------------------------
# Create BOM template (non-destructive)
# ---------------------------------------------------------
if [ -f "BOM/parts-list.csv" ]; then
  echo "[*] BOM/parts-list.csv already exists, leaving as-is."
else
  echo "[*] Creating BOM/parts-list.csv template..."
  cat << 'BOM_EOF' > BOM/parts-list.csv
Reference,Quantity,Description,Manufacturer,Manufacturer Part Number,Supplier,Supplier Part Number,Link,Notes
U1,1,Raspberry Pi 5 8GB,Raspberry Pi,,Preferred Supplier,,,Main compute module
DS1,1,Display Module,,,,,,,
KBD1,1,Keyboard / Input Device,,,,,,,
BAT1,1,Battery Pack,,,,,,,
SW1,1,Power Switch,,,,,,,
CN1,1,Main I/O Connector,,,,,,,
PCB1,1,Main PCB,,,,,,,
MECH1,1,Enclosure / Shell,,,,,,,
FASTENER,VAR,Fasteners (screws, inserts, etc.),,,,,,,
CABLE,VAR,Cables / Harnesses,,,,,,,
BOM_EOF
fi

# ---------------------------------------------------------
# Create .gitkeep placeholders
# ---------------------------------------------------------
echo "[*] Creating .gitkeep placeholders..."
for d in \
  cad/stl \
  cad/step \
  cad/source \
  firmware/overlays \
  firmware/configs \
  firmware/scripts \
  electrical/schematics \
  electrical/harness \
  assets/renders \
  assets/photos
do
  if [ ! -f "$d/.gitkeep" ]; then
    touch "$d/.gitkeep"
  fi
done

echo "== Done. Repo structure is now scaffolded for Pi5-Deck =="
