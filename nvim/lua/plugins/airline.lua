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
            lualine_b = {},
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = {
                {
                    'lsp_status',
                    ignore_lsp = {
                        'null-ls',
                        'tailwindcss',
                        'GitHub Copilot',
                        'eslint',
                        'sonarlint',
                    },
                },
            },
        },
        tabline = {
            lualine_a = {
                {
                    'buffers',
                    mode = 0,
                    fmt = function(buffer_name, ctx)
                        local buf_nr = ctx.bufnr
                        local is_listed = vim.bo[buf_nr].buflisted

                        if not is_listed then
                            return ''
                        end

                        return buffer_name
                    end,
                },
            },
            lualine_y = { 'branch' },
            lualine_z = { 'diff' },
        },
    },
}
