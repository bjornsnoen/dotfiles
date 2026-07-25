return {
    'vim-scripts/BufOnly.vim',
    lazy = false,
    keys = {
        {
            '<Leader>q',
            function()
                local special_filetypes = {
                    fugitive = true,
                    fugitiveblame = true,
                }

                local function is_normal_buffer(bufnr)
                    if bufnr <= 0 or not vim.api.nvim_buf_is_valid(bufnr) then
                        return false
                    end

                    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                    if special_filetypes[filetype] then
                        return false
                    end

                    local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
                    if buftype ~= '' then
                        return false
                    end
                    return true
                end

                local function is_normal_window(win)
                    if not vim.api.nvim_win_is_valid(win) then
                        return false
                    end

                    local win_config = vim.api.nvim_win_get_config(win)
                    local is_floating = win_config.relative and win_config.relative ~= ''
                    if is_floating then
                        return false
                    end

                    local has_winfixbuf = vim.api.nvim_get_option_value('winfixbuf', { win = win })
                    if has_winfixbuf then
                        return false
                    end

                    local buf = vim.api.nvim_win_get_buf(win)
                    return is_normal_buffer(buf)
                end

                local function is_available_normal_buffer(bufnr, exclude_buf)
                    return bufnr ~= exclude_buf and is_normal_buffer(bufnr)
                end

                local function find_normal_buffer(exclude_buf)
                    local alt_buf = vim.fn.bufnr('#')
                    if is_available_normal_buffer(alt_buf, exclude_buf) then
                        return alt_buf
                    end

                    local normal_bufs = {}
                    for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
                        if is_available_normal_buffer(info.bufnr, exclude_buf) then
                            table.insert(normal_bufs, info)
                        end
                    end

                    table.sort(normal_bufs, function(a, b)
                        return a.lastused > b.lastused
                    end)

                    if #normal_bufs > 0 then
                        return normal_bufs[1].bufnr
                    end

                    return nil
                end

                local current_win = vim.api.nvim_get_current_win()
                local current_buf = vim.api.nvim_get_current_buf()
                local replacement_buf = nil

                if not is_normal_window(current_win) then
                    if #vim.api.nvim_list_wins() > 1 and pcall(vim.cmd, 'close') then
                        return
                    end
                end

                if is_normal_buffer(current_buf) then
                    replacement_buf = find_normal_buffer(current_buf)
                end

                if not replacement_buf then
                    vim.cmd('enew')
                    replacement_buf = vim.api.nvim_get_current_buf()
                end

                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if is_normal_window(win) and vim.api.nvim_win_get_buf(win) == current_buf then
                        vim.api.nvim_win_set_buf(win, replacement_buf)
                    end
                end

                vim.api.nvim_buf_delete(current_buf, { force = true })
            end,
            mode = 'n',
            silent = true,
            desc = 'Delete current buffer',
        },
        { '<Leader>Q', ':BufOnly!<CR>', mode = 'n', silent = true, desc = 'Keep only current buffer' },
        { '<F16>', ':BufOnly<CR>', mode = 'n', silent = true, desc = 'Keep only current buffer' },
    },
}
