return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local formatting = null_ls.builtins.formatting
		local h = require("null-ls.helpers")

		local verible_format = h.make_builtin({
			name = "verible-verilog-format",
			meta = {
				url = "https://github.com/chipsalliance/verible",
				description = "Verilog/SystemVerilog formatter from the Verible tool suite.",
			},
			method = null_ls.methods.FORMATTING,
			filetypes = { "verilog", "systemverilog" },
			generator_opts = {
				command = "verible-verilog-format",
				args = { "--inplace", "$FILENAME" },
				to_temp_file = true,
				from_temp_file = true,
			},
			factory = h.formatter_factory,
		})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.clang_format,
				verible_format,
			},
		})
		vim.keymap.set("n", "<leader>b", vim.lsp.buf.format, {})
	end,
}
