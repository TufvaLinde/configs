-- Finding and opening files.
return {
  -- Telescope: fuzzy finder for files, text, help, keymaps...
  -- In the picker: type to filter, Ctrl-n/Ctrl-p to move, Enter to open,
  -- Ctrl-v to open in a vertical split, Esc to close.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find file" },
      { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Find text in project (grep)" },
      { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find open buffer" },
      { "<leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Search :help" },
      { "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Search keymaps" },
      { "<leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "All errors/warnings" },
      { "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in this file" },
      { "<leader><leader>", "<Cmd>Telescope find_files<CR>", desc = "Find file" },
    },
    opts = {},
  },

  -- Oil: edit the file system like a normal buffer.
  -- Press - to open the folder of the current file. Enter opens, - goes up.
  -- Rename/delete/create files by editing lines, then :w to apply.
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = { { "-", "<Cmd>Oil<CR>", desc = "Open parent folder" } },
    opts = { view_options = { show_hidden = true } },
  },
}
