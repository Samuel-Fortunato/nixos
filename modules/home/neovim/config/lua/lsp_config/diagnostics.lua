local severity = vim.diagnostic.severity

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		prefix = '●', -- or use the icons from your signs
		source = "if_many", -- Only show source if there are multiple
	},
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
	signs = {
		priority = 9,
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = " ",
			[severity.INFO] = " ",
		}
	}
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

vim.opt.updatetime = 1000 -- 300ms delay before the float appears
