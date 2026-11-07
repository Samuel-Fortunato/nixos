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
    group = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true }),
    callback = function()
        vim.diagnostic.open_float({
            focusable = false,
            scope = "line",
        })
    end,
})

vim.opt.updatetime = 1000 -- Trigger CursorHold after ~1s of inactivity
