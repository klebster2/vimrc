# klebster2's vimrc

# Table of Contents
- [Setup](#setup)
   - [Ubuntu](#ubuntu)
- [Usage notes and Useful commands](#usage-notes-and-useful-commands)
   - [Useful commands](#useful-commands)
      - [Completion Menu Lsp and Cmp](#completion-menu-for-lsp-and-cmp)
         - [Completion Docs](#completion-docs)
         - [LSP Diagnostics](#lsp-diagnostics)
      - [Luasnip](#luasnip)
      - [NvimTree](#nvimtree)
      - [Nvim Spell](#nvim-spell)
   - [Finally](#finally)


# Setup

## Ubuntu

1. Install the following packages (via `apt`, `apt-get`, `snap` or another package manager of your choosing)

- [`jq`](https://jqlang.github.io/jq/) For querying json files.
- [`curl`](https://curl.se/) For downloading installation files
- [`npm`](https://www.npmjs.com/) (node package manager)

To install all the dependencies, you can usually run:

```bash
apt-get install jq curl -y
curl -fsSL https://fnm.vercel.app/install | bash && . ~/.bashrc && fnm use --install-if-missing 20
```

Use `sudo` with `apt-get` if you are not root.

2. Next, clone repo to `~/.config/nvim`, and run the install script:

Clone the repo to `~/.config/nvim`
```bash
mkdir -pv ~/.config && git clone "https://github.com/klebster2/vimrc" ~/.config/nvim
```

Run the installation script [`install.sh`](./install.sh)
```bash
pushd ~/.config/nvim && ./install.sh && popd
```

3. Enjoy!
That's it for now. Enjoy your vim experience.

# Usage notes and Useful commands

## Useful commands

- To exit insert mode use `jk` typing them together quickly. (the default in vim / nvim is `<ESC>`, but that won't work because it has been unmapped).
- Use `gd` for 'j' to jump to the **D**efinition.
- Use `gf` for 'j' to jump to the **F**ile.


### Completion menu for Lsp and Cmp

Note that this applies to Insert Mode only.

To jump to the next completion using Lsp / Cmp / Luasnip etc.. use

- `<CTRL+p>` for **P**rev
- `<CTRL+n>` for **N**ext
- `<CTRL+e>` for **E**xit
- `<CTRL+y>` for **Y**es (confirm completion and insert the completion)
- `<CR>` for Enter confirm, replacing everying that was previously there.

#### Completion Docs

- `<CTRL-f>` to scroll the docs **F**orwards
- `<CTRL-b>` to scroll the docs **B**ackwards

Also see `: help vim.lsp.*` for documentation on any of the LSP functions

#### LSP Diagnostics

Note that this applies to Normal Mode only.

When in normal mode, the LSP will have already run and will be highlighting areas of code syntax.
Use:

- `<SPACE>+e` to open a floating window containing the LSP diagnostic (according to the LSP)
- `<SPACE>+q` to open a window of LSP diagnostics below the current buffer
- `[d` to go to the previous LSP diagnostic
- `]d` to go to the next LSP diagnostic

Also see `: help vim.diagnostic.*` for documentation on any of the functions.

### Luasnip

When completing a snippet, use

- `<CTRL+k>` after selecting a luasnip option to jump to the next snippet jump point
- `<CTRL+j>` to jump to the previous snippet jump point


### NvimTree

When within NvimTree (Using command mode `:NvimTreeToggle` to activate), use

- `<R>` to **P**erform a reread of the files contained in the project.
- `<H>` to **H**ide/display hidden files and folders (beginning with a dot .)
- `<E>` to **E**xpand the entire file tree starting from the root folder (workspace)
- `<W>` To **C**ollapse all open folders starting from the root folder
- `<f>` to **F**ind the interactive file search to which search filters can be applied
- `<\s>` to open the file with the **S**ystem application set by default for that file type
- `<->` (Dash/Hyphen) Allows you to go back up folders. This navigation also allows you to exit the root folder (workspace) to your home directory
- `<SHIFT+f>` to close the interactive search
- `<CTRL+k>` to display information about the file such as size, creation date, etc.
- `<g+?>` to open the help with all the predefined shortcuts for quick reference
- `<q>` to close the file explorer


### Nvim Spell

- `<z+w>` to add a word to the dictionary.
- `<leader>ss` to set spell (misspelled words will appear underlined)

## Finally

To go to two of the mappings.lua files, use:

- `<leader>m` to get to `~/.config/nvim/lua/keymappings.lua` (the basic set of mappings).
- `<leader>pm` to get to `~/.config/nvim/lua/plugins/keymappings.lua` (the set of plugin-based mappings).
