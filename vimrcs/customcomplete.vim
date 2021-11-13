
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
" ---- }}}

" Custom complete function ------------------- {{{
fun! CallCompleteApi()
    " vim autosuggest using datamuse api and curl
    " - assumed ubuntu / unix system is running and curl is installed
    let fileout = $HOME.'/.vim_runtime/assistive-writing-apis/autosuggest.elp'

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')
    " a can be an arg, but for now, we want this function to be simple
    let l:start = col('.') - 1

    while l:start > 0 && l:line[l:start - 1] =~ '\a'
        let l:start -= 1
    endwhile
    " append start of words to list

    " a can be an arg, but for now, we want this function to be simple
    let l:prev_start = l:start
    let l:start -= 1
    while l:start > 0 && l:line[l:start - 1] =~ '\a'
        let l:start -= 1
    endwhile

    echom l:start
    echom l:prev_start

    let partial = 'sp='.l:line[l:prev_start : col('.')-1].'*'
    let prev = 'lc='.l:line[l:start : l:prev_start - 2]

    let query = 'words?'.prev.'&'.partial

    echom query
    silent execute(':!curl -s "https://api.datamuse.com/'.query.'" | jq "." >'.fileout)
    let l:data = json_decode(join(readfile(fileout)))

    " Record what matches − pass this to complete() later
    let l:res = []

    " Find matches
    for m in l:data
        " Check if it matches what we're trying to complete; in this case we
        " want to match against the start of both the first and second list
        " entries (i.e. the name and email address)
        " for this dict.

        call add(l:res, {
            \ 'icase': 1,
            \ 'word': l:m['word'],
            \ 'menu': l:m['score'],
        \ })
        endfor

    " Now call the complete() function
    call complete(l:prev_start + 1, l:res)
    return ''
endfun

inoremap <buffer> <C-x><C-x> <C-r>=CallCompleteApi()<cr>


" Custom complete function ------------------- {{{
fun! CallCompleteApi2()
    " vim autosuggest using cosine similarity matrix
    " - assumed that ubuntu / unix system is running and python sklearn, numpy
    "   are installed
    let fileout = $HOME.'/.vim_runtime/iGotAGlue/found'
    " a can be an arg, but for now, we want this function to be simple
    let l:partial_start = col('.') - 1

    """ GET PARTIAL
    let l:line = getline('.')
    while l:partial_start > 0 && l:line[l:partial_start - 1] =~ '\a'
        let l:partial_start -= 1
    endwhile
    " append start of words to list
    " a can be an arg, but for now, we want this function to be simple
    let partial = l:line[l:partial_start : col('.')-1]
    """
    echom 'partial '.partial

    """ MOVE TO ABOVE
    let cursor_pos = getpos('.')
    let l:start_origin = col('.')
    normal! k$

    """ GET RHYMING ABOVE
    echohl None
    let l:line = getline('.')
    " Locate the start of the word and store the text we want to match in l:base
    let l:row = line('.')
    " Add multiple l:start as multiple word arguments
    let l:start = col('.')
    echom 'row '.l:row
    echom 'start '.l:start

    " append start of words to list
    " a can be an arg, but for now, we want this function to be simple
    let l:start -= 1
    while l:start > 0 && l:line[l:start] =~ '\a'
        let l:start -= 1
        echom l:start
    endwhile

    echom 'start2 '.l:start

    echom col('.')-1

    let l:word_on_row_above = l:line[l:start : col('.')]
    echom l:word_on_row_above

    echom 'partial '.partial
    "word on line above
    echom ":!python3 ./iGotAGlue/cli.py -p ".partial." ".l:word_on_row_above

    if empty(partial)
        silent execute(":!python3 ./iGotAGlue/cli.py ".l:word_on_row_above)
    else
        silent execute(":!python3 ./iGotAGlue/cli.py -p ".partial." ".l:word_on_row_above)
        let l:start_origin=l:partial_start "override
    endif

    let l:data = json_decode(join(readfile(fileout)))

    call setpos('.', cursor_pos)
    " Record what matches − pass this to complete() later

    let l:res = []

    " Find matches
    for m in l:data
        if !(l:m['word'] =~ "^".partial.".*")
            continue
        endif
        " Check if it matches what we're trying to complete; in this case we
        " want to match against the start of both the first and second list
        " entries (i.e. the name and email address)
        " for this dict.

        call add(l:res, {
            \ 'icase': 1,
            \ 'word': l:m['word'],
            \ 'menu': l:m['sim'].':'.l:m['count']
        \ })
        endfor

    if empty($partial)
        " Now call the complete() function
        call complete(l:start_origin + 1, l:res)
    else
        call complete(l:start_origin + 1, l:res)
        echom "partial nonempty"
    endif
    return ''
endfun
" --- }}}

inoremap <buffer> <C-x><C-r> <C-r>=CallCompleteApi2()<cr>
