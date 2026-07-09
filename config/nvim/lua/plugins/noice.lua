return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
        ---@type NoicePresets
        presets = {
            bottom_search = true,
        },
        routes = {
            {
                filter = {
                    event = 'lsp',
                    kind = 'progress',
                    cond = function(msg)
                        local progress = msg.opts and msg.opts.progress
                        if not progress or not progress.client_id then
                            return false
                        end
                        local client = vim.lsp.get_client_by_id(progress.client_id)
                        return client and client.name == 'sonarlint.nvim'
                    end,
                },
                opts = { skip = true },
            },
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        'MunifTanjim/nui.nvim',
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        'rcarriga/nvim-notify',
    },
}
