# klebster2's vimrc

# Table of Contents
- [Setup](#setup)
   - [Ubuntu Installation](#ubuntu-installation)
       - [1. Install the packages jq, curl, and npm](#1-install-the-packages-jq-curl-and-npm)
       - [2. Install neovim](#2-install-neovim)
       - [3. Clone the repo, and run install.sh](#3-clone-the-repo-and-run-installsh)
       - [4. That's it for now.](#4-thats-it-for-now)
- [Usage Notes](#usage-notes)
   - [Configuration Commands](#configuration-commands)
   - [Useful commands](#useful-commands)
      - [Completion Menu Lsp and Cmp](#completion-menu-for-lsp-and-cmp)
         - [Completion Docs](#completion-docs)
         - [LSP Diagnostics](#lsp-diagnostics)
      - [Luasnip](#luasnip)
      - [NvimTree](#nvimtree)
      - [Fzf-Lua](#fzf-lua)
      - [Nvim Spell](#nvim-spell)
      - [Json File formatting](#json-file-formatting)

---

# Setup

## Ubuntu installation

### 1. Install the packages jq, curl, and npm

   You can do this via `apt`, `apt-get`, `snap` or a package manager of your choosing. _Note: A package manager is usually dependent on your operating system. `apt`, `apt-get`, `snap` are relevant to Ubuntu._

   - [`jq`](https://jqlang.github.io/jq/) For querying json files.
   - [`curl`](https://curl.se/) For downloading installation files and plenary.nvim
   - [`npm`](https://www.npmjs.com/) (node package manager)

   To install all the above dependencies run:

   ```bash
   apt-get install jq curl -y
   # Install node / node package manager - npm
   curl -fsSL https://fnm.vercel.app/install | bash && . ~/.bashrc && fnm use --install-if-missing 20
   ```

   Use `sudo` with `apt-get`, `apt` or `snap` if you are not root.

### 2. Install neovim

   You can use the following shell script.

   ```bash
   curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
   chgrp sudo nvim.appimage
   chmod ugo+x nvim.appimage
   ./nvim.appimage --appimage-extract
   ./squashfs-root/AppRun --version
   mv squashfs-root / || sudo mv squashfs-root /
   ln -s /squashfs-root/AppRun /usr/bin/nvim || sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
   nvim --version
   ```

### 3. Clone the repo, and run the `install.sh` shell script.

   Clone the repo to `~/.config/nvim` (the default neovim location)

   ```bash
   mkdir -pv ~/.config && git clone "https://github.com/klebster2/vimrc" ~/.config/nvim
   ```

   Run the installation script [`install.sh`](./install.sh)

   ```bash
   pushd ~/.config/nvim && ./install.sh && popd
   ```

### 4. That's it for now.

   Enjoy your neovim experience!

# Usage notes

## Configuration Commands

_The following section lists commands that will take you to configuration files._

Use:

- `<leader>ev` to edit the init.lua file - this is the main configuration file (at the location ~/.config/nvim/init.lua ) in this repository find it here: [`init.lua`](./init.lua)

Some of the mappings listed below can be found within the following keymapping files:

To go to either one of the two keymappings.lua files, when in normal mode, use:

- `<leader>em` to go to [`lua/keymappings.lua`](./lua/keymappings.lua) (the basic set of mappings that should work with native neovim).

If you are unsure what a 'leader' key is, first read this: [Learn Vimscript the Hard Way - Chapter 06 - Leaders](https://learnvimscriptthehardway.stevelosh.com/chapters/06.html)

## Useful commands

_Note that the following commands apply to Normal Mode only._

- Use `gd` for **G**o to the **D**efinition.
   - When the **C**ursor is on a **W**ord (**cw**ord), and that word is a function-call, or variable, you can type `gd` to go to the function **D**efinition.

- Use `gf` for **G**o to the **F**ile.
   - When the Cursor is on a **F**ile (fullpath, or partial path), you can type `gf` to **G**o to the **F**ile.

- To exit insert mode use `jk` typing them together quickly. Note that the default way to exit normal mode in vi, vim and neovim is `<ESC>`, but `<ESC>` won't work because in this configuration, because it has been unmapped.
   - Learn Vimscript the Hard Way: ["A trick to learning something is to force yourself to use it."](https://learnvimscriptthehardway.stevelosh.com/chapters/10.html#learning-the-map). In other words, unmap and remap.

To jump to a configuration file (these will only work if you have a configuration file at that location), use:

- `<leader>et` for **E**dit **T**mux, to edit the tmux configuration file: `~/.tmux.conf`

- `<leader>eb` for **E**dit **B**ash, to edit the bashrc file `~/.bashrc`

- `<leader>ei` for **E**dit **I**nputrc, to edit the inputrc file `~/.inputrc`

### Completion menu for LSP and CMP

_Note that this applies to completions in Insert Mode only, when the cmp popup menu is visible._

[Nvim-Cmp](https://github.com/hrsh7th/nvim-cmp) is an autocompletion engine.
[LspConfig](https://github.com/neovim/nvim-lspconfig) is a NeoVim client that allows for configuring ([Language-Server-Protocol](https://microsoft.github.io/language-server-protocol/)s in NeoVim)

- Read more about the NeoVim LSP client on the [NeoVim LSP help page](https://neovim.io/doc/user/lsp.html)

To jump to the subsequent completions using Lsp, Cmp, Luasnip, etc. use

- `<CTRL+p>` for **P**rev
- `<CTRL+n>` for **N**ext

Use

- `<CTRL+e>` to **E**xit
- `<CTRL+y>` to say _**Y**es_, the user wants to complete the text with the current option; confirm and insert the completion
- `<CR>` to Accept the completion, replacing everying that was previously there

#### Completion Docs

_Note that this applies to Insert Mode only (as above)._

- `<CTRL-f>` to scroll the docs **F**orwards
- `<CTRL-b>` to scroll the docs **B**ackwards

Also see `:help vim.lsp.*` for documentation on any of the LSP functions

#### LSP Diagnostics

_Note that this applies to Normal Mode only._

Use:

- `<SPACE>+e` to open a floating window containing the LSP diagnostic (according to the LSP)
- `<SPACE>+q` to open a window of LSP diagnostics below the current buffer
- `[d` to go to the previous LSP diagnostic
- `]d` to go to the next LSP diagnostic

Also see `:help vim.diagnostic.*` for documentation on any of the Lsp diagnostics.

_To see the configuration, go to the file_ [`lua/plugins/nvim-cmp-cfg.lua`](./lua/plugins/nvim-cmp-cfg.lua).

### LuaSnip

[LuaSnip](https://github.com/L3MON4D3/LuaSnip) is a snippets engine, that permits the user to use snippet templates.
These templates should ideally increase the speed of development while not sacrificing code quality.

When completing a snippet, use

- `<CTRL+k>` after selecting a luasnip option to jump to the **next** snippet jump point
- `<CTRL+j>` to jump to the **previous** snippet jump point

See the snippets file here: [`lua/plugins/snippets.lua`](./lua/plugins/snippets.lua)

### NvimTree

[NvimTree](https://github.com/nvim-tree/nvim-tree.lua) is a plugin used for file / directory viewing.

When within the NvimTree viewer (You can use the command mode `:NvimTreeToggle` to activate from normal mode, or  `:vertical split .`), use any of the defaults:

- `<SHIFT+r>` to **R**eread the files contained in the focused project
- `<SHIFT+h>` to toggle the display of hidden files and folders beginning with a dot `.`. Note that some other files may be hidden by default (like git files / directories).
- `<SHIFT+e>` to **E**xpand the *entire* file tree starting from the root folder (workspace)
- `<f>` to **F**ind files (opening a search filter that will be applied)
- `<SHIFT+w>` To collapse all open folders starting from the root folder
- `<\s>` to open the file with the **S**ystem application set by default for that file type
- `<->` (Dash/Hyphen) Allows you to go "backwards" into parent folders. This navigation also allows you to exit the root folder (workspace) to your home directory
- `<SHIFT+f>` to close the interactive search
- `<CTRL+k>` to display information about the file such as size, creation date, etc.
- `<g+?>` to open the help with all the predefined shortcuts for quick reference
- `<q>` to close the file explorer

For the NvimTree configuration, go to [`lua/plugins/nvim-tree.lua`](./lua/plugins/nvim-tree.lua)

Also note that some files and directories such as `.git/`, and `.gitignore` may be omitted from the NvimTree view due to how unusual it is for those files to be edited.

### Fzf-Lua

[Fzf](https://github.com/junegunn/fzf) is a powerful fuzzy-finder. It can be used to quickly find files using keybindings in the terminal such as `<Ctrl+r>` for history.
Since the release of one of fzf's cousins [fzf.vim](https://github.com/junegunn/fzf.vim), a github user wrote an [Fzf-Lua](https://github.com/ibhagwan/fzf-lua/tree/main) plugin for neovim that is blazingly fast.
[_Allegedly_](https://www.reddit.com/r/neovim/comments/113ewaf/comment/j8qqf27/#t1_j8qqf27-comment-rtjson-content), it is even faster than [Telescope](https://github.com/nvim-telescope/telescope.nvim).

Use:

- `<CTRL-f>` to start searching for files.
- `<CTRL-t>` to search helptags
- `<CTRL-x>` to grep the cword (word under the cursor)

### Nvim Spell

Use:

- `<z>+<w>` to add a word to the dictionary.
- `<leader>ss` to set spell (misspelled words will appear underlined)

### Json File formatting

Use:

- `<localleader>j` inside a json file to format it with consistent indentation.
