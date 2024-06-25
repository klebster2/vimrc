local ls = require("luasnip")

local types = require "luasnip.util.types"
if not types then return end

--- $HOME/.config/nvim/snippets/
require("luasnip.loaders.from_vscode").load({
    include = {
      "awk",
      "c",
      "javascript",
      "json",
      "markdown",
      "python",
      "sh",
      "yaml"
    }
})

ls.config.set_config({
    history = true, -- keep around the last snippet local to jump back
    updateevents = "TextChanged,TextChangedI", -- update changes as you type
    enable_autosnippets = true,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { {"●", "GruvboxOrange" } },
        },
      },
    },
})

--- <c-k> snippet expansion / jump key (up/prev)
vim.keymap.set({"i", "s"}, "<c-k>", function ()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {silent=true})

--- <c-j> snippet expansion / jump key (down/next)
vim.keymap.set({"i", "s"}, "<c-j>", function ()
  if ls.expand_or_jumpable() then
    ls.jump(-1)
  end
end, {silent=true})

--- <c-l> can be used for selecting an option within a list of options
vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
