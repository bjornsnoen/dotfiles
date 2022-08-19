return {
    'sagi-z/vimspectorpy',
    run = ":call vimspectorpy#update()",
    config = function()
        vim.g["vimspectorpy#cmd_prefix"] = "VS"
    end
}

