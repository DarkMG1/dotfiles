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
				width = 30,
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
						".version482",
						".clang-format",
						"cmake_install.cmake",
						"CMakeCache.txt",
						"*.dSYM/",
						".git/",
						"*.a",
						"*.o",
						"cmake-build-debug/",
						"CMakeFiles",
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
