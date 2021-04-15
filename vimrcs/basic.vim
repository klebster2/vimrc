
"klebster1's vimrc file ----- {{{
"  thanks for visiting
" }}}
" Quote from 'Learn Vimscript the Hard Way' -------- {{{
" A trick to learning something is to force yourself to use it
" by disabling alternatives (basic remaps)
" }}}
" basic settings -------- {{{
syntax on
filetype plugin indent on
set noerrorbells
set shiftwidth=4
set shiftround
set expandtab
"indent
set smartindent
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
set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set statusline=%F
set backspace=indent,eol,start
"highlight Normal guibg=NONE
if executable('rg')
    let g:rg_derive_root='true'
endif
" bash syn
let g:is_bash = 1 | setfiletype sh

let g:mapleader=" "
let g:maplocalleader=";"
set foldlevelstart=0
" }}}
" plugin settings
" gruvbox --- {{{
colorscheme gruvbox
" }}}
" netrw file tree settings -- {{{
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
" }}}
" FZF settings ------------------ {{{
" This is the default option:
"   - Preview window on the right with 50% width
"   "   - CTRL-/ will toggle preview window.
"   " - Note that this array is passed as arguments to fzf#vim#with_preview
"   function.
"   " - To learn more about preview window options, see `--preview-window`
" section of `man fzf`.
" let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Preview window on the upper side of the window with 40% height,
" hidden by default, ctrl-/ to toggle
" let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

