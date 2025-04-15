return {
	{
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd.colorscheme('kanagawa-dragon')	
			vim.cmd [[
  			highlight Normal guibg=none
  			highlight NonText guibg=none
  			highlight Normal ctermbg=none
  			highlight NonText ctermbg=none
			]]
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"NTBBloodbath/doom-one.nvim",
		config = function()
		end,
	},
}

