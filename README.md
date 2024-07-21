# klebster2's vimrc

# Table of Contents
- [Setup](#setup)
   - [Ubuntu Installation](#ubuntu-installation)
- [Usage notes and Useful commands](#usage-notes-and-useful-commands)
   - [Useful commands](#useful-commands)
      - [Completion Menu Lsp and Cmp](#completion-menu-for-lsp-and-cmp)
         - [Completion Docs](#completion-docs)
         - [LSP Diagnostics](#lsp-diagnostics)
      - [Luasnip](#luasnip)
      - [NvimTree](#nvimtree)
      - [Nvim Spell](#nvim-spell)


# Setup

## Ubuntu installation

1. Install the following packages (via `apt`, `apt-get`, `snap` or another package manager of your choosing)

- [`jq`](https://jqlang.github.io/jq/) For querying json files.
- [`curl`](https://curl.se/) For downloading installation files
- [`npm`](https://www.npmjs.com/) (node package manager)

To install all the dependencies, you should run:

```bash
# Install jq, curl
apt-get install jq curl -y
# Install node
curl -fsSL https://fnm.vercel.app/install | bash && . ~/.bashrc && fnm use --install-if-missing 20
```

Use `sudo` with `apt-get` if you are not root.

2. Next, clone the repo to `~/.config/nvim` (default neovim configuration location), and run the install script:

Clone the repo to `~/.config/nvim`

```bash
mkdir -pv ~/.config && git clone "https://github.com/klebster2/vimrc" ~/.config/nvim
```

Run the installation script [`install.sh`](./install.sh)

```bash
pushd ~/.config/nvim && ./install.sh && popd
```

3. Enjoy!

That's it for now. Enjoy your neovim experience.

# Usage notes and Useful commands

The following section lists groups of useful commands.

* Note that _some_ of the mappings listed below can be found within the following files:
- [`lua/keymappings.lua`](./lua/keymappings.lua)
- [`lua/plugins/keymappings.lua`](./lua/plugins/keymappings.lua)

To go to either two of the keymappings.lua files, when in normal mode, use:

- `<leader>em` to get to the file [`~/.config/nvim/lua/keymappings.lua`](./lua/keymappings.lua) (the basic set of mappings that should work with native neovim).
- `<leader>epm` to get to the file [`~/.config/nvim/lua/plugins/keymappings.lua`](./lua/plugins/keymappings.lua) (the plugin-based mappings that cannot work without the plugins).

If you are unsure what a 'leader' key is, then read this: [Learn Vimscript the Hard Way - Chapter 06 - Leaders](https://learnvimscriptthehardway.stevelosh.com/chapters/06.html)

## Useful commands

- Use `gd` for **G**o to the **D**efinition.
- Use `gf` for **G**o to the **F**ile.
- To exit insert mode use `jk` typing them together quickly. Note that the default in vi, vim and neovim is `<ESC>`, but `<ESC>` won't work because in this configuration, because it has been unmapped.

### Completion menu for Lsp and Cmp

Note that this applies to completions in Insert Mode only.

To jump to the next completion using Lsp / Cmp / Luasnip etc.. use

- `<CTRL+p>` for **P**rev
- `<CTRL+n>` for **N**ext

Use
- `<CTRL+e>` to **E**xit
- `<CTRL+y>` to 'say' **Y**es, completing the text with the current option; confirm completion and insert the completion
- `<CR>` replacing everying that was previously there

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

Also see `: help vim.diagnostic.*` for documentation on any of the Lsp diagnostics.

---

For more information on Lsp / Cmp, and to see the configuration file, go to the file [`./lua/plugins/nvim-cmp-cfg.lua`](./lua/plugins/nvim-cmp-cfg.lua).

### LuaSnip

[LuaSnip](https://github.com/L3MON4D3/LuaSnip) is a snippets engine, that permits the user to use templates.
These templates should ideally increase the speed of development while not sacrificing quality.

When completing a snippet, use

- `<CTRL+k>` after selecting a luasnip option to jump to the **next** snippet jump point
- `<CTRL+j>` to jump to the **previous** snippet jump point

See the snippets file here: [`./lua/plugins/snippets.lua`](./lua/plugins/snippets.lua)

### NvimTree

[NvimTree](https://github.com/nvim-tree/nvim-tree.lua) is a plugin used for file / directory viewing.

When within the NvimTree viewer (You can use the command mode `:NvimTreeToggle` to activate from normal mode, or  `:vertical split .`), use

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

For the NvimTree configuration, go to [`./lua/plugins/nvim-tree-cfg.lua`](./lua/plugins/nvim-tree-cfg.lua)

### Nvim Spell

- `<z+w>` to add a word to the dictionary.
- `<leader>ss` to set spell (misspelled words will appear underlined)
