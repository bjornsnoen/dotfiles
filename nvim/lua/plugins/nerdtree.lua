return {
    {
        'preservim/nerdtree',
        config = function()
            vim.g.NERDTreeShowHidden = 1
            vim.g.NERDTreeMinimalUI = 1

            vim.keymap.set('n', "<leader>n", ":NERDTreeToggle<CR>", { noremap = true })
            vim.keymap.set('n', "<leader>N", ":NERDTreeFind<CR>")
            -- avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
            vim.g.plug_window = 'noautocmd vertical topleft new'

            vim.g.NERDTreeDirArrowExpandable = '▹'
            vim.g.NERDTreeDirArrowCollapsible = '▿'
            vim.g.NERDTreeQuitOnOpen = 1
        end
    },
    {
        'Xuyuanp/nerdtree-git-plugin'
    },
    {
        'ryanoasis/vim-devicons',
        config = function()
            vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
            vim.g.DevIconsEnableFoldersOpenClose = 1
            vim.g.DevIconsEnableFolderExtensionPatternMatching = 1
        end
    },
    {
        'tiagofumo/vim-nerdtree-syntax-highlight'
    }
}

