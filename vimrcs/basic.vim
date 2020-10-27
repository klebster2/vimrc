syntax on
"Inspired by ThePrimeagen
set noerrorbells
"tab
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
"indent
set smartindent
set nu rnu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim_runtime/undodir
set undofile
set incsearch
set path+=**
set wildmenu
set wildmode=longest:list,full

let g:mapleader=" "

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :verical resize 30<CR>
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

"colorscheme industry

call plug#begin('~/.vim/plugged')
" gruvbox colourscheme
Plug 'morhetz/gruvbox'
" ripgrep
Plug 'jremmen/vim-ripgrep'
" 
Plug 'tpope/vim-fugitive'
call plug#end()

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

":echo $MYVIMRC to echo your vimrc

" ECHOING MESSAGES
":echo "Hello world"
":echom "hello"
":messages

"message "hello" will be in the message list but not Hello world

