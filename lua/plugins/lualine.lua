local function get_ollama_condition()
	if package.loaded["ollama"] and require("ollama").status ~= nil then
		return "Ollama "
	else
		return ""
	end
end

local function get_status_icon()
	---@type string
	local status = require("ollama").status()
	vim.api.nvim_echo({ { status, "Normal" } }, false, {})
	if status == "IDLE" then
		return "Idle"
	elseif status == "WORKING" then
		return "Busy"
	end
end

local function get_detailed_ollama_status()
	if get_ollama_condition() == "" then
		return ""
	end
	return get_ollama_condition() .. " " .. get_status_icon()
end

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				fmt = string.lower,
				theme = require("lualine.themes.gruvbox_dark"),
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "branch" },
				lualine_b = { "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype", get_detailed_ollama_status },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
