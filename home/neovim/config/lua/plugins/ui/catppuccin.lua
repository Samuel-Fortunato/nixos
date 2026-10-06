return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	-- enabled = false,
	priority = 1000,
	opts = { flavour = "mocha", },
	config = function(_, opts)
		require("catppuccin")
		vim.cmd.colorscheme "catppuccin"
	end
}
