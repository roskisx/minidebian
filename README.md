# minidebian
# Debian Testing Netinst Post-Install for Intel ThinkPads

A minimal Bash script to upgrade a fresh Debian stable netinstall to the **Debian Testing** branch and set up a lightweight, optimized **Xfce** desktop environment specifically configured for **Intel-based Lenovo ThinkPads**.

## Features

- 🚀 **Debian Testing Upgrade:** Automatically switches repositories from stable/Trixie to testing/Forky.
- 📦 **Non-Free Firmware:** Enables `contrib`, `non-free`, and `non-free-firmware` sections for maximum hardware compatibility.
- ⚙️ **Sudo Configuration:** Automatically detects the non-root user running the script and grants them sudo privileges.
- 💻 **Minimal Xfce Desktop:** Installs a clean Xfce environment using `--no-install-recommends` to keep it free from bloatware (no pre-installed games or heavy office suites).
- 🔍 **Modern Addons:** Includes `xfce4-whiskermenu-plugin` and `xfce4-pulseaudio-plugin`.
- 🌐 **Intel Wi-Fi & Networking:** Installs `firmware-iwlwifi`, `intel-microcode`, and NetworkManager with a system tray applet.
- 🔊 **Modern Audio:** Deploys **PipeWire** with full PulseAudio compatibility (`pipewire-pulse`), WirePlumber, and Bluetooth audio support.
- 🔋 **ThinkPad Battery & Power Optimization:** Installs **TLP** along with the grahical interface **TLPUI** and DKMS packages (`tp-smapi`, `acpi-call`) for setting battery charge thresholds.
- 🦊 **Browser:** Installs the stable and official **Firefox ESR**.

## Prerequisites

1. Perform a fresh **Debian Stable Netinstall**.
2. During the *Tasksel* installation step (software selection), **uncheck all desktop environments** and only leave **Standard system utilities** (and optionally *SSH server*) selected. This ensures the script builds upon a truly minimal base.

## Usage

Clone this repository or download the script directly onto your fresh Debian installation:

```bash
# Download the script
 

# Make it executable
 
# Run it with sudo (or as root)
 
```

Once the script finishes execution, reboot your machine to log into your brand new graphical environment:

```bash
sudo reboot
```

## Post-Installation Tips

### Activating the Whisker Menu
1. Right-click your Xfce panel -> **Panel** -> **Add New Items...**
2. Search for **Whisker Menu** and click **Add**.
3. Right-click the newly added menu icon to move it to your preferred position (e.g., top-left corner) and remove the old default menu.

### Setting Battery Thresholds
Open the **TLPUI** application from your application menu to configure your battery charging rules (e.g., stop charging at 80% to prolong battery health).

## License

This project is open-source and available under the [MIT License](LICENSE).

