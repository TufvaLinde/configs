-- Formatting: tidy the file automatically on save.
-- :ConformInfo shows which formatter is used for the current file.
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<leader>cf", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format file" },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
      -- Format on save (any language with a formatter or a language server that formats)
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    },
  },
}
