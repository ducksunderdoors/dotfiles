# OmniWM — Replacing AeroSpace

> **Machines:** MacBook Air M1 (first), then MacBook Pro M3
> **Replaces:** AeroSpace, plus Sketchybar's workspace indicator and JankyBorders
> **Version at time of writing:** OmniWM v0.7.6 (Homebrew cask `omniwm`)
> **Started:** October 19, 2026

---

## Why Switch

| | AeroSpace | OmniWM |
|---|---|---|
| Layout | i3-style tiles / accordion | **Niri** scrolling columns *or* **Dwindle** BSP, per workspace |
| Config | `aerospace.toml`, hand-edited | `settings.toml` + a full Settings GUI; live reload |
| Workspace bar | needed Sketchybar + a plugin script | built in, click-to-focus, app icons per workspace |
| Focus border | needed JankyBorders | built in (`[borders]`) |
| Extras | — | Overview (all windows), command palette, scratchpads, window marks, Menu Anywhere, clipboard history |
| CLI | `aerospace` | `omniwmctl` (IPC off by default) |
| macOS | 13+ | **26 Tahoe+ only**, Apple Silicon only |
| SIP | stays on | stays on |
| License | MIT | GPL-2.0, signed + notarized |

What you give up: AeroSpace's letter workspaces (A–Z) and its binding modes. OmniWM workspaces are numbered (1–9 by default, more if you add them), which fits how you actually use workspaces 1–4.

**Niri vs Dwindle, in one line:** Niri lines windows up as columns on an endless strip you scroll through (2 visible at a time by default). Dwindle splits the screen in half again and again, which is closest to AeroSpace `tiles`. Switch a workspace with `Option + /` (after tuning) and keep whichever feels right; one-app-per-workspace looks the same in both.

---

## Before You Start

```bash
sw_vers -productVersion       # must be 26.x or later
```

If the Air is on macOS 15, either update to Tahoe first or keep AeroSpace for now; the rest of the agentic setup doesn't depend on the window manager.

OmniWM **refuses to manage windows while AeroSpace is running**, so AeroSpace has to go first.

---

## 1. Retire AeroSpace, Sketchybar's indicator, and borders

```bash
# Stop and remove AeroSpace (its config is already gone from the dotfiles repo;
# git history keeps a copy: dotfiles show HEAD~1:.config/aerospace/aerospace.toml)
osascript -e 'quit app "AeroSpace"'
brew uninstall --cask aerospace
mv ~/.config/aerospace ~/.config/aerospace.retired

# JankyBorders → OmniWM's own focus border
brew services stop borders 2>/dev/null; brew uninstall borders 2>/dev/null
mv ~/.config/borders ~/.config/borders.retired 2>/dev/null

# Sketchybar → OmniWM's workspace bar (recommended on 8 GB)
brew services stop sketchybar
mv ~/.config/sketchybar ~/.config/sketchybar.retired
```

Keeping Sketchybar is possible: its aerospace plugin will just stop updating. You'd rewrite it against `omniwmctl` subscriptions. On the Air, one bar is cheaper than two, so start with OmniWM's.

---

## 2. Install

```bash
brew install --cask omniwm      # also puts omniwmctl on PATH
```

Then the macOS side:

1. **System Settings → Desktop & Dock → Mission Control → "Displays have separate Spaces" ON** (the macOS default). Log out and back in if you had to change it.
2. Launch OmniWM. Grant **Accessibility** and **Input Monitoring**.
3. Screen Recording is optional — it powers Overview thumbnails. Grant it if you want Overview; skip it otherwise.
4. Click **Start OmniWM**.
5. Menu bar icon → Settings → General → **Start at Login**.
6. Keep **one native Space per display**; navigate with OmniWM workspaces.

---

## 3. Tune it (keeps AeroSpace muscle memory)

OmniWM writes a complete `~/.config/omniwm/settings.toml` on first launch. That file is strict: one missing key or duplicate hotkey rejects the whole thing. So the dotfiles don't ship a hand-written copy. Instead `omniwm-tune` changes values **in place** from `~/.config/omniwm/tune.conf`:

```bash
omniwm-tune            # dry run — prints each change
omniwm-tune --apply    # backs up settings.toml, writes it; OmniWM reloads instantly
```

What `tune.conf` changes:

