#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (using sudo or as root user)!" >&2
  exit 1
fi

SOURCES_FILE="/etc/apt/sources.list"
BACKUP_FILE="/etc/apt/sources.list.bak"

echo "=== 1. Creating a backup of the current sources.list: $BACKUP_FILE ==="
cp "$SOURCES_FILE" "$BACKUP_FILE"

echo "=== 2. Updating package sources to Testing (including contrib & non-free) ==="
# Replace stable/trixie release names with 'testing' and add non-free sections for drivers
sed -i -E 's/\b(stable|trixie)\b/testing/g' "$SOURCES_FILE"
sed -i -E 's/(main)/\1 contrib non-free non-free-firmware/g' "$SOURCES_FILE"

# Clean up duplicates if contrib/non-free sections already existed
sed -i -E 's/(contrib non-free non-free-firmware\s*)+/contrib non-free non-free-firmware /g' "$SOURCES_FILE"

# Comment out unnecessary -updates and -backports lines for the Testing branch
sed -i -E 's/^([^#].*-(updates|backports).*)/# \1/g' "$SOURCES_FILE"

echo "=== 3. Upgrading the system to the Testing branch ==="
apt update
apt full-upgrade -y

echo "=== 3b. Adding sudo privileges to the current user ==="
# Install sudo if it was not included during the netinst phase
apt install -y sudo

# Detect the non-root user who initiated the script via sudo
# Fall back to the system USER variable if run directly as root
ACTIVE_USER="${SUDO_USER:-$USER}"

if [ "$ACTIVE_USER" = "root" ]; then
  echo "Warning: Script was run directly as root. No user was added to the sudo group."
else
  usermod -aG sudo "$ACTIVE_USER"
  echo "User '$ACTIVE_USER' successfully added to the sudo group."
fi

echo "=== 4. Installing Intel Wi-Fi and network management ==="
# firmware-iwlwifi is critical for Intel wireless cards
apt install -y firmware-iwlwifi intel-microcode network-manager network-manager-gnome

echo "=== 5. Installing Xorg, LightDM, and minimal Xfce + Whisker Menu ==="
# --no-install-recommends prevents heavy bloatware (like LibreOffice or games) from being installed
apt install --no-install-recommends -y \
    xorg \
    lightdm \
    lightdm-gtk-greeter \
    xfce4 \
    xfce4-whiskermenu-plugin \
    xfce4-terminal \
    thunar

echo "=== 6. Installing PipeWire, Bluetooth support, and Pavucontrol ==="
# libspa-0.2-bluetooth enables Bluetooth audio routing for PipeWire
apt install -y \
    pipewire \
    pipewire-pulse \
    wireplumber \
    libspa-0.2-bluetooth \
    bluez \
    blueman \
    pavucontrol

echo "=== 7. Installing TLP, TLP-GUI, and ThinkPad battery drivers ==="
# tp-smapi-dkms and acpi-call-dkms enable battery charge thresholds on ThinkPads
apt install -y tlp tlp-rdw tlpui tp-smapi-dkms acpi-call-dkms

# Enable and start the TLP service immediately
systemctl enable tlp
systemctl start tlp

echo "=== 8. Installing Firefox and desktop plugins ==="
apt install -y \
    firefox-esr \
    xfce4-pulseaudio-plugin
apt install featherpad

echo "=== 9. Cleaning up redundant packages ==="
apt autoremove -y
apt clean

echo "========================================================="
echo " Done! Your system is ready and sudo rights are configured."
echo " Please restart your computer using the command: reboot"
echo "========================================================="
