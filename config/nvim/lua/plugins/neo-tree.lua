return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        cmd = { 'Neotree' },
        keys = {
            {
                '<Leader>n',
                function()
                    require('neo-tree.command').execute({ toggle = true, reveal = true, dir = vim.fn.getcwd() })
                end,
                desc = 'Neo-tree reveal cwd',
            },
            {
                '<Leader>N',
                function()
                    require('neo-tree.command').execute({ toggle = true, dir = vim.fn.getcwd() })
                end,
                desc = 'Neo-tree toggle cwd',
            },
        },
        config = function()
            require('neo-tree').setup({
                close_if_last_window = true,
                filesystem = {
                    follow_current_file = { enabled = true },
                    hijack_netrw_behavior = 'open_default',
                },
                event_handlers = {
                    {
                        event = 'file_open_requested',
                        handler = function()
                            require('neo-tree.command').execute({ action = 'close' })
                        end,
                    },
                },
            })
        end,
    },
    {
        'antosha417/nvim-lsp-file-operations',
        event = 'LspAttach',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-neo-tree/neo-tree.nvim', -- makes sure that this loads after Neo-tree.
        },
        config = function()
            require('lsp-file-operations').setup()
        end,
    },
    -- {
    --   "s1n7ax/nvim-window-picker",
    --   version = "2.*",
    --   config = function()
    --     require("window-picker").setup({
    --       filter_rules = {
    --         include_current_win = false,
    --         autoselect_one = true,
    --         -- filter using buffer options
    --         bo = {
    --           -- if the file type is one of following, the window will be ignored
    --           filetype = { "neo-tree", "neo-tree-popup", "notify" },
    --           -- if the buffer type is one of following, the window will be ignored
    --           buftype = { "terminal", "quickfix" },
    --         },
    --       },
    --     })
    --   end,
    -- },
}
