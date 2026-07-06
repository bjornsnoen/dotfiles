--- Run fn with the snacks module, or warn if it isn't available.
---@param fn fun(snacks: Snacks)
local function with_snacks(fn)
    local ok, snacks = pcall(require, 'snacks')
    if not ok then
        vim.notify('snacks.nvim is not available', vim.log.levels.WARN)
        return
    end
    return fn(snacks)
end

--- Returns a keymap callback that runs fn with the snacks module.
---@param fn fun(snacks: Snacks)
---@return fun()
local function snacks_fn(fn)
    return function()
        return with_snacks(fn)
    end
end

local function with_normal_context(picker_fn)
    return function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_name = vim.api.nvim_buf_get_name(current_buf)
        local buf_filetype = vim.bo[current_buf].filetype

        local is_special_buffer = buf_filetype == 'floaterm'
            or buf_name:match('^/tmp/')
            or vim.bo[current_buf].buftype ~= ''

        if is_special_buffer then
            local windows = vim.api.nvim_list_wins()
            for _, win in ipairs(windows) do
                local win_buf = vim.api.nvim_win_get_buf(win)
                local win_buftype = vim.bo[win_buf].buftype

                if win_buftype == '' and vim.bo[win_buf].filetype ~= 'floaterm' then
                    vim.api.nvim_set_current_win(win)
                    break
                end
            end
        end

        picker_fn()
    end
end

local function get_visual_text()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v'):gsub('\n', '')
    vim.fn.setreg('v', {})
    return text
end

local function grep_text(text)
    if #text > 0 then
        with_snacks(function(snacks)
            snacks.picker.grep({ search = text })
        end)
    end
end

local function get_omnisharp_client()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
        if client.name == 'omnisharp' or client.name == 'omnisharp_mono' then
            return client
        end
    end
end

local function definition_locations(result, client)
    local omnisharp_utils = require('omnisharp_utils')
    local locations = {}

    if not result or not result.Definitions or result.Definitions == vim.NIL then
        return locations
    end

    for _, definition in ipairs(result.Definitions) do
        local file = definition.Location.FileName
        if definition.MetadataSource ~= vim.NIL and definition.MetadataSource then
            local params = { timeout = 5000 }
            for key, value in pairs(definition.MetadataSource) do
                params[key] = value
            end
            _, file = omnisharp_utils.load_metadata_doc(params, client)
        end

        if definition.SourceGeneratedFileInfo ~= vim.NIL and definition.SourceGeneratedFileInfo then
            local params = { timeout = 5000 }
            for key, value in pairs(definition.SourceGeneratedFileInfo) do
                params[key] = value
            end
            _, file = omnisharp_utils.load_sourcegen_doc(params, client)
        end

        if file then
            locations[#locations + 1] = {
                uri = 'file://' .. file,
                range = {
                    start = {
                        line = definition.Location.Range.Start.Line,
                        character = definition.Location.Range.Start.Column,
                    },
                    ['end'] = {
                        line = definition.Location.Range.End.Line,
                        character = definition.Location.Range.End.Column,
                    },
                },
            }
        end
    end

    return locations
end

local function location_item(location)
    local uri = location.uri or location.targetUri
    local range = location.range or location.targetSelectionRange
    if not uri or not range then
        return
    end

    local buf = vim.uri_to_bufnr(uri)
    local file = vim.uri_to_fname(uri)
    local line = range.start.line + 1
    local col = range.start.character
    local text = file

    if vim.api.nvim_buf_is_loaded(buf) then
        local line_count = vim.api.nvim_buf_line_count(buf)
        line = math.min(line, line_count)
        text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1] or text
    end

    return {
        text = file .. ' ' .. text,
        file = file,
        buf = buf,
        pos = { line, col },
        end_pos = { range['end'].line + 1, range['end'].character },
        line = text,
    }
end

