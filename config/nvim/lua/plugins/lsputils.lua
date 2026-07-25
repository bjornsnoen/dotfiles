return {
    'RishabhRD/nvim-lsputils',
    event = 'LspAttach',
    dependencies = {
        'neovim/nvim-lspconfig',
        'RishabhRD/popfix',
    },
    config = function()
        vim.lsp.handlers['textDocument/codeAction'] = require('lsputil.codeAction').code_action_handler
        vim.lsp.handlers['textDocument/references'] = require('lsputil.locations').references_handler
        vim.lsp.handlers['textDocument/definition'] = require('lsputil.locations').definition_handler
        vim.lsp.handlers['textDocument/declaration'] = require('lsputil.locations').declaration_handler
    end,
}
