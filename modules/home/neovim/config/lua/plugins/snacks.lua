---@diagnostic disable: undefined-global

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{ "<leader>e",  function() Snacks.explorer.open() end,          desc = "Show file explorer" },
		{ "<leader>g",  function() Snacks.lazygit() end,                desc = "LazyGit" },

		{ "<leader>ff", function() Snacks.picker.files() end,           desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.grep() end,            desc = "Grep" },
		{ "<leader>fm", function() Snacks.picker.marks() end,           desc = "Marks" },
		{ "<leader>fb", function() Snacks.picker.buffers() end,         desc = "Buffers" },
		{ "<leader>fh", function() Snacks.picker.help() end,            desc = "Help Pages" },
		{ "<leader>:",  function() Snacks.picker.command_history() end, desc = "Command History" },

		{ "<C-\\>",     mode = { "n", "t" },                            function() Snacks.terminal.focus() end,  desc = "Terminal" },

		{ "<leader>T",  function() Snacks.picker.colorschemes() end,    desc = "Select Theme" },
		{ "<leader>z",  function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },

		{ "<leader>bc", function() Snacks.bufdelete.delete() end,       desc = "Close Buffer" },
	},
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = {
			enabled = true,
			replace_netrw = true,
			trash = true,
		},
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					auto_close = true,
					layout = { preset = "vertical", preview = true }
				}
			}
		},
		notifier = { enabled = false },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = {
			enabled = true,
			folds = { open = true },
		},
		words = { enabled = true },
	}
}
