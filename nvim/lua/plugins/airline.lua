return {
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            theme = 'codedark',
            icons_enabled = false,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = { 'dap-repl' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = {
                {
                    'lsp_status',
                    ignore_lsp = { 
                        "null-ls",
                        "tailwindcss",
                        "GitHub Copilot",
                        "eslint",
                    }
                }
            },
        },
        tabline = {
            lualine_a = { { 'buffers', mode = 2 } },
            lualine_z = { 'tabs' },
        },
    },
}
