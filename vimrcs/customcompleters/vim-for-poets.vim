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
" rhyme

" Custom VimPoet function 'RhymeWord' ------------------- {{{
fun! RhymeWord(...)
    " a:1 path to dictionary
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
    " Now call the complete()
    call complete(l:word_start + 1, l:res)
    return ''
endfun
" }}}

" Custom VimPoet functionary 'DefineWord' ------------------- {{{
fun! DefineWord(...)
    " a:1 is the fullpath to wikidict directories e.g. "/home/user/wiktionary-dictionary/"
    let l:start_query_word = GetWordUnderCursor()
    let l:word_start = l:start_query_word[0]
    let l:query_word = l:start_query_word[1]
    let l:search_glob = a:1.l:query_word[0:1]."/".l:query_word."*.json"
    echom l:search_glob
    " globular

    " Record what match − we can passing this to complete() later
    let l:res = []
    let l:filelistlen = split(glob(l:search_glob))
    for l:word_json in l:filelistlen
        if match(l:word_json, "\/.*".query_word.".*\.json") >= 0
            let l:local_res = ""

            let l:word_found = substitute(l:word_json, '/.*/\(.*\)\.\d*\.json', '\1', '')
            let l:word_data = json_decode(join(readfile(l:word_json, '')))


            let l:pos = l:word_data['pos'] is v:null ? '' : l:word_data['pos']
            while strlen(l:pos) < 11 " just a heuristic (most pos won't be larger than this afaik)
                let l:pos = l:pos.' '
            endwhile

            if l:word_data['etymology_text'] is v:null
                let l:etymology_text_word = ''
            else
                let l:etymology_text_formatted = ''
                let l:etymology_text_word = substitute(l:word_data['etymology_text'], '\m\%u200e', '', '')
            endif

            let l:menu = l:etymology_text_word is v:null ? l:pos.'  ' : l:pos.'  '.l:etymology_text_word

            call add(l:res, {
            \ 'icase': 1,
            \ 'word': substitute(l:word_found, '_', ' ', 'g'),
            \ 'abbr': substitute(l:word_found, '_', ' ', 'g'),
            \ 'menu': l:menu,
            \ 'info': l:word_data['etymology_text'] is v:null ? '' : l:word_data['etymology_text'],
            \ })
        endif
    endfor
    " Now call the complete() function
    call complete(l:word_start + 1, l:res)
    return ''
endfun
" }}}
" minute
inoremap <C-x><C-r> <C-r>=RhymeWord("/home/kleber/k2Britfone/britfone.main.3.1.1.csv", ', ')<cr>

" Map <C-x><C-m> for our custom completion
inoremap <C-x><C-x><C-d> <C-r>=DefineWord("/home/kleber/wiktionary-dictionary/en/")<CR>

" Make subsequent <C-m> presses after <C-x><C-m> go to the next entry (just like otherwise <C-x>* mappings)
inoremap <expr> <C-m> pumvisible() ?  "\<C-n>" : "\<C-m>"

" Complete function for addresses; we match the name & address
" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new line.
inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
