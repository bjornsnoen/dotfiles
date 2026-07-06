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
    config = function(_, opts)
        local overseer = require('overseer')
        overseer.setup(opts)
        -- The builtin mise template sets cwd to the dir containing the found
        -- mise.toml (e.g. ~/src/dnv), breaking tasks that depend on running
        -- from the current repo. Run mise tasks from vim's cwd instead; mise
        -- still finds the config by searching upward.
        overseer.add_template_hook({ module = '^mise$' }, function(task_defn)
            task_defn.cwd = vim.fn.getcwd()
        end)
    end,
}

