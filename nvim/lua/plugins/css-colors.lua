return {
    'NvChad/nvim-colorizer.lua',
    config = function()
        require('colorizer').setup({
            user_default_options = {
                rgb_fn = true,
                always_update = true,
                tailwind = true,
            },
        })
    end,
}
