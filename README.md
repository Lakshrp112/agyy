# agyy

Multi-account quota rotater and wrapper for Google Antigravity CLI (`agy`).

Swaps OAuth tokens automatically when you hit rate limits and lets you toggle `--dangerously-skip-permissions` globally.

---

## Features

- **Auto-rotate on limit:** Checks quota across all saved accounts before running and picks whichever has room.
- **Pass-through wrapper:** Runs `agy` transparently with your passed arguments (`agyy "build a snake game"`, `agyy -c`, etc.).
- **YOLO mode:** `agyy yolo true` keeps `--dangerously-skip-permissions` on so you aren't clicking approval prompts every command.
- **Status dashboard:** `agyy status` shows usage percentages and reset countdowns across your account pool.
- **No extra dependencies:** Pure bash using standard tools.

---

## Setup

```bash
git clone https://github.com/Lakshrp112/agyy ~/.agy_toys
cd ~/.agy_toys
./agyy init
```

Reload your shell or run `source ~/.bashrc`.

### Adding accounts

Log in with `agy`, then save the token under a name:

```bash
agyy save work
# log in with another account in agy
agyy save personal
agyy save backup
```

### Usage

Use `agyy` in place of `agy`:

```bash
agyy "fix the bug in auth.py"
agyy yolo true
agyy
```

---

## Commands

| Command | Arguments | Description |
| :--- | :--- | :--- |
| `agyy` | `[args...]` | Runs `agy` with auto token selection |
| `agyy status` | `[name] [gemini\|claude]` | Show accounts, usage, and reset timers |
| `agyy whoami` | — | Show active profile |
| `agyy swap` | `[name] [gemini\|claude]` | Manually switch active account or model |
| `agyy save` | `<name>` | Save current login token to pool |
| `agyy delete` | `<name> [-r] [-f]` | Delete a profile (`-r` revokes on Google) |
| `agyy sync` | — | Refresh quota data from Google |
| `agyy yolo` | `[true\|false\|status]` | Toggle or set auto-approve permissions |
| `agyy clean` | `[chats\|all] [-f]` | Wipe CLI chat cache / state |
| `agyy sync-skills` | — | Symlink `~/.agents/skills` to CLI skills folder |
| `agyy init` | — | Add PATH & completion to `~/.bashrc` |
| `agyy help` | — | Show help |

---

## Status output

```
$ agyy status

  Antigravity Auth Pool | Active: work | YOLO: ON | Profiles: 3

     AUTH                 MODEL    USAGE                         LEFT        COOLDOWN
  --------------------------------------------------------------------------------------------
  ●  work (active)        Gemini   [                    ] 000%   100 / 100   READY
                          Claude   [####                ] 020%   080 / 100   READY

     personal             Gemini   [####################] 100%   000 / 100   03h21m45s
                          Claude   [##########          ] 050%   050 / 100   READY

     backup               Gemini   [                    ] 000%   100 / 100   READY
                          Claude   [                    ] 000%   100 / 100   READY
```

---

## Environment variables

- `AUTH_DIR` (default: `~/.agy_toys/auth`): Where token profiles and quota caches are stored.
- `TARGET_AUTH` (default: `~/.gemini/antigravity-cli/antigravity-oauth-token`): Where the active token is copied.

---

## License

[MIT](LICENSE)
