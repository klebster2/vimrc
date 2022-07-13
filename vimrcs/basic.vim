"klebster1's vimrc file ----- {{{
"  thanks for visiting
" }}}

" Quote from 'Learn Vimscript the Hard Way' -------- {{{
" A trick to learning something is to force yourself to use it (in this case- remaps)
" }}}

" Default set -------- {{{
filetype plugin indent on
set path+=**
set wildmenu
set wildmode=longest:list,full
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set statusline=%F
set backspace=indent,eol,start

" bash syn
let g:is_bash = 1 | setfiletype sh
set foldlevelstart=1

" Leader Window vertical split open ---------- {{{
nnoremap gF :vertical wincmd f<cr>
" }}}

" Leader Plugin Remaps --------- {{{
"" open small side explorer
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
"" ripgrep PS Project Search
" }}}
" Leader Set Toggle remaps ------------- {{{
" FZF ------------------- {{{
nnoremap <leader>fi :Files<cr>
" }}}

" Leader source vimrc ---- {{{
" nnoremap <leader>sv :source ~/.vimrc<cr>:edit<cr>
" }}}
" search rhymezoneapi in visual mode --------------- {{{
vnoremap <leader>rz :terminal ./searchrhymezone_api.sh "%V"
" }}}
nnoremap H 0w
nnoremap L $
set nofoldenable "disable folding
" }}}
" * Insert mode ------------ {{{

" }}}

" }}}

" settings for all files ------------------------- {{{
"
"  trimwhitespace --- {{{
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
" }}}

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
    " gg = give-give (me a)
    " ggj: give-give (me a) json (import) (+ utils)
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

" out of bash and sh, use bash by default
" bash/sh File settings ----------- {{{
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
"

" speech engineering stuff
highlight Errors ctermfg=red guifg=#fb4934
highlight Sent ctermfg=red guifg=#fabd2f
highlight Int ctermfg=red guifg=#d3869b

let conda_default_env = $CONDA_DEFAULT_ENV
"if conda_default_env == 'base'
"    let env_name = 'neovim'
"else
"    let env_name = conda_default_env
"endif

"let bin_python = expand('~') . '/miniconda3/envs/' . env_name . '/bin/python'
"if filereadable(bin_python)
"    let g:python3_host_prog = bin_python
"endif

" OTHER NOTES: ----- {{{

" zm - un/indent all nested folds
" zM - un/indent all folds (non-nested)
" zi - toggle folding functionality
" 3== - re-indent 3 lines

" =% - re-indent a block with () or {} (cursor on brace)
" =iB - re-indent inner block with {}
" gg=G - re-indent entire buffer
" ]p - paste and adjust indent to current line

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
":help internal-variables
" }}}
