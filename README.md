# Vi Spell

Vietnamese spell for vim/neovim

## Install

### Vim

I ... don't know

### Lua

- Install
  ```lazy.lua
  -- lazy.lua
  ---@type LazySpec
  return {
  	"KevinNitroG/vi-spell.vim",
  	event = "VeryLazy",
  	config = true,
  }
  ```
- Default opts
  ```lua
  return {
  	toggle = {
  		filetypes = {
  			"markdown",
  			"text",
  		},
  		add = true,
  	},
  }
  ```

## Usage

> [!NOTE]
> <https://neovim.io/doc/user/spell.html>

```vim
set spelllang+=vi
```
