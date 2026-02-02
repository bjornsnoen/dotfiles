return {
    'stevearc/overseer.nvim',
    cmd = {
        'OverseerRun',
        'OverseerToggle',
        'OverseerOpen',
        'OverseerClose',
        'OverseerInfo',
        'OverseerBuild',
        'OverseerQuickAction',
        'OverseerTaskAction',
        'OverseerShell',
    },
    keys = {
        { '<leader>or', '<cmd>OverseerRun<cr>', desc = 'Overseer Run' },
        { '<leader>ot', '<cmd>OverseerToggle<cr>', desc = 'Overseer Toggle' },
        { '<leader>oo', '<cmd>OverseerOpen<cr>', desc = 'Overseer Open' },
        { '<leader>oc', '<cmd>OverseerClose<cr>', desc = 'Overseer Close' },
        { '<leader>oi', '<cmd>OverseerInfo<cr>', desc = 'Overseer Info' },
        { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = 'Overseer Build' },
        { '<leader>oq', '<cmd>OverseerQuickAction<cr>', desc = 'Overseer Quick Action' },
        { '<leader>oa', '<cmd>OverseerTaskAction<cr>', desc = 'Overseer Task Action' },
        { '<leader>os', '<cmd>OverseerShell<cr>', desc = 'Overseer Shell' },
    },
    opts = {
        task_list = {
            direction = 'bottom',
            min_height = 25,
            max_height = 25,
            default_detail = 1,
        },
    },
}

