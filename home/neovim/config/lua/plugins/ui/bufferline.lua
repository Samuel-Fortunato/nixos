return {
	'akinsho/bufferline.nvim',
	-- enabled = false,
	event = { "BufReadPre", "BufNew" },
	keys = {
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },

		{ "<leader>bc", "<cmd>bdelete<cr>", desc = "Close Buffer" },

		{ "<C-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
		{ "<C-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },

		{ "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
	},
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	opts = { }
}
