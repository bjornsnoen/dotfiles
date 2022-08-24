return {
    'hrsh7th/nvim-cmp',
    requires = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/vim-vsnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        vim.o.completeopt = 'menu,menuone,noselect'
        local cmp = require('cmp')

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
                    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'vsnip' }, -- For vsnip users.
                -- { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
            }, {
                { name = 'buffer' },
            }),
        })
        -- Setup lspconfig.
        local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
        -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
        for _, server in ipairs({ 'pyright', 'tsserver', 'sumneko_lua' }) do
            require('lspconfig')[server].setup({
                capabilities = capabilities,
            })
        end
    end,
}
