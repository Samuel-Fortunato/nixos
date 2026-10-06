return {
	"arborist-ts/arborist.nvim",
	enabled = false,
	lazy = false,
	opts = {
		install_popular = false,
		ignore = { "latex" },
		disable = {
			indent = { "latex" },
			highlight = { "latex" },
		},
	},
}
