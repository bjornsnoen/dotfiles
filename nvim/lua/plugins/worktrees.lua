return {
    'afonsofrancof/worktrees.nvim',
    dev = true,
    opts = {
        mappings = {
            switch = 'gw',
            create = 'gc',
        },
        base_path = '../../.worktrees',
        path_template = function(branch)
            local source_root = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]
            local repo_name = vim.fn.fnamemodify(source_root, ':t')

            return repo_name .. '/' .. branch
        end,
        on_switch = function(from_path, to_path, old_cwd)
            if old_cwd == from_path then
                return
            end

            local cwd_relatve_to_source_root = string.gsub(old_cwd, from_path .. '/', '')
            local target_path = to_path .. '/' .. cwd_relatve_to_source_root

            if vim.uv.fs_stat(target_path) then
                vim.fn.chdir(target_path)
            else
                print('Target path does not exist in the new worktree: ' .. target_path)
            end
        end,
        on_create = function(path)
            local source_root = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]

            if not source_root or source_root == '' then
                return
            end

            local cwd = vim.fn.getcwd()
            local target_path
            if cwd == source_root then
                target_path = path
            else
                local cwd_relatve_to_source_root = string.gsub(cwd, source_root .. '/', '')
                target_path = path .. '/' .. cwd_relatve_to_source_root
            end

            local untracked_to_bring = {
                'AGENTS.md',
                'node_modules',
                '.vscode',
                '../appsettings.Development.json',
            }

            for _, item in ipairs(untracked_to_bring) do
                local source_item = cwd .. '/' .. item
                local target_item = target_path .. '/' .. item

                if vim.uv.fs_stat(source_item) and not vim.uv.fs_stat(target_item) then
                    vim.fn.system({ 'ln', '-s', source_item, target_item })
                end
            end
        end,
    },
}
