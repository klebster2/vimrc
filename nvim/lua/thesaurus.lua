--- First, find the current file root, thesaurus is three directories back, then inside dicts/theasaurus as thesaurus.txt
vim.api.nvim_exec([[
  set thesaurus+=$HOME/.vim_runtime/dicts/thesaurus/thesaurus-no-underscore-no-numbers-no-names.txt
]], true)  -- $HOME/.vim_runtime/dicts/thesaurus/thesaurus.txt
-- By manually using <ctrl+w><ctrl+t> in normal mode, you can look up the word under the cursor in the thesaurus
-- in the future, I should look up the thesaurus command in the help docs
vim.api.nvim_exec([[
  func Thesaur(findstart, base)
    " supply input from $HOME/.vim_runtime/dicts/thesaurus/thesaurus-no-underscore-no-numbers-no-names.txt
    " Note! thesaurus is a csv file with occasional spaces
    if a:findstart
      return searchpos('\<', 'bnW', line('.'))[1] - 1
    endif

    for file in split(&thesaurus, ',')
      if filereadable(expand(file))
        let thesaurus = file
        break
      endif
    endfor

    let res = []

    for line in readfile(thesaurus)
      let parts = split(line, ',')
      let h = parts[0]
      let val = parts[1]
      if parts[0] ==# a:base
        let res = map(parts[1:], {_, val -> {'word': val, 'menu': '('..h..') [thesaurus.txt]'}})
        call extend(res, map(parts[1:], {_, val -> {'word': val, 'menu': '('..h..') [thesaurus.txt]'}}))
      endif

    endfor

    let h = ''
    for l in systemlist('aiksaurus ' .. shellescape(a:base))
      if l[:3] == '=== '
        let h = '(' .. substitute(l[4:], ' =*$', ') [Aiksaurus]', '')
      elseif l ==# 'Alphabetically similar known words are: '
        let h = "\U0001f52e"
      elseif l[0] =~ '\a' || (h ==# "\U0001f52e" && l[0] ==# "\t")
        call extend(res, map(split(substitute(l, '^\t', '', ''), ', '), {_, val -> {'word': val, 'menu': h}}))
      endif
    endfor
    return res
  endfunc

  if exists('+thesaurusfunc')
    set thesaurusfunc=Thesaur
  endif
]], true)
--- Requires aiksaurus -> To download, run: `sudo apt-get install aiksaurus -y`
