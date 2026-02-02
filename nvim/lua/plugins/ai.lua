return {
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
    keys = {
        { '<leader>aa', '<cmd>CodeCompanionChat<cr>', desc = 'CodeCompanion Chat' },
    },
    config = function(_, opts)
        require('codecompanion').setup(opts)

        -- Suppress CodeCompanion prompt library warnings
        local original_notify = vim.notify
        vim.notify = function(msg, level, notify_opts)
            if type(msg) == 'string' and msg:match('%[Prompt Library%]') then
                return
            end
            original_notify(msg, level, notify_opts)
        end
    end,
    opts = {
        display = {
            chat = {
                show_tools_processing = true,
            },
        },
        adapters = {
            http = {
                copilot = function()
                    return require('codecompanion.adapters').extend('copilot', {
                        opts = {
                            tools = true,
                        },
                    })
                end,
            },
        },
        interactions = {
            chat = {
                adapter = { name = 'copilot', model = 'claude-sonnet-4.5' },
                tools = {
                    opts = {
                        default_tools = { 'mcp', 'full_stack_dev' },
                        auto_submit_errors = true,
                        auto_submit_success = true,
                    },
                },
            },
            inline = { adapter = { name = 'copilot', model = 'claude-sonnet-4.5' } },
        },
        extensions = {
            mcphub = {
                callback = 'mcphub.extensions.codecompanion',
                opts = {
                    make_tools = true,
                    show_server_tools_in_chat = true,
                    add_mcp_prefix_to_tool_names = false,
                    show_result_in_chat = true,
                    make_vars = true,
                    make_slash_commands = true,
                },
            },
        },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
        'stevearc/dressing.nvim',
        {
            'zbirenbaum/copilot.lua',
            opts = {
                suggestion = { enabled = false },
                panel = { enabled = false },
            },
        },
    },
}
