# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A cross-platform dotfiles repo (macOS, WSL, Windows) managed with GNU Stow. Each top-level directory is a Stow package whose internal structure mirrors `$HOME`, so Stow creates matching symlinks.

**Packages:**
- `ghostty/` — Ghostty terminal config (macOS only)
- `nvim/` — Neovim config (kickstart.nvim-based)
- `zsh/` — Zsh shell config
- `agent-guards/` — `agent-repo-guard`, a PreToolUse hook shared by Claude Code (`~/.claude-work/settings.json`) and Codex (`~/.codex/config.toml`). Repos under the folders in `.config/agent-repo-guard/protected-roots` get read-only git, no alembic/proto commands, and no agent files (CLAUDE.md, AGENTS.md, .claude/, .codex/) inside the repo

## Stow Workflow

Install a package (run from repo root):
```sh
stow ghostty      # symlinks ghostty/.config/ghostty → ~/.config/ghostty
stow nvim         # symlinks nvim/.config/nvim → ~/.config/nvim
stow zsh          # symlinks zsh/.zshrc → ~/.zshrc
stow -D ghostty   # remove symlinks for a package
stow -R ghostty   # restow (remove + re-add)
```

When adding new config files, place them inside the package directory mirroring their `$HOME` path. For example, a file that should live at `~/.config/foo/bar.conf` goes at `ghostty/.config/foo/bar.conf`.

## Neovim Config

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). The entire config lives in `nvim/.config/nvim/init.lua` as a single-file setup managed by lazy.nvim.

**Plugin manager:** `:Lazy` — check status, update, install  
**LSP/tool installer:** `:Mason` — manage language servers and formatters  
**Formatter:** stylua (via conform.nvim) — format Lua with `<leader>f`; config in `.stylua.toml`

**Adding plugins:** Either inline in `init.lua` or via `lua/custom/plugins/init.lua` (return a LazySpec table). Uncomment the `{ import = 'custom.plugins' }` line in `init.lua` to activate custom plugins.

**Enabling optional kickstart plugins:** Uncomment the relevant `require 'kickstart.plugins.<name>'` lines near the bottom of `init.lua`. Available: `debug`, `indent_line`, `lint`, `autopairs`, `neo-tree`, `gitsigns`.

**Key leader bindings (leader = Space):**
- `<leader>sf` / `<leader>sg` — Telescope file/grep search
- `<leader>f` — format buffer
- `<leader>sh` — search help tags
- `<leader><leader>` — list open buffers
- `<leader>q` — open diagnostic quickfix

**Nerd Font:** `vim.g.have_nerd_font = false` in `init.lua` — set to `true` if a Nerd Font is active in the terminal.

## Zsh Config

`zsh/.zshrc` uses OS detection to load platform-specific paths:
- Linux (WSL/Ubuntu): loads nvm and bun from `~/.local/bin`, `~/.nvm`, `~/.bun`
- macOS: loads nvm and bun from standard locations
- oh-my-posh prompt (if installed) and zsh-autosuggestions are loaded conditionally

## Platform Notes

The `.zshrc` and Neovim config are designed to work on macOS and WSL without modification. Ghostty config is macOS-only. When adding new config, use conditional checks (`$OSTYPE`) for platform-specific settings rather than separate files.
