return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'rmarkdown', 'quarto', 'codecompanion' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { 'markdown', 'rmarkdown', 'quarto', 'codecompanion' },
    },
}
