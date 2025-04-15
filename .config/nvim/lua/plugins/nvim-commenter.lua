return {
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({ comment_empty = false, comment_empty_trim_whitespace = false })
			vim.keymap.set("v", "<Leader>cc", ":CommentToggle<CR>", {})
		end,
	},
}
