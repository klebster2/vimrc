" vimscript file settings ---------------------- {{{
augroup vim_file
    autocmd!
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
    autocmd FileType vim onoremap b /return<cr>
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim inoremap <buffer> <localleader>nln \n<left>
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
