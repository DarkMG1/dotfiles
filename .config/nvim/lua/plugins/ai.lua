return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main", -- or "main" if you prefer stable
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- required
      { "nvim-lua/plenary.nvim" },  -- required
    },
		build = "make tiktoken",
    opts = {
      show_help = true,
      mappings = {
        reset = { normal = "<leader>cR" },
        submit_prompt = { normal = "<CR>" },
      },
    },
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
      { "<leader>cq", "<cmd>CopilotChat<CR>", desc = "Prompt Copilot Chat" },
    },
  },
}
