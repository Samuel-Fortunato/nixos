return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	keys = { {
		"<leader>p",
		function()
			require("conform").format({ async = true })
		end,
		desc = "Format buffer",
	}, },
	opts = {
		formatters_by_ft = {
			c = { "astyle", lsp_format = "never" },
			cpp = { "astyle", lsp_format = "never" },
			sh = { "shfmt" },
			nix = { "nixfmt" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" }
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters = {
			astyle = {
				append_args = {
					"--indent=force-tab=3",
				},
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
