local DEFAULT_MODEL = "qwen3:14b"
local DEFAULT_PROVIDER = "ollama"

local _PROMPT_PY_PEP484_NUMPY_DOCSTRING_FORMAT =
	"Reformat the given function(s) conforming to PEP-484 annotations and corresponding docstring (Numpy format).\n\n"
local _PROMPT_PY_PEP257_MODULE_LVL_DOCSTRING_FORMAT =
	"Write a module-level docstring for the code that describes what the script/lib does.\n\n"
local _PROMPT_LUA_TYPEHINTS = "Add $ftype type hints to the given code ensuring comment annotations, structured types, with --@class/--@field and --@alias," --Lua
	.. ", handling optional and vararg arguments, marking optionals with ? or nil unions, and keeping annotations minimal and dry.\n\n"
local _PROMPT_GENERIC_TERSE_COMMENTS = "Rewrite the code, adding terse inline comments that add information about the core functionality intended.\n"
	.. "Do not change the code - even if it is obscure.\n\n"
local _PROMPT_GENERIC_DESIGN_PATTERN_SUGGESTION = "Improve the given code to implement a design pattern (Creational, Structural or Behaviourial).\n"
	.. "Rewrite the code, adding terse inline comments that add information about the core functionality intended.\nTry not to change the functionality of the code.\n"
	.. "Respond in this format:\n\n" --- Used for stripping out the code block

--[[
Creates a code block with the given language and selected code.
@param lang string - The programming language identifier (e.g., "lua", "python")
@param selected_code string - The code snippet to format
@return string - Formatted code block with triple backticks
]]
local function _single_example(lang, selected_code)
	return "```" .. lang .. "\n" .. selected_code .. "\n```"
end

--[[
Prepares an example for output formatting with markdown code example.
@param lang string - Language identifier for code block
@param selected_code string - Code snippet to format
@param markdown_code_example string - Example of expected markdown format
@return string - Formatted example with code block and output instructions
]]
local function provide_output_with_format_code_example_md(lang, selected_code, markdown_code_example)
	return "\n\n"
		.. _single_example(lang, selected_code)
		.. "\n\nPlease provide output in the format:\n\n"
		.. _single_example("$ftype", markdown_code_example)
end

--@type table
local opts = {
	provider = DEFAULT_PROVIDER, --@type string
	ollama = {
		model = DEFAULT_MODEL, --@type string
	},
	behaviour = {
		enable_cursor_planning_model = true, --@type boolean
	},
}

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = opts,
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{ -- ollama.nvim is not related to avante.nvim, just the ollama backend (and model selection)
			"nomnivore/ollama.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
			keys = {
				{
					"<leader>oo",
					":<c-u>lua require('ollama').prompt()<cr>",
					desc = "Ollama prompt",
					mode = { "n", "v" },
				},
				{
					"<leader>oG",
					":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
					desc = "Ollama Generate Code",
					mode = { "n", "v" },
				},
				{
					"<leader>oR",
					":<c-u>lua require('ollama').prompt('Raw')<cr>",
					desc = "Ollama Raw input",
					mode = { "n", "v" },
				},
				{
					"<leader>osd",
					":<c-u>lua require('ollama').prompt('OllamaServeStop')<cr>",
					desc = "Ollama Shutdown",
					mode = { "n", "v" },
				},
			},
			opts = {
				model = DEFAULT_MODEL,
				url = "http://127.0.0.1:11434",
				serve = {
					on_start = false,
					command = DEFAULT_PROVIDER,
					args = { "serve" },
					stop_command = "pkill",
					stop_args = { "-SIGTERM", "ollama" },
				},
				prompts = {
					py_pep484_function_docstrings = {
						prompt = _PROMPT_PY_PEP484_NUMPY_DOCSTRING_FORMAT
							.. provide_output_with_format_code_example_md("$ftype", "$sel", "# python code"),
						input_label = "󱙺 ",
						action = "display_replace",
					},
					py_pep257_module_docstring = {
						prompt = _PROMPT_PY_PEP257_MODULE_LVL_DOCSTRING_FORMAT,
						input_label = "󱙺 ",
						action = "display_replace",
					},
					lua_typehints = {
						prompt = _PROMPT_LUA_TYPEHINTS .. provide_output_with_format_code_example_md(
							"$ftype",
							"$sel",
							"\n---@type integer\nlocal x = 3\n```"
						),
						input_label = "󱙺 ",
						action = "display_replace",
					},
					generate_code = false,
					modify_code = { -- Generic
						prompt = "$input\n\n" .. provide_output_with_format_code_example_md("$ftype", "$sel", "<code>"),
						input_label = "Instruction: ",
						action = "display_replace",
					},
					comments_inline = {
						prompt = _PROMPT_GENERIC_TERSE_COMMENTS
							.. provide_output_with_format_code_example_md("$ftype", "$sel", "<code>"),
						input_label = "󱙺 ",
						action = "display_replace",
					},
					design_patterns_comment_inline = {
						prompt = _PROMPT_GENERIC_DESIGN_PATTERN_SUGGESTION --- Used for stripping out the code block
							.. provide_output_with_format_code_example_md("$ftype", "$sel", "comment\ncode\ncomment"),
						input_label = "󱙺 ",
						action = "display_replace",
					},
				},
			},
		},
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
