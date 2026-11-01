return {
	"mason-org/mason-lspconfig.nvim",
	enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"pyright",
			"clangd",
			"texlab"
		},
		automatic_enable = {
			exclude = { "clangd" }, -- Add the server names you want to disable here
		},
	},
	config = function(_, opts)
		vim.lsp.config("clangd", require("esp32").lsp_config())
		require("mason-lspconfig").setup(opts)
	end
}
