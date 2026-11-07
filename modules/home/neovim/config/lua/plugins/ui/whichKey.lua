return {
	"folke/which-key.nvim",
	name = "which-key",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	opts = {
		preset = "modern",

		icons = {
			mappings = true,
			colors = true,
			rules = {
				{ pattern = "git", icon = "", color = "orange" },
				{ pattern = "file", icon = "󰈔", color = "blue" },
				{ pattern = "find", icon = "", color = "green" },
				{ pattern = "format", icon = "󰉼", color = "cyan" },
				{ pattern = "theme", icon = "󰏘", color = "purple" },
				{ pattern = "zen", icon = "󰖔", color = "cyan" },

				-- Generic fallback instead of plugin icons
				{ pattern = ".", icon = "", color = "grey" },
			},
		},

		spec = {
			{ "<leader>f", group = "Find", icon = " " },
			-- { "<leader>e", group = "File Explorer", icon = "󰙅 " },
			{ "<leader>n", group = "Notifications", icon = "󰵅 " },
			{ "<leader>b", group = "Buffers", icon = "󰈔 " },
			-- { "<leader>c", group = "Overseer [C]omands" },
			{ "<leader>l", group = "LSP", icon = "󰒋 " },
			{ "<leader>s", group = "Sessions", icon = " " },
			{ "<leader>R", group = "ESP32", icon = "󰍛 " },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Current Buffer Keymaps",
		},
	},
}
