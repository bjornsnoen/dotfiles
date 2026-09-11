hl.on('hyprland.start', function()
    -- System essentials
    hl.exec_cmd('dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')
    hl.exec_cmd('waybar')
    hl.exec_cmd('albert')
    hl.exec_cmd('dunst')
    hl.exec_cmd('/usr/lib/mate-polkit/polkit-mate-authentication-agent-1')
    hl.exec_cmd('swww-daemon')
    hl.exec_cmd('waypaper --restore')
    hl.exec_cmd('hypridle')

    -- Tray applications
    hl.exec_cmd('udiskie --tray --no-automount')
    hl.exec_cmd('nm-applet')
    hl.exec_cmd('blueman-applet')
    hl.exec_cmd('~/bin/evolution-tray')
    hl.exec_cmd('~/bin/piholetray')
    hl.exec_cmd('dex /usr/share/applications/bitwarden.desktop')

    -- Default applications
    hl.exec_cmd('kitty', { workspace = '1 silent' })
    hl.exec_cmd('firefox-developer-edition', { workspace = '2 silent' })
    hl.exec_cmd('evolution', { workspace = '3 silent' })
end)
