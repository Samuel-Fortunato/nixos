# LaTeX Snippets

Custom LuaSnip snippets inspired by [Gilles Castel](https://castel.dev/post/lecture-notes-1/).

## Structure

| File | Purpose |
|---|---|
| `_helpers.lua` | Shared snippet builders and conditions |
| `math.lua` | Mathematical expressions and symbols |
| `greek.lua` | Greek letters |
| `environments.lua` | LaTeX environments |
| `structure.lua` | Document structure |
| `formatting.lua` | Text formatting |

`matrices.lua.disabled` and `physics.lua.disabled` are currently inactive.

## Loading

LuaSnip automatically loads all `.lua` files in this directory for the `tex` filetype.

Snippets are loaded lazily through `luasnip.loaders.from_lua`.

## Usage

- Math autosnippets expand only inside math mode.
- Text autosnippets expand outside math mode.
- Regular snippets are available through blink.cmp.
- VimTeX is used for math-zone detection when available.

Refer to the individual Lua files for the current triggers and expansions.
