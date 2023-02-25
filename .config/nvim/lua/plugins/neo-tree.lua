return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",    -- lazy load plugin if cmd is issued
  branch = "v2.x",
  keys = {             -- lazy load plugin if key sequence is seen
    { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "Neotree" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  -- use config as a lua table instead of a function.  If you use a
  -- table, lazy will automatically require it and pass the table
  -- to the plugin's setup function
  opts = {
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
    },
  },

--  config = function()
--    require('neo-tree').setup {
--      options = {
--        follow_current_file = true,
--        hijack_netrw_behavior = "open_current",
--      },
--    }
--  end
}
