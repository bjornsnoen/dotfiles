local servers = {
    'vtsls',
    'pyright',
    'lua_ls',
    'jsonls',
    'yamlls',
    'taplo',
    'eslint',
    'omnisharp_mono',
    'tailwindcss',
    'svelte',
    'phpactor',
    'cssls',
    'terraformls',
    'rust_analyzer',
    'prismals',
    'twiggy_language_server',
    'vuels',
    'pylsp',
    'dockerls',
    'sqls',
}

return {
    'neovim/nvim-lspconfig',
    version = 'v1.0.0',
    dependencies = {
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = {
                'williamboman/mason.nvim',
            },
        },
        'hrsh7th/cmp-nvim-lsp',
        'b0o/schemastore.nvim',
        'jose-elias-alvarez/typescript.nvim',
    },
    config = function()
        local opts = { noremap = true, silent = true }
        -- We must do this here to ensure that the LSP servers are installed before we try to use them
        local lspconfig = require('mason-lspconfig')
        lspconfig.setup({
            ensure_installed = servers,
        })
        vim.keymap.set('n', '<Leader>[', function()
            vim.diagnostic.goto_prev({ float = false })
        end, opts)
        vim.keymap.set('n', '<Leader>]', function()
            vim.diagnostic.goto_next({ float = false })
        end, opts)

        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

        local lsp_formatting = function(bufnr)
            vim.lsp.buf.format({
                filter = function(client)
                    -- apply whatever logic you want (in this example, we'll only use null-ls)
                    return client.name == 'null-ls'
                end,
                bufnr = bufnr,
            })
        end

        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<F18>', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('x', '<Leader>ca', vim.lsp.buf.code_action, bufopts)

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

            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting(bufnr)
                end,
            })
        end

        local lsp_flags = {
            -- This is the default in Nvim 0.7+
            debounce_text_changes = 150,
        }

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local overrides = {}

        for _, server in ipairs(servers) do
            local settings
            if server == 'lua_ls' then
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim', 'awesome', 'screen' },
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
                            checkThirdParty = false,
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
            elseif server == 'omnisharp_mono' then
                settings = {
                    useGlobalMono = 'always',
                    useModernNet = false,
                }
            elseif server == 'yamlls' then
                settings = {
                    yaml = {
                        keyOrdering = false,
                    },
                }
            elseif server == 'pylsp' then
                settings = {
                    pylsp = {
                        plugins = {
                            flake8 = {
                                enabled = true,
                                executable = '.venv/bin/flake8',
                                maxLineLength = 120,
                            },
                        },
                    },
                }
            elseif server == 'vtsls' then
                settings = {
                    vtsls = {
                        autoUseWorkspaceTsdk = true,
                    },
                }
            elseif server == 'sqls' then
                overrides = {
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                }
            else
                settings = {}
            end

            local conf = vim.tbl_extend('force', {
                on_attach = on_attach,
                flags = lsp_flags,
                capabilities = capabilities,
                settings = settings,
            }, overrides)
            require('lspconfig')[server].setup(conf)
        end
    end,
}
