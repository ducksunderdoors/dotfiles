# Agentic tmux — Setup & Daily-Driver Guide

> **Machine:** MacBook Air M1, 8 GB (couch computer / test bed)
> **Ports to:** MacBook Pro M3 (work) — minimal profile, see §9
> **User:** Jeffery Garza (@ducksunderdoors)
> **Philosophy:** Keyboard-centric, CLI/TUI-first, build on what's already there
> **Started:** October 19, 2026

---

## The Mental Model

| Layer | Tool | One of these per… |
|-------|------|-------------------|
| Desktop | OmniWM (see `~/docs/omniwm-setup.md`) | app (Ghostty lives on workspace 1) |
| Terminal | Ghostty | — |
| Session | **sesh** | project / repo |
| Window | **workmux** | task = git worktree + agent |
| Pane | tmux | agent \| shell |
| Float | **floax** | scratch work over anything |
| Horizon | **aven** | everything you intend to do |
| History | **atuin** | every command, searchable |

The one rule: **sesh owns sessions, workmux owns windows.** workmux runs in `window` mode, so every agent window lands inside its project's session.

```
Ghostty
└─ tmux
   ├─ session: learning-go          ← prefix T → "go"
   │   ├─ 1 zsh                      (you, in the main checkout)
   │   ├─ 2 wm-ch7-structs 🤖        ← wma ch7-structs -p "…"
   │   └─ 3 wm-ch7-tests ✅          ← finished; prefix A jumps here
   ├─ session: hackfluence
   ├─ session: tasks                 ← aven
   ├─ session: dotfiles              ← lazydotfiles
   └─ session: scratch               ← floax (hidden from the picker)
```

---

## What Changed in the Dotfiles

| File | Change |
|------|--------|
| `~/.tmux.conf` | Kept prefix, splits, h/j/k/l, H/J/K/L resize. Added sesh/workmux/aven bindings, TPM plugins, agent-friendly settings, Aura-coloured status bar at the top |
| `~/.zshrc` | New `AGENTIC STACK` section: atuin, workmux/aven aliases, `Ctrl-G` sesh picker; completions path |
| `~/.config/ghostty/config` | `ctrl+h/j/k/l` now `performable:` so they reach tmux/Neovim when there's no Ghostty split |
| `~/.config/workmux/config.yaml` | New |
| `~/.config/sesh/sesh.toml` | New |
| `~/.config/aven/config.yaml` | New |
| `~/.config/atuin/config.toml` | New |
| `~/.local/bin/agentic-setup` | New — installs dependencies, `--check` is read-only |
| `~/.config/aerospace/` | Removed — replaced by OmniWM |
| `~/.config/omniwm/tune.conf` + `~/.local/bin/omniwm-tune` | New — OmniWM keybindings tuned to AeroSpace muscle memory |
| `~/docs/omniwm-setup.md` | New — OmniWM install, tuning, rollback |
| `~/docs/agentic-tmux/` | This guide, Brewfile, templates |

### Keybinding conflicts resolved

| Wanted | Clashed with | Resolution |
|--------|-------------|------------|
| floax on `prefix p` | previous-window | floax on **`prefix f`** / menu `prefix F` |
| sesh last on `prefix L` | your resize-right | **`prefix b`** (back) |
| sesh widget on `Alt-s` | Option chords belong to the window manager | **`Ctrl-G`** |
| Ghostty `ctrl+hjkl` | vim-tmux-navigator | `performable:` — Ghostty acts only when it has a split to move to |
| catppuccin theme | your Ghostty `aura` theme | hand-written Aura status line, `bg=default` so the 0.85 opacity shows through |

---

## 1. Install

```bash
# 0. Look before touching anything
dotfiles pull
agentic-setup --check

# 1. Install deps (Brewfile, TPM + plugins, completions, atuin import, zoxide seed)
agentic-setup

# 2. Reload
exec zsh
tmux source-file ~/.tmux.conf      # inside tmux; or quit tmux and start fresh

# 3. Interactive bits
workmux setup                       # answer yes to the Nerd Font prompt
aven skill install
aven demo
```

If TPM plugins didn't install, press **`prefix I`** inside tmux.

Window manager: AeroSpace is replaced by OmniWM — follow `~/docs/omniwm-setup.md` (needs macOS 26+; `agentic-setup --check` tells you).

Agents, if missing:

```bash
curl -fsSL https://claude.ai/install.sh | bash   # Claude Code
npm i -g @openai/codex                           # Codex (or: mise use -g npm:@openai/codex)
```

---

## 2. Keymap

Prefix is **`Ctrl-a`**. Everything you already had still works.

### Sessions (sesh)

