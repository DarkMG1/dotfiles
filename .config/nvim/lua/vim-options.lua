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
vim.opt.cindent = false
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffer" })
vim.keymap.set("n", "<leader>ne", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>r", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "<C-h>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

vim.filetype.add({
	extension = {
		lc2k = "lc2k",
		as = "as",
		v = "verilog",
		sv = "systemverilog",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.expandtab = true
		vim.opt_local.smartindent = false
		vim.opt_local.autoindent = false
		vim.opt_local.cindent = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lc2k", "as" },
	callback = function()
		vim.opt_local.shiftwidth = 8
		vim.opt_local.tabstop = 8
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "verilog", "systemverilog" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
	end,
})

vim.diagnostic.config({
	float = { border = "rounded" },
	virtual_text = false, -- disable inline text if you prefer clean look
	signs = true,
	underline = true,
	update_in_insert = false,
})

vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float(nil, {
		border = "rounded",
		focusable = false,
	})
end, { desc = "Show diagnostics in float" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.v", "*.sv" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.cpp",
	callback = function()
		local header = string.format("//\n// Created by Chirag Bhat on %s.\n//\n\n", os.date("%Y-%m-%d"))
		vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(header, "\n"))
	end,
})

vim.api.nvim_create_user_command("CreateClangFormat", function()
  local config_path = vim.fn.getcwd() .. "/.clang-format"
  if vim.fn.filereadable(config_path) == 0 then
    local template = [[
# Generated from CLion C/C++ Code Style settings
---
Language: Cpp
BasedOnStyle: LLVM
AccessModifierOffset: -4
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignOperands: true
AlignTrailingComments: false
AlwaysBreakTemplateDeclarations: Yes
BraceWrapping:
  AfterCaseLabel: false
  AfterClass: false
  AfterControlStatement: false
  AfterEnum: false
  AfterFunction: false
  AfterNamespace: false
  AfterStruct: false
  AfterUnion: false
  AfterExternBlock: false
  BeforeCatch: false
  BeforeElse: false
  BeforeLambdaBody: false
  BeforeWhile: false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
BreakBeforeBraces: Custom
BreakConstructorInitializers: AfterColon
BreakConstructorInitializersBeforeComma: false
ColumnLimit: 120
ConstructorInitializerAllOnOneLineOrOnePerLine: false
ContinuationIndentWidth: 8
IncludeCategories:
  - Regex: '^<.*'
    Priority: 1
  - Regex: '^".*'
    Priority: 2
  - Regex: '.*'
    Priority: 3
IncludeIsMainRegex: '([-_](test|unittest))?$'
IndentCaseLabels: true
IndentWidth: 4
InsertNewlineAtEOF: true
MacroBlockBegin: ''
MacroBlockEnd: ''
MaxEmptyLinesToKeep: 2
NamespaceIndentation: All
SpaceAfterCStyleCast: true
SpaceAfterTemplateKeyword: false
SpaceBeforeRangeBasedForLoopColon: false
SpaceInEmptyParentheses: false
SpacesInAngles: false
SpacesInConditionalStatement: false
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
TabWidth: 4
...
]]
    local file = io.open(config_path, "w")
    if file then
      file:write(template)
      file:close()
      print("✅ Created .clang-format with CLion style")
    end
  else
    print("⚠️ .clang-format already exists")
  end
end, {})

vim.keymap.set("n", "<leader>;", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match("neo%-tree filesystem") then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "Focus Neo-tree" })
