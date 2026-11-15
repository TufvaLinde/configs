# configs

My whole development environment in one repo. **Neovim** is the IDE: Python with type checking, linting and formatting, **Jupyter notebooks** with inline plots, and **LaTeX** with the PDF *inside the terminal*. The rest is **Ghostty** (terminal app), **zsh** (shell) and optionally **tmux**.

The goal: get a new laptop, run two commands, and everything is back the way it was.

```
┌──────────────── Ghostty ──────────────────────────────────────────┐
│ Ghostty splits (or tmux)                                          │
│ ┌─────────────────┬──────────────────────┬──────────────────────┐ │
│ │ claude          │ nvim notes.tex       │ tdf notes.pdf        │ │
│ │                 │                      │ (reloads on compile) │ │
│ └─────────────────┴──────────────────────┴──────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
```

---

## Quick start on a new machine

### macOS

Open Terminal and run:

```sh
xcode-select --install          # git + compilers (skip if already installed)
git clone https://github.com/TufvaLinde/configs.git ~/code/configs
cd ~/code/configs && ./install.sh
```

Then open **Ghostty** (not Terminal) and run `t` to start tmux.

### Linux (Ubuntu/Debian, Fedora, Arch)

```sh
sudo apt install -y git         # or: sudo dnf install git / sudo pacman -S git
git clone https://github.com/TufvaLinde/configs.git ~/code/configs
cd ~/code/configs && ./install.sh
```

Install Ghostty with your distro's method ([ghostty.org/docs/install](https://ghostty.org/docs/install/binary)). The script will remind you.

### Windows

Windows can't run this bash script natively, so use **WSL**, which runs a real Linux inside Windows:

1. Open PowerShell as administrator, run `wsl --install`, and reboot.
2. Open **Ubuntu** from the Start menu and follow the Linux steps above.
3. Use **Windows Terminal** as your terminal app. It can display images, so the in-terminal PDF view works.

### Options

```sh
./install.sh --no-tex       # skip LaTeX (it's several GB)
./install.sh --links-only   # only recreate the config symlinks
./install.sh --help
```

The script is **safe to re-run**: each step checks whether it's already done and skips it. Re-run it after pulling changes or when something seems broken.

---

## What `install.sh` does

| Step | macOS | Linux / WSL |
|---|---|---|
| 1. System prerequisites | (Xcode tools) | compiler, curl, git, zsh, python via apt/dnf/pacman |
| 2. Homebrew | ✓ | ✓ (Homebrew on Linux) |
| 3. CLI tools via brew | neovim, tmux, tdf, ripgrep, fd, fzf, python, nvm | same |
| 4. Terminal | Ghostty | prints instructions (Windows Terminal on WSL) |
| 5. LaTeX | MacTeX (no GUI apps) | TeX Live + latexmk from the distro |
| 6. Shell | Oh My Zsh, zsh as default | same |
| 7. Symlinks | see below | same |
| 8. Neovim | Python envs (uv), plugins, syntax parsers, language servers, `scratch` Jupyter kernel | same |
| 9. Claude Code | native installer | same |

**Why Homebrew on Linux too?** One package list for every machine, and up-to-date versions. Ubuntu's own Neovim is too old for vimtex, and `tdf` isn't packaged for most distros.

### Symlinks: how the configs get "installed"

Nothing is copied. The script creates links from where programs look for their config to the files in this repo:

| Program looks at | Points to |
|---|---|
| `~/.config/nvim/` | `nvim/` |
| `~/.tmux.conf` | `tmux/.tmux.conf` |
| `~/.zshrc` | `zsh/.zshrc` |
| `~/.config/ghostty/config` | `ghostty/config` |
| `~/.local/bin/texview` | `bin/texview` |

So **editing a file in this repo changes your live setup immediately**, and `git commit && git push` saves it for every other machine. Existing files the script would replace are moved to `~/.dotfiles-backup/<timestamp>/` and never deleted.

Anything machine-specific or secret (API keys, work paths) goes in `~/.zshrc.local`. It's loaded automatically and isn't in git.

---

## Repo layout

