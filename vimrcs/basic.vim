syntax on

set noerrorbells
set shiftwidth=4
set shiftround
set expandtab
"indent
set smartindent
"set number relativenumber
set nu rnu
" don't wrap lines
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
set list
colorscheme gruvbox
set background=dark

set t_Co=256
" shell highlighting for bash
let b:is_bash = 1
set ft=sh

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:mapleader=" "
let g:maplocalleader=";"

"" LEARN VIMSCRIPT THE HARD WAY: 
" a trick to learning is to force yourself to use it by disabling alternatives
" (basic remaps)
nnoremap <leader>pi :PlugInstall<CR>

"" window
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

"" split resize
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

" plugin remaps
"" undotree side explorer
nnoremap <leader>u :UndotreeShow<CR>

"" open small side explorer
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

"" ripgrep PS Project Search
nnoremap <leader>ps :Rg<SPACE>

" pytest on entire file
nnoremap <leader>ptf :Pytest<SPACE>file<CR>

" pytest check last error msg
nnoremap <leader>ptl :Pytest<SPACE>last<CR>

" colorschemes:
nnoremap <leader>csg :colorscheme gruvbox<CR>

nnoremap <leader>bl :set background=light<CR>
nnoremap <leader>bd :set background=dark<CR>

" uppercase entire word while in insert/normal mode
inoremap <c-u> <esc>viwu<cr>i
nnoremap <c-u> <esc>viwu<cr>i
" create new + empty line below cursor in normal mode
nnoremap <c-o> <esc>o<esc>
nnoremap <c-O> <esc>O<esc>

" edit vimrc (basic.vim)
nnoremap <leader>ev :vsplit ~/.vim_runtime/vimrcs/basic.vim<cr>

" source vimrcs/basic
nnoremap <leader>sv :source ~/.vimrc<cr>

" first word and EOL remaps
nnoremap H 0w
nnoremap L $

" quote text
vnoremap <leader>" :s/\%V\(.*\)\%V/"\1\"/<cr>
vnoremap <leader>` :s/\%V\(.*\)\%V/`\1\`/<cr>
vnoremap <leader>' :s/\%V\(.*\)\%V/'\1\'/<cr>

command WriteSudo w !sudo tee %:t
nnoremap <leader>W :WriteSudo<cr>

" remap <esc> to quick jk
inoremap jk <esc>

" write any files as soon as you open a new
autocmd BufNewFile * :write
autocmd BufWritePre,BufRead *.html setlocal nowrap

" File-specific comment syntax for BOL
"
augroup c_file
    autocmd!
    autocmd FileType c nnoremap <buffer> <localleader>c I/*<esc>
augroup END

augroup vim_file
    autocmd!
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>''
augroup END

augroup python_file
    autocmd!
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType python :iabbrev <buffer> if: if:<left>
    autocmd FileType python :iabbrev <buffer> elif: elif:<left>
augroup END

augroup bash_file
    autocmd!
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
augroup END


augroup javascript
    autocmd!
    autocmd FileType javascript :iabbrev <buffer> iff if ()<left>
augroup END


"NOTES:
":w !sudo tee % - write out the current file using sudo 
" 3== - re-indent 3 lines
" =% - re-indent a block with () or {} (cursor on brace)
" =iB - re-indent inner block with {}
" gg=G - re-indent entire buffer
" ]p - paste and adjust indent to current line 
" 
" vim[grep] /pattern/ {`{file}`} - search for pattern in multiple files
" e.g. :vim[grep] /foo/ **/
"
"    :cn[ext] - jump to the next match
"    :cp[revious] - jump to the previous match
"    :cope[n] - open a window containing the list of matches
"    :ccl[ose] - close the quickfix window
"

":tabnew or :tabnew {page.words.file} - open a file in a new tab
"Ctrl + wT - move the current split window into its own tab
"gt or :tabn[ext] - move to the next tab
"gT or :tabp[revious] - move to the previous tab
"#gt - move to tab number #
":tabm[ove] # - move current tab to the #th position (indexed from 0)
":tabc[lose] - close the current tab and all its windows
":tabo[nly] - close all tabs except for the current one
":tabdo command - run the command on all tabs (e.g. :tabdo q - closes all opened tabs)


"zf - manually define a fold up to motion
"zd - delete fold under the cursor
"za - toggle fold under the cursor
"zo - open fold under the cursor
"zc - close fold under the cursor
"zr - reduce (open) all folds by one level
"zm - fold more (close) all folds by one level
"zi - toggle folding functionality
"]c - jump to start of next change
"[c - jump to start of previous change 

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
