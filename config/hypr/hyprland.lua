-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    input = {
        kb_layout = 'no_custom',
        kb_variant = '',
        kb_model = 'pc104',
        kb_options = 'ctrl:swapcaps,altwin:swap_lalt_lwin',
        kb_rules = '',
        follow_mouse = 1,
        natural_scroll = true,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
    general = {
        gaps_in = 1,
        gaps_out = 0,
        border_size = 0,
        col = {
            active_border = {
                colors = { 'rgba(33ccffee)', 'rgba(00ff99ee)' },
                angle = 45,
            },
            inactive_border = 'rgba(595959aa)',
        },
        layout = 'dwindle',
    },
    decoration = {
        rounding = 2,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 'rgba(1a1a1aee)',
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = 'master',
    },
    cursor = {
        no_hardware_cursors = true,
    },
    debug = {
        disable_logs = true,
    },
    ecosystem = {
        no_update_news = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve('myBezier', {
    type = 'bezier',
    points = {
        { 0.05, 0.9 },
        { 0.1, 1.05 },
    },
})

hl.animation({ leaf = 'windows', enabled = true, speed = 7, bezier = 'myBezier' })
hl.animation({ leaf = 'windowsOut', enabled = true, speed = 7, bezier = 'default', style = 'popin 80%' })
hl.animation({ leaf = 'border', enabled = true, speed = 10, bezier = 'default' })
hl.animation({ leaf = 'borderangle', enabled = true, speed = 8, bezier = 'default' })
hl.animation({ leaf = 'fade', enabled = true, speed = 7, bezier = 'default' })
hl.animation({ leaf = 'workspaces', enabled = true, speed = 6, bezier = 'default' })

hl.gesture({
    fingers = 3,
    direction = 'horizontal',
    action = 'workspace',
})

hl.window_rule({
    name = 'kitty-no-blur-or-shadow',
    match = { class = '^(kitty)$' },
    no_blur = true,
    no_shadow = true,
})

hl.env('GRIM_DEFAULT_DIR', '/home/bjorn/Pictures/Screenshots')
hl.env('XDG_SCREENSHOTS_DIR', '/home/bjorn/Pictures/Screenshots')
hl.env('MOZ_DISABLE_RDD_SANDBOX', '1')
hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')
hl.env('XCURSOR_SIZE', '24')

require('monitors')
require('keybinds')
require('autorun')
