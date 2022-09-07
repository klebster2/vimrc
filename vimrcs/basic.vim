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

let conda_default_env = $CONDA_DEFAULT_ENV

let g:spotify_token='NmEyM2IyZDcwOGM3NDA5Y2EwMTg3ODAxODNiNzk2MDY6YjZhNjJkN2U2MzBiNDE1MGEwMGVkMjkwY2I4ZTZmZTE='

" TODO
"let bin_python = expand('~') . '/miniconda3/envs/' . env_name . '/bin/python'
"if filereadable(bin_python)
"    let g:python3_host_prog = bin_python
"endif

