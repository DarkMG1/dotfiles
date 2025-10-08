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
vim.opt.clipboard = ""
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffer" })
vim.keymap.set("n", "<leader>ne", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>r", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "<C-h>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<leader>.", ":vertical resize +5<CR>")
vim.keymap.set("n", "<leader>+", ":vertical resize -5<CR>")
vim.g.instant_username = "DarkMG1"

vim.keymap.set("n", "<leader>ff", function()
  local path = require("neo-tree.sources.manager").get_state("filesystem").path
  require("telescope.builtin").find_files({ cwd = path })
end, { desc = "Find file within Neo-tree root" })


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

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "/Users/chiragbhat/CLionProjects/umich-eecs482/*",
  callback = function()
    vim.b.copilot_enabled = false
		local cwd = vim.fn.getcwd()
		if cwd:match("umich%-eecs482") then
			vim.cmd("Copilot disable")
		else
			vim.cmd("Copilot enable")
		end
  end,
})

vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float(nil, {
		border = "rounded",
		focusable = false,
	})
end, { desc = "Show diagnostics in float" })

vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end, { desc = "Format code" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.v", "*.sv" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_user_command("CreateCppProject", function()
	local cwd = vim.fn.getcwd()

	-- .clang-format creation
	local clang_path = cwd .. "/.clang-format"
	if vim.fn.filereadable(clang_path) == 0 then
		local clang_template = [[
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
		local file = io.open(clang_path, "w")
		if file then
			file:write(clang_template)
			file:close()
			print("✅ Created .clang-format with CLion style")
		end
	else
		print("⚠️ .clang-format already exists")
	end

	-- CMakeLists.txt creation
	local cmake_path = cwd .. "/CMakeLists.txt"
	if vim.fn.filereadable(cmake_path) == 0 then
		local project_name = vim.fn.fnamemodify(cwd, ":t")
		local cmake_template = string.format([[
cmake_minimum_required(VERSION 3.30)
project(%s)

set(CMAKE_CXX_STANDARD 17)

add_executable(%s main.cpp)
]], project_name, project_name)

		local file = io.open(cmake_path, "w")
		if file then
			file:write(cmake_template)
			file:close()
			print("✅ Created CMakeLists.txt for project '" .. project_name .. "'")
		end
	else
		print("⚠️ CMakeLists.txt already exists")
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

vim.api.nvim_create_user_command("NewCppClass", function(opts)
	local class_name = opts.args
	if class_name == "" then
		print("❌ Please provide a class name")
		return
	end

	local date = os.date("%m/%d/%y")
	local header_guard = string.upper(class_name) .. "_H"
	local h_filename = class_name .. ".h"
	local cpp_filename = class_name .. ".cpp"

	-- .h file
	local h_content = string.format(
		[[
//
// Created by Chirag Bhat on %s.
//

#ifndef %s
#define %s

class %s {

};

#endif //%s
]],
		date,
		header_guard,
		header_guard,
		class_name,
		header_guard
	)

	-- .cpp file
	local cpp_content = string.format(
		[[
//
// Created by Chirag Bhat on %s.
//

#include "%s"
]],
		date,
		h_filename
	)

	-- write files
	local h_path = vim.fn.getcwd() .. "/" .. h_filename
	local cpp_path = vim.fn.getcwd() .. "/" .. cpp_filename

	local h_file = io.open(h_path, "w")
	if h_file then
		h_file:write(h_content)
		h_file:close()
	end

	local cpp_file = io.open(cpp_path, "w")
	if cpp_file then
		cpp_file:write(cpp_content)
		cpp_file:close()
	end

	print("✅ Created " .. h_filename .. " and " .. cpp_filename)

	-- Refresh Neo-tree if it's open
	local ok, neo_tree = pcall(require, "neo-tree.sources.manager")
	if ok then
		neo_tree.refresh("filesystem")
	end
end, {
	nargs = 1,
	complete = "file",
	desc = "Create new C++ class with .h and .cpp",
})

-- Neo-tree auto resize
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "neo-tree*",
  callback = function()
    vim.cmd("vertical resize 30") -- shrink when focused
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "neo-tree*",
  callback = function()
    vim.cmd("vertical resize 15") -- smaller when not focused
  end,
})
