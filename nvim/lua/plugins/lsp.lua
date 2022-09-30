return {
    'neovim/nvim-lspconfig',
    requires = {
        'hrsh7th/cmp-nvim-lsp',
        'b0o/schemastore.nvim',
        -- 'ray-x/lsp_signature.nvim',
    },
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<Leader>[', function()
            vim.diagnostic.goto_prev({ float = false })
        end, opts)
        vim.keymap.set('n', '<Leader>]', function()
            vim.diagnostic.goto_next({ float = false })
        end, opts)
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

            -- Diagnostics float on hold
            vim.api.nvim_create_autocmd('CursorHold', {
                buffer = bufnr,
                callback = function()
                    local diagnostics_opts = {
                        focusable = false,
                        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'cursor',
                    }
                    vim.diagnostic.open_float(nil, diagnostics_opts)
                end,
            })
            vim.diagnostic.config({ virtual_text = false })

            -- -- Signature helper
            -- local signature_setup = {
            --     bind = true,
            --     handler_opts = {
            --         border = 'rounded',
            --     },
            -- }
            -- require('lsp_signature').on_attach(signature_setup, bufnr)
        end

        local lsp_flags = {
            -- This is the default in Nvim 0.7+
            debounce_text_changes = 150,
        }

        local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

        for _, server in ipairs({
            'pyright',
            'tsserver',
            'sumneko_lua',
            'jsonls',
            'yamlls',
            'taplo',
            'eslint',
        }) do
            local settings
            if server == 'sumneko_lua' then
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim', 'awesome' },
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
                }
            elseif server == 'jsonls' then
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                }
            else
                settings = {}
            end

            require('lspconfig')[server].setup({
                on_attach = on_attach,
                flags = lsp_flags,
                capabilities = capabilities,
                settings = settings,
            })
        end

        vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]])
        vim.cmd([[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll]])
    end,
}
