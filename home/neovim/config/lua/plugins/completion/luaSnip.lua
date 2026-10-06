local function load_snippets()
	require("luasnip.loaders.from_lua").lazy_load({
		paths = vim.fn.stdpath("config") .. "/lua/snippets",
	})
	require("luasnip.loaders.from_vscode").lazy_load({
		exclude = { "latex" },
	})
end

local function leave_snippet()
	if
		 ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
		 and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
		 and not require('luasnip').session.jump_active
	then
		require('luasnip').unlink_current()
	end
end

return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	keys = { {
		"<leader>S",
		function()
			load_snippets()
			vim.notify("LuaSnip snippets reloaded!", vim.log.levels.INFO)
		end,
		desc = "Reload LuaSnip snippets",
	}, },
	opts = {
		enable_autosnippets = true,
		store_selection_keys = "<Tab>",
		update_events = "TextChanged,TextChangedI",
	},
	config = function(_, opts)
		local ls = require("luasnip")
		ls.config.set_config(opts)

		load_snippets()

		vim.api.nvim_create_autocmd('ModeChanged', {
			pattern = '*',
			callback = leave_snippet,
		})
	end,
}
