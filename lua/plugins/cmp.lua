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
		"tzachar/cmp-tabnine",
	},
	lazy = false,
	config = function()
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

		--- Fasttext fastapi
		local source = {}
		source.new = function()
			return setmetatable({}, { __index = source })
		end

		source.get_trigger_characters = function()
			return {
				"a",
				"b",
				"c",
				"d",
				"e",
				"f",
				"g",
				"h",
				"i",
				"j",
				"k",
				"l",
				"m",
				"n",
				"o",
				"p",
				"q",
				"r",
				"s",
				"t",
				"u",
				"v",
				"w",
				"x",
				"y",
				"z",
				"A",
				"B",
				"C",
				"D",
				"E",
				"F",
				"G",
				"H",
				"I",
				"J",
				"K",
				"L",
				"M",
				"N",
				"O",
				"P",
				"Q",
				"R",
				"S",
				"T",
				"U",
				"V",
				"W",
				"X",
				"Y",
				"Z",
			}
		end

		source.is_available = function()
			return vim.api.nvim_get_mode().mode == "i"
		end
		local curl = require("plenary.curl")

		-- Define your API base URL
		local api_base_url = "http://localhost:8080"

		-- Utility function to fetch word neighbors
		local function fetch_word_neighbors(word, language, drop_strange)
			local response = curl.post(api_base_url .. "/get_word_neighbors/", {
				body = vim.json.encode({
					word = word,
					language = language,
					neighbors = 65,
					dropstrange = true,
				}),
				headers = {
					["Content-Type"] = "application/json",
				},
				timeout = 500,
			})

			if response.status == 200 then
				return vim.json.decode(response.body)
			else
				print("Failed to fetch word neighbors:", response.status)
				return nil
			end
		end

		-- Utility function to fetch word etymology
		local function fetch_word_etymology(word, language)
			local response = curl.post(api_base_url .. "/get_word_etymology/", {
				body = vim.json.encode({
					word = word,
					language = language,
				}),
				headers = {
					["Content-Type"] = "application/json",
				},
			})

			if response.status == 200 then
				print(response.body)
				return vim.json.decode(response.body)
			else
				print("Failed to fetch word etymology:", response.status)
				return nil
			end
		end

		source.complete = function(self, request, callback)
			local line = vim.fn.getline(".")
			local original_start = vim.fn.col(".") - 1
			local start = original_start
			while start > 0 and string.match(line:sub(start, start), "%S") do
				start = start - 1
			end
			local query_word = line:sub(start + 1, vim.fn.col(".") - 1)
			if #query_word < 3 then
				return
			end

			-- Assuming 'en' as default language for simplicity
			local neighbors_data = fetch_word_neighbors(query_word, "English", true)

			local items = {}
			if neighbors_data and neighbors_data.neighbors then
				for _, neighbor in ipairs(neighbors_data.neighbors) do
					table.insert(items, {
						label = query_word .. " [" .. neighbor.neighbor .. "]",
						documentation = neighbor.etymology,
						textEdit = {
							newText = neighbor.neighbor,
							filterText = neighbor.neighbor,
							range = {
								["start"] = { line = request.context.cursor.row - 1, character = original_start },
								["end"] = {
									line = request.context.cursor.row - 1,
									character = request.context.cursor.col - 1,
								},
							},
						},
					})
					callback({ items = items, isIncomplete = true })
				end
			end
		end
		cmp.register_source("fasttext", source.new())

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
			---rogets_thesaurus = "   THESAU",
			---fasttext = "ƒ FASTTEXT",
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
		kind_mapper.cmp_tabnine = 26
		---kind_mapper.Thesaurus = 26

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
				{ name = "cmp_tabnine", max_item_count = 10, priority = 10 },
				{ name = "nvim_lua", max_item_count = 10, priority = 5 },
				{ name = "luasnip", max_item_count = 2, priority = 5 },
				{ name = "treesitter", max_item_count = 10, priority = 5 },
				{ name = "nvim_lsp", max_item_count = 10, priority = 5 },
				{ name = "path", max_item_count = 10, priority = 4, keywork_length = 2 },
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
				--{ name = "fasttext", max_item_count = 50, priority = 3, keyword_length = 4 },
				--{ name = "rogets_thesaurus", max_item_count = 10, priority = 3, keyword_length = 4 },
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
					if entry.source.name == "copilot" or entry.source.name == "cmp_tabnine" then
						vim_item.kind = ""
						if entry.source.name == "cmp_tabnine" then
							vim_item.kind = "   TABNINE "
						else
							vim_item.kind = "   COPILOT "
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
						--rogets_thesaurus = "",  -- Custom thesaurus
						--fasttext = "ƒ",  -- Custom fasttext
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
		vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#d5c4a1" })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#fbf1c7" })
		vim.api.nvim_set_hl(0, "CmpItemAbbrFuzzy", { fg = "#fbf1c7" })
		vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#8ec07c" })
		vim.api.nvim_set_hl(0, "CmpItemKindTabNine", { fg = "#d3869b" })
	end,
}
