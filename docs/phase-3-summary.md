# MacBook Pro Setup - Phase 3 Summary

> **Machine:** 17" MacBook Pro (Apple Silicon M1/M2)
> **User:** Jeffery Garza (@ducksunderdoors)
> **Philosophy:** Keyboard-centric, CLI/TUI-first, mastery before experimentation
> **Phase 3 Completed:** February 9, 2026

---

## What Was Accomplished

### ✅ Container Infrastructure

| Tool | Purpose | Status |
|------|---------|--------|
| OrbStack | Docker runtime (lighter than Docker Desktop) | ✅ Installed |
| lazydocker | TUI for container management | ✅ Installed |
| Docker CLI | Container commands | ✅ Working |

### ✅ PostgreSQL Development Database

Running as a Docker container with persistent storage:

```bash
# Container details
Name: postgres
Image: postgres:16
User: jeffery
Password: localdev
Database: devdb
Port: 5432
Volume: postgres_data (persists across restarts)
```

### ✅ Database Clients

| Tool | Purpose | Status |
|------|---------|--------|
| pgcli | Beautiful CLI with autocomplete | ✅ Working |
| LazySQL | TUI database explorer | ⚠️ Alpha (installed, revisit later) |

### ✅ tmux Terminal Multiplexer

Configured with sensible defaults for keyboard-centric workflow.

### ✅ Git Configuration

- Delta as pager (beautiful diffs)
- Global gitignore (no more `.DS_Store` commits)
- Side-by-side diffs with line numbers

---

## Container Workflow

### Daily Commands

```bash
# Check running containers
docker ps

# Start Postgres (if stopped)
docker start postgres

# Stop Postgres
docker stop postgres

# View all containers (including stopped)
docker ps -a

# Visual container management
lazydocker
```

### Connect to Database

```bash
# Using alias (recommended)
pg

# Or full command
pgcli -h localhost -U jeffery -d devdb
# Password: localdev
```

### Container Lifecycle

```bash
# Remove container (data preserved in volume)
docker rm postgres

# Recreate with same volume (data intact)
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=localdev \
  -e POSTGRES_USER=jeffery \
  -e POSTGRES_DB=devdb \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:16

# Nuclear option: delete everything including data
docker rm postgres
docker volume rm postgres_data
```

---

## tmux Quick Reference

### Concepts

| Term | What It Is | Analogy |
|------|------------|---------|
| Session | Container for everything | A workspace |
| Window | A tab within a session | Browser tab |
| Pane | A split within a window | Split view |

### Prefix Key: `Ctrl-a`

All tmux commands start with the prefix. Press `Ctrl-a`, release, then press the next key.

### Session Management

```bash
# From shell
tmux                          # New session
tmux new -s myproject         # New named session
tmux ls                       # List sessions
tmux attach -t myproject      # Attach to session
tmux kill-session -t myproject # Kill session
```

| Keys | Action |
|------|--------|
| `Ctrl-a d` | Detach from session |

### Window Management

| Keys | Action |
|------|--------|
| `Ctrl-a c` | New window |
| `Ctrl-a n` | Next window |
| `Ctrl-a p` | Previous window |
| `Ctrl-a w` | List windows |
| `Ctrl-a ,` | Rename window |
| `Ctrl-a &` | Kill window |

### Pane Management

| Keys | Action |
|------|--------|
| `Ctrl-a |` | Split vertical |
| `Ctrl-a -` | Split horizontal |
| `Ctrl-a h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl-a x` | Kill pane |
| `Ctrl-a z` | Toggle pane zoom (fullscreen) |

### Copy Mode (Vi-style)

| Keys | Action |
|------|--------|
| `Ctrl-a [` | Enter copy mode |
| `q` | Exit copy mode |
| `h/j/k/l` | Navigate |
| `Space` | Start selection |
| `Enter` | Copy selection |
| `Ctrl-a ]` | Paste |

---

## tmux Configuration

Location: `~/.tmux.conf`

```bash
# Reload config without restarting tmux
tmux source-file ~/.tmux.conf
```

### What's Configured

