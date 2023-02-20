
local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep

ls.snippets = {
  lua = {
    ls.parser.parse_snippet("lf", "-- Defined in $TM_FILENAME\nlocal $1 = function($2)\n  $0\nend"),
  },
  python = {
    s(
      "meth", fmt("def {}(self, {}):\n    \"\"\"\n{}\"\"\"", {i(1, "default"), i(2, "default"), rep(2)})
    ),
  },
}
