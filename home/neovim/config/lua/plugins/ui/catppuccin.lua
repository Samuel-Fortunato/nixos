return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	-- enabled = false,
	priority = 100,
	opts = { },
	config = function (_,_)
		require("catppuccin")
		-- vim.cmd.colorscheme "catppuccin-nvim"
	end
}