| Keys | Action |
|------|--------|
| `prefix T` | Session picker: `^t` tmux · `^g` configs · `^x` zoxide · `^f` find · `^d` kill |
| `Ctrl-G` | Same picker from any shell prompt, even outside tmux |
| `prefix b` | Back to last session |
| `prefix R` | Jump to the repo-root session |
| Picker aliases | `t` tasks · `dot` dotfiles · `go` learning-go |

### Agents (workmux)

| Keys | Action |
|------|--------|
| `prefix N` | New worktree + agent — prompt opens in Neovim, branch auto-named |
| `prefix A` | Jump to the agent that finished or needs input (repeat to cycle) |
| `prefix Tab` | Bounce between your two most recent agents |
| `prefix C-s` | Dashboard — this project |
| `prefix C-d` | Dashboard — every project |
| `prefix C-w` | Dashboard — worktrees tab |
| `prefix C-t` | Toggle the agent sidebar |

Dashboard: `1–9` jump · `p` peek · `i` type to agent · `d` diff (`Tab` WIP ↔ branch) · `a` stage hunks · `o` comment on hunk → agent · `m` merge · `q` quit

### Everything else

| Keys | Action |
|------|--------|
| `prefix f` / `prefix F` | floax floating pane / its menu (resize, fullscreen, embed) |
| `prefix t` | aven popup, scoped to the current repo |
| `prefix g` | lazygit popup |
| `Ctrl-h/j/k/l` | Move between panes **and** Neovim splits, no prefix |
| `prefix x` | Kill pane, no prompt |
| `prefix r` | Reload tmux.conf |
| `Ctrl-R` | atuin history search (press again to cycle global → host → session → directory → repo) |
| `↑` | Your existing prefix-match history search (unchanged) |

### Shell aliases

| Alias | Command |
|-------|---------|
| `wma name -p "…"` | `workmux add` |
| `wmA "…"` | `workmux add -A -p` (auto-names the branch) |
| `wml` / `wmd` | list / dashboard |
| `wmm` / `wmr` | merge / remove |
| `wmo name` | reopen a worktree's window |
| `wmcd name` | cd this shell into a worktree |
| `av` / `ava "…"` | aven / aven add |

---

## 3. The Daily Loop

**Morning — horizon (5 min).** `prefix T`, type `t`. aven opens on the **queue**, already ranked: Needs action → Focus → Soon → Triage → Blocked → Later. Triage the inbox (`s` status, `d` done), mark 1–3 tasks `active`.

**Pick a project.** `prefix T`, a few letters, Enter. The session is created if needed.

**Hand off work.** One worktree per task:

```bash
wma ch7-exercises -p "Work on GO-4KX2. Use aven for status and notes."
wmA "Add a --json flag to the recon CLI"
workmux add spike -l duel -p "Prototype the parser"     # Claude + Codex side by side
```

Each creates `~/.workmux/<project>/<name>`, copies `.env`, opens a `wm-*` window (agent left, shell right) and switches you there. Add `-b` to stay where you are.

**Supervise, don't babysit.** Window names show 🤖 working / 💬 waiting / ✅ done. Work in window 1 yourself; `prefix A` when something needs you.

**Review.** `prefix C-s` → pick the agent → `d`. Stage the good hunks (`a`, then `y`/`n`), send feedback on the rest (`o`).

**Land it.**
- Solo repo: `wmm` — rebases onto main, merges, deletes worktree + window + branch.
- PR repo: push + `gh pr create` from the agent's shell. After merge: `workmux rm --gone`.

**Close the loop.** If the repo has `aven prime` (§6), the agent already updated the task. Otherwise `prefix t` → `d`.

**End of day.** Nothing. tmux-continuum saves every 15 min and restores on next launch. After a crash: `workmux resurrect`.

---

## 4. Many Projects with sesh

- **Where projects come from:** live tmux sessions, `[[session]]` entries, and zoxide. Anything you `z` into regularly appears; `agentic-setup` pre-seeds `~/code/*`.
- **Add an alias** for every project you touch daily — `alias = "hf"`, `alias_auto_connect = true` — and two keystrokes land you there.
- **Kill freely.** `detach-on-destroy off` drops you into another session instead of out of tmux.
- **Don't** `sesh connect` into `~/.workmux/...` paths; you'd get a separate session. Use `wmo` or the dashboard.

---

## 5. Floax

`prefix f` floats a pane over whatever you're in; `prefix f` again hides it with state intact. It follows the current session's directory. Good for: a quick `git log`, `ava "…"` without leaving an agent, tailing a log, `wml --pr`. `prefix F` → *embed* promotes it to a real window.

---

## 6. Aven — Tasks, Agents, iPhone

