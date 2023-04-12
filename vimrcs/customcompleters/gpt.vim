function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\\n")
endfunction

fun! CallCompleteApiGpt(...)
    " {{{ vim GPT3 suggestions }}}
    let l:api = 'gpt3'

    " Locate the start of the word and store the text we want to match in l:base
    let l:visual_selection_text_unsafe = s:get_visual_selection()
    let l:visual_selection_text = l:visual_selection_text_unsafe
    let l:gpt3_fileout = $HOME."/.vim_runtime/gpt3_out.json"
    " a can be an arg, but for now, we want this function to be simple
    " openai - oast openai set tokens:
    " openai - oasT openai set Temperature:
    let l:imports="'import openai, os;"
    let l:keypath='openai.api_key_path = "/home/kleber/.local/openai.api_key";'
    " let l:completion='result=openai.ChatCompletion.create(model="gpt-4-32k",messages=["'.l:visual_selection_text.'"'.", instruction='Make this more poetic']);"
    " result=openai.Completion.create(model="text-davinci-002", prompt=" -- hello, friend", max_tokens=200, temperature=0.8);
    let l:json='import json;open("'.l:gpt3_fileout.'", "w").write('."json.dumps(result))'"
    echom l:imports.l:keypath.l:completion.l:json
    echom ':!python -c '.l:imports.l:keypath.l:completion.l:json
    silent execute(":!python -c ".l:imports.l:keypath.l:completion.l:json)


    "let fileout = $HOME.'/.vim_runtime/'.api.'_response.json'
    "let l:script = $HOME.'/.vim_runtime/fasttext_neighbors.py'
    "let l:model_file = $HOME.'/.vim_runtime/fastText/cc.en.100.bin'

    "let l:endpoint = '"http://0.0.0.0:8080/get_word_neighbors/"'
    "let l:content_type_header = '"Content-Type:application/json" '

    "let l:data = "'{\"word\":\"".l:query_word."\",\"neighbors\":500,\"dropstrange\":true}'"
    "echom ':!curl POST '.l:endpoint.' -H '.l:content_type_header.' --data '.l:data
    "silent execute(':!curl POST '.l:endpoint.' -H '.l:content_type_header.' --data '.l:data.' > '.fileout)

    " Record what matches − pass this to complete() later
    "let l:res = []

    let l:data = json_decode(join(readfile(l:gpt3_fileout)))

    for c in l:data["choices"]
    " Record what matches − pass this to complete() later
    "        if !(m['neighbor'] =~ "^".l:query_word.".*")
    "            continue
    "        endif
        let l:results = [ getline('.') ]
        for l:line in split(c["text"],'\n')
            call add(l:results, l:line)
        endfor
        call setline('.', l:results)
    endfor
    echom l:data["created"]." ".l:data["model"]." completion_tok:".l:data["usage"]["completion_tokens"]." prompt_tok:".l:data["usage"]["prompt_tokens"]
    "
    " Check if it matches what we're trying to complete; in this case we
    " want to match against the start of both the first and second list
    " entries (i.e. the name and email address)
    " forq this dict.
    "    call add(l:res, {
    "        \ 'icase': 1,
    "        \ 'word': l:m['neighbor'],
    "        \ 'menu': l:m['score'],
    "    \ })
    "endfor

    " Now call the complete() function
    "call complete(l:start + 1, l:res)
    "return ''
endfun

vnoremap gt :<C-u>call CallCompleteApiGpt(200, 0.8)<CR>

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Your code is as poetic as a grocery list,
" as elegant as a stack of dirty dishes,
" as beautiful as a pile of garbage.
"
" And it's as poetic as a child's scribbles,
" and as elegant as a cheap knock-off,
" and as beautiful as a broken mirror.
