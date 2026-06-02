#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck CAD Scaffolding =="

mkdir -p cad/source cad/step cad/stl

# ---------------------------------------------------------
# CAD source README
# ---------------------------------------------------------
cat << 'SRC_EOF' > cad/source/README.md
# Pi5-Deck CAD Source

Place your native CAD project files here (e.g., Fusion 360, FreeCAD, SolidWorks).

Suggested structure:
- `enclosure/` – main shell, back cover, bezels
- `frame/` – internal frame, mounting brackets
- `pcbs/` – board outlines, keepouts
- `io/` – ports, buttons, connectors
- `misc/` – standoffs, spacers, custom parts
SRC_EOF

# ---------------------------------------------------------
# STEP exports README
# ---------------------------------------------------------
cat << 'STEP_EOF' > cad/step/README.md
# Pi5-Deck STEP Exports

Use this directory for STEP files exported from your CAD source.

Typical files:
- `pi5deck-assembly.step`
- `pi5deck-enclosure.step`
- `pi5deck-pcb-outline.step`
STEP_EOF

# ---------------------------------------------------------
# STL exports README
# ---------------------------------------------------------
cat << 'STL_EOF' > cad/stl/README.md
# Pi5-Deck STL Files

Use this directory for STL files intended for 3D printing.

Suggested naming:
- `enclosure-top.stl`
- `enclosure-bottom.stl`
- `button-*.stl`
- `bracket-*.stl`
STL_EOF

# ---------------------------------------------------------
# .gitkeep for safety
# ---------------------------------------------------------
for d in cad/source cad/step cad/stl; do
  [ -f "$d/.gitkeep" ] || touch "$d/.gitkeep"
done

echo "== CAD scaffolding complete =="
