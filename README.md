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
  opts = {},
  config = function(_, opts)
    require("nvim-config").setup(opts)

    local local_config = vim.fn.stdpath("config") .. "/myvimrc.lua"
    if (vim.uv or vim.loop).fs_stat(local_config) then
      dofile(local_config)
    end
  end,
  priority = 1000,
},
```
