" c/c++ file settings ------------------------ {{{
augroup c_file
    autocmd!
    autocmd FileType c nnoremap <buffer> <localleader>c I/*<esc>
    autocmd FileType c setl ofu=ccomplete#CompleteCpp
    autocmd FileType c nnoremap <buffer> <localleader>c I#include<space><stdio.h><return>#include<space><stdlib.h><return><return>int main()<return>{<return><space><space>return 0;<return>}<up><esc>
augroup END
" }}}

" vimscript file settings ---------------------- {{{
augroup vim_file
    autocmd!
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
    autocmd FileType vim onoremap b /return<cr>
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <leader>pi :PlugInstall<CR>
    autocmd FileType vim inoremap <buffer> <localleader>nln \n<left>
augroup END

" }}}

" python File settings --------------------- {{{
augroup python_file
    autocmd!
    autocmd FileType python inoremap <buffer> <localleader>m <C-r>=MyComplete("/.vim_runtime/dicts/custom_pycompletions")<cr>
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType python nnoremap <buffer> pdb Iimport<space>pdb;<return>pdb.set_trace()<esc>
    autocmd FileType python nnoremap <buffer> ggj Iimport<space>json<return>import<space>os<return>from<space>pathlib<space>import<space>Path<return><esc>
    autocmd FileType python nnoremap <buffer> ggnm Iif __name__=="__main__":<return><esc>
    autocmd FileType python :iabbrev <buffer> if: if:<left>
    autocmd FileType python :iabbrev <buffer> elif: elif:<left>
    autocmd FileType python onoremap <buffer> b /return<cr>
"    autocmd FileType python setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^\\s*#'
    autocmd FileType python setlocal foldenable
    autocmd FileType python setlocal foldmethod=syntax
    autocmd FileType python inoremap <buffer> <localleader>nln \n<left>
augroup END

" }}}

" out of bash and sh, use bash by default, bash/sh File settings ----------- {{{
augroup sh_file
    autocmd!
    " shell highlighting for bash... and get confused when we have a sh file
    autocmd FileType sh let b:is_bash = 1
    autocmd FileType sh set ft=sh
    autocmd FileType sh nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType sh nnoremap <buffer> <localleader>b I#!/bin/bash<cr><esc>
    autocmd FileType sh inoremap <buffer> <localleader>nln \n<left>
augroup END
" }}}

" Markdown file settings ------------------ {{{
augroup markdown_file
    autocmd!
    autocmd FileType markdown set wrap
    "c16 LVSTHW - more operator pending mappings
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^[=-]\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^[=-]\\+$\r:nohlsearch\rg_vk0"<cr>
    autocmd FileType markdown inoremap <buffer> <localleader>nln \n<left>
augroup END
" }}}

" json file settings  ------ {{{
augroup json_file
    autocmd!
    autocmd FileType json nnoremap <buffer> <localleader>j :%!jq '.'<cr>
"    autocmd FileType json <buffer> BufWritePre :normal gg=G
augroup END
" }}}

" html file settings  ------ {{{
augroup html_file
    autocmd!
    autocmd FileType *.html :iabbrev <buffer> <localleader>nln \n<left>
    autocmd BufNewFile,BufRead *.html setlocal nowrap
    autocmd BufWritePre *.html :normal gg=G
augroup END
" }}}

" bash_eternal_history file settings --- {{{
augroup bash_eternal_history
    autocmd!
    autocmd BufNewFile,BufRead *.bash_eternal_history set filetype=bash_eternal_history
    autocmd BufWritePre *.bash_eternal_history :normal gg=G
    autocmd FileType bash_eternal_history cnoremap :q q!
augroup END
" }}}

" elp file settings ---- {{{
augroup elp_file
    autocmd!
    autocmd FileType elp highlight matchQuery term=bold gui=bold guifg=Magenta cterm=bold ctermfg=red guifg=#fabd2f
augroup END
" }}}
