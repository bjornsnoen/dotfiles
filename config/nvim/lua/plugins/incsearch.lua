return {
    'haya14busa/is.vim',
    lazy = false,
    config = function()
        vim.opt.hlsearch = true
        vim.cmd([[noh]]) -- clear any stale highlights
        vim.g['is#do_default_mappings'] = 1
    end,
}
