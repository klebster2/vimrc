
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
set thesaurus+=~/.vim_runtime/thesaurus/thesaurus-no-names.txt

" ---- }}}
" Custom complete function ------------------- {{{
fun! CallDataMuseCompleteApi()
    " vim autosuggest using datamuse api and curl
    " - assumed ubuntu / unix system is running and curl is installed
    let l:api = 'datamuse'
    let fileout = $HOME.'/.vim_runtime/apis/'.l:api.'/response.json'

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')
    " a can be an arg, but for now, we want this function to be simple
    let l:start = col('.') - 1

    while l:start > 0 && l:line[l:start - 1] =~ '\S'
        let l:start -= 1
    endwhile
    " append start of words to list

    " a can be an arg, but for now, we want this function to be simple
    let l:prev_start = l:start
    let l:start -= 1
    while l:start > 0 && l:line[l:start - 1] =~ '\S'
        let l:start -= 1
    endwhile

    let partial = 'sp='.l:line[l:prev_start : col('.')-1].'*'
    let prev = 'lc='.l:line[l:start : l:prev_start - 2]

    let query = 'words?'.prev.'&'.partial

    silent execute(':!curl -s "https://api.datamuse.com/'.query.'" | jq "." >'.fileout)
    let l:data = json_decode(join(readfile(fileout)))

    " Record what matches − pass this to complete() later
    let l:res = []

    " Find matches in the same time . up
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

" Custom thesarus function ------------------- {{{
fun! CallCompleteApiFastText()
    " docstring --- {{{ vim autosuggest using datamuse api and curl
    " - assumed ubuntu / unix system is running and curl is installed, and
    " - fasttext_fastapi has been installed:
    "   "https://github.com/klebster2/fasttext_fastapi"
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

    let fileout = $HOME.'/.vim_runtime/apis/'.api.'/response.json'
    "let l:script = $HOME.'/.vim_runtime/fasttext_neighbors.py'
    "let l:model_file = $HOME.'/.vim_runtime/fastText/cc.en.100.bin'

    let l:endpoint = '"http://0.0.0.0:8080/get_word_neighbors/"'
    let l:content_type_header = '"Content-Type:application/json" '

    let l:data = "'{\"word\":\"".l:query_word."\",\"neighbors\":100}'"
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

    " Now call the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun

" Custom GPT-3 complete function ------------------- {{{
fun! CallGPT3()
    let l:api = 'gpt'
    " vim autosuggest using gpt3 api and curl
    " assumed ubuntu / unix system is running and curl is installed

    let fileout = $HOME.'/.vim_runtime/apis/'.l:api.'/response.json'
    let l:script = $HOME.'/.vim_runtime/call_gpt3.sh'

    " let l:script = $HOME.'/.vim_runtime/fasttext_neighbors.py'
    " let l:model_file = $HOME.'/.vim_runtime/fastText/cc.en.100.bin'

    echom ':!'.l:script.' | jq . > '.fileout
    silent execute(':!'.l:script.' | jq . > '.fileout)
    " Record what matches − pass this to complete() later
    "
    let l:res = []

    let l:data = json_decode(join(readfile(fileout)))

    let l:start = col('.') - 1
    silent execute(':!rm '.$HOME.'/.vim_runtime/apis/gpt/prompt')

    for m in l:data["choices"]
    " Check if it matches what we're trying to complete; in this case we
    " want to match against the start of both the first and second list
    " entries (i.e. the name and email address)
    " forq this dict.
        call add(l:res, {
               \ 'icase': 1,
               \ 'word': l:m['text'],
               \ 'menu': l:m['index'].':'.l:m['finish_reason'],
           \ })
        endfor

    " Now call the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun

" returns max about 2 words, works for very common completions
inoremap <C-x><C-d> <C-r>=CallDataMuseCompleteApi()<cr>
" returns a thesarus like set of prompts
inoremap <C-x><C-x> <C-r>=CallCompleteApiFastText()<cr>
" append completions
xnoremap <leader>gtt may:!rm $HOME/.vim_runtime/apis/gpt/prompt<cr>:vs $HOME/.vim_runtime/apis/gpt/prompt<cr>p:%s/^["' \s]+//g<cr>:%s/["' \s]+$//g<cr>:wq<cr>`a
" returns a set of completions
inoremap <C-x><C-g><C-g> <C-r>=CallGPT3()<cr>


" Vim is a beast, vim in the east
" vim in the west, vim is the best
"
" Write a line about how good vim is
"
" " Vim is a beast, vim in the east
" vim in the west, vim is the best
"
" No path found
" hey there"
" datamuse is almost ready 
" No path found
" hey there
" muses abuse


