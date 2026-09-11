-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = 'eDP-1', mode = 'highres', position = 'auto', scale = 'auto' })
-- hl.monitor({ output = 'eDP-1', disabled = true })
hl.monitor({
    output = 'desc:Philips Consumer Electronics Company PHL 27B1U5601 UK02241049060',
    mode = 'preferred',
    position = 'auto-left',
    scale = 1,
})
hl.monitor({
    output = 'desc:Panasonic Industry Company Panasonic-TV 0x01010101',
    mode = '1920x1080',
    position = 'auto-right',
    scale = 2,
})
hl.monitor({
    output = 'desc:Lenovo Group Limited P27q-20 V9062YAA',
    mode = 'preferred',
    position = 'auto-right',
    scale = 1.25,
})
hl.monitor({
    output = 'desc:LG Electronics LG HDR 4K 0x01010101',
    mode = 'preferred',
    position = 'auto-right',
    scale = 1.5,
})
hl.monitor({
    output = 'desc:LG Electronics LG HDR 4K',
    mode = 'preferred',
    position = 'auto-right',
    scale = 1.5,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.env('GDK_SCALE', '1')

-- NVIDIA
hl.env('LIBVA_DRIVER_NAME', 'nvidia')
hl.env('XDG_SESSION_TYPE', 'wayland')
hl.env('GBM_BACKEND', 'nvidia-drm')
hl.env('__GLX_VENDOR_LIBRARY_NAME', 'nvidia')
hl.env('NVD_BACKEND', 'direct')
hl.env('AQ_DRM_DEVICES', '/dev/dri/intel-gpu:/dev/dri/nvidia-gpu')
