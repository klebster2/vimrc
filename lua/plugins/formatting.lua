return { -- formatting using conform.nvim
	"stevearc/conform.nvim",
	event = { "BufRead", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				graphql = { "prettier" },
				markdown = { "prettier" },
				css = { "prettier" },
				json = { "prettier", "jq" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout = 500,
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
