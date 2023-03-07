local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_create_autocmd("FileType", {pattern = {"python"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>pdb", "Iimport<space>pdb<return>pdb.set_trace()<esc>", opts)
        keymap('n', "<localleader>js", "Iimport<space>json<return><esc>", opts)
        keymap('n', "<localleader>os", "Iimport<space>os<return><esc>", opts)
        keymap('n', "<localleader>tq", "Iimport<space>tqdm<return><esc>", opts)
        keymap('n', "<localleader>ap", "Iimport<space>argparser<return><esc>", opts)
        -- if __name__ == "__main__": <- use `main' in snippets
        keymap('n', "<localleader>pl", "A # pylint: disable=", opts)
        keymap('n', "<localleader>c", "I#<esc>", opts)
        keymap('n', "<localleader>I", "<esc>:Isort", opts)
        keymap('n', "<localleader>ff", "<esc>:Black<return><esc>:Isort<return>", opts)
        vim.opt_local.foldenable = true
        vim.opt_local.foldmethod = "syntax"
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
      end)
    end,
})

local make_key = function(entry)
    assert(entry.Package, "Must have Package" .. vim.inspect(entry))
    assert(entry.Test, "Must have Test" .. vim.inspect(entry))
    return string.format("%s/%s", entry.Package, entry.Test)
end

local add_pytest = function(state, entry)
    state.tests[make_key(entry)] = {
        name = entry.Test,
        line = find_test_line(state.bufnr, entry.Test),
        output = {},
    }
end

local ns = vim.api.nvim_create_namespace "pytests"
--local group = vim.api.nvim_create_augroup("pytest-augroup", { clear = true})

local attach_to_buffer = function(bufnr, command)
  local state = {
    bufnr = bufnr,
    tests = {},
  }
  vim.api.nvim_buf_create_user_command(bufnr, "PyTestLineDiag", function() 
      local line = vim.fn.line "." -1
      for _, test in pairs(state.tests) do
          if test.line == line then
              vim.cmd.new()
              vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, test.output)
          end
      end
  end, {})

  vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("Pytest-Group", { clear = true }),
      pattern = "*.py",
      callback = function()
        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
          state = {
            bufnr = bufnr,
            tests = {},
          }
        vim.fn.jobstart(command, {
            stdout_buffered=true,
            on_stdout = function(_, data)
                if not data then
                    return
                end
                --vim.echo(data)
                -- Test data
                print(data)
                for _, line in ipairs(data) do
                    local decoded = vim.json.decode(line)
                    if decoded.outcome == "run" then
                        add_pytest(state, decoded)
                    elseif decoded.outcome == "output" then
                        if not decoded.name then
                            return
                        end

                        add_pytest_output(state, decoded)
                    elseif decoded.outcome == "passed" or decoded.outcome == "failed" then
                        mark_success(state, decoded)
                        local test = state.tests[make_key(decoded)]
                        if test.outcome == "passed" then
                            local text = { "OK" }
                            vim.api.nvim_buf_set_extmark(bufnr, ns, test.line, 0, {
                                virt_text = { text },
                            })
                        elseif test.outcome == "failed" then
                            local text = { "test failed" }
                            vim.api.nvim_buf_set_extmark(bufnr, ns, test.line, 0, {
                                virt_text = { text },
                            })
                        end
                    elseif decoded.outcome == "pause" or decoded.outcome == "cont" then
                        -- Do nothing
                    else
                        error("Failed to handle" .. vim.inspect(data))
                    end
                end
            end,

            on_exit = function()
                local failed = {}
                for _, test in pairs(state.tests) do
                    if test.line then
                        if not test.success then
                            table.insert(failed, {
                                    bufnr = bufnr,
                                    test.line,
                                    col = 0,
                                    severity = vim.diagnostic.severity.ERROR,
                                    source = "Pytest-Group",
                                    message = "Test Failed",
                                    user_data = {},
                                })
                        end
                    end
                end
                vim.diagnostic.set(ns, bufnr, failed, {})
            end,
        })
    end,
  })
end
--attach_to_buffer(34, "*.py", { "python", "-m", "pytest" })
vim.api.nvim_create_user_command("PyTestOnSave", function()
    vim.fn.jobstart({ "python", "-m", "pytest", "-vvv",  vim.fn.expand('%:p'), "--json=~/pytestreport.json"}, {
        stdout_buffered=true,
      })
    attach_to_buffer(vim.api.nvim_get_current_buf(),  {"cat", "~/pytestreport.json"})
end, {})

vim.api.nvim_create_autocmd("FileType", {pattern = {"shell","bash"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>b", "I#!/bin/bash<cr><esc>", opts)
        keymap('n', "<localleader>c", "I#<esc>", opts)
      end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = {"json"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>j", ":%!jq '.'<cr>", opts)
      end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = {"lua"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>c", "I-- <esc>", opts)
        keymap('n', "<localleader>C", "O--[[<esc>jo--]]<esc>k0", opts)
        keymap('n', "<localleader>fu", "Ifunction()<cr>end<esc>ko", opts)
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
      end)
    end,
})
