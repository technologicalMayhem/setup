#!/bin/bash

# Set directory to script location
cd "$(dirname "$0")"

# Install gnome-extensions-cli
python -m venv venv
source venv/bin/activate
pip3 install gnome-extensions-cli

# Install extensions
gnome-extensions-cli install $(< ./extensions.list)

# Configure
mkdir ~/.config
cp -r config/* ~/.config/

# Load dconf file mappings
source dconf/mappings
for ext in ${!dconf_mapping[@]}; do
  echo "Configuring $ext.."
  dconf load "${dconf_mapping[$ext]}" < dconf/$ext
done

# Cleanup
rm -r venv
deactivate
