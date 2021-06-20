" klebster1's vimrc file ----- {{{
"  thanks for visiting
" }}}
" Quote from 'Learn Vimscript the Hard Way' -------- {{{
" A trick to learning something is to force yourself to use it (in this case- remaps)
" }}}

" Default set -------- {{{
syntax on
set autoindent
filetype plugin indent on
set noerrorbells
set shiftwidth=4
set shiftround
set expandtab
"set number relativenumber
set nu nornu
" don't wrap lines
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim_runtime/undodir
set undofile
set incsearch
set termguicolors
set colorcolumn=80
set signcolumn=yes
set path+=**
set wildmenu
set wildmode=longest:list,full
set list
set cmdheight=1
set shortmess+=c
set background=dark
colorscheme gruvbox
set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set statusline=%F
set backspace=indent,eol,start
"highlight Normal guibg=NONE
" shell highlighting for bash
let b:is_bash = 1
set ft=sh
if executable('rg')
    let g:rg_derive_root='true'
endif
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-file -oc --exclude-standard']
" bash syn
let g:is_bash = 1 | setfiletype sh

let g:mapleader=" "
let g:maplocalleader=";"
set foldlevelstart=1
"set foldcolumn=0
" netrw tree
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
" }}}

" Leader remaps ---- {{{
" Leader Window Movement Remaps --------- {{{
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
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
" Leader Window Explorer --------- {{{
nnoremap <leader>vx :Vex<cr>
nnoremap <leader>sx :Sex<cr>
" }}}
" }}}

" Leader Plugin Remaps --------- {{{
"" undotree side explorer
nnoremap <leader>u :UndotreeShow<CR>
"" open small side explorer
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
"" ripgrep PS Project Search
nnoremap <leader>ps :Rg<CR>
let g:rg_command = 'rg --vimgrep -S'
" pytest on entire file
nnoremap <leader>ptf :Pytest<SPACE>file<CR>
" pytest check last error msg
nnoremap <leader>ptl :Pytest<SPACE>last<CR>
" colorschemes:
nnoremap <leader>gb :colorscheme gruvbox<CR>
nnoremap <leader>bd :set background=dark<CR>
" vim-fugitive:
nnoremap <leader>gh :diffget //3<CR>
nnoremap <leader>gu :diffget //2<CR>
nnoremap <leader>gs :G<CR>
" }}}
" Leader Set Toggle remaps ------------- {{{
nnoremap <leader>sn :set number!<cr>
nnoremap <leader>srn :set relativenumber!<cr>
nnoremap <leader>sw :set wrap!<cr>
nnoremap <leader>sp :set paste!<cr>
" }}}

nnoremap <leader>rz
    \ :!$HOME/.vim_runtime/assistive-writing-apis/searchrhymezone_api.sh "<cword>"
    \ <cr> :vs $HOME/.vim_runtime/assistive-writing-apis/rhymezone_wordlist.elp<cr>
    \ <c-w><c-r>

" Leader edit vimrc (basic.vim) ---- {{{
nnoremap <leader>ev :vsplit ~/.vim_runtime/vimrcs/basic.vim<cr>
nnoremap <leader>eV :e ~/.vim_runtime/vimrcs/basic.vim<cr>
" }}}
" Leader edit vimrc plugins (plugins.vim) ---- {{{
nnoremap <leader>ep :vsplit ~/.vim_runtime/vimrcs/plugins.vim<cr>
" }}}
" Leader source vimrc ---- {{{
nnoremap <leader>sv :source ~/.vimrc<cr>
" }}}
" Leader disregard tab (delete tab) ---- {{{
nnoremap <leader>qq :quit<cr>
" }}}
" Leader disregard tab (delete tab) ---- {{{
nnoremap <leader>ss :hsplit<cr>
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
nnoremap <buffer> <leader>q :r!curl -s 'http://whatthecommit.com/index.txt'<cr>

" }}}
" }}}
" * Command mode mappings -------------- {{{
" expand current script path
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" }}}

" settings for all files ------------------------- {{{
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
augroup END
" }}}
" vimscript file settings ---------------------- {{{
augroup vim_file
    autocmd!
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
    autocmd FileType vim onoremap b /return<cr>
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <leader>pi :PlugInstall<CR>
augroup END
" }}}
" python File settings --------------------- {{{
augroup python_file
    autocmd!
    autocmd FileType python inoremap <buffer> <localleader>m <C-r>=MyComplete("/.vim_runtime/dicts/custom_pycompletions")<cr>
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType python :iabbrev <buffer> if: if:<left>
    autocmd FileType python :iabbrev <buffer> elif: elif:<left>
    autocmd FileType python onoremap b /return<cr>
    autocmd FileType python setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^\\s*#'
augroup END
" }}}
" bash/sh File settings ----------- {{{
augroup sh_file
    autocmd!
    autocmd FileType sh nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType sh nnoremap <buffer> <localleader>b I#!/bin/bash<cr><esc>
augroup END
" }}}
" use bash by default
" Markdown file settings ------------------ {{{
augroup markdown_file
    autocmd!
    autocmd FileType markdown set wrap
    "16 - more operator pending mappings
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^[=-]\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^[=-]\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END
" }}}
augroup json_file
    autocmd!
    autocmd FileType json nnoremap <buffer> <localleader>j :%!jq '.'<cr>
augroup END

augroup elp_file
    autocmd!
    autocmd FileType elp highlight matchQuery term=bold gui=bold guifg=Magenta cterm=bold ctermfg=red guifg=#fabd2f Conceal Ignore /\*/

augroup END
" OTHER NOTES: ----- {{{
" Below is some stuff I don't currently do.
" I keep it incase I forget how to.
"
" autocmd BufWritePre,BufRead *.html setlocal nowrap
"
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
"
"
"
":help internal-variables
" }}}