local function show_omnisharp_locations(title, locations, client)
    if vim.tbl_isempty(locations) then
        vim.notify('No locations found')
        return
    end

    if #locations == 1 then
        local show_document = vim.lsp.util.show_document or vim.lsp.util.jump_to_location
        show_document(locations[1], client.offset_encoding, { reuse_win = true })
        return
    end

    local items = {}
    for _, location in ipairs(locations) do
        local item = location_item(location)
        if item then
            items[#items + 1] = item
        end
    end

    if vim.tbl_isempty(items) then
        vim.notify('No locations found')
        return
    end

    with_snacks(function(snacks)
        snacks.picker({
            title = title,
            items = items,
            format = 'file',
            jump = { tagstack = true, reuse_win = true },
        })
    end)
end

local function omnisharp_locations(title, method, params, to_locations)
    local client = get_omnisharp_client()
    if not client then
        return false
    end

    client:request(method, params, function(err, result)
        if err then
            vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
            return
        end

        vim.schedule(function()
            show_omnisharp_locations(title, to_locations(result, client), client)
        end)
    end, vim.api.nvim_get_current_buf())

    return true
end

local function lsp_references()
    local client = get_omnisharp_client()
    if client then
        local omnisharp_utils = require('omnisharp_utils')
        return omnisharp_locations(
            'OmniSharp references',
            'o#/findusages',
            omnisharp_utils.cmd_params(client, {
                excludeDefinition = true,
            }),
            function(result)
                if not result or not result.QuickFixes or result.QuickFixes == vim.NIL then
                    return {}
                end
                return omnisharp_utils.quickfixes_to_locations(result.QuickFixes, client)
            end
        )
    end

    with_snacks(function(snacks)
        snacks.picker.lsp_references({ include_declaration = false })
    end)
end

local function lsp_implementations()
    local client = get_omnisharp_client()
    if client then
        local omnisharp_utils = require('omnisharp_utils')
        return omnisharp_locations(
            'OmniSharp implementations',
            'o#/findimplementations',
            omnisharp_utils.cmd_params(client),
            function(result)
                if not result or not result.QuickFixes or result.QuickFixes == vim.NIL then
                    return {}
                end
                return omnisharp_utils.quickfixes_to_locations(result.QuickFixes, client)
            end
        )
    end

    with_snacks(function(snacks)
        snacks.picker.lsp_implementations()
    end)
end

local function lsp_definitions()
    local client = get_omnisharp_client()
    if client then
        local omnisharp_utils = require('omnisharp_utils')
        return omnisharp_locations(
            'OmniSharp definitions',
            'o#/v2/gotodefinition',
            omnisharp_utils.cmd_params(client),
            function(result)
                return definition_locations(result, client)
            end
        )
    end

    with_snacks(function(snacks)
        snacks.picker.lsp_definitions()
    end)
end

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
        {
            '<Leader>b',
            snacks_fn(function(snacks)
                snacks.picker.buffers({ hidden = true })
            end),
            desc = 'Buffers (all)',
        },
        {
            '<Leader>f',
            with_normal_context(snacks_fn(function(snacks)
                snacks.picker.files({ hidden = true })
            end)),
            desc = 'Find files (hidden)',
        },
        {
            '<Leader>F',
            with_normal_context(snacks_fn(function(snacks)
                snacks.picker.files({ hidden = true, ignored = true })
            end)),
            desc = 'Find files (all)',
        },
        {
            '<Leader>s',
            with_normal_context(snacks_fn(function(snacks)
                snacks.picker.git_diff()
            end)),
        },
        {
            '<Leader>r',
            with_normal_context(snacks_fn(function(snacks)
                snacks.picker.grep()
            end)),
            mode = 'n',
            desc = 'Live grep',
        },
        {
            '<Leader>r',
            with_normal_context(function()
                grep_text(get_visual_text())
            end),
            mode = 'v',
            desc = 'Live grep selection',
        },
        {
            '<Leader>R',
            with_normal_context(function()
                vim.cmd('normal! vE')
                grep_text(get_visual_text())
            end),
            desc = 'Live grep word',
        },
        {
            'gb',
            with_normal_context(snacks_fn(function(snacks)
                snacks.picker.git_branches()
            end)),
            desc = 'Git branches',
        },
        {
            'gu',
            with_normal_context(lsp_references),
            desc = 'LSP references',
        },
        {
            'gi',
            with_normal_context(lsp_implementations),
            desc = 'LSP implementations',
        },
        {
            'gd',
            with_normal_context(lsp_definitions),
            desc = 'LSP definitions',
        },
        {
            '<leader>.',
            snacks_fn(function(snacks)
                snacks.scratch()
            end),
            desc = 'Toggle Scratch Buffer',
        },
        {
            '<leader>S',
            snacks_fn(function(snacks)
                snacks.scratch.select()
            end),
            desc = 'Select Scratch Buffer',
        },
    },
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = true,
        },
        picker = {
            enabled = true,
        },
        scratch = {
            filekey = {
                cwd = true,
                branch = false,
                count = true,
            },
            ft = 'markdown',
        },
        image = {
            enabled = true,
            doc = {
                inline = false,
            },
        },
    },
}
