return {
    'ravitemer/mcphub.nvim',
    event = 'VeryLazy',
    opts = {
        -- Enable auto-approval for all MCP tool calls
        -- You can also toggle this in the Hub UI with 'ga'
        auto_approve = false, -- Set to true to automatically approve all MCP tool calls
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
}
