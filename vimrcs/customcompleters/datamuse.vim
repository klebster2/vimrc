fun! AddToList(unsorted_list, query_word, first_entry_value, word, side)
    if a:side == "a"
        let l:insertion = a:query_word." ".a:word['word']
    else
        let l:insertion = a:word['word']." ".a:query_word
    endif
    echom l:insertion
    call add(a:unsorted_list, {
        \ 'icase': 1,
        \ 'word': l:insertion,
        \ 'menu': (a:word['score']*100 / a:first_entry_value),
        \ 'kind': 'ﲳ',
        \ 'type': a:word["type"],
    \ })
    return a:unsorted_list
endfun

" Custom thesaurus function ------------------- {{{
fun! CallCompleteApiDataMuse(side)
    " {{{ 
    " This makes use of the datamuse API
    " A long standing API
    " }}}
    let l:api = 'datamuse'
    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')
    " can be an arg, but for now, we want this function to be simple
    let l:start = col('.') - 1
    while l:start > 0 && l:line[l:start - 1] =~ '\S'
        let l:start -= 1
    endwhile

    " initialise result list
    let l:unsorted = []
    " append start of words to list
    let l:query_word = l:line[l:start : col('.')-2]

    if a:side == "lhs"
        let l:side = "b"
    elseif a:side == "rhs"
        let l:side = "a"
    endif

    let l:endpoint = '"https://api.datamuse.com/words?rel_jj'.l:side.'='.l:query_word.'"'
    let l:cmd1 = 'curl --silent '.l:endpoint."| jq -c "."'[.[]+{".'"type'.'"'.':"'.'bg'.l:side.'"}]'."'"

    let l:endpoint = '"https://api.datamuse.com/words?rel_bg'.l:side.'='.l:query_word.'"'
    let l:cmd2 = 'curl --silent '.l:endpoint."| jq -c "."'[.[]+{".'"type'.'"'.':"'.'jj'.l:side.'"}]'."'"

    let l:cmd = "cat <(".l:cmd1.") <(".l:cmd2.") | jq -s '[.[][]]'"

    " Rewrite the above as lua vim
    let l:cmd_result = substitute(system(l:cmd), '\n\+$', '', '')
    " Record what matches − pass this to complete() later
    let l:data = json_decode(l:cmd_result)

    let l:first_entry_bg = 0
    let l:first_entry_jj = 0

    for m in l:data
        echom l:m
        if (l:m["type"] == "jj".l:side)
            if (l:first_entry_jj == 0)
                let l:first_entry_jj = l:m["score"]
            endif
            let l:unsorted =
                \ AddToList(l:unsorted, l:query_word, l:first_entry_jj, l:m, l:side)
        elseif (l:m["type"] == "bg".l:side)
            if (l:first_entry_bg == 0)
                let l:first_entry_bg = l:m["score"]
            endif
            let l:unsorted =
                \ AddToList(l:unsorted, l:query_word, l:first_entry_bg, l:m, l:side)
        endif
    endfor
    echom l:unsorted
    " Now run the complete() function
    call complete(l:start + 1, l:unsorted)
    return ''
endfun

" h is for call complete datamuse 'left'
inoremap <C-x><C-h> <C-r>=CallCompleteApiDataMuse("lhs")<CR>
" l is for call complete datamuse 'right'
inoremap <C-x><C-l> <C-r>=CallCompleteApiDataMuse("rhs")<CR>
" convert the above code (including all functions) to lua
