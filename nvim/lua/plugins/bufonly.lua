return {
    'vim-scripts/BufOnly.vim',
    lazy = false,
    keys = {
        {
            '<Leader>q',
            function()
                local function is_codecompanion_buffer(bufnr)
                    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                    return filetype == 'codecompanion'
                end

                local function is_normal_buffer(bufnr)
                    local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
                    if buftype ~= '' then
                        return false
                    end
                    return not is_codecompanion_buffer(bufnr)
                end

                local function is_normal_window(win)
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

                local function find_normal_buffer(exclude_buf)
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if buf ~= exclude_buf and vim.api.nvim_buf_is_loaded(buf) and is_normal_buffer(buf) then
                            return buf
                        end
                    end
                    return nil
                end

                local function find_normal_window(exclude_win)
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if win ~= exclude_win and is_normal_window(win) then
                            return win
                        end
                    end

                    return nil
                end

                local current_win = vim.api.nvim_get_current_win()
                local current_buf = vim.api.nvim_get_current_buf()

                -- If we're in a normal window, try to load another normal buffer first
                if is_normal_window(current_win) then
                    local alt_buffer = find_normal_buffer(current_buf)
                    if alt_buffer then
                        -- Switch to another normal buffer in this window before deleting
                        vim.api.nvim_win_set_buf(current_win, alt_buffer)
                    else
                        -- No other normal buffers, create a new empty buffer
                        vim.cmd('enew')
                    end
                end

                -- Delete the buffer
                vim.cmd('bdelete! ' .. current_buf)
            end,
            mode = 'n',
            silent = true,
            desc = 'Delete current buffer',
        },
        { '<Leader>Q', ':BufOnly!<CR>', mode = 'n', silent = true, desc = 'Keep only current buffer' },
        { '<F16>', ':BufOnly<CR>', mode = 'n', silent = true, desc = 'Keep only current buffer' },
    },
}
