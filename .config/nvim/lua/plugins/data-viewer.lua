return{
{
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    },
    config = function ()
        vim.keymap.set('n', '<Leader>vd', ':DataViewer<CR>')
            vim.keymap.set('n', '<Leader>vn', ':DataViewerNextTable<CR>')
            vim.keymap.set('n', '<Leader>vp', ':DataViewerPrevTable<CR>')
            vim.keymap.set('n', '<Leader>vc', ':DataViewerClose<CR>')
    end
  },

}
