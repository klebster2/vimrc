# klebster2's Neovim Configuration

Welcome to klebster2's Neovim configuration.

This setup is designed to be **powerful, customizable, and beginner-friendly**. Whether you're a new user or an experienced Vim/Neovim user, this guide will help you get started quickly and smoothly.

## 📌 Table of Contents

- [Getting Started](#getting-started)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Optional: Install Ollama](#optional-install-ollama)
- [Tips and Shortcuts](#tips-and-shortcuts)
- [License](#license)

---

# Getting Started

This configuration is built with the following tools:

- **Neovim** (latest version)
- **Lazy.nvim** (plugin manager)
- **LSP & CMP** (for smart autocompletion)
- **Treesitter** (for syntax highlighting)
- **Fzf-Lua** (for fast file and command search - derived from [Fzf](https://github.com/junegunn/fzf))
- **Ollama** (optional, for AI-powered code generation)

## Installation

### Prerequisites

Before installing, ensure you have the following tools installed:

[neovim](https://neovim.io)

For instructions see up-to-date Neovim [Releases](https://github.com/neovim/neovim/releases). For unix based systems (Mac, Linux), you will need to know the kernel CPU architecture\*. \* Get the kernel using

```bash
uname -a | rev | cut -d ' ' -f1 | rev
```

Other dependencies include [`jq`](https://jqlang.github.io/jq/) for querying json files; [`curl`](https://curl.se/) for downloading installation files, ollama.nvim, and plenary.nvim; [`npm`](https://www.npmjs.com/) (node package manager), `autotools-dev` and `autoconf`

To install them, on Ubuntu, run:

```bash
sudo apt-get install jq curl autotools-dev autoconf git -y
```

On macOS (using Homebrew) run:

```bash
brew install neovim jq curl npm git autoconf
```

### Setup

Clone the repo to `~/.config/nvim` (the default neovim location)

```bash
mkdir -pv ~/.config && git clone "https://github.com/klebster2/vimrc" ~/.config/nvim
```

Run the installation script [`install.sh`](./install.sh)

```bash
pushd ~/.config/nvim && ./install.sh && popd
```

### Optional: Install Ollama

Ollama is useful for generative AI applications.

Generate code candidates using the neovim package: [ollama.nvim](https://github.com/nomnivore/ollama.nvim), or [avante.nvim](https://github.com/yetone/avante.nvim)

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

**IMPORTANT**

Check your GPU Virtual RAM (VRAM) can hold a model defined in [`lua/plugins/ollama.lua`](./lua/plugins/ollama.lua), under `opts.model`, configure [`lua/plugins/avante.lua`](./lua/plugins/avante.lua) with the same model under `opts.ollama.model`.

---

##  Tips and Shortcuts

Key combination remappings here are structured using Mnemonics - for instance - help by allowing the first letter of each word for each command.

**Shortcuts**

The following section lists commands that will take you to configuration files (both Neovim dependent and other configs)

If you do not know what `leader` key means, then just assume for now that it means the space `<space>` (as it is set in this configuration to space).

- Use `<leader>ev` when in normal mode edits the [`init.lua`](init.lua) file - the main configuration file for neovim.
- The configuration file should live by default at the following location `$HOME/.config/nvim/init.lua`. Some of the mappings listed below can be found within the following keymapping files:
  - Use `<leader>em` to go to [`lua/keymappings.lua`](./lua/keymappings.lua) (the basic set of mappings that should work when running native neovim).

Miscellaneous configuration file shortcuts (these will only work if you have a configuration file at that location), use:

- `<leader>et` for **E**dit **T**mux, to edit the tmux configuration file: `~/.tmux.conf`
- `<leader>eb` for **E**dit **B**ash, to edit the bashrc file `~/.bashrc`
- `<leader>ei` for **E**dit **I**nputrc, to edit the inputrc file `~/.inputrc`

**Generic commands**

Note that the following commands apply to **Normal Mode only**.

- Use `gd` to **G**o to the **D**efinition. When the **C**ursor is on a **W**ord (**cw**ord), and that word is a function-call, or variable, you can type `gd` to go to the function **D**efinition or where the variable is set.
- When the Cursor is on a **F**ile (fullpath, or partial path), you can type `gf` to **G**o to the **F**ile.
- To exit **Insert Mode** use `jk` typing them together quickly. Note that the default way to exit normal mode in vi, vim and neovim is `<ESC>`.

**Completion menu for LSP and CMP**

Note that these completions apply to _Insert Mode_ and _Command Mode_ only, when the cmp popup menu _is visible_.

[Nvim-Cmp](https://github.com/hrsh7th/nvim-cmp) is the autocompletion engine used.
[LspConfig](https://github.com/neovim/nvim-lspconfig) is a NeoVim client that allows for configuring ([Language-Server-Protocol](https://microsoft.github.io/language-server-protocol/)s in NeoVim)

- Read more about the NeoVim LSP client on the [NeoVim LSP help page](https://neovim.io/doc/user/lsp.html)

To jump to the subsequent completions using Lsp, Cmp, Luasnip, etc. use

- `<CTRL+p>` for **P**rev completion option
- `<CTRL+n>` for **N**ext completion option
- `<CTRL+e>` to **E**xit the completion menu
- `<CTRL+y>` to say _**Y**es_. E.g. the user wants to complete the text with the current option; confirm and insert the completion
- `<CR>` to Accept the completion, replacing everything that was previously there

**LuaSnip**

[LuaSnip](https://github.com/L3MON4D3/LuaSnip) is a snippets engine, that permits the user to use snippet templates.
These templates should ideally increase the speed of development while not sacrificing code quality.

When completing a snippet, use

- `<CTRL+k>` after selecting a luasnip option to jump to the **next** snippet jump point
- `<CTRL+j>` to jump to the **previous** snippet jump point

See the snippets file here: [`lua/plugins/snippets.lua`](./lua/plugins/snippets.lua)

**Completion Docs**

_Note that this applies to Insert Mode only (as above)._

- `<CTRL-f>` to scroll the docs **F**orwards
- `<CTRL-b>` to scroll the docs **B**ackwards

Also see `:help vim.lsp.*` for documentation on any of the LSP functions

**Language Server Protocol (LSP) Diagnostics**

_Note that this applies to Normal Mode only._

Use:

- `<SPACE>+e` to open a floating window containing the LSP diagnostic (according to the LSP)
- `<SPACE>+q` to open a window of LSP diagnostics below the current buffer
- `[d` to go to the previous LSP diagnostic
- `]d` to go to the next LSP diagnostic

Also see `:help vim.diagnostic.*` for documentation on any of the Lsp diagnostics.

To _see the configuration_, go to the file [`lua/plugins/nvim-cmp-cfg.lua`](./lua/plugins/nvim-cmp-cfg.lua).

**Nvim Spell**

Use:

- `<z>+<w>` to add the cword to the dictionary.
- `<leader>ss` to `:set spell` (misspelled words will appear underlined)

**NvimTree**

[NvimTree](https://github.com/nvim-tree/nvim-tree.lua) is a plugin used for file / directory viewing.

To active the `NvimTree` view, use `<leader>vs`, with the default settings this is `<space>vs`.
When within the NvimTree viewer, you can use any of the defaults:

- `<SHIFT+r>` to **R**eread the files contained in the focused project
- `<SHIFT+h>` to toggle the display of hidden files and folders beginning with a dot `.`. Note that some other files may be hidden by default (like git files / directories).
- `<SHIFT+e>` to **E**xpand the _entire_ file tree starting from the root folder (workspace)
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

**Fzf-Lua**

[Fzf](https://github.com/junegunn/fzf) is a powerful fuzzy-finder.
It can be used to quickly find files using keybindings in the terminal such as `<Ctrl+r>` for history.

Since the release of one of Fzf's cousins [fzf.vim](https://github.com/junegunn/fzf.vim), a github user wrote an [Fzf-Lua](https://github.com/ibhagwan/fzf-lua/tree/main) plugin which is blazingly fast.
[_Allegedly_](https://www.reddit.com/r/neovim/comments/113ewaf/comment/j8qqf27/#t1_j8qqf27-comment-rtjson-content), it is even faster than [Telescope](https://github.com/nvim-telescope/telescope.nvim).

Use:

- `<CTRL-f>` to start searching for files.
- `<CTRL-t>` to search helptags
- `<CTRL-x>` to grep the cword (word under the cursor)

# License

MIT License
