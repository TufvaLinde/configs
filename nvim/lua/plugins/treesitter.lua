-- Treesitter: real parsing of code → accurate syntax colours.
-- Add a language: put it in the list below (or run :TSInstall <lang>).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "python", "lua", "vim", "vimdoc", "markdown", "markdown_inline",
        "bash", "json", "yaml", "toml", "html", "css", "javascript", "typescript",
      })
      -- Turn on treesitter highlighting for any filetype that has a parser.
      -- (LaTeX is left to vimtex, which does it better.)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.bo[args.buf].filetype ~= "tex" then
            pcall(vim.treesitter.start, args.buf)
          end
        end,
      })
    end,
  },
}
