return {
	'akinsho/bufferline.nvim',
	lazy = false,
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		"folke/snacks.nvim",
	},
	keys = {
		{ "<S-h>",      "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>",      "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },


		{ "<C-h>",      "<cmd>BufferLineMovePrev<cr>",  desc = "Move buffer left" },
		{ "<C-l>",      "<cmd>BufferLineMoveNext<cr>",  desc = "Move buffer right" },

		{ "<leader>bb", "<cmd>BufferLinePick<cr>",      desc = "Pick Buffer" },
	},
	opts = {}
}
