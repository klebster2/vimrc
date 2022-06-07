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

" shell highlighting for bash
set ft=sh
if executable('rg')
    let g:rg_derive_root='true'
endif

" bash syn
let g:is_bash = 1 | setfiletype sh

let g:mapleader=" "
let g:maplocalleader=";"
set foldlevelstart=1

"set foldcolumn=0
" vim plug for debugging
"g:nvimgdb_use_cmake_to_find_executables = 0
" netrw tree
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
" }}}

" Leader Window reize remaps --------- {{{
" simplify resizing splits
if has('unix')
    nnoremap j <C-w>-5
    nnoremap k <C-w>+5
    nnoremap h <C-w><5
    nnoremap l <C-w>>5
else
    nnoremap <M-j> <C-w>-
    nnoremap <M-k> <C-w>+
    nnoremap <M-h> <C-w><
    nnoremap <M-l> <C-w>>
endif
" }}}

" Leader Window closing remaps ---------- {{{
nnoremap <leader>o :only<cr>
" }}}

" Leader Window vertical split open ---------- {{{
nnoremap gF :vertical wincmd f<cr>
" }}}

" Leader Window Explorer --------- {{{
" }}}
nnoremap <leader>tp :tabprev<cr>
nnoremap <leader>tn :tabnext<cr>
nnoremap <leader>tt :tabnew<cr>
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

" Leader edit vimrc (basic.vim) ---- {{{
nnoremap <leader>ev :vsplit ~/.vim_runtime/vimrcs/basic.vim<cr>
nnoremap <leader>eV :e ~/.vim_runtime/vimrcs/basic.vim<cr>
" }}}
" Leader edit vimrc plugins (plugins.vim) ---- {{{
nnoremap <leader>ep :vsplit ~/.vim_runtime/vimrcs/plugins.vim<cr>
" }}}
" Leader source vimrc ---- {{{
nnoremap <leader>sv :source ~/.vimrc<cr>:edit<cr>
" }}}
" Leader source vimrc ---- {{{
nnoremap <leader>sb :set scrollbind!<cr>
" }}}
" Leader disregard tab (delete tab) ---- {{{
nnoremap <leader>qq :quit<cr>
" }}}
command! Wq :wq
" Leader disregard tab (delete tab) ---- {{{
" }}}
" search rhymezoneapi in visual mode --------------- {{{
vnoremap <leader>rz :terminal ./searchrhymezone_api.sh "%V"
" }}}
" Leader quote text in Visual mode --------------- {{{
vnoremap <leader>" :s/\%V\(.*\)\%V/"\1\"/<cr>
vnoremap <leader>` :s/\%V\(.*\)\%V/`\1\`/<cr>
vnoremap <leader>' :s/\%V\(.*\)\%V/'\1\'/<cr>
" }}}
" Leader write with permissions ------------- {{{
cnoremap w!! w !sudo tee > /dev/null %
" }}}
nnoremap <leader>dt :put =strftime('%d/%m/%y %H:%M:%S')<cr>
"
" * Normal-mode remaps ---------------- {{{
" use zi to disable and enable folding on the fly
" create new + empty line below cursor in normal mode
nnoremap <c-o> <esc>o<esc>
nnoremap <c-O> <esc>O<esc>
" hard H and L remaps
nnoremap H 0w
nnoremap L $
nnoremap s i<cr><esc>
nnoremap <leader>snhls :set nohls<cr>
" Check filetypes known to vim
nnoremap <leader>ft :setfiletype <c-d>
set nofoldenable "disable folding
" }}}
" * Operator pending mappings -------------- {{{
" in next parenthesis
onoremap in( :<c-u>normal! f(vi(<cr>
" in last parenthesis
onoremap il( :<c-u>normal! F)vi(<cr>
" and next parenthesis
onoremap an( :<c-u>normal! f(va(<cr>
" and last parentthesis
onoremap al( :<c-u>normal! F)va(<cr>
" more operator pending mappings (change inside next email address)
onoremap in@ :<c-u>execute "normal! ?^.+@$\rvg_"<cr>
onoremap an@ :<c-u>execute "normal! ?^\\S\\+@\\S\\+$\r:nohlsearch\r0vg"<cr>
" }}}
" * Insert mode ------------ {{{

" Remap esc --------------  {{{
inoremap jk <esc>
" }}}
" Autocomplete tab functionality ---- {{{
" InsertTabWrapper ------- {{{
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif
    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
" }}}

" Tab Remaps ---------- {{{
inoremap <expr> <s-tab> InsertTabWrapper()
inoremap <tab> <c-n>
" }}}

" }}}

" Random commit message --- {{{
nnoremap <buffer> <leader>wtc :r!curl -s 'http://whatthecommit.com/index.txt'<cr>
" }}}
" }}}
" * Command mode mappings -------------- {{{
"
" expand current script path
cnoremap %% <C-R>=expand('%:h').'/'<cr>
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
