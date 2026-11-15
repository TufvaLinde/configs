#!/usr/bin/env bash
# install.sh — set up my whole dev environment on a fresh machine.
#
#   git clone https://github.com/TufvaLinde/configs.git ~/code/configs
#   cd ~/code/configs && ./install.sh
#
# Works on macOS and Linux (Debian/Ubuntu, Fedora, Arch), including WSL on Windows.
# Safe to re-run: every step checks first and skips what's already done.
#
# Options:
#   --no-tex     skip the (large) LaTeX install
#   --links-only only (re)create the config symlinks
#   -h, --help   show this help

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
WITH_TEX=1
LINKS_ONLY=0

for arg in "$@"; do
  case "$arg" in
    --no-tex) WITH_TEX=0 ;;
    --links-only) LINKS_ONLY=1 ;;
    -h|--help) sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg (try --help)"; exit 1 ;;
  esac
done

# ---------- pretty output ----------
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[32m  ✓ %s\033[0m\n' "$*"; }
warn() { printf '\033[33m  ! %s\033[0m\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------- detect platform ----------
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM=mac ;;
  Linux)  PLATFORM=linux ;;
  MINGW*|MSYS*|CYGWIN*)
    cat <<'EOF'
This looks like Git Bash / MSYS on Windows. Use WSL instead — it's a real Linux
inside Windows and this script fully supports it:

  1. In PowerShell (as admin):   wsl --install      (then reboot)
  2. Open "Ubuntu" from the Start menu, then inside it:
       git clone https://github.com/TufvaLinde/configs.git ~/code/configs
       cd ~/code/configs && ./install.sh
  3. Use Windows Terminal as your terminal (it can show images for the PDF view).
EOF
    exit 1 ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac
IS_WSL=0; grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1

# ---------- symlink helper (backs up anything it replaces) ----------
link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ok "$dest already linked"; return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    warn "backed up old $dest -> $BACKUP_DIR/"
  fi
  ln -s "$src" "$dest"
  ok "linked $dest -> $src"
}

make_links() {
  step "Linking configs"
  link nvim            "$HOME/.config/nvim"
  link tmux/.tmux.conf "$HOME/.tmux.conf"
  link zsh/.zshrc      "$HOME/.zshrc"
  link ghostty/config  "$HOME/.config/ghostty/config"
  link bin/texview     "$HOME/.local/bin/texview"
}

if [ "$LINKS_ONLY" = 1 ]; then make_links; exit 0; fi

# ---------- 1. system prerequisites (Linux only) ----------
if [ "$PLATFORM" = linux ]; then
  step "Installing system prerequisites"
  if have apt-get; then
    sudo apt-get update -y
    sudo apt-get install -y build-essential curl git zsh file procps python3 python3-venv unzip
  elif have dnf; then
    sudo dnf group install -y development-tools || sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y curl git zsh file procps-ng python3 unzip
  elif have pacman; then
    sudo pacman -Sy --needed --noconfirm base-devel curl git zsh file procps-ng python unzip
  else
    warn "Unknown package manager — install curl, git, zsh, python3 and a compiler yourself."
  fi
fi

# ---------- 2. Homebrew (used on both macOS and Linux) ----------
step "Homebrew"
if ! have brew; then
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && break
  done
fi
if ! have brew; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && break
  done
fi
ok "brew $(brew --version | head -1 | awk '{print $2}')"

# ---------- 3. command-line tools ----------
step "Command-line tools"
FORMULAE=(
  git             # version control
  neovim          # the editor
  tmux            # terminal sessions (optional on macOS, handy over SSH / WSL)
  tdf             # PDF viewer that draws inside the terminal (LaTeX preview)
  ripgrep         # fast search (rg) — powers Space fg in nvim
  fd              # fast file finder — powers Space ff in nvim
  fzf             # fuzzy finder for the shell (Ctrl-R history search etc.)
  python          # system Python
  uv              # Python package/venv manager (fast pip + venv + python versions)
  tree-sitter-cli # compiles syntax parsers for nvim-treesitter
  imagemagick     # converts plots/images so they can be drawn in the terminal
  node            # some language servers installed by Mason need Node
  nvm             # Node version manager (for your own projects)
)
for f in "${FORMULAE[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then ok "$f"; else brew install "$f"; fi
done

# ---------- 4. terminal app ----------
step "Terminal (Ghostty)"
if [ "$PLATFORM" = mac ]; then
  if [ -d /Applications/Ghostty.app ] || brew list --cask ghostty >/dev/null 2>&1; then
    ok "Ghostty"
  else
    brew install --cask ghostty
  fi
