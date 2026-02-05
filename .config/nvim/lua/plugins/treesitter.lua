-- Plugin: nvim-treesitter
-- Description: Modern syntax highlighting and code parsing engine.
-- Features: Superior indenting, folding, and scope awareness for IBL.
-- Note: Run :TSUpdate after adding new languages to 'ensure_installed'.

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true,
			ensure_installed = { "lua", "cpp", "python", "rust", "verilog" },
			highlight = { enable = true },
			indent = { enable = true },
			-- ADD THIS:
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<Enter>", -- Start selecting with Enter
					node_incremental = "<Enter>", -- Expand selection to the next "node"
					node_decremental = "<BS>", -- Shrink selection with Backspace
				},
			},
		})
	end,
}
