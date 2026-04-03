# nvim-config

My personal neovim configuration.  It's actually sourced from my private
dotfiles via (chezmoi)[https://www.chezmoi.io/]

## Lazy.nvim Usage

This repo is designed to be consumed as a lazy.nvim plugin with `opts = {}`.

```lua
{
  "amadeus/nvim-config",
  branch = "main",
  import = "plugins",
  main = "nvim-config",
  opts = {},
  priority = 1000,
}
```
