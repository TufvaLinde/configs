-- Editor settings. `:help 'option'` explains any of them, e.g. :help 'scrolloff'
local o = vim.opt

o.number = true          -- line numbers...
o.relativenumber = true  -- ...relative to the cursor, so "5j" / "3dk" are easy to count
o.mouse = "a"            -- the mouse works (fine while learning)
o.clipboard = "unnamedplus" -- y / p use the system clipboard
o.ignorecase = true      -- search ignores case...
o.smartcase = true       -- ...unless you type a capital letter
o.expandtab = true       -- Tab inserts spaces
o.shiftwidth = 4         -- indent size (Python standard)
o.tabstop = 4
o.splitright = true      -- :vsplit opens to the right
o.splitbelow = true      -- :split opens below
o.scrolloff = 8          -- keep 8 lines visible above/below the cursor
o.undofile = true        -- undo history survives closing the file
o.signcolumn = "yes"     -- always show the column for errors / git marks (no jumping)
o.cursorline = true      -- highlight the current line
o.updatetime = 250       -- faster hover / diagnostics
o.timeoutlen = 400       -- how long to wait for the next key in a sequence (which-key pops up then)
o.wrap = true            -- long lines wrap to the window width (e.g. when a split makes it narrow)
o.linebreak = true       -- ...at word boundaries, not in the middle of a word
o.breakindent = true     -- ...and wrapped parts keep the line's indentation
o.showbreak = "↪ "       -- mark where a line continues
o.confirm = true         -- ask instead of failing when quitting with unsaved changes

-- Python for plugins (UltiSnips, Molten/Jupyter) lives in its own venv, made by install.sh
vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/venv/bin/python")
-- ...and its helper commands (jupytext, texview) live in ~/.local/bin
vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH

-- Show errors/warnings at the end of the line and with a little sign in the margin
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded" },
})
