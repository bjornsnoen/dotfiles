local servers = {
    'vtsls',
    'pyright',
    'pylsp',
    'lua_ls',
    'jsonls',
    'yamlls',
    'taplo',
    'eslint',
    'omnisharp',
    'tailwindcss',
    'svelte',
    'phpactor',
    'cssls',
    'terraformls',
    'rust_analyzer',
    'prismals',
    'twiggy_language_server',
    'dockerls',
    'sqls',
    'kotlin_lsp',
    'jdtls',
    'gopls',
    'clangd',
}

return {
    'neovim/nvim-lspconfig',
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

        local function is_wsl()
            local release = vim.loop.os_uname().release:lower()
            return release:find('microsoft') ~= nil or release:find('wsl') ~= nil
        end

        local function get_omnisharp_exec()
            if is_wsl() then
                local win_bin = vim.env.WIN_OMNISHARP_CMD or vim.env.OMNISHARP_CMD
                if win_bin and win_bin ~= '' then
                    local expanded = vim.fn.expand(win_bin)
                    if vim.fn.executable(expanded) == 1 then
                        return expanded
                    end
                end
            end

            local mason_bin_dir = vim.fn.stdpath('data') .. '/mason/bin/'
            for _, candidate in ipairs({ 'omnisharp', 'OmniSharp' }) do
                local mason_bin = mason_bin_dir .. candidate
                if vim.fn.executable(mason_bin) == 1 then
                    return mason_bin
                end
            end

            if vim.fn.executable('omnisharp') == 1 then
                return 'omnisharp'
            end
        end
        -- We must do this here to ensure that the LSP servers are installed before we try to use them
        local masonLspConfig = require('mason-lspconfig')
        masonLspConfig.setup({
            ensure_installed = servers,
            automatic_enable = false,
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

        local capabilities = vim.lsp.protocol.make_client_capabilities()

        for _, server in ipairs(servers) do
            local settings
            if server == 'lua_ls' then
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim', 'awesome', 'screen', 'bluez_monitor' },
                        },
                        format = {
                            enable = true,
                            defaultConfig = {
                                indent_style = 'space',
                                indent_size = 4,
                            },
                        },
                        workspace = {
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
            elseif server == 'omnisharp' then
                settings = {
                    FormattingOptions = {
                        EnableEditorConfigSupport = true,
                        OrganizeImports = nil,
                    },
                    MsBuild = {
                        LoadProjectsOnDemand = true,
                    },
                    RoslynExtensionsOptions = {
                        EnableAnalyzersSupport = false,
                        EnableImportCompletion = false,
                        AnalyzeOpenDocumentsOnly = true,
                        EnableDecompilationSupport = false,
                    },
                    Sdk = {
                        IncludePrereleases = false,
                    },
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
                            pycodestyle = { enabled = false },
                            mccabe = { enabled = false },
                            pyflakes = { enabled = false },
                        },
                    },
                }
            elseif server == 'pyright' then
                settings = {
                    pyright = {
                        disableOrganizeImports = true,
                        disableTaggedHints = true,
                    },
                    python = {
                        analysis = {
                            diagnosticSeverityOverrides = {
                                reportUnreachable = 'none',
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
            end

            local common = {
                on_attach = on_attach,
                -- flags = lsp_flags,
                capabilities = capabilities,
                settings = settings,
            }
            local base = vim.lsp.config[server] or {}

            local conf = vim.tbl_deep_extend('force', base, common)
            if server == 'omnisharp' then
                local exec = get_omnisharp_exec()
                if exec then
                    if conf.cmd == nil or vim.tbl_isempty(conf.cmd) then
                        conf.cmd = { exec }
                    else
                        conf.cmd[1] = exec
                    end
                end
            end
            vim.lsp.config(server, conf)
            vim.lsp.enable(server)
        end
    end,
}
