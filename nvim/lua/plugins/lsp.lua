-- Language support: go-to-definition, hover docs, errors, rename, autocompletion.
--
-- How it fits together:
--   mason        downloads language servers/tools (open :Mason to browse & install more)
--   lspconfig    knows how to start each server
--   blink.cmp    the completion popup
--
-- Adding a language later = add its server name to `ensure_installed` below
-- (find names with :Mason or https://github.com/neovim/nvim-lspconfig).
return {
  { "mason-org/mason.nvim", opts = {} },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "basedpyright", -- Python: types, go-to-definition, hover, completion
        "ruff",         -- Python: linting + formatting (very fast)
        "lua_ls",       -- Lua: for editing this config
        "texlab",       -- LaTeX: completion of \ref, \cite...
      },
    },
    config = function(_, opts)
      -- Python: let basedpyright do types, let ruff do style/lint, so they don't double up
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = { typeCheckingMode = "standard" },
          },
        },
      })
      vim.lsp.config("ruff", {
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      })
      require("mason-lspconfig").setup(opts) -- installs + enables the servers
    end,
  },

  -- Makes lua_ls understand Neovim's API while editing this config
  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  -- Completion popup. Ctrl-n / Ctrl-p to move, Ctrl-y to accept, Ctrl-e to close,
  -- Ctrl-Space to open it manually. (Tab is left to UltiSnips snippets.)
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default", ["<Tab>"] = {}, ["<S-Tab>"] = {} },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },

  -- Shortcuts that work whenever a language server is attached.
  -- Neovim already gives you: K (hover docs), grn (rename), gra (code action),
  -- grr (references), gri (implementation), gO (symbols), [d / ]d (prev/next error).
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = args.buf, desc = d }) end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action / quick fix")
          map("<leader>cs", "<Cmd>Telescope lsp_document_symbols<CR>", "Symbols in file")
        end,
      })
    end,
  },
}
