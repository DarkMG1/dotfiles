vim.g.mapleader = " "
vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.clipboard = ""

vim.filetype.add({
	extension = {
		lc2k = "lc2k",
		as = "as",
		v = "verilog",
		sv = "systemverilog",
	},
})

vim.diagnostic.config({
	float = { border = "rounded" },
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
})

-- DAP Icons
local dap_icons = {
	Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
	Breakpoint = { " ", "DiagnosticError" },
	BreakpointCondition = { " ", "DiagnosticError" },
	BreakpointRejected = { " ", "DiagnosticError" },
	LogPoint = { ". ", "DiagnosticInfo" },
}

for name, sign in pairs(dap_icons) do
	vim.fn.sign_define("Dap" .. name, {
		text = sign[1],
		texthl = sign[2],
		linehl = sign[3],
		numhl = sign[3],
	})
end

local function set_ibl_highlights()
	vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4252", nocombine = true })
	vim.api.nvim_set_hl(0, "IblScope", { fg = "#A3BE8C", nocombine = true, bold = true })

	-- Rainbow Delimiters
	vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" }) -- Fixed: removed extra ')'
end

set_ibl_highlights()

-- 3. Force it to stay active even if you change color themes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_ibl_highlights,
})
