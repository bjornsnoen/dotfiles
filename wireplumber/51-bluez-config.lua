bluez_monitor.rules = {
    -- An array of matches/actions to evaluate.
    {
        -- Rules for matching a device or node. It is an array of
        -- properties that all need to match the regexp. If any of the
        -- matches work, the actions are executed for the object.
        matches = {
            {
                -- This matches all cards.
                { 'device.name', 'matches', 'bluez_card.*' },
            },
        },
        -- Apply properties on the matched object.
        apply_properties = {
            -- Auto-connect device profiles on start up or when only partial
            -- profiles have connected. Disabled by default if the property
            -- is not specified.
            --["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink hfp_ag hsp_ag a2dp_source ]",

            -- Hardware volume control (default: [ hfp_ag hsp_ag a2dp_source ])
            --["bluez5.hw-volume"] = "[ hfp_hf hsp_hs a2dp_sink hfp_ag hsp_ag a2dp_source ]",

            -- LDAC encoding quality
            -- Available values: auto (Adaptive Bitrate, default)
            --                   hq   (High Quality, 990/909kbps)
            --                   sq   (Standard Quality, 660/606kbps)
            --                   mq   (Mobile use Quality, 330/303kbps)
            ['bluez5.a2dp.ldac.quality'] = 'sq',

            -- AAC variable bitrate mode
            -- Available values: 0 (cbr, default), 1-5 (quality level)
            --["bluez5.a2dp.aac.bitratemode"] = 0,

            -- Profile connected first
            -- Available values: a2dp-sink (default), headset-head-unit
            --["device.profile"] = "a2dp-sink",

            -- Opus Pro Audio encoding mode: audio, voip, lowdelay
            --["bluez5.a2dp.opus.pro.application"] = "audio",
            --["bluez5.a2dp.opus.pro.bidi.application"] = "audio",
        },
    },
    {
        matches = {
            {
                -- Matches all sources.
                { 'node.name', 'matches', 'bluez_input.*' },
            },
            {
                -- Matches all sinks.
                { 'node.name', 'matches', 'bluez_output.*' },
            },
        },
        apply_properties = {
            --["node.nick"] = "My Node",
            --["priority.driver"] = 100,
            --["priority.session"] = 100,
            --["node.pause-on-idle"] = false,
            --["resample.quality"] = 4,
            --["channelmix.normalize"] = false,
            --["channelmix.mix-lfe"] = false,
            --["session.suspend-timeout-seconds"] = 5,  -- 0 disables suspend
            --["monitor.channel-volumes"] = false,

            -- Media source role, "input" or "playback"
            -- Defaults to "playback", playing stream to speakers
            -- Set to "input" to use as an input for apps
            --["bluez5.media-source-role"] = "input",
        },
    },
}
