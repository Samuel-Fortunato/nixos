return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"L3MON4D3/LuaSnip",
	},
	event = "InsertEnter",

	-- v2's supported Rust fuzzy matcher build method.
	build = function()
		require("blink.cmp").build():pwait()
	end,

	opts = {
		keymap = {
			preset = "enter",

			-- Completion navigation
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },

			-- LuaSnip choice nodes
			["<C-l>"] = {
				function()
					local ls = require("luasnip")
					if ls.choice_active() then
						ls.change_choice(1)
						return true
					end
					return false
				end,
				"fallback",
			},
		},

		appearance = { nerd_font_variant = "normal", },
		snippets = { preset = "luasnip", },

		-- fuzzy = { implementation = "rust", },

		sources = {
			default = { "lsp", "snippets", "path", "buffer", },

			-- VimTeX exposes an omnifunc for TeX completion.
			per_filetype = { tex = { inherit_defaults = true, "omni" }, },
			providers = { snippets = { min_keyword_length = 2, opts = { show_autosnippets = false, }, }, buffer = { min_keyword_length = 5, }, },
		},

		completion = {
			trigger = { show_on_trigger_character = false, },

			-- Avoid competing with nvim-autopairs.
			accept = { auto_brackets = { enabled = false }, },

			list = {
				selection = {
					preselect = true, auto_insert = false,
				},
			},

			menu = {
				border = "rounded",
				draw = {
					columns = { {
						"label", "label_description", gap = 1 }, { "kind" }, },
				},
			},

			documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = "rounded" }, },
		},
	},
}
