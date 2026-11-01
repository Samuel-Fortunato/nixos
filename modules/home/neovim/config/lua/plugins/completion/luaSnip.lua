return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets", },

	opts = {
		enable_autosnippets = true,
		update_events = "TextChanged,TextChangedI",
	},

	config = function(_, opts)
		local ls = require("luasnip")
		ls.config.setup(opts)

		require("luasnip.loaders.from_lua").lazy_load({
			paths = vim.fn.stdpath("config") .. "/lua/snippets",
		})

		require("luasnip.loaders.from_vscode").lazy_load({
			exclude = { "latex" },
		})
	end,
}