" Empty value to disable preview window altogether
" let g:fzf_preview_window = []
" [Buffers] Jump to the existing window if possible
" let g:fzf_buffers_jump = 1
"
" " [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
"
"  " [Tags] Command to generate tags file
" let g:fzf_tags_command = 'ctags -R'
"
"  " [Commands] --expect expression for directly executing the command
" let g:fzf_commands_expect = 'alt-enter,ctrl-x'

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" See `man fzf-tmux` for available options
if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
"inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

function! s:update_fzf_colors()
  let rules =
  \ { 'fg':      [['Normal',       'fg']],
    \ 'bg':      [['Normal',       'bg']],
    \ 'hl':      [['Comment',      'fg']],
    \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
    \ 'bg+':     [['CursorColumn', 'bg']],
    \ 'hl+':     [['Statement',    'fg']],
    \ 'info':    [['PreProc',      'fg']],
    \ 'prompt':  [['Conditional',  'fg']],
    \ 'pointer': [['Exception',    'fg']],
    \ 'marker':  [['Keyword',      'fg']],
    \ 'spinner': [['Label',        'fg']],
    \ 'header':  [['Comment',      'fg']] }
  let cols = []
  for [name, pairs] in items(rules)
    for pair in pairs
      let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
      if !empty(name) && code > 0
        call add(cols, name.':'.code)
        break
      endif
    endfor
  endfor
  let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
  let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts .
        \ empty(cols) ? '' : (' --color='.join(cols, ','))
endfunction

augroup _fzf
  autocmd!
  autocmd ColorScheme * call <sid>update_fzf_colors()
augroup END

" }}}
" Leader remaps
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
" Leader Plugin Remaps --------- {{{
"" undotree side explorer
nnoremap <leader>u :UndotreeShow<CR>
"" open small side explorer
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
"" ripgrep PS Project Search
nnoremap <leader>ps :Rg<CR>
" pytest on entire file
nnoremap <leader>ptf :Pytest<SPACE>file<CR>
" pytest check last error msg
nnoremap <leader>ptl :Pytest<SPACE>last<CR>
" colorschemes:
nnoremap <leader>gb :colorscheme gruvbox<CR>
nnoremap <leader>bd :set background=dark<CR>
" }}}
" Leader Set Toggle remaps ------------- {{{
nnoremap <leader>sn :set number!<cr>
nnoremap <leader>srn :set relativenumber!<cr>
nnoremap <leader>sw :set wrap!<cr>
nnoremap <leader>sp :set paste!<cr>
" }}}
" Leader edit vimrc (basic.vim) ---- {{{
nnoremap <leader>ev :vsplit ~/.vim_runtime/vimrcs/basic.vim<cr>
" }}}
" Leader edit vimrc plugins (plugins.vim) ---- {{{
nnoremap <leader>ep :vsplit ~/.vim_runtime/vimrcs/plugins.vim<cr>
" }}}
" Leader source vimrc ---- {{{
nnoremap <leader>sv :source ~/.vimrc<cr>
" }}}
" Leader quote text in Visual mode --------------- {{{
vnoremap <leader>" :s/\%V\(.*\)\%V/"\1\"/<cr>
vnoremap <leader>` :s/\%V\(.*\)\%V/`\1\`/<cr>
vnoremap <leader>' :s/\%V\(.*\)\%V/'\1\'/<cr>
" }}}
" Leader write with permissions ------------- {{{
nnoremap <leader>W :w !sudo tee %:t<cr>
" }}}
" modus operandi remapant
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
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
" }}}

" }}}
" Custom Completion ------ {{{
function! Keyword32()
    let s:saved_iskeyword = &iskeyword
    let s:saved_updatetime = &updatetime
    if &updatetime > 200 | let &updatetime = 200 | endif
    augroup Keyword32
        autocmd CursorHold,CursorHoldI <buffer>
                    \ let &updatetime = s:saved_updatetime |
                    \ let &iskeyword = s:saved_iskeyword |
                    \ autocmd! Keyword32
    augroup END
    set iskeyword+=32
endfunction

inoremap <c-x><c-t> <C-O>:call Keyword32()<CR><c-x><c-t>
set thesaurus+=~/.vim_runtime/thesaurus-no-names.txt
" Custom complete function ------------------- {{{
fun! MyComplete(dictfilepath, ...)
    " Data from a file
    let l:data = readfile($HOME.a:dictfilepath, '')

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')
    let l:start_list = []
    let l:prev_start = 0

    " first record a:1 wordstarts
    for l:idx in range(1, a:1)
        let l:start = col('.') - l:prev_start - 1
        let l:start -= 1
        while l:start > 0 && l:line[l:start - 1] =~ '\a'
            let l:start -= 1
        endwhile
        " append start of words to list
        call add(l:start_list, l:start)
        let l:prev_start = l:start
    endfor

    " Record what matches − pass this to complete() later
    let l:res = []
    for l:start in reverse(l:start_list)

        let l:base = substitute(l:line[l:start : col('.')-1], '\v^\s*([^ ]+)\s*$', '\1', '')
        " Find matches
        for m in l:data
            " Check if it matches what we're trying to complete; in this case we
            " want to match against the start of both the first and second list
            " entries (i.e. the name and email address)
            if l:m !~? '^' . l:base
                " no match
                continue
            endif
            " match, see :help complete() for the full docs on the key names
            " for this dict.
            call add(l:res, {
                \ 'icase': 1,
                \ 'word': l:m,
                \ 'abbr': l:m,
                \ 'menu': $HOME.a:dictfilepath,
                \ 'info': 'whitespaces'.a:1,
            \ })
        endfor
    endfor
    " Now call the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun
" }}}

" Custom phrase and proverb completion -------- {{{
inoremap <buffer> <C-x><C-p> <C-r>=MyComplete("/.vim_runtime/dicts/proverbs_and_common_phrases", 2)<CR>
" }}}
" }}}
" }}}
" * Command mode mappings -------------- {{{
" expand current script path
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" }}}
" file settings
" general settings files ------------------------- {{{
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
    autocmd FileType sh nnoremap <buffer> <localleader>bb I#!/bin/bash<cr><esc>
    " use bash by default
augroup END
" }}}
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

" OTHER NOTES: ----- {{{
" below is some stuff that I don't currently do. I keep it incase I forget it
" to.
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
