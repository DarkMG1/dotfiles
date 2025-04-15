return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    local ibl = require("ibl")

    local scope_enabled = true

    local function setup_ibl()
      ibl.setup({
        scope = { enabled = scope_enabled },
        exclude = {
          filetypes = scope_enabled and {} or { "lua", "c", "cpp", "python", "java", "javascript", "typescript", "html", "css", "json", "markdown", "sh", "go", "rust", "tex", "r", "yaml", "toml", "sql", "text", "verilog", "systemverilog", "*" },
        },
      })
    end

    setup_ibl()

    vim.keymap.set("n", "<leader>n", function()
      scope_enabled = not scope_enabled
      setup_ibl()
      local status = scope_enabled and "enabled" or "disabled"
      vim.notify("IBL indent lines " .. status, vim.log.levels.INFO)
    end)
  end,
}