elif [ "$IS_WSL" = 1 ]; then
  ok "WSL: use Windows Terminal (supports images); Ghostty isn't on Windows"
elif have ghostty; then
  ok "Ghostty"
else
  warn "Install Ghostty with your distro's method: https://ghostty.org/docs/install/binary"
fi

# ---------- 5. LaTeX ----------
if [ "$WITH_TEX" = 1 ]; then
  step "LaTeX (this one is big — skip with --no-tex)"
  [ -d /Library/TeX/texbin ] && export PATH="/Library/TeX/texbin:$PATH"
  if have latexmk; then
    ok "latexmk found ($(command -v latexmk))"
  elif [ "$PLATFORM" = mac ]; then
    brew install --cask mactex-no-gui     # full TeX Live, no GUI apps
    export PATH="/Library/TeX/texbin:$PATH"
  elif have apt-get; then
    sudo apt-get install -y latexmk texlive-latex-extra texlive-science texlive-fonts-extra
  elif have dnf; then
    sudo dnf install -y latexmk texlive-scheme-medium
  elif have pacman; then
    sudo pacman -S --needed --noconfirm texlive texlive-latexextra texlive-science
  fi
fi

# ---------- 6. Oh My Zsh + zsh as default shell ----------
step "zsh + Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  ok "Oh My Zsh"
else
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ "$(basename "${SHELL:-}")" != zsh ]; then
  if chsh -s "$(command -v zsh)"; then
    ok "default shell is now zsh (log out/in to apply)"
  else
    warn "couldn't change shell; run: chsh -s $(command -v zsh)"
  fi
else
  ok "zsh is the default shell"
fi

# ---------- 7. config symlinks ----------
make_links

# ---------- 8. Neovim: Python envs, plugins, parsers, language servers ----------
step "Neovim"
# Neovim's own Python: UltiSnips, Molten (Jupyter bridge), jupytext.
# Python 3.13 via uv, because brand-new Python versions often lack wheels.
VENV="$HOME/.local/share/nvim/venv"
[ -x "$VENV/bin/python" ] || uv venv -q --python 3.13 "$VENV"
uv pip install -q --python "$VENV" pynvim jupyter_client nbformat jupytext pyperclip
mkdir -p "$HOME/.local/bin"
ln -sf "$VENV/bin/jupytext" "$HOME/.local/bin/jupytext"
ok "nvim Python env"

# A ready-made Jupyter kernel called "scratch" with numpy/pandas/matplotlib
SCRATCH="$HOME/.local/share/jupyter-scratch"
[ -x "$SCRATCH/bin/python" ] || uv venv -q --python 3.13 "$SCRATCH"
uv pip install -q --python "$SCRATCH" ipykernel numpy pandas matplotlib rich
"$SCRATCH/bin/python" -m ipykernel install --user --name scratch --display-name "Python (scratch)" >/dev/null
ok "Jupyter kernel 'scratch'"

# `rich` command: pretty-print Markdown, CSV, JSON, code... in the terminal
uv tool list 2>/dev/null | grep -q '^rich-cli' || uv tool install -q --python 3.13 rich-cli
ok "rich-cli"

# Plugins (lazy.nvim installs itself), then wait for parsers + language servers,
# which otherwise download in the background.
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1
nvim --headless -c "lua require('nvim-treesitter').install({'python','lua','vim','vimdoc','markdown','markdown_inline','bash','json','yaml','toml','html','css','javascript','typescript'}):wait(300000)" -c qa >/dev/null 2>&1
nvim --headless -c "MasonInstall basedpyright ruff lua-language-server texlab" -c qa >/dev/null 2>&1
nvim --headless +UpdateRemotePlugins +qa >/dev/null 2>&1
ok "plugins, parsers and language servers installed"

# ---------- 9. Claude Code ----------
step "Claude Code"
if have claude; then
  ok "claude $(claude --version 2>/dev/null | head -1)"
else
  curl -fsSL https://claude.ai/install.sh | bash
fi

step "Done!"
cat <<EOF
Next:
  • Open a new terminal (Ghostty on macOS/Linux, Windows Terminal on WSL)
  • Split with  Cmd-D  in Ghostty (or run  t  for tmux on Linux/WSL)
  • Run  claude  in one pane and  nvim  in the other
  • In nvim press  Space ?  for the cheat sheet
$( [ -d "$BACKUP_DIR" ] && echo "  • Your old config files were moved to $BACKUP_DIR" )
EOF
