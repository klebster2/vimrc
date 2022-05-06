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

" Custom VimPoet functionary 'DefineWord' ------------------- {{{
" help
fun! DefineWord(...)
    " a:1 path to wikidict directories e.g. "/home/user/wiktionary-dictionary/"
    let l:start_query_word = GetWordUnderCursor()
    let l:word_start = l:start_query_word[0]
    let l:query_word = l:start_query_word[1]
    echom a:1
    let l:search_glob = a:1.l:query_word[0]."/*.json"
    echom l:search_glob

    " Record what matches − we can pass this to complete() later
    let l:res = []
    " todo add morpho lookback of ~3? for english
    for l:word_json in split(glob(l:search_glob))
        if match(l:word_json, "\/.*".query_word.".*\.json") >= 0
            let l:local_res = ""

            let l:word_found = substitute(l:word_json, '/.*/\(.*\).json', '\1', '')
            let l:word_data = json_decode(join(readfile(l:word_json, '')))

            let l:word_data['etymology_text']

            call add(l:res, {
            \ 'icase': 1,
            \ 'word': l:word_found,
            \ 'abbr': l:word_found,
            \ 'menu': l:word_data['pos'] is v:null ? '' : l:word_data['pos'],
            \ 'info': l:word_data['etymology_text'] is v:null ? '' : l:word_data['etymology_text'],
            \ })
        endif
    endfor
    " Now call the complete() functional
    call complete(l:word_start + 1, l:res)
    return ''
endfun
" }}}
" dealbreaker

" Map <C-x><C-m> for our custom completion
inoremap <C-x><C-m> <C-r>=MyComplete()<CR>

" Make subsequent <C-m> presses after <C-x><C-m> go to the next entry (just like
" other <C-x>* mappings)
inoremap <expr> <C-m> pumvisible() ?  "\<C-n>" : "\<C-m>"

" Complete function for addresses; we match the name & address
fun! MyComplete()
    " The data. In this example it's static, but you could read it from a file,
    " get it from a command, etc.
    let l:data = [
        \ ["Elmo the Elk", "daring@brave.com", "HELP ME"],
        \ ["Eek the Cat", "doesnthurt@help.com", "HEY FRIENDS"]
    \ ]

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')
    let l:start = col('.') - 1
    while l:start > 0 && l:line[l:start - 1] =~ '\a'
        let l:start -= 1
    endwhile
    let l:base = l:line[l:start : col('.')-1]

    " Record what matches − we pass this to complete() later
    let l:res = []

    " Find matches
    for m in l:data
        " Check if it matches what we're trying to complete; in this case we
        " want to match against the start of both the first and second list
        " entries (i.e. the name and email address)
        if l:m[0] !~? '^' . l:base && l:m[1] !~? '^' . l:base
            " Doesn't match
            continue
        endif

        " It matches! See :help complete() for the full docs on the key names
        " for this dict.
        call add(l:res, {
            \ 'icase': 1,
            \ 'word': l:m[0] . ' <' . l:m[1] . '>, ',
            \ 'abbr': l:m[0],
            \ 'menu': l:m[1],
            \ 'info': len(l:m) > 2 ? join(l:m[2:], "\n") : '',
        \ })
    endfor

    " Now call the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun
" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

