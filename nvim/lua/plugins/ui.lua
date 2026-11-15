-- Discoverability, git and status line. (Colours: colors/ansi.lua follows the Ghostty theme.)
return {

  -- which-key: press <Space> and wait — a menu shows every shortcut that follows.
  -- The best way to learn your own config.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>j", group = "jupyter" },
        { "<leader>g", group = "git" },
      },
    },
  },

  -- Git: change marks in the margin, ]h / [h to jump between changed hunks
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = buf, desc = d }) end
        map("]h", function() gs.nav_hunk("next") end, "Next git change")
        map("[h", function() gs.nav_hunk("prev") end, "Previous git change")
        map("<leader>gp", gs.preview_hunk, "Preview change")
        map("<leader>gr", gs.reset_hunk, "Undo this change")
        map("<leader>gb", gs.blame_line, "Who wrote this line")
      end,
    },
  },

  -- Status line at the bottom
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "16color", globalstatus = true } } },
}
