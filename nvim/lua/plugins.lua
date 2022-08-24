local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    vim.cmd([[packadd packer.nvim]])
end

return require('packer').startup(function(use)
    use('wbthomason/packer.nvim')
    -- My plugins here
    use(require('plugins/abolish'))
    use(require('plugins/airline'))
    use(require('plugins/bufonly'))
    use(require('plugins/coc'))
    use(require('plugins/commentary'))
    use(require('plugins/css-colors'))
    use(require('plugins/debug'))
    use(require('plugins/debug-ui'))
    use(require('plugins/editorconfig'))
    use(require('plugins/floaterm'))
    use(require('plugins/fugitive'))
    use(require('plugins/fzf'))
    use(require('plugins/incsearch'))
    use(require('plugins/js-debug'))
    use(require('plugins/lastpage'))
    use(require('plugins/matchit'))
    use(require('plugins/multicursor'))
    use(require('plugins/nerdtree'))
    use(require('plugins/neotest'))
    use(require('plugins/rainbow'))
    use(require('plugins/solarized'))
    use(require('plugins/suda'))
    use(require('plugins/surround'))
    use(require('plugins/tabularize'))
    use(require('plugins/treesitter'))
    use(require('plugins/vimtest'))
    use(require('plugins/zoom'))
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
