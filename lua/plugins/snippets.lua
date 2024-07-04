local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- If you're reading this file for the first time, best skip to around line 190
-- where the actual snippet-definitions start.

-- Every unspecified option will be set to the default.
ls.setup({
	keep_roots = true,
	link_roots = true,
	link_children = true,
	update_events = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	ext_base_prio = 200,
	ext_prio_increase = 1,
	enable_autosnippets = true,
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

local function copy(args)
	return args[1]
end

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

ls.add_snippets("all", {
	s("ls", f(bash, {}, { user_args = { "ls" } })),
	s("link_url", {
		t('<a href="'),
		f(function(_, snip)
			-- TM_SELECTED_TEXT is a table to account for multiline-selections.
			-- In this case only the first line is inserted.
			return snip.env.TM_SELECTED_TEXT[1] or {}
		end, {}),
		t('">'),
		i(1),
		t("</a>"),
		i(0),
	}),
	-- The nonempty-node inserts text depending on whether the arg-node is
	-- empty.
	s("nempty", {
		i(1, "sample_text"),
		n(1, "i(1) is not empty!"),
	}),
	-- dynamic lambdas work exactly like regular lambdas, except that they
	-- don't return a textNode, but a dynamicNode containing one insertNode.
	-- This makes it easier to dynamically set preset-text for insertNodes.
	s("dl1", {
		i(1, "sample_text"),
		t({ ":", "" }),
		dl(2, l._1, 1),
	}),
	-- Obviously, it's also possible to apply transformations, just like lambdas.
	s("dl2", {
		i(1, "sample_text"),
		i(2, "sample_text_2"),
		t({ "", "" }),
		dl(3, l._1:gsub("\n", " linebreak ") .. l._2, { 1, 2 }),
	}),
}, {
	key = "all",
})


-- tex
ls.add_snippets("tex", {
	-- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
	-- \item as necessary by utilizing a choiceNode.
	s("ls", {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_ls, {}),
		t({ "", "\\end{itemize}" }),
	}),
}, {
	key = "tex",
})

-- set type to "autosnippets" for adding autotriggered snippets.
ls.add_snippets("all", {
	s("autotrigger", {
		t("autosnippet"),
	}),
}, {
	type = "autosnippets",
	key = "all_auto",
})

for _, name in ipairs({"local", "var"}) do
	ls.add_snippets('lua', {
			s(name, c(1, {
						fmt('local {} = {}',  {
							i(1),
							i(2)
						}),
					fmt('{} = {}', {
							i(1),
							i(2)
						})
				})
			)
	})
end
--- luasnippets for lua
ls.add_snippets('lua', {
		s('require', {t('require'),
				t('('),
				i(1, '"module"'),
				t	(')')
			})
})
ls.add_snippets('lua', {
		s('require', fmt('local {} = require("{}")', {
					f(function(values)
						local value = values[1][1]
						local path = vim.split(value, '%.')
						return path[#path]
					end, { 1 }),
				i(1)
		}))
})

local lua_func_template = [[
-- {}{}
-- @returns {}
function {}({})
	return {}
end
]]

ls.add_snippets('lua', {
		s(
			'ii', fmt(lua_func_template, {
		i(1, 'function'),
		d(4, function(values)
			local param_str = values[1][1]
			param_str = param_str:gsub(' ', '')
			if param_str == '' then
				return sn(1, { t('') })
			end
			local params = vim.split(param_str, ',')
			local nodes = {}

			for index, param in ipairs(params) do
				table.insert(nodes, sn(index, fmt('\n\n-- @param {} {} {}', {
					t(param),
					i(1, 'any'),
					i(2, 'description'),
				})))
			end
			return sn(nil, nodes)
		end, { 3 }),
		i(2, 'returnValue'),
		rep(1),
		i(3, 'params'),
		rep(2),
		}))
})

local pep_484_numpy_python_func_template = [[
def {}({}) -> {}:
    """{}

		Parameters
		----------
		{}

		Raises
		------
		{}
				{}

		{}
		{}
				{}

		Examples
		--------
		>>> {}
		{}
		"""
		{}
]]

local pep_484_numpy_python_method_template = [[
    def {}(self, {}) -> {}:
				"""{}

				Parameters
				----------
				{}

				Raises
				------
				{}
						{}

				{}
				{}
						{}

				Examples
				--------
				>>> {}
				{}
				"""
				{}
]]

local pep_484_numpy_python_class_template = [[
class {}:
  """{}

  Attributes
  ----------
  {}
  """
  def __init__(self, {}):
  	"""{}

   	Parameters
 	----------
    {}
    """
    {}
]]


ls.add_snippets('python', {
	s(
		'pdb', t('import pdb; pdb.set_trace()')
	),
	s(
		'__main__', t({'if __name__	== "__main__":', "" })
	),
  s(
		'def(function)',	fmt(pep_484_numpy_python_func_template, {
				i(1, 'function_name'),
				i(2, 'args'),
				i(3, 'returnType'),
				i(4, 'Description'),
				d(5, function(values)
					local param_str = values[1][1]
					if param_str == '' then
						return sn(1, { t('') })
					end
					local params = vim.split(param_str, ',')
					local nodes = {}
					for index, param in ipairs(params) do
						local _param_str = param:gsub('^ ', '')
						table.insert(nodes, sn(index, fmt('\n\n:param {} {}:\n{}', {
							t(_param_str),
							i(1, 'type'),
							i(2, 'description'),
						})))
					end
					return sn(nil, nodes)
				end, { 2 }),
				i(6, 'Exception'),
				i(7, 'exceptionDescription'),
				c(8, {
					t({'Returns', '-------'}),
					t({'Yields', '------'}),
				}),
			  rep(3),
				i(9, 'returnDescription'),
			  i(10, 'ExampleCode'),
				i(11, 'ExampleOutput'),
			  i(12, 'pass')})),
  s(
		'def(method)',	fmt(pep_484_numpy_python_method_template, {
				i(1, 'function_name'),
				i(2, 'args'),
				i(3, 'returnType'),
				i(4, 'Description'),
				d(5, function(values)
					local param_str = values[1][1]
					if param_str == '' then
						return sn(1, { t('') })
					end
					local params = vim.split(param_str, ',')
					local nodes = {}
					for index, param in ipairs(params) do
						local _param_str = param:gsub('^ ', '')
						table.insert(nodes, sn(index, fmt('\n\n:param {} {}:\n{}', {
							t(_param_str),
							i(1, 'type'),
							i(2, 'description'),
						})))
					end
					return sn(nil, nodes)
				end, { 2 }),
				i(6, 'Exception'),
				i(7, 'exceptionDescription'),
				c(8, {
					t({'Returns', '-------'}),
					t({'Yields', '------'}),
				}),
			  rep(3),
				i(9, 'returnDescription'),
			  i(10, 'ExampleCode'),
				i(11, 'ExampleOutput'),
			  i(12, 'pass')})),
			s(
				'class',	fmt(pep_484_numpy_python_class_template, {
						i(1, 'ClassName'),
						i(2, 'Description'),
						i(3, 'Attributes'),
						i(4, 'args'),
						i(5, 'Description'),
						d(6, function(values)
							local param_str = values[1][1]
							if param_str == '' then
								return sn(1, { t('') })
							end
							local params = vim.split(param_str, ',')
							local nodes = {}
							for index, param in ipairs(params) do
							local _param_str = param:gsub('^ ', '')
							table.insert(nodes, sn(index, fmt('\n\n    :param {} {}:\n    {}', {
								t(_param_str),
								i(1, 'type'),
								i(2, 'description'),
							}))
							)
							end
							return sn(nil, nodes)
						end, { 4 }),
						i(7, 'pass')})),
})


ls.filetype_extend("cpp", { "c" })
-- Beside defining your own snippets you can also load snippets from "vscode-like" packages
-- that expose snippets in json files, for example <https://github.com/rafamadriz/friendly-snippets>.

require("luasnip.loaders.from_vscode").load({ include = { "python" } }) -- Load only python snippets

-- The directories will have to be structured like eg. <https://github.com/rafamadriz/friendly-snippets> (include
-- a similar `package.json`)
--require("luasnip.loaders.from_vscode").load({ paths = { "./my-snippets" } }) -- Load snippets from my-snippets folder

-- You can also use lazy loading so snippets are loaded on-demand, not all at once (may interfere with lazy-loading luasnip itself).
require("luasnip.loaders.from_vscode").lazy_load() -- You can pass { paths = "./my-snippets/"} as well

-- You can also use snippets in snipmate format, for example <https://github.com/honza/vim-snippets>.
-- The usage is similar to vscode.

-- One peculiarity of honza/vim-snippets is that the file containing global
-- snippets is _.snippets, so we need to tell luasnip that the filetype "_"
-- contains global snippets:
ls.filetype_extend("all", { "_" })

--require("luasnip.loaders.from_snipmate").load({ include = { "c" } }) -- Load only snippets for c.

-- Load snippets from my-snippets folder
-- The "." refers to the directory where of your `$MYVIMRC` (you can print it
-- out with `:lua print(vim.env.MYVIMRC)`.
-- NOTE: It's not always set! It isn't set for example if you call neovim with
-- the `-u` argument like this: `nvim -u yeet.txt`.
--require("luasnip.loaders.from_snipmate").load({ path = { "./my-snippets" } })
-- If path is not specified, luasnip will look for the `snippets` directory in rtp (for custom-snippet probably
-- ~/.config/nvim/snippets ).

require("luasnip.loaders.from_snipmate").lazy_load() -- Lazy loading

-- see DOC.md/LUA SNIPPETS LOADER for some details.
require("luasnip.loaders.from_lua").lazy_load({ include = { "all", "cpp", "c", "python" } })
