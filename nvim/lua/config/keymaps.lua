-- My own shortcuts. Plugin shortcuts live next to the plugin in lua/plugins/.
-- See every mapping with  <Space>fk  (fuzzy-search keymaps) or  :map
local map = vim.keymap.set

-- Esc also clears the search highlight
map("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- Move between splits with Ctrl + h/j/k/l (instead of Ctrl-w then h/j/k/l)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- With wrapping on, j/k move by *screen* line, so you can move through a wrapped line.
-- With a count (5j) they still move by real line, so relative numbers keep working.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Save with Space w, quit with Space q
map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<Cmd>quit<CR>", { desc = "Quit window" })

-- Keep the selection when indenting in visual mode (> and < can be repeated)
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Diagnostics (errors/warnings)
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show error under cursor" })

-- Open my cheat sheet in a split
map("n", "<leader>?", function()
  -- opens on the far right, 70 columns wide, so your code keeps most of the screen
  vim.cmd("botright vertical 70split " .. vim.fn.stdpath("config") .. "/CHEATSHEET.md")
end, { desc = "Open my cheat sheet" })

-- Briefly highlight what you just yanked (copied), so you can see it worked
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})
