#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Electrical / KiCad Scaffolding =="

mkdir -p electrical/schematics electrical/harness

# ---------------------------------------------------------
# Schematics README
# ---------------------------------------------------------
cat << 'SCHEM_EOF' > electrical/schematics/README.md
# Pi5-Deck Electrical Schematics

Place all KiCad schematic files here.

Recommended structure:
- `pi5deck.kicad_pro` — KiCad project file
- `pi5deck.kicad_sch` — main schematic
- `pi5deck.kicad_pcb` — PCB layout (if applicable)
- `symbols/` — custom schematic symbols
- `footprints/` — custom PCB footprints
- `pdf/` — exported schematic PDFs

Notes:
- Keep all electrical documentation version-controlled.
- Export PDFs for non-KiCad users.
SCHEM_EOF

# ---------------------------------------------------------
# Harness README
# ---------------------------------------------------------
cat << 'HARNESS_EOF' > electrical/harness/README.md
# Pi5-Deck Wiring Harness Documentation

Use this directory for:
- Pinout tables
- Cable harness drawings
- Connector maps
- Wiring diagrams

Suggested files:
- `harness-map.csv`
- `pinout-gpio.csv`
- `display-connector-map.csv`
HARNESS_EOF

# ---------------------------------------------------------
# Harness Template CSV
# ---------------------------------------------------------
cat << 'CSV_EOF' > electrical/harness/harness-map.csv
Connector,Pin,Signal,Direction,Voltage,Notes
GPIO,1,3V3,Power,3.3V,---
GPIO,2,5V,Power,5V,---
GPIO,3,SDA,I/O,3.3V,I2C bus
GPIO,5,SCL,I/O,3.3V,I2C bus
DISPLAY,1,VBUS,Power,5V,Display power
DISPLAY,2,D+,Data,USB,Touch interface
DISPLAY,3,D-,Data,USB,Touch interface
CSV_EOF

# ---------------------------------------------------------
# KiCad Project Placeholders
# ---------------------------------------------------------
cat << 'KPRO_EOF' > electrical/schematics/pi5deck.kicad_pro
(kicad_pro_placeholder "Pi5-Deck Project")
KPRO_EOF

cat << 'KSCH_EOF' > electrical/schematics/pi5deck.kicad_sch
(kicad_schematic_placeholder "Pi5-Deck Schematic")
KSCH_EOF

cat << 'KPCB_EOF' > electrical/schematics/pi5deck.kicad_pcb
(kicad_pcb_placeholder "Pi5-Deck PCB Layout")
KPCB_EOF

# ---------------------------------------------------------
# .gitkeep for safety
# ---------------------------------------------------------
for d in electrical/schematics electrical/harness; do
  [ -f "$d/.gitkeep" ] || touch "$d/.gitkeep"
done

echo "== Electrical scaffolding complete =="
