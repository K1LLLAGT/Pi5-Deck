# Pi5 DECK — 7″ Touchscreen Build

A Raspberry Pi 5 turned into a compact **7″ touchscreen Linux computer**. The Pi mounts on the
back of the official Touch Display 2, runs Kali (or Raspberry Pi OS), and uses a regular USB
keyboard and mouse. Powered over USB-C — no battery, no soldering, no custom wiring.

This is the simplest way to build the deck: **mount → flash → plug in → boot.** An afternoon, start
to finish.

> Want the full handheld cyberdeck instead (built-in keyboard, internal battery, 3D-printed
> slab)? That path is fully documented too — see [Advanced build](#advanced-build-the-handheld-cyberdeck).

---

## At a glance

| | Spec |
|---|---|
| **Compute** | Raspberry Pi 5, 8GB (BCM2712, 4×A76 @ 2.4GHz) |
| **Display** | Raspberry Pi Touch Display 2 — 7″ IPS, 720×1280 native, run **landscape 1280×720**, 5-pt touch (DSI) |
| **Input** | Any USB keyboard + mouse (plug-and-play) |
| **Power** | USB-C PD supply (official 27W recommended) |
| **Cooling** | Official Active Cooler (or any Pi 5 cooler) — still required |
| **Storage** | microSD (simplest), or optional 1TB NVMe |
| **OS** | Kali Linux (Pi 5 ARM image) or Raspberry Pi OS |
| **Footprint** | ~189 × 120 mm (just the display), ~28 mm deep with the Pi behind |

---

## What you need

**Required**
- Raspberry Pi 5 (8GB)
- Raspberry Pi Touch Display 2 — buy a **current revision**
- Official Active Cooler (or equivalent Pi 5 cooler)
- microSD card, 32GB, A2 / U3
- USB-C PD power supply (27W official)
- USB keyboard + mouse

**Included with the display:** the DSI ribbon and the GPIO power jumper — no extra cables to buy.

**Optional add-ons** (see below): 1TB NVMe + M.2 HAT+ for fast storage, a USB-C power bank or UPS
HAT for portability, a case or stand.

---

## Build it (5 steps)

1. **Mount the Pi.** The Pi 5 screws to the Touch Display 2's pre-installed M2.5 standoffs
   (58 × 49 mm pattern). Seat the **22-pin DSI ribbon** into **DSI1**, and connect the included
   jumper for **5V (GPIO pin 2)** and **GND (pin 6)** to power the panel.
2. **Fit the cooler.** Attach the Active Cooler to the SoC and plug its fan into the Pi 5 4-pin fan
   header. Active cooling is not optional on a Pi 5.
3. **Flash the OS.** Use Raspberry Pi Imager to write Kali (Pi 5 ARM image) or Raspberry Pi OS to
   the microSD. In Imager's advanced options set hostname, user, SSH, and Wi-Fi.
4. **First boot & configure.** Power on with the USB-C supply, then:
   ```bash
   sudo apt update && sudo apt full-upgrade -y
   ```
   Rotate the panel to landscape (it's portrait-native), e.g. on Wayland:
   ```bash
   wlr-randr --output DSI-1 --transform 90
   ```
   Add to `/boot/firmware/config.txt`:
   ```
   usb_max_current_enable=1
   ```
5. **Plug in peripherals.** Connect the USB keyboard and mouse to any USB-A port. They're
   plug-and-play — no drivers. Touch works via libinput; recalibrate if offset after rotating.

That's a working deck.

---

## Verify

- Boots to the desktop/console on the 7″ panel, in landscape
- Touch tracks correctly
- Keyboard and mouse work
- Thermals are healthy under load:
  ```bash
  vcgencmd measure_temp
  vcgencmd get_throttled     # 0x0 = healthy
  ```

---

## Optional add-ons

- **Fast storage (NVMe).** Add the official M.2 HAT+ and a 1TB **2242** NVMe, then migrate the OS
  off the microSD with the included `nvme-migrate.sh` (run it on the Pi as root — it clones the
  system and sets the bootloader to prefer NVMe). See the script header for details.
- **Portability.** Run from a USB-C PD power bank, or add a UPS HAT later for an internal battery.
- **Enclosure.** Print or buy a case/stand. The full handheld enclosure is documented in the
  advanced build below.

---

## Software notes

- **OS:** Kali's Pi 5 ARM image suits security-research use and the DSI panel is driver-free on it;
  Raspberry Pi OS is the lighter general-purpose option.
- **Display revision:** buy a current Touch Display 2 — older revisions can trip the Pi 5's
  power-detection and refuse to boot.
- **Thermals:** confirm `vcgencmd get_throttled` stays `0x0` under load.

---

## Advanced build: the handheld cyberdeck

If you'd rather build the full self-contained handheld — physical BlackBerry-style keyboard,
internal 4× 21700 battery via a UPS HAT, NVMe, and a 3D-printed slab enclosure — the complete
reference is in this repo:

| Document | Purpose |
| --- | --- |
| `Pi5-Handheld-Terminal-Blueprint.md` | Full blueprint + shopping list — start here |
| `Pi5-Deck-Wiring.md` | Wiring diagram: UPS HAT, display, I2C, cooler, charging |
| `Pi5-Deck-CAD-Handoff.md` | Dimensioned enclosure / CAD handoff |
| `Pi5-DECK-Build-Guide.pdf` | Full illustrated build guide |
| `nvme-migrate.sh` | SD-card → NVMe migration helper (used by both builds) |

That path involves Li-ion cells and GPIO wiring — read its safety notes before sourcing parts.

---

## License

MIT License — © 2026 Greg. See [`LICENSE`](LICENSE).
