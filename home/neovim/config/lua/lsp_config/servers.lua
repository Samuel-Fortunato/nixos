vim.lsp.config("clangd", require("esp32").lsp_config())

vim.lsp.enable({
	"clangd",
	"pyright",
	"texlab",
	"lua_ls",
})
