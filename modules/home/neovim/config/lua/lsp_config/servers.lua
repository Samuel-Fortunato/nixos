-- Use the ESP-IDF clangd configuration only when its tooling is available.
if vim.fn.executable("idf.py") == 1 then
	local ok, esp32 = pcall(require, "esp32")
	if ok then
		vim.lsp.config("clangd", esp32.lsp_config())
	end
end

local servers = { "clangd", "basedpyright", "texlab", "lua_ls", "nixd" }
local matlab_server = vim.fn.expand("~/.local/share/MATLAB-language-server/out/index.js")
if vim.fn.executable("distrobox") == 1 and vim.fn.filereadable(matlab_server) == 1 then
	vim.lsp.config("matlab_ls", {
		cmd = { "distrobox", "enter", "--name", "matlab", "--no-tty", "--", "node", matlab_server, "--stdio" },
		settings = {
			MATLAB = {
				installPath = vim.fn.expand("~/.matlab/R2026b"),
				telemetry = false,
			},
		},
	})
	table.insert(servers, "matlab_ls")
end

vim.lsp.enable(servers)
