return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				mappings = {
					["<BS>"] = "noop", -- disable backspace going up a directory
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						"*.dSYM",
						"cmake-build-debug/",
						"build/",
						".idea",
						".cache",
						"compile_commands.json",
						"*.o",
					},
					never_show = {}, -- allow Makefile and other all-caps files
				},
			},
		})
	end,
}
