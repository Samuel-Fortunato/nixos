return {
	"uZer/pywal16.nvim",
	enabled = false,
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("pywal16")

		local colors = require("pywal16.core").get_colors()
		if colors then
			vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", {
				fg = colors.color15, bold = true
			})
			vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", {
				fg = colors.color15, bold = true
			})
			vim.api.nvim_set_hl(0, "SnacksPickerDir", {
				fg = colors.color15
			})
			vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', {
				fg = colors.color1,
				bg = colors.color14,
				bold = true
			})
		end
	end,
}
