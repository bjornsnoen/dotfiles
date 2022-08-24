return {
    'neovim/nvim-lspconfig',
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<Leader>[', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<Leader>]', vim.diagnostic.goto_next, opts)
        -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', function()
                vim.lsp.buf.references({ includeDeclaration = false })
            end, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<F18>', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('x', '<space>ca', vim.lsp.buf.code_action, bufopts)

            -- Disable formatting so we can handle it in null-ls
            client.resolved_capabilities.document_formatting = false
        end

        local lsp = require('lspconfig')
        local lsp_flags = {
            -- This is the default in Nvim 0.7+
            debounce_text_changes = 150,
        }

        for _, server in ipairs({ 'pyright', 'tsserver' }) do
            lsp[server].setup({
                on_attach = on_attach,
                flags = lsp_flags,
            })
        end
        lsp['sumneko_lua'].setup({
            on_attach = on_attach,
            flags = lsp_flags,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = 'space',
                            indent_size = 4,
                        },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                        maxPreload = 2000,
                        preloadFileSize = 1000,
                    },
                },
            },
        })
        vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]])
    end,
}
