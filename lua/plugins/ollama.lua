local function code_example_md(lang, code, use_start)
  local language_prefix_md = "```" .. lang .. "\n"
  if use_start then
    return language_prefix_md .. code .. "\n```" .. "\n\n" .. language_prefix_md
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
    model = "codellama:8b",
    url = "http://127.0.0.1:11434",
    serve = {
      on_start = true,
      command = "ollama",
      args = { "serve" },
      stop_command = "pkill",
      stop_args = { "-SIGTERM", "ollama" },
    },
    prompts = {
      PEP484_docstrings = {
        prompt = {
          "Reformat the given function(s) with PEP 484 type annotations.",
          "\n```python\n$sel```\n",
          "\nProvide output in the form",
          "\n\n", code_example_md("python", "<code>"),
        },
        input_label = "󱙺 ",
        action = "display_replace",
      },
      Python_module_docstring = {
        prompt = "Write a module docstring for the given module that describes what the script/lib does.",
        input_label = "󱙺 ",
        action = "display_replace",
      },
      Lua_typehints = {
        prompt = {
          "Add type hints to the given $ftype code:\n\n",
          code_example_md("$ftype","$sel"),
          "in the form:",
          "\n\n```$ftype\n---@type integer\nlocal x = 3\n```",
        },
        input_label = "󱙺 ",
        action = "display_replace",
      },
      Generate_Code = false,
      Modify_Code = {
        prompt = "$input\n\n"
          .. "Respond in this format:\n"
          .. code_example_md("$ftype", "code", false)   --- Used for stripping out the code block
          .. "\n\n" .. code_example_md("$ftype", "$sel", true),
        input_label = "Instruction: ",
        action = "display_replace",
      },
      Comments_Inline = {
        prompt = "Rewrite the code, adding terse inline comments that add information about the core functionality intended.\n"
          .. "Do not change the code - even if it is obscure!\n\n"
          .. "Respond in this format:\n\n" --- Used for stripping out the code block
          .. code_example_md("$ftype", "code", false)   --- Used for stripping out the code block
          .. "\n\n" .. code_example_md("$ftype", "$sel", true),
        input_label = "󱙺 ",
        action = "display_replace",
      },
    }
  }
}
