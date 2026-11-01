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

		map("n", "<leader>la", vim.lsp.buf.code_action, "Code Actions")
		map("n", "<leader>li", vim.lsp.buf.implementation, "Implementation")
		-- map("n", "<leader>lr", ":IncRename " .. vim.fn.expand("<cword>"), "Rename")
		vim.keymap.set("n", "<leader>lr", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { expr = true })
		map("n", "<leader>lf", vim.lsp.buf.references, "References")
		map("n", "<leader>lt", vim.lsp.buf.type_definition, "Type definitions")
		map("n", "<leader>lx", vim.lsp.codelens.run, "Run codelens")
		map("n", "<leader>lO", vim.lsp.buf.document_symbol, "List symbol on document")

		map("n", "ºd", jump_forward, "Jump to next Diagnostic")
		map("n", "çd", jump_backward, "Jump to previous Diagnostic")
	end,
})
