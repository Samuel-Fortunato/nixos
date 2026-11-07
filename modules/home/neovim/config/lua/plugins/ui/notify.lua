return {
	"rcarriga/nvim-notify",
	opts = {
		render = "wrapped-default",
		minimum_width = 25,
		max_width = function()
			return math.floor(vim.o.columns * 0.55)
		end,
	},
}
