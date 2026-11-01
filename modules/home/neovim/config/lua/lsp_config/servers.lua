vim.lsp.config("clangd", require("esp32").lsp_config())

vim.lsp.enable({
	"clangd",
	"basedpyright",
	"texlab",
	"lua_ls",
})
