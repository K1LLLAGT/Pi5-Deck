#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Release Packaging =="

VERSION="${1:-0.1.0}"
DATE="$(date +"%Y-%m-%d")"
RELEASE_DIR="build/releases/pi5deck-$VERSION"
ARCHIVE="pi5deck-$VERSION.zip"

echo "[*] Creating release directory: $RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# ---------------------------------------------------------
# Copy project components into release bundle
# ---------------------------------------------------------
echo "[*] Copying project files..."

cp -r docs "$RELEASE_DIR/"
cp -r cad "$RELEASE_DIR/"
cp -r firmware "$RELEASE_DIR/"
cp -r electrical "$RELEASE_DIR/"
cp -r assets "$RELEASE_DIR/"
cp -r scripts "$RELEASE_DIR/"

# Include top-level files if present
for f in README.md LICENSE; do
  if [ -f "$f" ]; then
    cp "$f" "$RELEASE_DIR/"
  fi
done

# ---------------------------------------------------------
# Generate release notes
# ---------------------------------------------------------
echo "[*] Generating release notes..."

cat << NOTES_EOF > "$RELEASE_DIR/release-notes.txt"
Pi5-Deck Release $VERSION
Date: $DATE

Included components:
- Documentation (docs/)
- CAD files (cad/)
- Firmware overlays & configs (firmware/)
- Electrical schematics & harness maps (electrical/)
- Renders & photos (assets/)
- Utility scripts (scripts/)

This release contains the full project structure and assets
as of version $VERSION.

NOTES_EOF

# ---------------------------------------------------------
# Generate manifest
# ---------------------------------------------------------
echo "[*] Creating manifest..."

cat << MANIFEST_EOF > "$RELEASE_DIR/manifest.json"
{
  "project": "Pi5-Deck",
  "version": "$VERSION",
  "date": "$DATE",
  "contents": [
    "docs/",
    "cad/",
    "firmware/",
    "electrical/",
    "assets/",
    "scripts/",
    "README.md",
    "LICENSE",
    "release-notes.txt"
  ]
}
MANIFEST_EOF

# ---------------------------------------------------------
# Create ZIP archive
# ---------------------------------------------------------
echo "[*] Creating ZIP archive: $ARCHIVE"

(
  cd build/releases
  zip -r "$ARCHIVE" "pi5deck-$VERSION" >/dev/null
)

# ---------------------------------------------------------
# Generate checksums
# ---------------------------------------------------------
echo "[*] Generating checksums..."

(
  cd build/releases
  sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"
)

echo "== Release packaging complete =="
echo "Release archive: build/releases/$ARCHIVE"
