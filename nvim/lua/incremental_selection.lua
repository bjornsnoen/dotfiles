local api = vim.api
local M = {}

---@type table<integer, TSNode[]>
local selections = {}

-- Convert treesitter range (0-indexed, end-exclusive) to vim range (1-indexed, end-inclusive)
local function get_vim_range(node, buf)
    local srow, scol, erow, ecol = vim.treesitter.get_node_range(node)
    srow = srow + 1
    scol = scol + 1
    erow = erow + 1

    if ecol == 0 then
        erow = erow - 1
        ecol = #api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
        ecol = math.max(ecol, 1)
    end
    return srow, scol, erow, ecol
end

-- Get the current visual selection range (1-indexed, inclusive)
local function visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos('v'))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos('.'))

    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return csrow, cscol, cerow, cecol
    else
        return cerow, cecol, csrow, cscol
    end
end

-- Update visual selection to cover the given node (called while in visual mode)
local function update_selection(buf, node)
    local start_row, start_col, end_row, end_col = get_vim_range(node, buf)

    local mode = api.nvim_get_mode()
    if mode.mode ~= 'v' then
        vim.cmd('normal! v')
    end

    api.nvim_win_set_cursor(0, { start_row, start_col - 1 })
    vim.cmd('normal! o')
    api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

local function range_matches(node, buf)
    local csrow, cscol, cerow, cecol = visual_selection_range()
    local srow, scol, erow, ecol = get_vim_range(node, buf)
    return srow == csrow and scol == cscol and erow == cerow and ecol == cecol
end

function M.increment()
    local buf = api.nvim_get_current_buf()
    local nodes = selections[buf]
    local csrow, cscol, cerow, cecol = visual_selection_range()

    -- Initialize if no state or selection was changed externally
    if not nodes or #nodes == 0 or not range_matches(nodes[#nodes], buf) then
        local parser = vim.treesitter.get_parser(buf)
        parser:parse({ vim.fn.line('w0') - 1, vim.fn.line('w$') })
        local node = parser:named_node_for_range(
            { csrow - 1, cscol - 1, cerow - 1, cecol },
            { ignore_injections = false }
        )
        if not node then
            return
        end
        update_selection(buf, node)
        selections[buf] = { node }
        return
    end

    -- Find a parent node that changes the selection
    local node = nodes[#nodes]
    while true do
        local parent = node:parent()
        if not parent or parent == node then
            return
        end
        node = parent
        local srow, scol, erow, ecol = get_vim_range(node, buf)
        if not (srow == csrow and scol == cscol and erow == cerow and ecol == cecol) then
            table.insert(selections[buf], node)
            update_selection(buf, node)
            return
        end
    end
end

function M.decrement()
    local buf = api.nvim_get_current_buf()
    local nodes = selections[buf]
    if not nodes or #nodes < 2 then
        return
    end

    table.remove(selections[buf])
    update_selection(buf, nodes[#nodes])
end

function M.scope()
    local buf = api.nvim_get_current_buf()
    local nodes = selections[buf]
    local csrow, cscol, cerow, cecol = visual_selection_range()

    if not nodes or #nodes == 0 or not range_matches(nodes[#nodes], buf) then
        local parser = vim.treesitter.get_parser(buf)
        parser:parse({ vim.fn.line('w0') - 1, vim.fn.line('w$') })
        local node = parser:named_node_for_range(
            { csrow - 1, cscol - 1, cerow - 1, cecol },
            { ignore_injections = false }
        )
        if not node then
            return
        end
        update_selection(buf, node)
        selections[buf] = { node }
        return
    end

    -- Expand to enclosing scope-like node
    local scope_types = {
        function_declaration = true,
        function_definition = true,
        method_declaration = true,
        method_definition = true,
        arrow_function = true,
        function_item = true,
        if_statement = true,
        for_statement = true,
        for_in_statement = true,
        while_statement = true,
        do_statement = true,
        try_statement = true,
        catch_clause = true,
        class_declaration = true,
        class_definition = true,
        module = true,
        program = true,
        chunk = true,
        block = true,
    }

    local node = nodes[#nodes]
    local current = node:parent()
    while current do
        if scope_types[current:type()] then
            local srow, scol, erow, ecol = get_vim_range(current, buf)
            if not (srow == csrow and scol == cscol and erow == cerow and ecol == cecol) then
                table.insert(selections[buf], current)
                update_selection(buf, current)
                return
            end
        end
        current = current:parent()
    end
end

return M