**Model.** Workspace `personal` by default. Projects are inferred from the directory, so `prefix t` inside a repo is already scoped. Status: inbox → backlog → todo → active → done/canceled. Epics group, dependencies order, `available_at` defers, `due_on` sets deadlines. `aven doctor` explains what it resolved.

**Agents.** `aven skill install` is global and on-demand. For repos you actively track, merge `~/docs/agentic-tmux/templates/claude-settings-aven-prime.json` into `<repo>/.claude/settings.json` — every Claude session then starts with that project's active/ready/blocked tasks. Keep secrets out of task text; it syncs.

**Sync + iPhone.** The phone app *joins* a sync, so the Mac goes first. The Air sleeps, so don't host the server on it. Options:
- **Aven Cloud** (free preview, cloud.aventasks.dev) — easiest; end-to-end encrypted.
- **Self-host** `aven server` on your DigitalOcean box over Tailscale.

```bash
aven backup                          # always first
aven sync setup                      # grabs the aven-setup: invitation from the clipboard
aven config set sync.enabled true
aven daemon install                  # LaunchAgent: syncs on edit + every 30 s
aven sync invite                     # QR code, valid 10 min
```

App Store → **Aven Tasks** → join → scan. Phone captures land in the inbox; triage them in the morning. The server isn't a backup — keep running `aven backup`.

---

## 7. Living with 8 GB

| Rule | Why |
|------|-----|
| **Two agents at a time**, three max | Each Claude/Codex CLI is a Node process; it's the dev servers and installs beside them that swap |
| `--max-concurrent 2` for batch runs | Same reason |
| Quit OrbStack when not using it | It reserves memory even idle |
| No workmux sandbox on the Air | Container per agent is too heavy here — try it on the MBP |
| `workmux claude prune` monthly | Cleans dead worktree entries out of `~/.claude.json` |
| Watch `btop` the first week | Learn your real ceiling before trusting it |

---

## 8. Guardrails

- **Permissions.** The `cc-yolo` / `cod-yolo` profiles are commented out. Only enable them together with `sandbox: { enabled: true }` (MBP). Meanwhile the symlinked `.claude/settings.local.json` means you approve a permission once per repo, not once per worktree — add it to `~/.gitignore_global`.
- **Ports.** Two worktrees running the same dev server collide; see "Port conflicts" in the workmux README for the `.env.local` recipe.

---

## 9. Porting to the Work MacBook Pro

```bash
dotfiles pull
agentic-setup --check
agentic-setup --minimal        # everything except aven
```

Decide before going further:

- **Tasks.** Don't sync work tasks to a personal Aven account without checking VulnCheck policy on third-party services. Options: no aven at work · local-only (`sync.enabled: false`) · a `work` workspace route on `~/work` synced to a server work approves.
- **History.** atuin sync stays off across the personal/work line.
- **Agent configs.** The MBP already keeps isolated config dirs per agent. Point workmux at them with structured profiles instead of juggling logins:

  ```yaml
  # ~/.config/workmux/config.yaml (MBP)
  agents:
    cc-work:
      type: claude
      command: claude
      env:
        CLAUDE_CONFIG_DIR: ~/.claude-work
  ```
- **Git identity.** Your `includeIf "gitdir:~/work/"` covers worktrees only if they live under `~/work/` — set `worktree_dir: '~/work/.workmux/{project}'` on the MBP.
- **Window manager.** OmniWM is a resident app with Accessibility + Input Monitoring access — check it's allowed on work hardware before installing. If not, the terminal stack works the same without it.
- **Sandbox.** The MBP has the RAM for `sandbox.enabled: true` with OrbStack — that's when the yolo profiles become reasonable.

---

## Dotfiles Workflow for This Change

```bash
dotfiles status
dotfiles add ~/.tmux.conf ~/.zshrc ~/.config/ghostty/config \
  ~/.config/workmux ~/.config/sesh ~/.config/aven ~/.config/atuin \
  ~/.local/bin/agentic-setup ~/docs/agentic-tmux
dotfiles commit -m "Add agentic tmux stack"
dotfiles push
```

Or `lazydotfiles` and stage visually.

---

## References

- workmux — https://github.com/raine/workmux
- aven — https://aventasks.dev/getting-started/
- sesh — https://github.com/joshmedeski/sesh
- tmux-floax — https://github.com/omerxx/tmux-floax

---

## Session Log

| Date | Accomplishments |
|------|-----------------|
| Oct 19, 2026 | Designed stack; merged into existing dotfiles; Air test bed |
| Oct 19, 2026 | Swapped AeroSpace (+ Sketchybar indicator, borders) for OmniWM |
| | *Next: first week on the Air, then §9 on the MBP* |
