-- Plugin: data-viewer.nvim
-- Description: Spreadsheet and SQLite database viewer for Neovim.
-- Dependency: sqlite3 (must be installed on system)
-- Keybinds: <leader>vd (Open), <leader>vn/p (Navigate tables)
return{
	{
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    },
  },

}
