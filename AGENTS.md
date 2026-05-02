# Agent Instructions

## Repo Context

- This is a personal Neovim configuration repo. It is also designed to be consumed as a lazy.nvim plugin via `import = "plugins"` and `require("nvim-config").setup(opts)`.
- `lua/nvim-config.lua` is the plugin entrypoint; it currently just loads `lua/init.lua`.
- `lua/init.lua` owns broad Neovim defaults, global options, built-in plugin setup, and loads `lua/config/*.lua` modules at the end.
- `lua/plugins/*.lua` files are lazy.nvim plugin specs. Most specs return a single table and often use `version = false` to track plugin HEAD.
- `lua/config/*.lua` contains focused config modules loaded by `lua/init.lua`.
- `lua/utils/*.lua` contains shared helpers; `_G.utils` is initialized in `lua/init.lua` for selected runtime helpers.
- `plugin/*.lua` contains normal runtime plugin scripts and user commands loaded by Neovim.
- `after/ftplugin/*.lua` contains filetype-local tweaks. Prefer `vim.opt_local` and buffer-local keymaps there.
- `.nvim.lua` is project-local config for this repo and currently enables Stylua through ALE on save.

## Working Rules

- Before changing Neovim plugin configuration, inspect the plugin's local help/docs or source to confirm the supported options, events, and APIs. Do not guess from memory when the plugin provides help files, README docs, or installed Lua source.
- Installed plugin sources are typically under `~/.local/share/nvim/lazy/<plugin>/`. Check local `doc/`, README files, and Lua source before changing options, events, styles, or key/action names.
- Prefer the smallest correct change and preserve the existing config style.
- Keep plugin-specific behavior in that plugin's spec when possible. Put broad editor behavior in `lua/init.lua` or `lua/config/*.lua`, and filetype-only behavior in `after/ftplugin/*.lua`.
- Be careful with option scope. Use plugin-provided style/window config when available; otherwise use `vim.opt_local`, `vim.bo`, or `vim.wo` according to whether the option is buffer-local or window-local.
- Avoid introducing compatibility layers or abstractions unless there is a concrete persisted/external compatibility need.
- Do not rewrite personal wording/comments unless necessary for the requested change.

## Style

- Lua formatting follows `stylua.toml`: 2-space indents, Unix line endings, 120 column width, and double quotes preferred when Stylua has a choice.
- Prefer direct Lua tables and small local helpers over broad framework-style abstractions.
- Keep comments brief and only when they explain non-obvious behavior or a temporary workaround.

## Verification

- After Lua edits, run `stylua` on touched Lua files when available.
- For plugin config changes, if feasible, verify by starting Neovim or checking the relevant plugin module loads without errors.
- If a change relies on plugin behavior, mention the local docs/source location that confirmed it when summarizing the work.
