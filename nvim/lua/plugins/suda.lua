return {
    'lambdalisue/suda.vim',
    init = function()
        local function can_write(path)
            local stat = vim.loop.fs_stat(path)
            if stat then
                return vim.loop.fs_access(path, 'W') == true
            end

            local dir = vim.fn.fnamemodify(path, ':h')
            if dir == '' then
                return false
            end

            return vim.loop.fs_access(dir, 'W') == true
        end

        local function smart_write(bang)
            local buf = vim.api.nvim_get_current_buf()
            if vim.bo[buf].buftype ~= '' then
                vim.cmd(bang and 'write!' or 'write')
                return
            end

            local name = vim.api.nvim_buf_get_name(buf)
            if name == '' or name:match('^suda://') then
                vim.cmd(bang and 'write!' or 'write')
                return
            end

            if can_write(name) then
                local force = bang or vim.bo[buf].readonly
                vim.cmd(force and 'noautocmd write!' or 'noautocmd write')
                return
            end

            vim.cmd('SudaWrite')
        end

        vim.api.nvim_create_user_command('SmartWrite', function(opts)
            smart_write(opts.bang)
        end, { bang = true })

        vim.cmd([[
            cnoreabbrev <expr> w ((getcmdtype() == ':' && getcmdline() == 'w') ? 'SmartWrite' : 'w')
            cnoreabbrev <expr> write ((getcmdtype() == ':' && getcmdline() == 'write') ? 'SmartWrite' : 'write')
            cnoreabbrev <expr> w! ((getcmdtype() == ':' && getcmdline() == 'w!') ? 'SmartWrite!' : 'w!')
            cnoreabbrev <expr> write! ((getcmdtype() == ':' && getcmdline() == 'write!') ? 'SmartWrite!' : 'write!')
        ]])
    end,
}
