-- Jupyter notebooks inside Neovim.
--
--   jupytext   opens .ipynb files as plain Python, cells separated by "# %%" lines
--              (so Python LSP, linting and completion work in notebooks too)
--   molten     runs code in a real Jupyter kernel and shows the output under the cell
--   image.nvim draws plots/images in the terminal (needs Ghostty or kitty)
--
-- Workflow: open a .ipynb or .py file → <Space>ji pick a kernel → <Space>jr run cell.
-- Kernels: "scratch" (numpy/pandas/matplotlib, made by install.sh), or your project's
-- venv after :JupyterRegisterVenv (see the cheat sheet).

-- Find the "# %%" cell around the cursor. Returns first and last line of its code.
local function cell_range()
  local is_marker = function(l) return vim.fn.getline(l):match("^# %%") ~= nil end
  local cur, last = vim.fn.line("."), vim.fn.line("$")
  local s = cur
  while s > 1 and not is_marker(s) do s = s - 1 end
  if is_marker(s) then s = s + 1 end
  local e = math.max(cur, s)
  while e < last and not is_marker(e + 1) do e = e + 1 end
  return s, e
end

local function kernel_running()
  local ok, k = pcall(vim.fn.MoltenRunningKernels, true)
  return ok and #k > 0
end

local function run_cell(move_after)
  if not kernel_running() then
    vim.notify("No kernel yet: press <Space>ji to start one", vim.log.levels.WARN)
    return
  end
  local s, e = cell_range()
  vim.fn.MoltenEvaluateRange(s, e)
  if move_after then
    local next_marker = vim.fn.search("^# %%", "nW")
    if next_marker > 0 then vim.api.nvim_win_set_cursor(0, { math.min(next_marker + 1, vim.fn.line("$")), 0 }) end
  end
end

local function jump_cell(dir)
  vim.fn.search("^# %%", dir == 1 and "W" or "bW")
end

return {
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",          -- Ghostty speaks the kitty image protocol
      processor = "magick_cli",   -- uses the `magick` command (ImageMagick)
      integrations = {
        markdown = { enabled = true, only_render_image_at_cursor = true },
      },
      max_width = 100,
      max_height = 20,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
    },
  },

  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    lazy = false,
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = false     -- show output inline instead of popping up
      vim.g.molten_virt_text_output = true      -- output appears under the cell
      vim.g.molten_virt_lines_off_by_1 = true   -- ...below the last line, not on it
      vim.g.molten_output_virt_lines = true
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_max_height = 20
    end,
    config = function()
      local map = function(m, l, r, d) vim.keymap.set(m, l, r, { desc = d }) end
      map("n", "<leader>ji", "<Cmd>MoltenInit<CR>", "Start a kernel (pick one)")
      map("n", "<leader>jr", function() run_cell(false) end, "Run cell")
      map("n", "<leader>jn", function() run_cell(true) end, "Run cell, go to next")
      map("n", "<leader>jl", "<Cmd>MoltenEvaluateLine<CR>", "Run line")
      map("v", "<leader>jr", ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", "Run selection")
      map("n", "<leader>jo", "<Cmd>noautocmd MoltenEnterOutput<CR>", "Open output (scroll/copy it)")
      map("n", "<leader>jh", "<Cmd>MoltenHideOutput<CR>", "Hide output")
      map("n", "<leader>jd", "<Cmd>MoltenDelete<CR>", "Delete cell output")
      map("n", "<leader>jx", "<Cmd>MoltenInterrupt<CR>", "Interrupt (stop running code)")
      map("n", "<leader>jR", "<Cmd>MoltenRestart!<CR>", "Restart kernel")
      map("n", "<leader>jc", "o<CR># %%<CR>", "New cell below")
      map("n", "]j", function() jump_cell(1) end, "Next cell")
      map("n", "[j", function() jump_cell(-1) end, "Previous cell")

      -- Make the current project's .venv available as a Jupyter kernel
      vim.api.nvim_create_user_command("JupyterRegisterVenv", function()
        local py = vim.fn.getcwd() .. "/.venv/bin/python"
        if vim.fn.executable(py) == 0 then
          vim.notify("No .venv in " .. vim.fn.getcwd() .. " (create one with: uv venv)", vim.log.levels.ERROR)
          return
        end
        local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.notify("Installing ipykernel into .venv and registering kernel '" .. name .. "'…")
        vim.system({ "uv", "pip", "install", "--python", py, "ipykernel" }, {}, function(r1)
          if r1.code ~= 0 then return vim.schedule(function() vim.notify(r1.stderr, vim.log.levels.ERROR) end) end
          vim.system({ py, "-m", "ipykernel", "install", "--user", "--name", name }, {}, function(r2)
            vim.schedule(function()
              vim.notify(r2.code == 0 and ("Kernel '" .. name .. "' ready — <Space>ji to start it")
                or r2.stderr, r2.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
            end)
          end)
        end)
      end, { desc = "Register ./.venv as a Jupyter kernel" })
    end,
  },

  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- must be loaded before you open a .ipynb
    opts = {
      style = "hydrogen",        -- cells look like "# %%"
      output_extension = "auto",
      force_ft = nil,
    },
  },
}
