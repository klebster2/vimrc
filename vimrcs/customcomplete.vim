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

" Custom complete function ------------------- {{{
fun! CallCompleteApiFastText()
    " vim autosuggest using datamuse api and curl
    " - assumed ubuntu / unix system is running and curl is installed

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')

    " a can be an arg, but for now, we want this function to be simple
    let l:start = col('.') - 1
    while l:start > 0 && l:line[l:start - 1] =~ '\a'
        let l:start -= 1
    endwhile
    " append start of words to list


    let l:query_word = l:line[l:start : col('.')-1]

    let fileout = $HOME.'/.vim_runtime/assistive-writing-apis/fasttext_response.json'
    let l:script = $HOME.'/.vim_runtime/fasttext_neighbors.py'
    let l:model_file = $HOME.'/.vim_runtime/fastText/cc.en.100.bin'

    silent execute(':!/bigdrive/kleber/environments/spellchecker_fasttext/bin/python3 '.l:script.' '.l:model_file.' '.l:query_word.' > '.fileout)

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
            \ 'word': l:m['neighbor'],
            \ 'menu': l:m['score'],
        \ })
        endfor

    " Now call the complete() function
    call complete(l:start + 1, l:res)
    return ''
endfun

inoremap <buffer> <C-x><C-d> <C-r>=CallCompleteApi()<cr>
inoremap <buffer> <C-x><C-x> <C-r>=CallCompleteApiFastText()<cr>

