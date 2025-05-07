local function _single_example(lang, selected_code)
	return "```" .. lang .. "\n" .. selected_code .. "\n```"
end
local function provide_output_with_format_code_example_md(lang, selected_code, markdown_code_example)
	return "\n\n"
		.. _single_example(lang, selected_code)
		.. "\n\nPlease provide output in the format:\n\n"
		.. _single_example("$ftype", markdown_code_example)
end

--local function provide_output_in_the_format(a, b)
--	return
--- Create environment variable for ollama model
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
			"<leader>om",
			":<c-u>lua require('ollama').prompt('OllamaModel')<cr>",
			desc = "Ollama Model",
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
		model = "qwen3:4b", -- Use one of the smallest models as smoke test
		-- (change to larger model after validating)
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
					.. provide_output_with_format_code_example_md("$ftype", "$sel", "# python code"),
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
					.. provide_output_with_format_code_example_md(
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
			comments_inline = { -- Generic (Explain in comments)
				prompt = "Rewrite the code, adding terse inline comments that add information about the core functionality intended.\n"
					.. "Do not change the code - even if it is obscure.\n\n"
					.. provide_output_with_format_code_example_md("$ftype", "$sel", "<code>"),
				input_label = "󱙺 ",
				action = "display_replace",
			},
			design_patterns_comment_inline = { -- Generic
				prompt = "Improve the given code to implement a design pattern (Creational, Structural or Behaviourial).\n"
					.. "Rewrite the code, adding terse inline comments that add information about the core functionality intended.\n"
					.. "Try not to change the functionality of the code.\n"
					.. "Respond in this format:\n\n" --- Used for stripping out the code block
					.. provide_output_with_format_code_example_md("$ftype", "$sel", "comment\ncode\ncomment"),
				input_label = "󱙺 ",
				action = "display_replace",
			},
		},
	},
}
