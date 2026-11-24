return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'rmarkdown', 'quarto' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { 'markdown', 'rmarkdown', 'quarto' },
        -- Leave LSP popup rendering and sizing to its signature/hover provider.
        ignore = function(buf)
            return vim.bo[buf].buftype == 'nofile'
        end,
    },
}
