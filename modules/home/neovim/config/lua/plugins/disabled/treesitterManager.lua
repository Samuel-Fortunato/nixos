return {
	"romus204/tree-sitter-manager.nvim",
	enabled = false,
	event = {
		"BufReadPost", "BufNewFile"
	},
	opts = {
		auto_install = true,
		noauto_install = { "latex" },
		nohighlight = { "latex" },
	},
}
