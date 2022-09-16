" Default set -------- {{{
" filetype plugin indent on
set path+=**
set backspace=indent,eol,start

" Leader Window vertical split open ---------- {{{
nnoremap gF :vertical wincmd f<cr>
" }}}

" speech engineering stuff
highlight Errors ctermfg=red guifg=#fb4934
highlight Sent ctermfg=red guifg=#fabd2f
highlight Int ctermfg=red guifg=#d3869b
let g:spotify_token='NmEyM2IyZDcwOGM3NDA5Y2EwMTg3ODAxODNiNzk2MDY6YjZhNjJkN2U2MzBiNDE1MGEwMGVkMjkwY2I4ZTZmZTE='

let conda_default_env = $CONDA_DEFAULT_ENV

" TODO
"let bin_python = expand('~') . '/miniconda3/envs/' . env_name . '/bin/python'
"if filereadable(bin_python)
"    let g:python3_host_prog = bin_python
"endif

" Make subsequent <C-m> presses after <C-x><C-m> go to the next entry (just like otherwise <C-x>* mappings)
inoremap <expr> <C-m> pumvisible() ?  "\<C-n>" : "\<C-m>"

" Complete function for addresses; we match the name & address
" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new line.
inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
