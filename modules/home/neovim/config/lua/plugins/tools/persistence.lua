return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	keys = {
		{ "<leader>sd", function() require("persistence").load() end,                desc = "Load the session for the current directory" },
		{ "<leader>sl", function() require("persistence").select() end,              desc = "Select a session to load" },
		{ "<leader>ss", function() require("persistence").load({ last = true }) end, desc = "Load the last session" },
		{ "<leader>sS", function() require("persistence").stop() end,                desc = "Stop Persistence => session won't be saved on exit" },
	},
	opts = {}
}
