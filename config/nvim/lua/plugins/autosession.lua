return {
    'rmagatti/auto-session',
    dependencies = { 'stevearc/overseer.nvim' },
    opts = {
        log_level = 'error',
        suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        session_lens = { load_on_setup = false },
        save_extra_cmds = {
            function()
                local tasks = require('overseer.task_list').list_tasks({
                    status = { 'RUNNING' },
                    include_ephemeral = true,
                    filter = function(task)
                        return task.parent_id == nil
                    end,
                })
                if #tasks == 0 then
                    return nil
                end
                local cmds = {}
                for _, task in ipairs(tasks) do
                    local json = vim.json.encode(task:serialize())
                    json = string.gsub(json, '\\/', '/')
                    json = string.gsub(json, "'", "\\'")
                    table.insert(
                        cmds,
                        string.format("lua require('overseer').new_task(vim.json.decode('%s')):start()", json)
                    )
                end
                return cmds
            end,
        },
        pre_restore_cmds = {
            function()
                local tasks = require('overseer.task_list').list_tasks({ include_ephemeral = true })
                for _, task in ipairs(tasks) do
                    task:dispose(true)
                end
            end,
        },
    },
}
