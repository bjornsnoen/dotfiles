return {
    'David-Kunz/gen.nvim',
    config = function()
        local gen = require('gen')
        gen.setup({
            model = 'deepseek-coder:6.7b',
            display_mode = 'split',
            show_prompt = true,
        })
        gen.prompts['Write_Test'] = {
            prompt = 'Write a test for the following code. Only output the result in format ```$filetype\n...\n```:```$filetype\n$text\n```',
            replace = false,
        }
        vim.keymap.set({ 'n', 'v' }, '<leader>ai', ':Gen<CR>', { silent = true })
        vim.keymap.set({ 'n', 'v' }, '<C-c>', ':Gen Chat<CR>', { silent = true })
        vim.keymap.set('v', '<C-t>', ':Gen Write_Test<CR>', { silent = true })
        vim.keymap.set('v', '<C-r>', ':Gen Review_Code<CR>', { silent = true })
    end,
}
