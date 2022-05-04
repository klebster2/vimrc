"function! SuperTab()
"  let l:part = strpart(getline('.'),col('.')-2,1)
"  if (l:part =~ '^\W\?$')
"      return "\<Tab>"
"  else
"      return "\<C-n>"
"  endif
"endfunction
"imap <Tab> <C-R>=SuperTab()<CR>

fun! GetWordUnderCursor(...)
    let l:start = col('.') - 1
    " Locate the start of the word
    let l:line = getline('.')
    " a can be an arg, but for now, we want this function to be simple
    while l:start > 0 && l:line[l:start - 1] =~ '\S'
        let l:start -= 1
    endwhile
    " append start of words to list
    let l:query_word = l:line[l:start : col('.')-2]
    return [l:start, l:query_word]
endfun

" Custom VimPoet functions 'RhymeWord' ------------------- {{{
fun! RhymeWord(...)
    " a:1 path to dict
    " a:2 is the separator between word (lhs) and pronunciation (rhs)
    let l:start_query_word = GetWordUnderCursor()
    let l:word_start = l:start_query_word[0]
    let l:query_word = l:start_query_word[1]

    " Record what matches − we can pass this to complete() later
    let l:res = []
    let l:PronunciationDict = readfile(a:1, '')
    let l:query_matches = []

    let l:stringtomatch = '^'.toupper(l:query_word).a:2.'.*'
    for l:pronunciation_line in l:PronunciationDict
        let l:pronunciation_line_no_digit = substitute(l:pronunciation_line, "([0-9]*)", '', '')
        let l:is_match = match( l:pronunciation_line_no_digit, l:stringtomatch )
        if l:is_match >= 0 
            call add(l:query_matches, split(l:pronunciation_line, a:2))
        endif
    endfor
    echom l:query_matches

    for l:query_match in l:query_matches
        let l:rhyming_part = substitute(l:query_match[1], '.*[ˈˌ]\(\([iuɑɔɜ]ː\|[iʊæɐɒəɛɪ]\|a[ɪʊ]\|[eɔ]ɪ\|əʊ\|[ɛɪʊ]ə\).*\)', '\1', 'g')
        
        for l:pronunciation_line in l:PronunciationDict
            let l:pronunciation_line_split = split(l:pronunciation_line, a:2)

            let l:word = l:pronunciation_line_split[0]
            let l:pronunciation = l:pronunciation_line_split[1]
            if match(l:pronunciation, l:rhyming_part.' \?$') >= 0
                call add(l:res, {
                    \ 'icase': 1,
                    \ 'word': tolower(substitute(l:word, "([0-9]*)", '', '')),
                    \ 'info': 'example info',
                \ })
            endif
        endfor
    endfor
    " Now call the complete() function
    call complete(l:word_start + 1, l:res)
    return ''
endfun
" }}}
inoremap <C-x><C-r> <C-r>=RhymeWord("/home/kleber/k2Britfone/britfone.main.3.1.1.csv", ', ')<cr>
