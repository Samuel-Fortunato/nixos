return {
	'nvim-telescope/telescope.nvim',
	enabled = false,
	version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
	},
	cmd = "Telescope",
	opts = { 
		defaults = {
			path_display = { "smart" },
			mappings = {
				i = {
					["<C-k>"] = "move_selection_previous",
					["<C-j>"] = "move_selection_next",	

					["<CR>"] = "select_default",
					["<C-v>"] = "select_vertical",
					["<C-s>"] = "select_horizontal",
					["<C-t>"] = "select_tab",
				},
				n = { 
					["<CR>"] = "select_default",
					["v"] = "select_vertical",
					["s"] = "select_horizontal",
					["t"] = "select_tab",
				},
			}
		}
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
}
