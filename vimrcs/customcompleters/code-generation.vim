" Custom thesarus function ------------------- {{{
fun! CallGenerationPredictionApi()
    " {{{ vim fasttext suggestions
    " assumed ubuntu / unix system is running and curl is installed, and
    " fasttext_fastapi has been installed:
    " run using  "https://github.com/klebster2/langtransformers_fastapi"
    " }}}
    let l:api = 'langtransformers'

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')

    " a can be an arg, but for now, we want this function to be simple
    " append start of words to list
    let l:query_word = l:line
    echom l:query_word

    let fileout = $HOME.'/.vim_runtime/'.api.'_response.json'

    let l:endpoint = '"http://0.0.0.0:8080/next_token_prediction/"'
    let l:content_type_header = '"Content-Type:application/json" '

    let l:data = "'{\"text\":\"".l:query_word."\",\"model\":\"Salesforce/codegen-350M-mono\""."}'"
    echom ':!curl POST '.l:endpoint.' -H '.l:content_type_header.' --data '.l:data
    silent execute(':!curl POST '.l:endpoint.' -H '.l:content_type_header.' --data '.l:data.' > '.fileout)

    " Record what matches − pass this to complete() later
    let l:res = []

    let l:data = json_decode(join(readfile(fileout)))
    echom l:data

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
        \ 'word': l:data['generated_text'],
        \ 'menu': '🤗',
    \ })

    " Now say the complete() function
    call complete(col('.'), l:res)
    return ''
endfun

inoremap <C-x><C-x><C-x> <C-r>=CallGenerationPredictionApi()<CR>
