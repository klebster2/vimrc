" Custom thesarus function ------------------- {{{
fun! CallCompleteApiFastText()
    " {{{ vim fasttext suggestions
    " assumed ubuntu / unix system is running and curl is installed, and
    " fasttext_fastapi has been installed:
    " run using  "https://github.com/klebster2/fasttext_fastapi"
    " }}}
    let l:api = 'fasttext'

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')

    " a can be an arg, but for now, we want this function to be simple
    let l:start = col('.') - 1
    while l:start > 0 && l:line[l:start - 1] =~ '\S'
        let l:start -= 1
    endwhile
    " append start of words to list

    let l:query_word = l:line[l:start : col('.')-2]
    echom l:query_word

    let fileout = $HOME.'/.vim_runtime/'.api.'_response.json'
    "let l:model_file = $HOME.'/.vim_runtime/fastText/cc.en.100.bin'

    let l:endpoint = '"http://0.0.0.0:8080/get_word_neighbors/"'
    let l:content_type_header = '"Content-Type:application/json" '

    let l:data = "'{\"word\":\"".l:query_word."\",\"neighbors\":500,\"dropstrange\":true}'"
    echom ':!curl POST '.l:endpoint.' -H '.l:content_type_header.' --data '.l:data
    silent execute(':!curl POST '.l:endpoint.' -H '.l:content_type_header.' --data '.l:data.' > '.fileout)

    " Record what matches − pass this to complete() later
    let l:res = []

    let l:data = json_decode(join(readfile(fileout)))

    for m in l:data["neighbors_output"]
    " Record what matches − pass this to complete() later
    "        if !(m['neighbor'] =~ "^".l:query_word.".*")
    "            continue
    "        endif
    "
    " Check if it matches what we're trying to complete; in this case we
    " want to match against the start of both the first and second list
    " entries (i.e. the name and email address)
    " forq this dict.
        call add(l:res, {
            \ 'icase': 1,
            \ 'word': l:m['neighbor'],
            \ 'menu': l:m['score'],
        \ })
    endfor

    " Now say the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun

inoremap <C-x><C-w> <C-r>=CallCompleteApiFastText()<CR>
" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" -- hello, friend
