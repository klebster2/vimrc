" Plugins
" colorschemes
call plug#begin('~/.vim/plugged')
" colourschemes (incl. gruvbox)
Plug 'rafi/awesome-vim-colorschemes'
" colorscheme
Plug 'morhetz/gruvbox'
" ripgrep
Plug 'jremmen/vim-ripgrep'
" Vim-friendly github Plugin
Plug 'tpope/vim-fugitive'
"
Plug 'vim-airline/vim-airline'
"
Plug 'ctrlpvim/ctrlp.vim'
" filepath/ var autocompleter
Plug 'mbbill/undotree'
" pytest
Plug 'alfredodeza/pytest.vim'
" mql4
Plug 'vobornik/vim-mql4'
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"
Plug 'airblade/vim-rooter'
" vim-tmux navigator
Plug 'christoomey/vim-tmux-navigator'
" markdown
Plug 'skanehira/preview-markdown.vim'
"Plug 'ycm-core/YouCompleteMe'
" listchars
Plug 'pdurbin/vim-tsv'
" coc - use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

