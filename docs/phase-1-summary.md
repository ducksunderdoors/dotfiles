# MacBook Pro Setup - Phase 1 Summary

> **Machine:** 17" MacBook Pro (Apple Silicon M1/M2)
> **User:** Jeffery Garza (@ducksunderdoors)
> **Philosophy:** Keyboard-centric, CLI/TUI-first, mastery before experimentation
> **Phase 1 Completed:** February 7, 2025

---

## What Was Accomplished

### ✅ Shell Foundation
- **Zsh** configured with sane defaults (history, auto-cd, spell correction)
- **Starship** prompt installed and active
- **Emacs-style** keybindings for command line editing (Ctrl-A, Ctrl-E, etc.)
- **History search** with partial matching (type partial command, arrow up)

### ✅ CLI Toolkit ("Better Unix")
| Tool | Replaces | Command |
|------|----------|---------|
| `eza` | ls | `ls`, `ll`, `la`, `lt` |
| `bat` | cat | `cat` (aliased) |
| `ripgrep` | grep | `rg` |
| `fd` | find | `fd` |
| `fzf` | — | `Ctrl-R` (history), `Ctrl-T` (files) |
| `zoxide` | cd | `z <partial-path>` |
| `delta` | diff | Used automatically in git |
| `jq` | — | JSON processing |
| `yq` | — | YAML processing |
| `htop` | top | `top` (aliased), `htop` |
| `tree` | — | `tree` |

### ✅ Git & GitHub
- Git identity configured (Jeffery Garza / jefferyagarza@gmail.com)
- SSH key generated (Ed25519) and added to GitHub
- SSH key backed up in 1Password

### ✅ Dotfiles Repository
- Bare git repo at `~/.dotfiles`
- Remote: `git@github.com:ducksunderdoors/dotfiles.git`
- Currently tracking:
  - `~/.zshrc`
  - `~/.config/ghostty/config`

### ✅ Shell Plugins (via zinit)
- `zsh-autosuggestions` — Fish-like ghost suggestions (→ to accept)
- `zsh-syntax-highlighting` — Valid commands green, invalid red
- `zsh-completions` — Enhanced tab completions

---

## Dotfiles Workflow (Memorize This)

```bash
# 1. See what's changed
dotfiles status

# 2. Stage specific file(s)
dotfiles add ~/.zshrc
dotfiles add ~/.config/ghostty/config

# 3. Commit with descriptive message
dotfiles commit -m "Add zinit plugins for autosuggestions"

# 4. Push to GitHub
dotfiles push
```

### Common Patterns

```bash
# Add and commit in one flow
dotfiles add ~/.zshrc && dotfiles commit -m "Update zshrc"

# See recent commits
dotfiles log --oneline -10

# See what a file looked like before
dotfiles show HEAD~1:~/.zshrc

# Undo changes to a file (before committing)
dotfiles checkout -- ~/.zshrc
```

### Key Insight
The `dotfiles` command is just `git` with special flags:
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
Anything you can do with `git`, you can do with `dotfiles`.

---

## File Locations

| Config | Location |
|--------|----------|
| Shell config | `~/.zshrc` |
| Ghostty terminal | `~/.config/ghostty/config` |
| SSH keys | `~/.ssh/id_ed25519` (private), `~/.ssh/id_ed25519.pub` (public) |
| Git config | `~/.gitconfig` |
| Dotfiles repo | `~/.dotfiles` (bare repo) |
| zinit plugins | `~/.local/share/zinit/` |

---

## Tools Installed via Homebrew

```bash
# Verify with:
brew list
```

**Formulae:**
- bat, eza, fd, fzf, ripgrep, zoxide, delta
- jq, yq, tree, htop
- starship
- figlet, tlrc (pre-existing)

**Casks:**
- ghostty, aerospace, marta, warp (pre-existing)

---

## Key Shortcuts to Practice

### Shell (Zsh)
| Shortcut | Action |
|----------|--------|
| `Ctrl-R` | Fuzzy search command history (fzf) |
| `Ctrl-T` | Fuzzy find files (fzf) |
| `→` (right arrow) | Accept ghost suggestion |
| `↑` (after typing) | Search history for matching commands |
| `Ctrl-A` | Jump to start of line |
| `Ctrl-E` | Jump to end of line |
| `z <partial>` | Jump to frecent directory |

### Git/Dotfiles
| Command | Action |
|---------|--------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline -20` |

---

## What's Next: Phase 2 (Neovim + LazyVim)

### Goals
1. Install Neovim
2. Set up LazyVim (pre-configured Neovim distribution)
3. Configure LSPs for Python, Go, JavaScript/TypeScript
4. Install and learn LazyGit (TUI for git)
5. Build vim muscle memory (hjkl, motions, text objects)

### Philosophy Reminder
- **No AI assistance in Neovim** — Build fundamentals first
- VSCode/Cursor remain available for "get things done" mode
- LazyGit will become primary git interface (visual, keyboard-driven)

### Resources to Bookmark
- [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Vim Cheat Sheet](https://vim.rtorr.com/)

---

## Session Log

| Date | Phase | Accomplishments |
|------|-------|-----------------|
| Feb 6, 2025 | 1 | Initial setup: zshrc, CLI tools, Starship, git/SSH, dotfiles repo |
| Feb 7, 2025 | 1 | Fixed zinit config, completed Phase 1 |
| | 2 | *Next: Neovim + LazyVim* |

---

## Quick Reference: Restarting on a New Machine

If you ever need to bootstrap a fresh Mac:

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles (bare repo method)
git clone --bare git@github.com:ducksunderdoors/dotfiles.git $HOME/.dotfiles

# 3. Create temporary alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 4. Checkout files (this puts your configs in place)
dotfiles checkout

# 5. Hide untracked files
dotfiles config --local status.showUntrackedFiles no

# 6. Install tools
brew install starship ripgrep fd bat eza zoxide fzf delta jq yq tree htop

# 7. Install zinit (will auto-install plugins on first shell load)
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 8. Reload shell
source ~/.zshrc
```

---

*This document should be committed to your dotfiles repo for future reference.*
