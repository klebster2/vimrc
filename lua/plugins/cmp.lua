return {
	"hrsh7th/nvim-cmp",
	dependencies = { -- lsp configuration for linting, etc.
		"neovim/nvim-lspconfig",
		"onsails/lspkind-nvim",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"octaltree/cmp-look",
		"saadparwaiz1/cmp_luasnip",
		"nvim-lua/plenary.nvim",
		"L3MON4D3/LuaSnip", -- snippets for completion see https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip and luasnip ( $HOME/.config/nvim/snippets )
		"rafamadriz/friendly-snippets",
		--"klebster2/wordnet-cmp",
	},
	lazy = false,
	config = function()
		vim.g.wn_cmp_language = "en"
		local cmp = require("cmp")
		if not cmp then
			return
		end
		local luasnip = require("luasnip")
		if not luasnip then
			return
		end
		local lspconfig = require("lspconfig")
		if not lspconfig then
			return
		end
		local lspkind = require("lspkind")
		if not lspkind then
			return
		end
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		if not cmp_nvim_lsp then
			return
		end
		local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
		--- Use an on_attach function to only map the following keys
		--- after the language server attaches to the current buffer

		--- Works with 'Consolas NF' & 'DroidSansMono Nerd Font Mono'
		local lsp_symbols = {
			Text = "   TEXT",
			Method = "   METH",
			Function = "   FUNC",
			Constructor = "   CONSTR",
			Field = " ﴲ  FIELD",
			Variable = "[] VAR",
			Class = "   CLASS",
			Interface = " ﰮ  INTERF",
			Module = "   MOD",
			Property = " 襁 PROP",
			Unit = "   UNIT",
			Value = "   VALUE",
			Enum = " 練 ENUM",
			Keyword = "   KEYW",
			Snippet = "   SNIP",
			Color = "   COLOR",
			File = "   FILE",
			Reference = "   REF",
			Folder = "   FOLDER",
			EnumMember = "   ENUMMEM",
			Constant = " ﲀ  CONST",
			Struct = " ﳤ  STRUCT",
			Event = "   EVENT",
			Operator = "   OPER",
			TypeParameter = "   TYPE",
			Copilot = "   COPILOT",
			cmp_tabnine = "   TABNINE",
			wordnet = "  WORDNET",
		}

		--- Window options
		local window = {
			documentation = cmp.config.window.bordered({
				border = { "╭", "╍", "╮", "│", "╯", "╍", "╰", "│" },
				winhighlight = "Normal:MyPmenu,FloatBorder:MyPmenu,CursorLine:MyPmenuSel,Search:None",
				side_padding = 0,
				col_offset = 1,
			}),
			completion = cmp.config.window.bordered({
				border = "none",
				winhighlight = "Normal:MyPmenu,FloatBorder:MyPmenu,CursorLine:MyPmenuSel,Search:None",
				side_padding = 0,
				col_offset = -1,
			}),
		}

		local kind_mapper = cmp.lsp.CompletionItemKind
		kind_mapper.Copilot = 25
		kind_mapper.wordnet = 26

		--- Set configuration for specific filetype.
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}, {
				{ name = "look" },
			}),
		})

		cmp.setup.cmdline("./", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		-- Setup for README.md files:
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = window,
			experimental = { ghost_text = true, native_menu = false },
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4), --- Mnemonic - back
				["<C-f>"] = cmp.mapping.scroll_docs(4), --- Mnemonic - forward
				["<C-e>"] = cmp.mapping.abort(), --- Mnemonic - escape
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				["<C-y>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				}),
				["<C-Space>"] = cmp.mapping.complete({ select = true }),
			}),
			sources = {
				{ name = "copilot", max_item_count = 10, priority = 10 },
				{ name = "wordnet", max_item_count = 10, priority = 10, keyword_length = 4 },
				{ name = "cmp_tabnine", max_item_count = 10, priority = 10 },
				{ name = "nvim_lua", max_item_count = 10, priority = 5 },
				{ name = "luasnip", max_item_count = 2, priority = 5 },
				{ name = "treesitter", max_item_count = 10, priority = 5 },
				{ name = "nvim_lsp", max_item_count = 10, priority = 5 },
				{ name = "path", max_item_count = 10, priority = 4, keyword_length = 2 },
				{ name = "cmdline", max_item_count = 3, priority = 3, keyword_length = 4 },
				{
					name = "spell", --- check $HOME/.config/nvim/lua/options.lua
					option = {
						keep_all_entries = false,
						enable_in_context = function()
							return true
						end,
						preselect_correct_word = true,
					},
					max_item_count = 3,
					priority = 3,
					keyword_length = 6,
				},
			},
			formatting = {
				fields = {
					cmp.ItemField.Menu,
					cmp.ItemField.Abbr,
					cmp.ItemField.Kind,
				},
				format = function(entry, vim_item)
					-- if you have lspkind installed, you can use it like
					-- in the following line:
					-- FIXME this is a hack, find a better way to do this
					-- --- First check Copilot and cmp_tabnine are not the source
					if
						entry.source.name == "copilot"
						or entry.source.name == "wordnet"
					then
						if entry.source.name == "copilot" then
							vim_item.kind = "   COPILOT"
						else
							vim_item.kind = "暈WORDNET"
						end
					else
						vim_item.kind = string.format(
							"%s %s",
							(lsp_symbols[vim_item.kind] or "?"),
							(lspkind.presets.default[vim_item.kind] or "?")
						)
					end
					vim_item.menu = ({
						copilot = "", -- Copilot
						cmp_tabnine = "",
						nvim_lua = "", -- lua engine
						luasnip = "", -- snippets engine
						nvim_lsp = "", -- local context
						treesitter = "", -- treesitter ( $HOME/.config/nvim/lua/plugins/treesitter.lua )
						path = "ﱮ",
						buffer = "﬘",
						spell = "暈",
						wordnet = "暈",
					})[entry.source.name]
					return vim_item
				end,
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					require("copilot_cmp.comparators").prioritize, -- Requires Copilot
					require("cmp_tabnine.compare"), -- Requires tabnine
					cmp.config.compare.recently_used,
					cmp.config.compare.offset,
					cmp.config.exact,
					cmp.config.score,
					cmp.config.recently_used,
					cmp.config.locality,
				},
			},
		})
		--- Also see $HOME/.config/nvim/lua/plugins/gruvbox.lua
		--- Colors for cmp (matching gruvbox)
		vim.api.nvim_set_hl(0, "CmpItemMenuCopilot", { fg = "#fe8019" })
		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#d3869b" })
		vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#bdae93" })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#fbf1c7" })
		vim.api.nvim_set_hl(0, "CmpItemAbbrFuzzy", { fg = "#f9f5d7", bg = "#bdae93" })
		vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#8ec07c" })
		vim.api.nvim_set_hl(0, "MyPmenuSel", { fg = "#282828", bg = "#fe8019" })
	end,
}
