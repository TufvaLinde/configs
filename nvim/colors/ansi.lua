-- "ansi": a colour scheme that only uses the terminal's 16 colours.
-- So Neovim always matches the Ghostty theme (set `theme = ...` in ghostty/config).
-- Numbers are the terminal palette:
--   0 black   1 red   2 green   3 yellow/brown   4 blue   5 magenta   6 cyan   7 white/grey
--   8–15 are the bright versions (8 = dark grey, 9 = bright red, ... 15 = bright white)

vim.cmd("highlight clear")
vim.g.colors_name = "ansi"
vim.o.termguicolors = false -- use the terminal's palette instead of fixed RGB colours

local function hl(group, spec) vim.api.nvim_set_hl(0, group, spec) end

-- Editor
hl("Normal", {})                                   -- terminal's own foreground/background
hl("NormalFloat", { ctermbg = 0 })
hl("FloatBorder", { ctermfg = 8 })
hl("LineNr", { ctermfg = 8 })
hl("CursorLineNr", { ctermfg = 11, bold = true })
hl("CursorLine", {})
hl("SignColumn", {})
hl("VertSplit", { ctermfg = 8 })
hl("WinSeparator", { ctermfg = 8 })
hl("StatusLine", { ctermfg = 15, ctermbg = 4 })
hl("StatusLineNC", { ctermfg = 7, ctermbg = 8 })
hl("Visual", { ctermfg = 0, ctermbg = 6 })
hl("Search", { ctermfg = 0, ctermbg = 11 })
hl("IncSearch", { ctermfg = 0, ctermbg = 13 })
hl("CurSearch", { ctermfg = 0, ctermbg = 13 })
hl("MatchParen", { ctermfg = 13, bold = true, underline = true })
hl("Pmenu", { ctermfg = 15, ctermbg = 4 })
hl("PmenuSel", { ctermfg = 0, ctermbg = 14 })
hl("PmenuSbar", { ctermbg = 8 })
hl("PmenuThumb", { ctermbg = 15 })
hl("NonText", { ctermfg = 8 })
hl("Whitespace", { ctermfg = 8 })
hl("Folded", { ctermfg = 14, ctermbg = 0 })
hl("Title", { ctermfg = 13, bold = true })
hl("Directory", { ctermfg = 12 })
hl("ErrorMsg", { ctermfg = 9, bold = true })
hl("WarningMsg", { ctermfg = 11 })
hl("ModeMsg", { ctermfg = 10, bold = true })
hl("MoreMsg", { ctermfg = 10 })
hl("Question", { ctermfg = 10 })
hl("TabLine", { ctermfg = 7, ctermbg = 8 })
hl("TabLineSel", { ctermfg = 15, ctermbg = 4, bold = true })
hl("TabLineFill", { ctermbg = 0 })

-- Code
hl("Comment", { ctermfg = 8, italic = true })
hl("String", { ctermfg = 10 })
hl("Character", { ctermfg = 10 })
hl("Number", { ctermfg = 13 })
hl("Boolean", { ctermfg = 13 })
hl("Float", { ctermfg = 13 })
hl("Constant", { ctermfg = 13 })
hl("Identifier", { ctermfg = 15 })
hl("Function", { ctermfg = 14 })
hl("Statement", { ctermfg = 11, bold = true })
hl("Keyword", { ctermfg = 11, bold = true })
hl("Conditional", { ctermfg = 11, bold = true })
hl("Repeat", { ctermfg = 11, bold = true })
hl("Operator", { ctermfg = 7 })
hl("Exception", { ctermfg = 9, bold = true })
hl("PreProc", { ctermfg = 12 })
hl("Include", { ctermfg = 12 })
hl("Type", { ctermfg = 12 })
hl("Special", { ctermfg = 6 })
hl("Delimiter", { ctermfg = 7 })
hl("Todo", { ctermfg = 0, ctermbg = 11, bold = true })
hl("Error", { ctermfg = 15, ctermbg = 1 })
hl("Underlined", { underline = true })

-- Treesitter groups that need a nudge (the rest link to the groups above)
hl("@variable", { ctermfg = 15 })
hl("@variable.parameter", { ctermfg = 7, italic = true })
hl("@variable.builtin", { ctermfg = 5 })
hl("@property", { ctermfg = 6 })
hl("@module", { ctermfg = 12 })
hl("@function.builtin", { ctermfg = 6 })
hl("@constructor", { ctermfg = 12 })
hl("@punctuation", { ctermfg = 7 })

-- Errors / warnings from language servers
hl("DiagnosticError", { ctermfg = 9 })
hl("DiagnosticWarn", { ctermfg = 11 })
hl("DiagnosticInfo", { ctermfg = 12 })
hl("DiagnosticHint", { ctermfg = 14 })
hl("DiagnosticOk", { ctermfg = 10 })
hl("DiagnosticUnderlineError", { underline = true, sp = 9 })
hl("DiagnosticUnderlineWarn", { underline = true })

-- Git changes in the margin
hl("Added", { ctermfg = 10 })
hl("Changed", { ctermfg = 11 })
hl("Removed", { ctermfg = 9 })
hl("DiffAdd", { ctermfg = 0, ctermbg = 2 })
hl("DiffChange", { ctermfg = 0, ctermbg = 3 })
hl("DiffDelete", { ctermfg = 0, ctermbg = 1 })
hl("DiffText", { ctermfg = 0, ctermbg = 11 })

-- Markdown / LaTeX headings
hl("@markup.heading", { ctermfg = 13, bold = true })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.link", { ctermfg = 12, underline = true })
