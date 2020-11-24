" Plugins
" colorschemes
call plug#begin('~/.vim/plugged')
" colourschemes (incl. gruvbox)
Plug 'rafi/awesome-vim-colorschemes'
Plug 'morhetz/gruvbox'
" ripgrep
Plug 'jremmen/vim-ripgrep'
" github (vim friendly)
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'
" filepath/ var autocompleter
Plug 'ycm-core/YouCompleteMe', { 'commit':'d98f896' }
Plug 'mbbill/undotree'
" pytest
Plug 'alfredodeza/pytest.vim'
Plug 'sheerun/vim-polyglot'
Plug 'chriskempson/base16-vim'
call plug#end()