```
configs/
├── install.sh              # the bootstrap script
├── bin/texview             # opens a compiled PDF in a tmux pane (used by vimtex)
├── ghostty/config          # terminal app settings
├── tmux/.tmux.conf         # splits, pane movement, mouse, image passthrough
├── zsh/.zshrc              # shell: PATH, Oh My Zsh, aliases (portable, guarded)
└── nvim/
    ├── init.lua            # entry point: leader keys, loads the rest
    ├── CHEATSHEET.md       # every shortcut + how to learn Vim (Space ? in nvim)
    ├── lua/config/
    │   ├── options.lua     # editor settings
    │   ├── keymaps.lua     # my own shortcuts
    │   └── lazy.lua        # plugin manager (lazy.nvim)
    ├── lua/plugins/        # one file per topic, each lists its plugins
    │   ├── ui.lua          # which-key menu, git signs, status line
    │   ├── navigation.lua  # Telescope (fuzzy find), Oil (file explorer)
    │   ├── treesitter.lua  # syntax parsing / highlighting
    │   ├── lsp.lua         # language servers (Mason), completion (blink.cmp)
    │   ├── format.lua      # format on save (conform)
    │   ├── jupyter.lua     # Molten + jupytext + image.nvim
    │   └── latex.lua       # vimtex + UltiSnips
    ├── colors/ansi.lua     # colour scheme: uses the terminal's 16 colours, so it follows the Ghostty theme
    ├── plugin/terminal.vim # Ctrl-t terminal toggle
    ├── ftplugin/tex.vim    # LaTeX-only mappings + quickfix filters
    └── UltiSnips/          # snippets (tex.snippets = the LaTeX ones)
```

---

## Daily workflow

On macOS, **Ghostty's own splits are all you need**. Open Ghostty, press `Cmd-D` to split, run `claude` on one side and `nvim` on the other. `\lv` adds the PDF as a third split.

### Ghostty splits & tabs (macOS)

| Keys | Action |
|---|---|
| `Cmd-D` / `Cmd-Shift-D` | split right / split down |
| `Cmd-[` / `Cmd-]` | previous / next split |
| `Cmd-Option-←↑↓→` | move to the split in that direction |
| `Cmd-Ctrl-←↑↓→` / `Cmd-Ctrl-=` | resize split / make all splits equal |
| `Cmd-Shift-Enter` | zoom a split to full window, or back |
| `Cmd-W` | close split |
| `Cmd-T` / `Cmd-1..8` | new tab / go to tab |

### When tmux is still worth it

tmux is optional. It's here for when you need what Ghostty can't do:
- **Sessions that survive**: close the terminal, `t` later, and everything is still running.
- **Remote machines over SSH**: run tmux on the server and keep working if the connection drops.
- **WSL / Linux without Ghostty**: the same keys in any terminal.

```sh
t                    # alias: attach to tmux session "main" (or create it)
```

### tmux (prefix = `Ctrl-b`, press it, release, then the key)

