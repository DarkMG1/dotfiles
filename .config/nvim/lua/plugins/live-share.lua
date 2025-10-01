-- ~/.config/nvim/lua/plugins.lua
return {
    {
        "azratul/live-share.nvim",
        dependencies = { "jbyuki/instant.nvim" },
        cmd = { "LiveShareServer", "LiveShareJoin" }, -- load only on these commands
        config = function()
            require("live-share").setup({
                -- optional settings can go here
            })
        end,
    },
}
