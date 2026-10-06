return {
	"saghen/blink.cmp",
	branch = 'v1',
	dependencies = {
		"L3MON4DE/LuaSnip",
		"windwp/nvim-autopairs",
		"saghen/blink.compat",
	},
	event = "InsertEnter",
	opts = {
		keymap = {
			preset = 'enter',

			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
		},

		appearance = { nerd_font_variant = "normal" },
		snippets = { preset = "luasnip" },

		sources = {
			default = { 'lsp', 'vimtex', 'snippets', 'path', 'buffer' },
			per_filetype = { "codecompanion" },
			providers = {
				snippets = {
					min_keyword_length = 2,
				},
				vimtex = {
					name = "vimtex",
					module = "blink.compat.source",
				},
				buffer = {
					min_keyword_length = 5,
				},
			},
		},

		completion = {
			trigger = {
				show_on_trigger_character = false,
			},
			list = { selection = { preselect = true, auto_insert = false } },
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 }, { "kind" } }
				},
				border = "rounded"
			},
			documentation = {
				window = { border = "rounded" },
				auto_show = true,
				auto_show_delay_ms = 500
			},
		},
	},
}
