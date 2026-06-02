#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Firmware Scaffolding =="

mkdir -p firmware/overlays firmware/configs firmware/scripts

# ---------------------------------------------------------
# Device Tree Overlay Example
# ---------------------------------------------------------
cat << 'DTS_EOF' > firmware/overlays/example-overlay.dts
/dts-v1/;
/plugin/;

/ {
    compatible = "brcm,bcm2712";

    fragment@0 {
        target = <&gpio>;
        __overlay__ {
            pi5deck_test_pin: test_pin {
                brcm,pins = <17>;
                brcm,function = <1>; /* output */
                brcm,pull = <0>;
            };
        };
    };
};
DTS_EOF

# ---------------------------------------------------------
# Boot Config Template
# ---------------------------------------------------------
cat << 'BOOT_EOF' > firmware/configs/boot-config.txt
# Pi5-Deck Boot Configuration
# Add overlays, kernel params, and tuning here.

# Example overlay
dtoverlay=example-overlay

# Enable I2C
dtparam=i2c_arm=on

# Enable SPI
dtparam=spi=on

# GPU memory split
gpu_mem=128
BOOT_EOF

# ---------------------------------------------------------
# Firmware Apply Script
# ---------------------------------------------------------
cat << 'SCRIPT_EOF' > firmware/scripts/apply-firmware.sh
#!/usr/bin/env bash
set -euo pipefail

echo "Applying Pi5-Deck firmware..."

OVERLAY_SRC="firmware/overlays/example-overlay.dts"
OVERLAY_OUT="/boot/overlays/example-overlay.dtbo"
BOOTCFG_SRC="firmware/configs/boot-config.txt"
BOOTCFG_DST="/boot/config.txt"

echo "[*] Compiling overlay..."
dtc -@ -I dts -O dtb "$OVERLAY_SRC" -o "$OVERLAY_OUT"

echo "[*] Installing boot config..."
cp "$BOOTCFG_SRC" "$BOOTCFG_DST"

echo "Firmware applied. Reboot recommended."
SCRIPT_EOF

chmod +x firmware/scripts/apply-firmware.sh

echo "== Firmware scaffolding complete =="
