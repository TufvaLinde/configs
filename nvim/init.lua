-- ~/.config/nvim/init.lua — the entry point. Neovim runs this first.
--
-- Layout of this config (each file is small and commented — read them!):
--   lua/config/options.lua   editor settings (line numbers, tabs, clipboard...)
--   lua/config/keymaps.lua   my own shortcuts that don't belong to a plugin
--   lua/config/lazy.lua      the plugin manager (lazy.nvim)
--   lua/plugins/*.lua        one file per topic; each returns plugin specs
--   ftplugin/tex.vim         LaTeX-only settings
--   plugin/terminal.vim      Ctrl-t toggles a terminal at the bottom
--   colors/ansi.lua          colour scheme that uses the terminal's 16 colours
--   UltiSnips/               snippets
--   CHEATSHEET.md            open it with <Space>? from anywhere

-- Leader keys must be set before plugins load, so their mappings use them.
vim.g.mapleader = " "       -- <leader> = Space: all my own shortcuts start here
vim.g.maplocalleader = "\\" -- <localleader> = \ : filetype shortcuts (vimtex: \ll, \lv)

require("config.options")
require("config.keymaps")
require("config.lazy")

-- Colours come from the terminal theme (see colors/ansi.lua), so change the
-- theme in ghostty/config and Neovim follows.
vim.cmd.colorscheme("ansi")
