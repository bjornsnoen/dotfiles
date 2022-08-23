vim.keymap.set("n", "<leader>ve", ":vsp ~/.config/nvim/init.lua<CR>")
-- Using this keymap for .vimspector.json, remap before uncomment
-- nmap <Leader>vc :vsp ~/.config/nvim/coc-settings.json<CR>

vim.keymap.set("n", "<leader>vr", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^plugins") or name:match("^opts") or name:match("^keymap") then
            package.loaded[name] = nil
        end
    end

    dofile(vim.env.MYVIMRC)
    require('packer').compile()
    vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end)

vim.keymap.set("n", "gf", ":edit <cfile><CR>")
vim.keymap.set("n", "tn", ":bn<CR>")
vim.keymap.set("n", "tp", ":bp<CR>")
vim.keymap.set("n", "<Leader>wq", ":w<CR>|:bdelete<CR>")
vim.keymap.set("n", "<Leader>o", ":only<CR>")
vim.keymap.set("n", "zx", "zfat")
vim.keymap.set("n", "//", ":noh<CR>")
