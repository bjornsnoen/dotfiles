local mainMod = 'SUPER'

-- Main keys
hl.bind(mainMod .. ' + Return', hl.dsp.exec_cmd('kitty'))
hl.bind(mainMod .. ' + CTRL + Q', hl.dsp.window.close())
hl.bind(mainMod .. ' + CTRL + M', hl.dsp.exit())
hl.bind(mainMod .. ' + V', hl.dsp.window.float({ action = 'toggle' }))
hl.bind(mainMod .. ' + R', hl.dsp.exec_cmd('anyrun'))
hl.bind(mainMod .. ' + CTRL + R', hl.dsp.exec_cmd('hyprctl reload'))
hl.bind(mainMod .. ' + F', hl.dsp.window.fullscreen())

-- Move focus with mainMod + Vim keys.
hl.bind(mainMod .. ' + j', hl.dsp.focus({ direction = 'left' }))
hl.bind(mainMod .. ' + k', hl.dsp.focus({ direction = 'right' }))
hl.bind(mainMod .. ' + h', hl.dsp.focus({ direction = 'up' }))
hl.bind(mainMod .. ' + l', hl.dsp.focus({ direction = 'down' }))

-- Switch workspaces or move the active window with mainMod + [0-9].
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. ' + ' .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. ' + CTRL + ' .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll.
hl.bind(mainMod .. ' + mouse_down', hl.dsp.focus({ workspace = 'e+1' }))
hl.bind(mainMod .. ' + mouse_up', hl.dsp.focus({ workspace = 'e-1' }))

-- Move/resize windows with mainMod + LMB/RMB and dragging.
hl.bind(mainMod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Audio
hl.bind('XF86AudioMute', hl.dsp.exec_cmd('pactl set-sink-mute @DEFAULT_SINK@ toggle'))
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd('pactl set-source-mute @DEFAULT_SOURCE@ toggle'))
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('pactl set-sink-volume @DEFAULT_SINK@ -5%'))
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('pactl set-sink-volume @DEFAULT_SINK@ +5%'))
hl.bind('XF86AudioPlay', hl.dsp.exec_cmd('playerctl play-pause'))
-- Cancel is the hang-up button.
hl.bind('Cancel', hl.dsp.exec_cmd('playerctl play-pause'))
hl.bind('XF86AudioNext', hl.dsp.exec_cmd('playerctl next'))
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd('playerctl previous'))

-- Brightness
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd('brightnessctl set 1+'))
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd('brightnessctl set 1-'))

-- Print screen
hl.env('GRIMBLAST_EDITOR', 'ksnip')
hl.bind('PRINT', hl.dsp.exec_cmd('grimblast --notify copy area'))
hl.bind('SHIFT + PRINT', hl.dsp.exec_cmd('grimblast edit area'))
hl.bind(mainMod .. ' + PRINT', hl.dsp.exec_cmd('grimblast --notify save area'))
hl.bind(mainMod .. ' + SHIFT + PRINT', hl.dsp.exec_cmd('grimblast --notify save screen'))
hl.bind('CTRL + SHIFT + PRINT', hl.dsp.exec_cmd('grimblast edit screen'))

-- Monitors
hl.bind(mainMod .. ' + o', hl.dsp.workspace.move({ monitor = '+1' }))

-- Suspend
hl.bind('Pause', hl.dsp.exec_cmd('loginctl lock-session'))
hl.bind(mainMod .. ' + Pause', hl.dsp.exec_cmd('systemctl suspend'))
hl.bind(mainMod .. ' + P', hl.dsp.exec_cmd('loginctl lock-session'))
hl.bind(mainMod .. ' + CTRL + P', hl.dsp.exec_cmd('systemctl suspend'))

-- Waybar reload
hl.bind(mainMod .. ' + CTRL + B', hl.dsp.exec_cmd('pkill waybar || true && waybar'))

-- Slack
hl.bind(mainMod .. ' + s', hl.dsp.exec_cmd('killall slack && dex /usr/share/applications/slack.desktop'))
hl.bind(mainMod .. ' + SHIFT + s', hl.dsp.exec_cmd('killall slack'))
