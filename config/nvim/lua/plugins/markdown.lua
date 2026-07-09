return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'rmarkdown', 'quarto' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { 'markdown', 'rmarkdown', 'quarto' },
    },
}
