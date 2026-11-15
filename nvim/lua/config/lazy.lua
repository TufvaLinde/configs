-- lazy.nvim: the plugin manager. It installs itself the first time.
-- :Lazy opens its window (U = update all, S = sync, ? = help).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } }, -- load every file in lua/plugins/
  rocks = { enabled = false },        -- no luarocks needed (image.nvim uses the magick CLI)
  install = { colorscheme = { "ansi" } },
  checker = { enabled = false },      -- don't nag about updates; run :Lazy update yourself
  change_detection = { notify = false },
})
