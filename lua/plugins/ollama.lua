local function code_example_md(lang, code, use_start)
	local language_prefix_md = "```" .. lang .. "\n"
	if use_start then
		-- Use start may prompt the LLM to add within the started code block
		return language_prefix_md .. code .. "\n```" .. "\n\n```" .. language_prefix_md
	else
		return language_prefix_md .. code .. "\n```"
	end
end

return {
	"nomnivore/ollama.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- All the user commands added by the plugin
	cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
	keys = {
		{
			"<leader>oo",
			":<c-u>lua require('ollama').prompt()<cr>",
			desc = "ollama prompt",
			mode = { "n", "v" },
		},
		{
			"<leader>oG",
			":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
			desc = "ollama Generate Code",
			mode = { "n", "v" },
		},
		{
			"<leader>oR",
			":<c-u>lua require('ollama').prompt('Raw')<cr>",
			desc = "ollama Raw input",
			mode = { "n", "v" },
		},
	},
	opts = {
		model = "qwen3:32b",
		url = "http://127.0.0.1:11434",
		serve = {
			on_start = false,
			command = "ollama",
			args = { "serve" },
			stop_command = "pkill",
			stop_args = { "-SIGTERM", "ollama" },
		},
		prompts = {
			py_pep484_function_docstrings = {
				prompt = "Reformat the given function(s)"
					.. " conforming to PEP-484 annotations and corresponding docstring (Numpy format)."
					.. code_example_md("$ftype", "$sel")
					.. "\nProvide output with the format:"
					.. "\n\n"
					.. code_example_md("$ftype", "<code>", false),
				input_label = "󱙺 ",
				action = "display_replace",
			},
			py_pep257_module_docstring = {
				prompt = "Write a module-level docstring for the code that describes what the script/lib does.",
				input_label = "󱙺 ",
				action = "display_replace",
			},
			lua_typehints = {
				prompt = "Add $ftype type hints to the given code" -- Generic
					.. " ensuring comment annotations, structured types, with --@class/--@field and --@alias," --Lua
					.. ", handling optional and vararg arguments, mark optional with ? or nil unions," -- Lua
					.. " and keep annotations minimal and dry." -- Lua
					.. "\n\n" -- Lua
					.. code_example_md("$ftype", "$sel")
					.. "\nProvide output with the format:"
					.. "\n\n"
					.. code_example_md("$ftype", "\n---@type integer\nlocal x = 3\n```"),
				input_label = "󱙺 ",
				action = "display_replace",
			},
			generate_code = false,
			modify_code = { -- Generic
				prompt = "$input\n\n"
					.. "\nProvide output in the form:"
					.. code_example_md("$ftype", "<code>", false) --- Used for stripping out the code block
					.. "\n\n"
					.. code_example_md("$ftype", "$sel", true),
				input_label = "Instruction: ",
				action = "display_replace",
			},
			comments_inline = { -- Generic
				prompt = "Rewrite the code, adding terse inline comments that add information about the core functionality intended.\n"
					.. "Do not change the code - even if it is obscure!\n\n"
					.. "Respond in this format:\n\n" --- Used for stripping out the code block
					.. code_example_md("$ftype", "<code>", false) --- Used for stripping out the code block
					.. "\n\n"
					.. code_example_md("$ftype", "$sel", true),
				input_label = "󱙺 ",
				action = "display_replace",
			},
		},
	},
}
