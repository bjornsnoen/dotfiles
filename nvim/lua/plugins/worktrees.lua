return {
    'afonsofrancof/worktrees.nvim',
    opts = {
        base_path = '../../.worktrees',
        mappings = {
            switch = 'gw',
            create = 'gc',
        },
        on_switch = function(from_path, to_path)
            print('Switched to worktree: ' .. to_path)
        end,
        on_create = function(path)
            local source_root = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]

            if not source_root or source_root == '' then
                return
            end

            local agents_source = vim.fn.getcwd .. '/AGENTS.md'
            local agents_target = path .. '/AGENTS.md'

            if vim.uv.fs_stat(agents_source) and not vim.uv.fs_stat(agents_target) then
                vim.fn.writefile(vim.fn.readfile(agents_source), agents_target)
            end

            local node_modules_source = source_root .. '/node_modules'
            local node_modules_target = path .. '/node_modules'

            if vim.uv.fs_stat(node_modules_source) and not vim.uv.fs_stat(node_modules_target) then
                vim.fn.system({ 'ln', '-s', node_modules_source, node_modules_target })
            end

            local vscode_source = source_root .. '/.vscode'
            local vscode_target = path .. '/.vscode'

            if vim.uv.fs_stat(vscode_source) and not vim.uv.fs_stat(vscode_target) then
                vim.fn.system({ 'ln', '-s', vscode_source, vscode_target })
            end
        end,
    },
}
