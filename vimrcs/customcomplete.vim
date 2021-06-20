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

fun! CallCompleteApi(script, ...)
    let l:line = getline('.')
    let l:start = col('.')

    while l:start > 0 && l:line[l:start - 1] =~ '\a'
        let l:start -= 1
        echom l:start
    endwhile

    let l:base = l:line[l:start : col('.')-1]

    let l:res = []
    echom l:script

    execute 'silent !'.$HOME.a:script.' '.l:base.' &' | redraw!

    let l:data = readfile($HOME.a:1, '')
    echom l:data
    " Find matches
"    for m in l:data
        " Check if it matches what we're trying to complete; in this case we
        " want to match against the start of both the first and second list
        " entries (i.e. the name and email address)
        " match, see :help complete() for the full docs on the key names
        " for this dict.
"        call add(l:res, {
"            \ 'icase': 1,
"            \ 'word': l:m,
"            \ 'abbr': l:m,
"            \ 'menu': 'placeholder',
"            \ 'info': 'placeholder',
"        \ })
"    endfor

    " Now call the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun
":
"
"Custom phrase and proverb completion -------- {{{
inoremap <buffer> <C-x><C-p> <C-r>=MyComplete("/.vim_runtime/dicts/proverbs_and_common_phrases", 2)<CR>
" }}}
"inoremap <buffer> <C-x><C-s> <C-r>=CallCompleteApi("/.vim_runtime/searchrhymezone_api.sh", "/.vim_runtime/rhymezone_wordlist_pretty")
" }}}
