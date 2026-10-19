# =============================================================================
# ZSHRC - Jeffery's Shell Configuration
# =============================================================================
# Philosophy: Keyboard-centric, fast, understandable
# Started: February 2026
# =============================================================================

# -----------------------------------------------------------------------------
# PATH Configuration
# -----------------------------------------------------------------------------
# Homebrew (Apple Silicon path)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add local bin for user scripts
export PATH="$HOME/.local/bin:$PATH"

# GOPATH (~/go/bin)
export PATH="$HOME/go/bin:$PATH"

# -----------------------------------------------------------------------------
# History Configuration
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000                # Commands to keep in memory
SAVEHIST=10000                # Commands to save to file
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_ALL_DUPS   # Don't save duplicates
setopt HIST_SAVE_NO_DUPS      # Don't write duplicates
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS     # Remove extra blanks

# -----------------------------------------------------------------------------
# Shell Options
# -----------------------------------------------------------------------------
setopt AUTO_CD                # cd into directories without typing cd
setopt CORRECT                # Spell correction for commands
setopt NO_CASE_GLOB           # Case-insensitive globbing
setopt EXTENDED_GLOB          # Extended pattern matching

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
# Use emacs-style keybindings (Ctrl-A, Ctrl-E, etc.)
bindkey -e

# Better history search - type partial command, then arrow up
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# -----------------------------------------------------------------------------
# Aliases - Better Defaults (ACTIVE - tools installed)
# -----------------------------------------------------------------------------

# eza (better ls)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'

# bat (better cat)
alias cat='bat --paging=never'
alias catp='bat'  # bat with paging when you want it

# Safety nets
alias rm='rm -i'              # Confirm before removing
alias mv='mv -i'              # Confirm before overwriting
alias cp='cp -i'              # Confirm before overwriting

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts (LazyGit is primary, but these are handy)
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -20'

# Shortcuts for new tools
alias top='btop'              

# Local Development Database Connection(Postgres)
alias pg='pgcli -h localhost -U jeffery -d devdb'

# -----------------------------------------------------------------------------
# Dotfiles Management (Bare Git Repo)
# -----------------------------------------------------------------------------
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# -----------------------------------------------------------------------------
# Tool Initialization (ACTIVE - tools installed)
# -----------------------------------------------------------------------------

# Starship prompt
eval "$(starship init zsh)"

# zoxide (smarter cd - use 'z' instead of 'cd')
eval "$(zoxide init zsh)"

# fzf keybindings and completion
# Ctrl-T: paste selected files
# Ctrl-R: search command history
# Alt-C: cd into selected directory
source <(fzf --zsh)

# -----------------------------------------------------------------------------
# FZF Configuration
# -----------------------------------------------------------------------------
# Use fd instead of find (faster, respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Preview files with bat
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

# -----------------------------------------------------------------------------
# Environment Variables
# -----------------------------------------------------------------------------
# Default editor (will be nvim once installed)
export EDITOR='nvim'
export VISUAL='nvim'

# Use bat as man pager for colorized man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# -----------------------------------------------------------------------------
# Plugin Manager (zinit)
# -----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# Essential plugins
zinit light zsh-users/zsh-autosuggestions    # Fish-like suggestions
zinit light zsh-users/zsh-syntax-highlighting # Fish-like syntax colors
zinit light zsh-users/zsh-completions         # Additional completions

# Generated completions for workmux / sesh / aven (see ~/.local/bin/agentic-setup)
fpath=(~/.zsh/completions $fpath)

# Load completions
autoload -Uz compinit && compinit

# -----------------------------------------------------------------------------
# mise (runtime version manager) - Uncomment after installing
# -----------------------------------------------------------------------------
eval "$(mise activate zsh)"

# =============================================================================
# AGENTIC STACK (tmux + sesh + workmux + aven + atuin)
# =============================================================================
# Guide: ~/docs/agentic-tmux/guide.md

# -----------------------------------------------------------------------------
# atuin — takes over Ctrl-R from fzf; ↑ keeps your prefix-match history search
# -----------------------------------------------------------------------------
if command -v atuin >/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# -----------------------------------------------------------------------------
# workmux — git worktree + tmux window per agent
# -----------------------------------------------------------------------------
alias wm='workmux'
alias wma='workmux add'                   # wma oauth -p "Work on HFL-7KQ9 ..."
alias wmA='workmux add -A -p'             # wmA "Add pagination"  (branch auto-named)
alias wml='workmux list'
alias wmd='workmux dashboard'
alias wmm='workmux merge'
alias wmr='workmux remove'
alias wmo='workmux open'
wmcd() { cd "$(workmux path "$1")"; }     # jump this shell into a worktree

# -----------------------------------------------------------------------------
# aven — tasks
# -----------------------------------------------------------------------------
alias av='aven'
alias ava='aven add'

# -----------------------------------------------------------------------------
# sesh — Ctrl-G picks a session from any prompt, in or out of tmux
# -----------------------------------------------------------------------------
# (Alt-s belongs to AeroSpace workspace S, so this uses Ctrl-G)
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c -z | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect "$session"
  }
}
zle -N sesh-sessions
bindkey '^G' sesh-sessions

# -----------------------------------------------------------------------------
# Local Overrides
# -----------------------------------------------------------------------------
# Source local config if it exists (for machine-specific settings)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# =============================================================================
# END ZSHRC
# =============================================================================
alias lazydotfiles='lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME'
