#!/usr/bin/env python

# Desc: Set up custom gnome settings

import json
from subprocess import run

number_of_workspaces = 10


def gsettings(subcommand: str):
    parts = subcommand.split(" ")
    return run(["gsettings"] + parts, capture_output=True)


# Set number of workspaces
gsettings(f"set org.gnome.desktop.wm.preferences num-workspaces {number_of_workspaces}")

for i in range(number_of_workspaces):
    workspace = i
    if i == 0:
        workspace = 10

    gsettings(f"set org.gnome.desktop.wm.keybindings switch-to-workspace-{workspace} ['<Super>{i}']")
    gsettings(f"set org.gnome.desktop.wm.keybindings move-to-workspace-{workspace} ['<Super><Ctrl>{i}']")

# Set Super+Ctrl+Q to close the window
gsettings("set org.gnome.desktop.wm.keybindings close ['<Super><Ctrl>q']")


def create_custom_bind(shell_cmd, key):
    existing_keys_setting = (
        gsettings("get org.gnome.settings-daemon.plugins.media-keys custom-keybindings")
        .stdout.decode("utf-8")
        .strip()
    )

    if existing_keys_setting == "":
        existing_keys = []
    else:
        double_quoted = existing_keys_setting.replace("'", '"')
        existing_keys = json.loads(double_quoted)

    new_key = f"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/{key}/"
    new_keys = existing_keys
    if new_key not in existing_keys:
        new_keys.append(new_key)

    new_keys_setting = str(new_keys)
    gsettings(f"set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '{new_keys_setting}'")

    section = "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
    subsection = f"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/{key}/"
    gsettings(f"set {section}:{subsection}{key}/ name '{shell_cmd}'")
    gsettings(f"set {section}:{subsection}{key}/ command '{shell_cmd}'")
    gsettings(f"set {section}:{subsection}{key}/ binding '{key}'")


create_custom_bind("albert toggle", "<Super>r")
create_custom_bind("kitty", "<Super>Return")
