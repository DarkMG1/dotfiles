return {
  "pocco81/auto-save.nvim",
  config = function()
    require("auto-save").setup({
      debounce_delay = 135,
      condition = function(buf)
        return vim.bo[buf].filetype ~= "" and vim.bo[buf].modifiable
      end,
    })
  end,
}
