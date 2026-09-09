# agyy

Multi-account quota manager and wrapper for Google Antigravity (`agy`) and ACP editor runtimes.

When one account hits rate limits on Gemini or Claude, `agyy` swaps to one that still has quota and runs your command. It keeps CLI logins and ACP editor sessions in sync so your editor doesn't break when you rotate accounts in the terminal.

---

## Features

- **Automatic account rotation:** Checks live quotas before running `agy` and switches to whichever account has headroom.
- **CLI & ACP sync:** Keeps `~/.gemini/antigravity-cli` and `~/.gemini/antigravity-acp` tokens aligned on every swap and rotation, with SIGHUP reloads for running ACP servers.
- **Scope-aware switches:** Swap or save tokens for CLI only (`--cli`), ACP only (`--acp`), or both.
- **YOLO mode:** `agyy yolo true` keeps `--dangerously-skip-permissions` on so you don't get stopped by confirmation prompts on every step.
- **Continue mode:** `agyy continue true` passes `-c` by default so you don't lose session context across runs.
- **Live quota dashboard:** `agyy status` polls Google's model API to show actual usage percentages, accounts on cooldown, and exact reset countdowns.
- **Zero dependencies:** Written in Bash and standard-library Python 3.

---

## Installation

```bash
git clone https://github.com/Lakshrp112/agyy ~/.agy_toys
cd ~/.agy_toys
./agyy init
```

Run `source ~/.bashrc` (or restart your terminal) to load completion and PATH.

### Adding accounts

Log in with `agy` (or through your editor for ACP), then save the token under a nickname:

```bash
# Log in normally in your browser / CLI
agyy save work

# Log in with another account
agyy save personal
agyy save backup
```

If you logged into ACP in an editor and want to save that token directly:

```bash
agyy save work --acp
```

---

## Usage

Use `agyy` everywhere you would use `agy`:

```bash
# Runs agy with auto-account selection
agyy "fix the auth retry loop in client.go"

# Session continuation is supported
agyy -c

# Keep tools auto-approved
agyy yolo true

# Keep -c on by default
agyy continue true
```

---

## Commands

| Command | Arguments | Description |
| :--- | :--- | :--- |
| `agyy` | `[args...]` | Run `agy` with auto token selection |
| `agyy status` | `[name] [model]` | Show all accounts, model usage %, and cooldown countdowns |
| `agyy whoami` | `[--cli\|--acp] [-s]` | Print active profile name and sync state |
| `agyy swap` | `[name] [model] [--cli\|--acp]` | Manually switch active profile (for CLI, ACP, or both) |
| `agyy save` | `<name> [--cli\|--acp]` | Save current active login to the account pool |
| `agyy delete` | `<name> [-r] [-f]` | Remove profile (`-r` revokes token with Google) |
| `agyy sync` | — | Fetch fresh quota stats from Google |
| `agyy yolo` | `[true\|false\|status]` | Toggle or check auto-approval mode |
| `agyy continue` | `[true\|false\|status]` | Toggle or check default `-c` session continuation |
| `agyy clean` | `[chats\|acp\|all] [-f]` | Clear conversation history, logs, or ACP caches |
| `agyy reload-acp` | — | Send reload signal (SIGHUP) to running ACP processes |
| `agyy sync-skills` | — | Symlink `~/.agents/skills` to CLI skills directory |
| `agyy init` | — | Add PATH and bash completion to `~/.bashrc` |
| `agyy help` | — | Show usage summary |

---

## Status Dashboard

```
$ agyy status

  Antigravity Auth Pool | Active: work | ACP: synced | YOLO: ON | CONT: ON | Profiles: 3

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

## Configuration & Hooks

- `AUTH_DIR` (default: `~/.agy_toys/auth`): Directory storing saved token profiles and cache.
- `TARGET_AUTH` (default: `~/.gemini/antigravity-cli/antigravity-oauth-token`): Active CLI token file.
- `TARGET_ACP_AUTH` (default: `~/.gemini/antigravity-acp/acp_token.json`): Active ACP token file.
- `T3_USERDATA_DIR` (default: `~/.t3/userdata`): Base userdata folder for editor ACP instances.
- `ACP_RELOAD_CMD`: Optional shell command to run on profile swap (e.g. reload an editor workspace).
- `ACP_RELOAD_SIGNAL` (default: `HUP`): Signal sent to running ACP daemon processes when swapping.
- **Lifecycle hooks:** Executables placed in `~/.agy_toys/auth/hooks/on_swap` or `~/.agy_toys/auth/hooks/on_acp_reload` run automatically whenever profiles change.

---

## License

[MIT](LICENSE)
