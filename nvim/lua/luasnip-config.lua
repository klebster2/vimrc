local ls = require("luasnip")
USER = vim.fn.expand('$USER')

-- $HOME/.config/nvim/snippets/
vim.o.runtimepath = vim.o.runtimepath..'~/.vim_runtime/nvim/snippets/'
require("luasnip.loaders.from_vscode").load({
    include = { "python", "c", "sh", "markdown", "json", "yaml" }
})
-- require('luasnip').filetype_extend("markdown")

ls.config.set_config({
    history = true, -- keep around the last snippet local to jump back
    updateevents = "TextChanged,TextChangedI", -- update changes as you type
    enable_autosnippets = true,
    ext_opts = {
      [require("luasnip.util.types").choiceNode] = {
        active = {
          virt_text = { {"●", "GruvboxOrange" } },
        },
      },
    },
})

-- Key Maps
vim.keymap.set({ "i", "s" }, "<a-p>", function()
  if ls.expand_or_jumpable() then
    ls.expand()
  end
end)

-- jump
vim.keymap.set({ "i", "s" }, "<a-k>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<a-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

-- cycle through choices in choice nodes
vim.keymap.set({ "i", "s" }, "<a-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<a-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)