Swedish Mac keyboard: `|` is `Option-7`, `\` is `Shift-Option-7`, `[ ]` are `Option-8/9`, `{ }` are `Shift-Option-8/9`.

| Keys | Action |
|---|---|
| `\|` / `-` | split side-by-side / top-bottom |
| `h` `j` `k` `l` | move to pane left / down / up / right |
| `H` `J` `K` `L` | resize pane (repeatable) |
| `z` | zoom pane to full screen, or back |
| `c` / `Ctrl-h` / `Ctrl-l` | new window / previous / next window |
| `[` | scroll / copy mode (vim keys, `q` to exit) |
| `d` | detach (session keeps running; `t` to come back) |
| `r` | reload tmux config |

### Neovim

The full list lives in **[nvim/CHEATSHEET.md](nvim/CHEATSHEET.md)**: open it in Neovim with `Space ?`. Or press `Space` and wait, and a menu shows every shortcut. The most used:

| Keys | Action |
|---|---|
| `Space Space` / `Space fg` | find file / find text in project |
| `-` | file explorer (edit it like text, `:w` applies) |
| `gd` / `K` / `grr` | go to definition / docs / references |
| `Space ca` / `Space cr` | quick fix / rename |
| `]d` / `[d` | next / previous error |
| `Ctrl-n` `Ctrl-p` `Ctrl-y` | move in / accept completion |
| `Space ji` / `Space jr` | Jupyter: start kernel / run cell |
| `Ctrl-t` | toggle a terminal at the bottom |

### Python

Language support comes from **basedpyright** (types, go-to-definition, completion) and **Ruff** (lint + format; runs on every save). The project's virtualenv is picked up automatically when it's in `.venv/`. To start a project:

```sh
mkdir myproj && cd myproj
uv init && uv add numpy        # creates .venv + pyproject.toml
nvim main.py
```

### Jupyter notebooks

Open a `.ipynb` file and it appears as plain Python with `# %%` lines between cells (via jupytext), so all the Python tooling works in it. `:w` writes it back to `.ipynb`.

1. `Space ji` → pick a kernel. `scratch` has numpy, pandas and matplotlib ready.
2. `Space jr` runs the cell under the cursor. Output (and plots) appear below it. `Space jn` runs it and moves to the next cell.
3. For a project's own packages: create `.venv` with `uv`, then `:JupyterRegisterVenv` in Neovim, then `Space ji` → pick the kernel named after the folder.

**Rich** ([Textualize/rich](https://github.com/Textualize/rich)) is installed in `scratch` and as the `rich` shell command (`rich notes.md`, `rich data.csv`). Snippets `rprint`, `rtrace`, `rtable`, `rtrack`, `rinspect` add it to your code. In notebooks Molten shows Rich's layout but strips colours; run scripts in a terminal to get the colours.

A `.py` file with `# %%` cells works the same way and is nicer in git than `.ipynb`. Plots need Ghostty (or kitty); Molten's outputs are not saved into the `.ipynb`.

### LaTeX (`\` = local leader, only in `.tex` files)

| Keys | Action |
|---|---|
| `\ll` | start continuous compile (recompiles on every save) |
| `\c` | save + compile once |
| `\lv` | **show the PDF in a split on the right** |
| `\le` | show errors |
| `\lk` / `\lc` | stop compiling / clean aux files |
| `Tab` | expand snippet / jump to next field (`Shift-Tab` back) |
| `cse` `dse` | change / delete surrounding environment |
| `ci$` `dsm` | change inside math / delete surrounding math |

---

## LaTeX in the terminal (no PDF app)

`\lv` runs `bin/texview`, which opens [`tdf`](https://github.com/itsjunetime/tdf) in a split next to Neovim. On macOS with Ghostty this is a **native Ghostty split** to the right of tmux, because images don't make it through tmux reliably (tdf shows *"Couldn't transfer image… deadline has elapsed"*). Elsewhere it falls back to a tmux pane. tdf draws the actual PDF pages as images in the terminal, and it **reloads whenever latexmk rewrites the PDF**. Start `\ll`, save, and the preview updates.

In tdf, use `j`/`k` or the arrow keys to change pages, `/` to search, and `q` to quit.

**Requirements:**
- A terminal that can draw images: **Ghostty**, Kitty, WezTerm, or Windows Terminal. *macOS Terminal.app can't*, which is why the script installs Ghostty.
- The first time, macOS asks whether Ghostty may control Ghostty (AppleScript). Click **OK**.

If you're outside tmux, you can always run `tdf file.pdf` by hand in another terminal tab.

---

## Changing the colours

Set `theme = ...` in `ghostty/config` (list them with `ghostty +list-themes`; currently **CGA**), then reload Ghostty with `Cmd-Shift-,`. Neovim has no theme of its own: `nvim/colors/ansi.lua` only uses the terminal's 16 colours, so it follows automatically. Restart Neovim to see the change. To tweak which colour code elements get, edit the numbers in that file (0–15 = the terminal palette).

## Adding things later

- **A new CLI tool:** add it to `FORMULAE` in `install.sh`.
- **A new config file:** put it in the repo and add a `link` line in `make_links()` in `install.sh`.
- **A Neovim plugin:** add a spec to a file in `nvim/lua/plugins/` (or a new file there); lazy.nvim installs it on next start. `:Lazy` shows plugins, `U` updates.
- **A new language:** add its language server to `ensure_installed` in `nvim/lua/plugins/lsp.lua` (browse names with `:Mason`), its parser to `nvim/lua/plugins/treesitter.lua`, and to the `MasonInstall` / treesitter lines in `install.sh`.

Re-run `./install.sh` after any of these, and commit.

## Troubleshooting

| Problem | Fix |
|---|---|
| `VimTeX does not support your version of Vim` | `brew upgrade neovim` |
| Snippets don't expand / Jupyter commands missing | `:checkhealth vim.provider`; re-run `./install.sh` (rebuilds the Python venv), then `:UpdateRemotePlugins` and restart nvim |
| No errors/completion in a file | `:checkhealth vim.lsp` shows attached servers; `:Mason` to install missing ones |
| Plots don't show | must be Ghostty or kitty, *not* inside tmux; `:checkhealth image` |
| `Space ji` lists no kernel | `jupyter kernelspec list` (from `~/.local/share/nvim/venv/bin/`); re-run `./install.sh` to recreate `scratch` |
| `\lv` does nothing | a tdf viewer for that PDF is already open somewhere; close it with `q` and try again. Also check you're in Ghostty, not Terminal.app |
| "Couldn't transfer image to the terminal" | tdf is running inside tmux; use `\lv` (opens a Ghostty split) or run `tdf file.pdf` in a Ghostty tab |
| Can't type `\|` `\` `{` `}` in the terminal (e.g. `\ll` just moves the cursor) | Ghostty must have `macos-option-as-alt = false` (Option has to type characters on Swedish/Nordic keyboards); restart Ghostty with `Cmd-Q` after changing it |
| Old config files disappeared | they're in `~/.dotfiles-backup/` |

---

Neovim LaTeX setup based on [Elijan Mastnak's Vim + LaTeX guide](https://www.ejmastnak.com/tutorials/vim-latex/intro/).
