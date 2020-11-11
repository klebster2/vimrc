syntax on

"Inspired by ThePrimeagen https://www.youtube.com/watch?v=n9k9scbTuQ
set noerrorbells
"tab
set tabstop=4 softtabstop=4
set shiftwidth=4
set shiftround
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

" Plugins
call plug#begin('~/.vim/plugged')
" gruvbox colourscheme
Plug 'morhetz/gruvbox'
Plug 'colepeters/spacemacs-theme.vim'
" ripgrep
Plug 'jremmen/vim-ripgrep'
" github (vim friendly)
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'
" filepath/ var autocompleter
Plug 'ycm-core/YouCompleteMe'
Plug 'mbbill/undotree'
Plug 'alfredodeza/pytest.vim'
call plug#end()

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:mapleader=" "

" plugin remaps
" window
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
" undotree side explorer
nnoremap <leader>u :UndotreeShow<CR>
" open small side explorer
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
" ripgrep PS Project Search
nnoremap <leader>ps :Rg<SPACE>
" split resize
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

" YCM
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>

" pytest on entire file
nnoremap <leader>ptf :Pytest<SPACE>file<CR>
" pytest check last error msg
nnoremap <leader>ptl :Pytest<SPACE>last<CR>

":echo $MYVIMRC to echo your vimrc

"c1 ECHOING MESSAGES
":echo "Hello world"
":echom "hello"
":messages

"message "hello" will be in the message list but not Hello world

"also instructions for how to use nnoremap

"c2 BOOLEAN OPTS 
":set number
":set nonumber

"bang toggles bool
":set number!

"set shiftround -> when shifting lines (<,>), round indentation to nearest multiple
"of "shiftround"

"set shiftwidth?

"save on typing multiple set commands:
"set number numberwidth=6

"c3: mapping
"

