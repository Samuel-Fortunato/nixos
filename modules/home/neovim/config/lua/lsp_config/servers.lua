-- clangd
vim.lsp.config("clangd", require("esp32").lsp_config())

-- matlab_ls
vim.lsp.config("matlab_ls", {
	cmd = {
		"distrobox", "enter",
		"--name", "matlab",
		"--no-tty",
		"--",
		"node",
		vim.fn.expand("~/.local/share/MATLAB-language-server/out/index.js"),
		"--stdio",
	},

	settings = {
		MATLAB = {
			installPath = vim.fn.expand("~/.matlab/R2026b"),
			telemetry = false,
		},
	},
}
)

vim.lsp.enable({
	"clangd",
	"basedpyright",
	"texlab",
	"lua_ls",
	"matlab_ls",
})