| Setting | Value | Why |
|---------|-------|-----|
| Prefix | `Ctrl-a` | Easier than `Ctrl-b`, one-handed |
| Pane navigation | `h/j/k/l` | Vim muscle memory |
| Pane splits | `|` and `-` | Visual mnemonics |
| Base index | 1 | Windows start at 1, matches keyboard |
| History limit | 10,000 lines | Generous scrollback |
| Mouse | Enabled | Scroll support |
| Escape time | 0 | No delay for Neovim |
| Copy mode | Vi keys | Consistency |

---

## Git Configuration

### Delta Pager

Location: `~/.gitconfig`

Delta provides:
- Syntax highlighting in diffs
- Side-by-side view
- Line numbers
- Navigate between files with `n`/`N`

### Global Gitignore

Location: `~/.gitignore_global`

Ignores across all repos:
- `.DS_Store` (macOS)
- `*.swp`, `*.swo` (Vim swap files)
- `.idea/`, `.vscode/` (IDE folders)
- `.env`, `.env.local` (secrets)
- `node_modules/`, `__pycache__/` (dependencies)

---

## File Locations

| Config | Location |
|--------|----------|
| tmux config | `~/.tmux.conf` |
| Git config | `~/.gitconfig` |
| Global gitignore | `~/.gitignore_global` |

---

## Aliases Added (in .zshrc)

```bash
# Database
alias pg='pgcli -h localhost -U jeffery -d devdb'

# Already existed
alias lazydotfiles='lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

---

## Dotfiles Commit Log (Phase 3)

```
xxxxxxx Add gitconfig with delta and global gitignore
06dac7f Add TMUX & More Ergonomic base configuration
63bf0d9 Add pg alias for localdev Postgres connection
```

---

## Inspiration & Resources

### Josh Medeski

Keyboard-centric workflow inspiration:
- Website: https://www.joshmedeski.com/
- GitHub: https://github.com/joshmedeski
- Dev Workflow Guide: https://www.joshmedeski.com/guides/dev-workflow-intro/

### tmux Book

Currently reading: **TMUX2: Productive Mouse-Free Development**

Key takeaway implemented: Remap Caps Lock → Ctrl for ergonomics

---

## What's Next: Phase 4 Ideas

### Polish & Integration
- [ ] Neovim + tmux seamless navigation (vim-tmux-navigator)
- [ ] tmux session management (tmuxinator or custom scripts)
- [ ] Starship prompt tweaks

### Advanced Workflows
- [ ] Multiple development databases
- [ ] Docker Compose for project stacks
- [ ] SSH + tmux persistence patterns

### Learning & Practice
- [ ] Daily vim motions practice
- [ ] tmux muscle memory drills
- [ ] First real project using full stack

---

## Session Log

| Date | Phase | Accomplishments |
|------|-------|-----------------|
| Feb 6-7, 2026 | 1 | Shell foundation, CLI tools, dotfiles repo |
| Feb 7-8, 2026 | 2 | Neovim, LazyVim, LSPs, mise, LazyGit |
| Feb 8-9, 2026 | 3 | OrbStack, PostgreSQL, tmux, git config |
| | 4 | *Next: Polish, integration, real projects* |

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────┐
│  DAILY STARTUP                                          │
├─────────────────────────────────────────────────────────┤
│  docker start postgres     # Start database             │
│  tmux attach -t DEV        # Attach to session          │
│  pg                        # Connect to Postgres        │
│  lazydocker                # Container TUI              │
│  lazydotfiles              # Dotfiles git TUI           │
├─────────────────────────────────────────────────────────┤
│  TMUX (prefix: Ctrl-a)                                  │
├─────────────────────────────────────────────────────────┤
│  |     Split vertical      -     Split horizontal       │
│  hjkl  Navigate panes      d     Detach session         │
│  c     New window          n/p   Next/prev window       │
│  z     Zoom pane           x     Kill pane              │
├─────────────────────────────────────────────────────────┤
│  NEOVIM (leader: Space)                                 │
├─────────────────────────────────────────────────────────┤
│  ff    Find files          fg    Live grep              │
│  e     File explorer       gg    LazyGit                │
└─────────────────────────────────────────────────────────┘
```

---

*This document lives in `~/docs/` and is tracked in the dotfiles repo.*
