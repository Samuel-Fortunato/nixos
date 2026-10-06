return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lsp_config.servers")
		require("lsp_config.diagnostics")
		require("lsp_config.keymaps")
	end,
}
