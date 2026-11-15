-- LaTeX: vimtex (compile/view/motions) + UltiSnips (snippets in UltiSnips/).
-- LaTeX-only mappings are in ftplugin/tex.vim.
return {
  {
    "lervag/vimtex",
    lazy = false, -- vimtex must not be lazy-loaded
    init = function()
      -- \lv shows the PDF inside the terminal (tdf in a Ghostty split, see bin/texview)
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = vim.fn.expand("~/.local/bin/texview")
      vim.g.vimtex_view_general_options = "@pdf"
    end,
  },
  {
    "SirVer/ultisnips",
    lazy = false,
    init = function()
      vim.g.UltiSnipsExpandTrigger = "<Tab>"        -- expand a snippet
      vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"   -- next field
      vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>" -- previous field
      vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("config") .. "/UltiSnips" }
    end,
    keys = {
      { "<leader>u", "<Cmd>call UltiSnips#RefreshSnippets()<CR>", desc = "Reload snippets" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