| Action | OmniWM default | Tuned to | Why |
|---|---|---|---|
| Focus left/down/up/right | `Option + arrows` | `Option + H/J/K/L` | AeroSpace muscle memory |
| Move window | `Option + Shift + arrows` | `Option + Shift + H/J/K/L` | same |
| Toggle workspace layout | `Option + Shift + L` | `Option + /` | freed L; AeroSpace's layout key |
| Workspace back-and-forth | `Control + Option + Tab` | `Option + Tab` | AeroSpace `alt-tab` |
| Focus previous window | `Option + Tab` | `Control + Option + Tab` | swapped with the above |
| Move workspace to next monitor | unassigned | `Option + Shift + Tab` | AeroSpace `alt-shift-tab` |
| Toggle floating | unassigned | `Option + Shift + Space` | was AeroSpace service-mode `f` |
| Quake terminal | `Option + \`` | off | Ghostty's `Cmd + \`` quick terminal stays; saves memory |
| IPC (`omniwmctl`) | off | on | needed for scripting |
| Inner gap | 16 | 10 | matches the old AeroSpace gaps |

Unchanged defaults worth learning:

| Keys | Action |
|---|---|
| `Option + 1–9` / `Option + Shift + 1–9` | Switch to / move window to workspace (same as AeroSpace) |
| `Option + - / =` | Shrink / grow (same as AeroSpace) |
| `Option + Return` | Fullscreen the window within the layout |
| `Option + , / .` | Cycle window width presets (⅓, ½, ⅔) |
| `Option + T` | Tab the current column (Niri) |
| `Option + Shift + F` | Column takes the full width (Niri) |
| `Option + Shift + B` | Balance sizes |
| `Option + Shift + O` | Overview — every window, type to filter |
| `Control + Option + Space` | Command palette — windows, app menus, commands, apps, files |
| `Control + Option + M` | Menu Anywhere — the app's menu bar at your cursor |

Once it feels right, commit OmniWM's own file so the MacBook Pro gets it:

```bash
dotfiles add ~/.config/omniwm/settings.toml ~/.config/omniwm/tune.conf
dotfiles commit -m "Add OmniWM settings"
```

Two notes on tracking `settings.toml`: changing anything in the Settings window rewrites the file (keys reordered, comments dropped), so expect noisy diffs; and workspace-to-display assignments include display UUIDs, so the MBP may re-run the monitor assistant once.

---

## 4. How It Fits the Terminal Stack

| Layer | Owns | Keys |
|---|---|---|
| OmniWM | apps + workspaces | `Option + …` |
| Ghostty | the terminal window | `Cmd + …` |
| tmux | sessions / agent windows / panes | `Ctrl-a` prefix, `Ctrl-h/j/k/l` |
| Neovim | buffers / splits | `Space` leader |

No overlap: Ghostty doesn't treat Option as Alt (no `macos-option-as-alt` in your config), so `Option + H` never reaches tmux or Neovim anyway. That's also why the sesh shell picker lives on `Ctrl-G`, not `Alt-s`.

Suggested workspace layout on the Air (one app per workspace, as before):

| Workspace | App |
|---|---|
| 1 | Ghostty (tmux) |
| 2 | Browser |
| 3 | Notes / Obsidian |
| 4 | Comms |

Pin apps there with **App Rules** (menu bar icon → App Rules → focus the window → *New Rule from Focused Window* → *Assign to Workspace*).

---

## 5. Optional

- **Caps Lock as Hyper:** Settings → Keyboard Shortcuts → System Hyper Trigger → Caps Lock. Gives you a whole layer of free chords for later.
- **Workspace bar:** Settings → Workspace Bar → Position (over the menu bar, below it, bottom, left, right). "Hide empty workspaces" keeps it short.
- **Scratchpads:** bind *Toggle Scratchpad 1* + *Toggle Scratchpad 1 Assignment* to park something like Spotify or a notes window and summon it over any workspace.
- **tmux status from OmniWM:** with IPC on, `omniwmctl query` can feed the focused workspace into a tmux status segment. Not wired up yet — worth doing only if you miss it.

---

## 6. Rollback

```bash
osascript -e 'quit app "OmniWM"'; brew uninstall --cask omniwm
brew install --cask aerospace
mv ~/.config/aerospace.retired ~/.config/aerospace
mv ~/.config/sketchybar.retired ~/.config/sketchybar && brew services start sketchybar
# then add ~/.config/aerospace/aerospace.toml back to dotfiles if you're staying
```

---

## References

- Repo — https://github.com/OmniNull/OmniWM
- Docs — https://omniwm.app/guides/quick-start/
- Keyboard shortcuts — https://omniwm.app/guides/keyboard-shortcuts/
- Settings reference — https://omniwm.app/config/settings-reference/
- Known limitations — https://omniwm.app/help/known-limitations/
