return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- optional, for file icons
	}, -- if using WSL2, Windows Terminal needs nerd font so install a NerdFont (e.g. Consolas NF in the Windows Terminal application)
	-- E.g. After https://learn.microsoft.com/en-us/windows/wsl/install , go to https://learn.microsoft.com/en-us/windows/terminal/install
	config = function()
		vim.g.webdevicons_enable = 1
		vim.g.webdevicons_enable_nerdtree = 1
		vim.g.webdevicons_enable_unite = 1

		if vim.fn.has("win32") == 1 then
			vim.g.WebDevIconsOS = "Windows"
		elseif vim.fn.has("macunix") == 1 then
			vim.g.WebDevIconsOS = "macos"
		else
			vim.g.WebDevIconsOS = "Linux"
		end

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")
			-- keep the defaults first
			api.config.mappings.default_on_attach(bufnr)
			local function opts(desc)
				return {
					desc = "nvim-tree: " .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				}
			end
			------------------------------------------------------------------
			--  Press  “ga”  on any entry in the tree to stage / un-stage it
			------------------------------------------------------------------
			local function git_add()
				local node = api.tree.get_node_under_cursor()
				-- figure out the git status of the node (file or directory)
				local gs = node.git_status.file
				if gs == nil then -- it’s a directory → look at children
					gs = (node.git_status.dir.direct and node.git_status.dir.direct[1])
						or (node.git_status.dir.indirect and node.git_status.dir.indirect[1])
				end
				if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
					-- untracked / unstaged / partially-staged → stage it
					vim.cmd("silent !git add " .. vim.fn.fnameescape(node.absolute_path))
				elseif gs == "M " or gs == "A " then
					-- already staged → un-stage it
					vim.cmd("silent !git restore --staged " .. vim.fn.fnameescape(node.absolute_path))
				end
				api.tree.reload() -- refresh the icons immediately
			end
			vim.keymap.set("n", "ga", git_add, opts("git add / restore"))
		end
		require("nvim-tree").setup({ -- BEGIN_DEFAULT_OPTS
			disable_netrw = true,
			hijack_netrw = true,
			update_cwd = true,
			view = {
				width = 35,
			},
			hijack_directories = {
				enable = true,
				auto_open = true,
			},
			renderer = {
				indent_markers = {
					enable = false,
					icons = {
						corner = "└ ",
						edge = "│ ",
						none = "  ",
					},
				},
			},
			filters = {
				custom = { ".git" },
				-- Get all fuzzy paths from .gitignore (current directory)
			},
			actions = {
				open_file = {
					resize_window = false,
				},
			},
			trash = {
				cmd = "trash",
				require_confirm = true,
			},
			git = {
				enable = true,
				ignore = true,
				timeout = 1000,
			},
			on_attach = my_on_attach,
		})
	end,
}
