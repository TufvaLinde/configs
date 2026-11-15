# ~/.zshrc — managed by ~/code/configs (symlinked). Works on macOS and Linux.
# Every machine-specific line is guarded, so missing tools are simply skipped.

# ----- PATH -----
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (macOS Apple Silicon, macOS Intel, Linux)
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
done
unset brew_bin

# TeX (MacTeX puts its binaries here)
[ -d /Library/TeX/texbin ] && export PATH="/Library/TeX/texbin:$PATH"

# ----- Oh My Zsh -----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# ----- Editor -----
export EDITOR='nvim'
export VISUAL='nvim'

# ----- Language toolchains (each only if installed) -----
# nvm (Node): Homebrew install or the standard ~/.nvm install
export NVM_DIR="$HOME/.nvm"
if command -v brew >/dev/null && [ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ]; then
  source "$(brew --prefix nvm)/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# chruby (Ruby)
if command -v brew >/dev/null && [ -f "$(brew --prefix 2>/dev/null)/opt/chruby/share/chruby/chruby.sh" ]; then
  source "$(brew --prefix)/opt/chruby/share/chruby/chruby.sh"
  source "$(brew --prefix)/opt/chruby/share/chruby/auto.sh"
  chruby ruby-3.4.1 2>/dev/null
fi

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"   # Haskell
[ -f "$HOME/.unity/env" ] && . "$HOME/.unity/env"        # Unity

# ----- Aliases -----
alias c='clear'
alias v='nvim'
alias t='tmux new -A -s main'      # attach to "main" session, or create it

# room of requirement script shortcuts
alias wtg='python3 ~/silly-scripts/room-of-requirement/ror.py'
alias wtgrn='python3 ~/silly-scripts/room-of-requirement/ror.py rn'
alias wtgtd='python3 ~/silly-scripts/room-of-requirement/ror.py td'

# Machine-local stuff that shouldn't be in git (secrets, work paths...)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
