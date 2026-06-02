#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Termux ↔ Ubuntu Integration =="

PREFIX="$HOME"
BIN="$PREFIX/bin"
INTEGRATION_DIR="$PREFIX/integration"

mkdir -p "$BIN" "$INTEGRATION_DIR"

# ---------------------------------------------------------
# Integration README
# ---------------------------------------------------------
cat << 'README_EOF' > "$INTEGRATION_DIR/README.md"
# Termux ↔ Ubuntu Integration (Pi5-Deck)

This integration layer provides:
- Shared filesystem mounts
- Unified PATH between Termux and Ubuntu
- X11/Wayland environment support
- Clipboard bridging
- A single launcher for entering Ubuntu

Files created:

- bin/ubuntu-launch  
- bin/ubuntu-binds.sh  
- bin/termux-path.sh  
- bin/ubuntu-x.sh  

Run `ubuntu-launch` to enter Ubuntu with full integration.
README_EOF

# ---------------------------------------------------------
# Bind Mount Script
# ---------------------------------------------------------
cat << 'BINDS_EOF' > "$BIN/ubuntu-binds.sh"
#!/usr/bin/env bash
set -euo pipefail

# Bind Termux home → Ubuntu home
BIND_HOME="--bind $HOME:/home/termux"

# Bind shared storage
BIND_STORAGE="--bind /sdcard:/sdcard"

# Bind Termux usr
BIND_USR="--bind $PREFIX:/termux"

# Combine
echo "$BIND_HOME $BIND_STORAGE $BIND_USR"
BINDS_EOF

chmod +x "$BIN/ubuntu-binds.sh"

# ---------------------------------------------------------
# PATH Injection Script
# ---------------------------------------------------------
cat << 'PATH_EOF' > "$BIN/termux-path.sh"
#!/usr/bin/env bash
set -euo pipefail

# Add Termux binaries to Ubuntu PATH
export PATH="/termux/bin:/termux/usr/bin:/termux/usr/sbin:$PATH"
export LD_LIBRARY_PATH="/termux/usr/lib:$LD_LIBRARY_PATH"
PATH_EOF

chmod +x "$BIN/termux-path.sh"

# ---------------------------------------------------------
# X11 / Wayland Environment Script
# ---------------------------------------------------------
cat << 'X11_EOF' > "$BIN/ubuntu-x.sh"
#!/usr/bin/env bash
set -euo pipefail

# X11
export DISPLAY=:0
export XAUTHORITY=/tmp/.Xauthority

# Wayland (if using termux-x11)
export WAYLAND_DISPLAY=wayland-0

# QT / GTK scaling
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland,x11
X11_EOF

chmod +x "$BIN/ubuntu-x.sh"

# ---------------------------------------------------------
# Ubuntu Launcher Script
# ---------------------------------------------------------
cat << 'LAUNCH_EOF' > "$BIN/ubuntu-launch"
#!/usr/bin/env bash
set -euo pipefail

# Load integration layers
source "$HOME/bin/termux-path.sh"
source "$HOME/bin/ubuntu-x.sh"

# Build bind arguments
BINDS=$(bash "$HOME/bin/ubuntu-binds.sh")

# Launch Ubuntu
proot-distro login ubuntu --shared-tmp $BINDS
LAUNCH_EOF

chmod +x "$BIN/ubuntu-launch"

echo "== Termux ↔ Ubuntu Integration Complete =="
echo "Run: ubuntu-launch"
