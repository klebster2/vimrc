# klebster2's vimrc

Ubuntu Setup
============

First clone repo to `~/.config/nvim`:

```bash
mkdir -pv ~/.config && git clone "https://github.com/klebster2/vimrc" ~/.config/nvim && cd ~/.config/nvim && ./install.sh
```

# Usage notes and Useful commands

To exit insert mode, use `jk` by using them together quickly.

### Completion menu (LSP / CMP)
To exit the complete menu use `<CTRL+y>`, also see the settings in ./nvim/lua/luasnip-config.lua

To jump to the next completion using Lsp / Cmp / Luasnip etc.. use

`<CTRL+p>` for prev and

`<CTRL+n>` for next (in insert mode)

Use `gd` for 'j' to jump to the definition.

Also see `: help vim.lsp.*` for documentation on any of the LSP functions

### Luasnip

Use

`CTRL+k` after selecting a luasnip option to jump to the next snippet (where you can enter code)

`CTRL+j` to jump to the previous snippet


#### NvimTree

Use

`<R>` (refresh) to perform a reread of the files contained in the project.

`<H>` (hide) to hide/display hidden files and folders (beginning with a dot .)

`<E>` (expand_all) to expand the entire file tree starting from the root folder (workspace)

`<W>` (collapse_all) to close all open folders starting from the root folder

`-` (dir_up) allows you to go back up folders. This navigation also allows you to exit the root folder (workspace) to your home directory

`<\s>` (system) to open the file with the system application set by default for that file type

`<f>` (find) to open the interactive file search to which search filters can be applied

`<SHIFT+f>` to close the interactive search

`<CTRL+k>` to display information about the file such as size, creation date, etc.

`g + ?` to open the help with all the predefined shortcuts for quick reference

`q` to close the file explorer


#### Nvim Spell:

`<z+w>` to add a word to the dictionary.

`<leader>ss` to set spell (misspelled words will appear underlined)

#### LSP Doc Scrolling

When in insert mode with completions appearing (from {LSP, Snippets Engine, etc.} + cmp)

and the window to the right (showing the highlighted completion item) is available, you can also scroll the docs using

`<CTRL+f>` for forwards and `<CTRL+d>` for backward

These commands will work on this window if there is a scrollbar to the right-hand side.

```
cmp.ItemField
╭╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╮
│unknown                 │
│────────────────────────│
│(field) cmp.ItemField: {│
│    Abbr: unknown,      │
│    Kind: unknown,      │
╰╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╯
```

### LSP Diagnostics

When in normal mode, the LSP will have already run and will be highlighting areas of code syntax.

To go to diagnostics use `<SPACE>+e` to open a floating window containing the LSP diagnostic (according to the LSP)

To go to diagnostics use `<SPACE>+q` to open a floating window of LSP diagnostics

While in normal mode use `[d` to go to the previous LSP diagnostic and `]d` to go to the next LSP diagnostic

Also see `: help vim.diagnostic.*` for documentation on any of the functions.

#### Copilot scrolling

According to the docs you can use Alt+] / Alt+[ to cycle through suggestions.

#### More mappings

Go to `./nvim/lua/keymappings.lua` for the basic set of mappings (with the current configuration, you can use `<leader>m`).
