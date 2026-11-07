local function jump_forward()
	vim.diagnostic.jump({ count = 1 })
end
local function jump_backward()
	vim.diagnostic.jump({ count = -1 })
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
		end

		map("n", "<leader>la", vim.lsp.buf.code_action, "Code actions")
		map("n", "<leader>li", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>lf", vim.lsp.buf.references, "Find references")
		map("n", "<leader>lt", vim.lsp.buf.type_definition, "Go to type definition")
		map("n", "<leader>lx", vim.lsp.codelens.run, "Run code lens")
		map("n", "<leader>lO", vim.lsp.buf.document_symbol, "Document symbols")

		map("n", "ºd", jump_forward, "Next diagnostic")
		map("n", "çd", jump_backward, "Previous diagnostic")
	end,
})
