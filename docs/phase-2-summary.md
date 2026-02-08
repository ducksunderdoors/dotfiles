# MacBook Pro Setup - Phase 2 Summary

> **Machine:** 17" MacBook Pro (Apple Silicon M1/M2)
> **User:** Jeffery Garza (@ducksunderdoors)
> **Philosophy:** Keyboard-centric, CLI/TUI-first, mastery before experimentation
> **Phase 2 Completed:** February 8, 2026

---

## What Was Accomplished

### ✅ Neovim + LazyVim

- **Neovim** installed via Homebrew (v0.10+)
- **LazyVim** starter template configured
- Config location: `~/.config/nvim/`
- All configs tracked in dotfiles repo

### ✅ Language Server Protocol (LSP) Setup

| Language | LSP Server | Formatter | Linter | Status |
|----------|------------|-----------|--------|--------|
| Python | pyright | ruff | ruff | ✅ Working |
| Go | gopls | gofumpt, goimports | golangci-lint | ✅ Working |
| TypeScript/JS | vtsls | stylua | — | ✅ Working |
| Lua | lua-language-server | stylua | — | ✅ Working |

### ✅ Runtime Version Manager (mise)

Installed and configured:
```bash
python3 --version  # Python 3.12.12
go version         # go1.25.7 darwin/arm64
node --version     # v20.20.0
```

Global versions set in `~/.config/mise/config.toml`

### ✅ LazyVim Extras Enabled

- `lang.python`
- `lang.go`
- `lang.typescript`
- `lang.git`

### ✅ LazyGit Integration

- Standalone TUI: `lazygit`
- Dotfiles alias: `lazydotfiles`
- Neovim integration: `<Space>gg`

---

## Neovim Survival Guide

### Modes

| Mode | Enter With | Purpose |
|------|------------|---------|
| Normal | `Esc` | Navigate, commands |
| Insert | `i` | Type text |
| Visual | `v` | Select text |
| Command | `:` | Run commands |

### Essential Commands

| Command | Action |
|---------|--------|
| `:w` | Save file |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:qa` | Quit all buffers |
| `:e <file>` | Open/create file |

### LazyVim Keybindings (Leader = Space)

| Binding | Action |
|---------|--------|
| `<Space>` | Open which-key (shows all mappings) |
| `<Space>ff` | Find files (Telescope) |
| `<Space>fg` | Live grep (search in files) |
| `<Space>fb` | Browse buffers |
| `<Space>e` | File explorer (neo-tree) |
| `<Space>gg` | Open LazyGit |
| `<Space>l` | Lazy plugin manager |
| `<Space>cm` | Mason (LSP installer) |

### Basic Motions (Practice These!)

| Motion | Action |
|--------|--------|
| `h j k l` | Left, Down, Up, Right |
| `w` | Next word |
| `b` | Previous word |
| `0` | Start of line |
| `$` | End of line |
| `gg` | Top of file |
| `G` | Bottom of file |
| `{` `}` | Previous/next paragraph |

### Text Objects (The Power of Vim)

| Command | Action |
|---------|--------|
| `ciw` | Change inside word |
| `ci"` | Change inside quotes |
| `ci(` | Change inside parentheses |
| `ca{` | Change around braces |
| `diw` | Delete inside word |
| `yiw` | Yank (copy) inside word |

---

## LazyGit Quick Reference

### Launching

```bash
# For normal repos
cd ~/code/myproject
lazygit

# For dotfiles (bare repo)
lazydotfiles

# From inside Neovim
<Space>gg
```

### Key Bindings

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all |
| `c` | Commit |
| `C` | Commit with editor |
| `P` | Push |
| `p` | Pull |
| `?` | Show all keybindings |
| `q` | Quit |
| `[` `]` | Navigate between panels |
| `j` `k` | Navigate within panel |

### Panels

```
[1]-Status      — Current branch, sync status
[2]-Files       — Changed files
[3]-Branches    — Local/remote branches
[4]-Commits     — Commit history
[5]-Stash       — Stashed changes
```

---

## File Locations (Updated)

| Config | Location |
|--------|----------|
| Neovim config | `~/.config/nvim/` |
| LazyVim extras | `~/.config/nvim/lazyvim.json` |
| Plugin lock file | `~/.config/nvim/lazy-lock.json` |
| mise config | `~/.local/share/mise/` |
| mise shims | `~/.local/share/mise/shims/` |

---

## Go Project Structure Note

Go requires a module structure. Don't create loose `.go` files:

```bash
# Wrong
nvim ~/test.go  # gopls will complain

# Right
mkdir -p ~/code/myproject
cd ~/code/myproject
go mod init myproject
nvim main.go  # gopls works perfectly
```

---

## Dotfiles Commit Log (Phase 2)

```
3be7b782 Add lazydotfiles alias for LazyGit
d9d311c0 Add LazyVim config with Python, Go, TypeScript extras
19797b83 Enable mise runtime manager
a25770ae Add Phase 1 setup documentation
fda4f630 Add zinit plugins: autosuggestions, syntax-highlighting
c6a616e3 Initial commit: zshrc and ghostty config
```

---

## What's Next: Phase 3

### Infrastructure & Containers
- [ ] OrbStack (Docker alternative, lighter weight)
- [ ] lazydocker (TUI for container management)
- [ ] Local PostgreSQL + pgcli

### Terminal Multiplexing
- [ ] tmux setup and configuration
- [ ] Session management
- [ ] Neovim + tmux integration

### Git Configuration
- [ ] `~/.gitconfig` optimization
- [ ] Delta as git pager (pretty diffs)
- [ ] Global `.gitignore`

---

## Practice Exercises

### Vim Fundamentals (Do These Daily)

1. **Motion practice:** Open any file, navigate using only `hjkl`, `w`, `b`, `0`, `$`
2. **Text objects:** Find a word, try `ciw`, `diw`, `yiw`
3. **Search:** Press `/`, type a word, press `n` to find next
4. **File navigation:** Use `<Space>ff` to fuzzy find files

### LazyGit Practice

1. Edit your `.zshrc` (add a comment)
2. Open `lazydotfiles`
3. Stage, commit, push — all without leaving LazyGit

---

## Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/)
- [LazyGit GitHub](https://github.com/jesseduffield/lazygit)
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [ThePrimeagen's Vim Playlist](https://www.youtube.com/playlist?list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R)

---

## Session Log

| Date | Phase | Accomplishments |
|------|-------|-----------------|
| Feb 6, 2026 | 1 | Shell foundation, CLI tools, dotfiles repo |
| Feb 7, 2026 | 1 | Completed zinit, Phase 1 done |
| Feb 7-8, 2026 | 2 | Neovim, LazyVim, LSPs, mise, LazyGit |
| | 3 | *Next: OrbStack, tmux, Postgres* |

---

*This document lives in `~/docs/` and is tracked in the dotfiles repo.*
