require('fzf-lua').setup{
  winopts = {
    hl = { border = "FloatBorder", normal = "IncSearch", }
  }
}
--- --vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
--- -- https://github.com/ibhagwan/fzf-lua/wiki/Advanced#example-1-live-ripgrep
--- require('fzf-lua').fzf_live(
---   function(q)
---     return "rg --column --colors 'match:bg:yellow' --color=always -- " .. vim.fn.shellescape(q or '')
---   end,
---   {
---     fn_transform = function(x)
---       return require('fzf-lua').make_entry.file(
--- 	x,
--- 	{file_icons=true, color_icons=true}
---     )
---     end,
---     fzf_opts = {
---       ['--delimiter'] = ':',
---       ['--preview-window'] = 'nohidden,down,60%,border-top,+{3}+3/3,~3',
---     },
---   }
--- )
