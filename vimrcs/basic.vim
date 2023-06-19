" Default set -------- {{{
" filetype plugin indent on
let g:python3_host_prog='/bigdrive/kleber/miniconda3/envs/pynvim/bin/python3'
set backspace=indent,eol,start

" Leader Window vertical split open ---------- {{{
nnoremap gF :vertical wincmd f<cr>
" }}}

" Speech Engineering stuff
highlight Errors ctermfg=red guifg=#fb4934
highlight Sent ctermfg=red guifg=#fabd2f
highlight Int ctermfg=red guifg=#d3869b
