return {
    'David-Kunz/gen.nvim',
    cmd = 'Gen',
    keys = {
        { '<leader>ai', ':Gen<CR>', mode = { 'n', 'v' }, silent = true, desc = 'Gen prompt' },
        { '<C-c>', ':Gen Chat<CR>', mode = { 'n', 'v' }, silent = true, desc = 'Gen chat' },
        { '<C-t>', ':Gen Write_Test<CR>', mode = 'v', silent = true, desc = 'Gen write test' },
        { '<C-r>', ':Gen Review_Code<CR>', mode = 'v', silent = true, desc = 'Gen review code' },
    },
    config = function()
        local gen = require('gen')
        gen.setup({
            model = 'gpt-oss:20b',
            display_mode = 'vertical-split',
            show_model = true,
            show_prompt = true,
        })
        gen.prompts['Write_Test'] = {
            prompt = 'Write a test for the following code. Only output the result in format ```$filetype\n...\n```:```$filetype\n$text\n```',
            replace = false,
        }
    end,
}
