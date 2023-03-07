function! ScoreLessThan(leftArg, rightArg)
  if a:leftArg['menu'] == a:rightArg['menu']
    return 0
  elseif a:leftArg['menu'] < a:rightArg['menu']
    return -1
  else
    return 1
  endif
endfunction

" Custom thesarus function ------------------- {{{
fun! CallCompleteApiDataMuseLhs()
    " {{{ 
    " This makes use of the datamuse API
    " A long standing API
    " }}}
    let l:model = "en-70k-0.2-pruned.lm"
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

    let l:endpoint = '"https://api.datamuse.com/words?rel_jjb='.l:query_word.'"'
    let l:cmd1 = 'curl --silent '.l:endpoint."| jq -c "."'[.[]+{".'"type'.'"'.':"'.'bgb"}]'."'"

    let l:endpoint = '"https://api.datamuse.com/words?rel_bgb='.l:query_word.'"'
    let l:cmd2 = 'curl --silent '.l:endpoint."| jq -c "."'[.[]+{".'"type'.'"'.':"'.'jjb"}]'."'"

    let l:cmd = "cat <(".l:cmd1.") <(".l:cmd2.") | jq '.' -c --raw-output | python lm.py '".l:query_word."'"." '".l:model."' 2>/dev/null"
    echom l:cmd

    " rewrite the above as lua vim
    let l:subbed_cmd = substitute(system(l:cmd), '\n\+$', '', '')

    " Record what matches − pass this to complete() later
    let l:data = json_decode(l:subbed_cmd)


    let l:first_entry_bgb = 0
    let l:first_entry_jjb = 0

    for m in l:data
        " Record what matches − pass this to complete() later
        " if !(m['neighbor'] =~ "^".l:query_word.".*")
        "     continue
        " endif
        "
        " Check if it matches what we're trying to complete; in this case we
        " want to match against the start of both the first and second list
        " entries (i.e. the name and email address)
        " for this dict.

        " echom l:first_entry_jjb

        if (l:m["type"] == "jjb")
            call add(l:unsorted, {
                \ 'icase': 1,
                \ 'word': l:m['word']." ".l:query_word,
                \ 'menu': l:m['perplexity_str'],
                \ 'kind': ' ﲳ '.l:model,
                \ 'type': l:m["type"],
            \ })
        elseif (l:m["type"] == "bgb")
            call add(l:unsorted, {
                \ 'icase': 1,
                \ 'word': l:m['word']." ".l:query_word,
                \ 'menu': l:m['perplexity_str'],
                \ 'kind': ' ﲳ '.l:model,
                \ 'type': l:m["type"],
            \ })
        endif

    endfor
    " Now say the complete() function
    call complete(l:start + 1, l:unsorted)
    return ''
endfun

fun! CallCompleteApiDataMuseRhs()
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

    " convert the above code into lua vim:

    let l:endpoint = '"https://api.datamuse.com/words?rel_jja='.l:query_word.'"'
    let l:cmd1 = 'curl --silent '.l:endpoint."| jq "."'[.[]+{".'"type'.'"'.':"'.'bga"}]'."'"

    let l:endpoint = '"https://api.datamuse.com/words?rel_bga='.l:query_word.'"'
    let l:cmd2 = 'curl --silent '.l:endpoint."| jq "."'[.[]+{".'"type'.'"'.':"'.'jja"}]'."'"

    let l:cmd = "cat <(".l:cmd1.") <(".l:cmd2.") | jq -s '[.[][]]'"

    let l:subbed_cmd = substitute(system(l:cmd), '\n\+$', '', '')
    " Record what matches − pass this to complete() later
    let l:data = json_decode(l:subbed_cmd)

    let l:first_entry_bga = 0
    let l:first_entry_jja = 0

    for m in l:data
        echom l:m
        " Record what matches − pass this to complete() later
        " if !(m['neighbor'] =~ "^".l:query_word.".*")
        "     continue
        " endif
        "
        " Check if it matches what we're trying to complete; in this case we
        " want to match against the start of both the first and second list
        " entries (i.e. the name and email address)
        " for this dict.

        if (l:m["type"] == "jja")
            if (l:first_entry_jja == 0)
                let l:first_entry_jja = l:m["score"]
            endif
            call add(l:unsorted, {
                \ 'icase': 1,
                \ 'word': l:query_word." ".l:m['word'],
                \ 'menu': (l:m['score']*100 / l:first_entry_jja),
                \ 'kind': 'ﲳ',
                \ 'type': l:m["type"],
            \ })
        elseif (l:m["type"] == "bga")
            if (l:first_entry_bga == 0)
                let l:first_entry_bga = l:m["score"]
            endif
            call add(l:unsorted, {
                \ 'icase': 1,
                \ 'word': l:query_word." ".l:m['word'],
                \ 'menu': (l:m['score']*100 / l:first_entry_bga),
                \ 'kind': 'ﲳ',
                \ 'type': l:m["type"],
            \ })
        endif

    endfor
    call sort(l:unsorted, function("ScoreLessThan"))
    let l:res2 = []
    for m in l:unsorted
        call add(l:res2, {
            \ 'icase': 1, 
            \ 'word': l:m['word'], 
            \ 'menu': ( l:m["type"] == "jja" ? l:m['menu']." "."Adj ➜ Noun" : l:m['menu']." "."Collocation"),
            \ 'kind': l:m['kind'],
        \ })
    endfor


    " Now say the complete() function
    call complete(l:start + 1, reverse(l:res2))
    return ''
endfun

" h is for 'left'
inoremap <C-x><C-h> <C-r>=CallCompleteApiDataMuseLhs()<CR>
" l is for 'right'
inoremap <C-x><C-l> <C-r>=CallCompleteApiDataMuseRhs()<CR>
" convert the above code (including all functions) to lua
" hello goodbye
" say goodbye before
