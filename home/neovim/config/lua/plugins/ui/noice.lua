return {
	"folke/noice.nvim",
	-- enabled = false,
	event = "VeryLazy",
	keys = {
		{ "<leader>n", "<cmd>Noice dismiss<cr>", desc = "Dismiss Notifications" }
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		presets = {
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true,
			lsp_doc_border = true,
		}
	},
}
