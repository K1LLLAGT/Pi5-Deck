#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Assets / Renders Scaffolding =="

mkdir -p assets/renders assets/photos

# ---------------------------------------------------------
# Renders README
# ---------------------------------------------------------
cat << 'REND_EOF' > assets/renders/README.md
# Pi5-Deck Renders

Use this directory for:
- CAD renders
- Exploded views
- Assembly diagrams
- Promotional images
- Annotated mechanical drawings

Suggested naming:
- `pi5deck-exploded.png`
- `pi5deck-iso.png`
- `pi5deck-section-view.png`
- `pi5deck-thermal-layout.png`
REND_EOF

# ---------------------------------------------------------
# Photos README
# ---------------------------------------------------------
cat << 'PHOTO_EOF' > assets/photos/README.md
# Pi5-Deck Photos

Use this directory for:
- Build photos
- Wiring close-ups
- PCB photos
- Assembly steps
- Final product shots

Suggested naming:
- `step-01-shell-open.jpg`
- `step-02-mounting-frame.jpg`
- `pcb-top.jpg`
- `pcb-bottom.jpg`
- `assembled-front.jpg`
- `assembled-back.jpg`
PHOTO_EOF

# ---------------------------------------------------------
# Renders Manifest (JSON placeholder)
# ---------------------------------------------------------
cat << 'MANIFEST_EOF' > assets/renders/renders-manifest.json
{
  "project": "Pi5-Deck",
  "version": "0.1",
  "renders": [
    {
      "file": "pi5deck-iso.png",
      "description": "Isometric render of the full assembly"
    },
    {
      "file": "pi5deck-exploded.png",
      "description": "Exploded view showing internal components"
    }
  ]
}
MANIFEST_EOF

# ---------------------------------------------------------
# Photo Index CSV
# ---------------------------------------------------------
cat << 'CSV_EOF' > assets/photos/photo-index.csv
Filename,Category,Description,Notes
step-01-shell-open.jpg,Assembly,Opening the enclosure,
step-02-mounting-frame.jpg,Assembly,Mounting the internal frame,
pcb-top.jpg,PCB,Top view of PCB,
pcb-bottom.jpg,PCB,Bottom view of PCB,
assembled-front.jpg,Final,Front view of assembled unit,
assembled-back.jpg,Final,Back view of assembled unit,
CSV_EOF

# ---------------------------------------------------------
# .gitkeep for safety
# ---------------------------------------------------------
for d in assets/renders assets/photos; do
  [ -f "$d/.gitkeep" ] || touch "$d/.gitkeep"
done

echo "== Assets scaffolding complete =="
