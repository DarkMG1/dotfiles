return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<Leader>gp", ":Git push<CR>", {})
			vim.keymap.set("n", "<Leader>gc", ":Git commit<CR>", {})
			vim.keymap.set("n", "<Leader>gl", ":Git pull<CR>", {})
			vim.keymap.set("n", "<Leader>gm", ":Git merge<CR>", {})
			vim.keymap.set("n", "<Leader>ga", ":Git add .<CR>", {})
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<Leader>gh", ":Gitsigns preview_hunk<CR>", {})
		end,
	},
}
