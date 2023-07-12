# klebster2's vimrc

Ubuntu Setup
============

First clone repo to `~/.vim_runtime`:

```bash
git clone "https://github.com/klebster2/vimrc" ~/.vim_runtime && cd ~/.vim_runtime
```

Then run the installer

``` bash
./install_vimrc.sh
```

# Usage notes and Useful commands

To exit insert mode, use jk by using them together quickly.

### Completion menu (LSP / CMP)
To exit the complete menu use `<CTRL+y>`, also see the settings in ./nvim/lua/luasnip-config.lua

To jump to the next completion using Lsp / Cmp / Luasnip etc.. use
`<CTRL+p>` for prev and `<CTRL+n>` for next (in insert mode)

Use `gd` to jump (¿g-jump?) to the definition.

Also see `: help vim.lsp.*` for documentation on any of the LSP functions

#### LSP Doc Scrolling

When in insert mode with completions appearing (from {LSP, Snippets Engine, etc.} + cmp)
and the window to the right (showing the highlighted completion item) is available, you can also scroll the docs using
`<CTRL+f>` for forwards and `<CTRL+d>` for backward

e.g. these commands will work on this window if there is a scrollbar to the right-hand side.
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

To go to diagnostics use `<SPACE>+e` to open a floating window containing the LSP diagnostic (what smells bad according to the LSP)
To go to diagnostics use `<SPACE>+q` to open a floating window of LSP diagnostics
`[d` to go to the previous LSP diagnostic and `]d` to go to the next LSP diagnostic

Also see `: help vim.diagnostic.*` for documentation on any of the functions.

#### Copilot scrolling
According to the docs you can use Alt+] / Alt+[ to cycle through suggestions
