-- Run from the repo root: nvim --headless -u NONE -l scripts/test-clipboard.lua
local writes = {}
vim.api.nvim_ui_send = function(sequence)
    table.insert(writes, sequence)
end
dofile('config/nvim/lua/opts.lua')
assert(vim.o.clipboard == 'unnamedplus')
assert(vim.fn['provider#clipboard#Executable']() == 'OSC 52')

for _, reg in ipairs({ '+', '*' }) do
    local lines = { 'clipboard æøå', string.rep('long text ', 1000) }
    vim.fn.setreg(reg, lines, 'V')
    local target = reg == '+' and 'c' or 'p'
    assert(writes[#writes] == '\027]52;' .. target .. ';'
        .. vim.base64.encode(table.concat(lines, '\n') .. '\n') .. '\027\\')
end

vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'first', 'second' })
vim.cmd('normal! ggyy')
local count = #writes
vim.cmd('normal! p')
assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), { 'first', 'first', 'second' }))
assert(#writes == count, 'paste must not query the terminal')
assert(vim.fn.getregtype('+') == 'V')
print('OSC 52 writes and local paste: OK')
