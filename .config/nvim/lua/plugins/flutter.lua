-- =============================================================================
-- PLUGIN: flutter-tools.nvim
-- DESCRIPTION: A complete toolset for developing Flutter/Dart apps in Neovim.
--              Manages the Dart Language Server (LSP), Hot Reloads, Device 
--              Selection, and Widget Guides.
-- =============================================================================

return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false, -- Needs to load to handle filetype detection for .dart files
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Improves the UI for selecting devices/emulators
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "plugin", -- Uses nvim-notify if you have it installed
        },
        decorations = {
          statusline = {
            device = true,
            app_version = true,
          },
        },
        widget_guides = {
          enabled = true, -- Draws vertical lines to help visualize the widget tree
        },
        lsp = {
          -- Note: flutter-tools handles the dartls setup for you.
          color = {
            enabled = true, -- Displays color squares for Colors.red, etc.
          },
          on_attach = function(client, bufnr)
            -- Standard LSP keybindings (Definition, Hover, etc.)
            local opts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          end,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            -- Adding this ensures your code follows Flutter's style guide
            lineLength = 80, 
          },
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit", -- Opens the server log in a new tab
        },
      })
    end,
  },
}
