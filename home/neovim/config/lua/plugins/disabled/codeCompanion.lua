return {
	"olimorris/codecompanion.nvim",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim"
	},
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionActions",
		"CodeCompanionCLI",
		"CodeCompanionCmd",
		"CodeCompanionHistory",
		"CodeCompanionSummaries",
	},
	keys = {
		{ "<leader><space>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI Chat" }
	},
	opts = {
		interactions = {
			chat = {
				adapter = "ollama",
				slash_commands = {
					["image"] = {
						opts = {
							dirs = { "/home/samff/Pictures/Screenshots/" }
						}
					}
				},
			},
			inline = {
				adapter = "ollama",
			},
			cmd = {
				adapter = "ollama",
			},
		},
		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "qwen3.5:9b",
							},
							num_ctx = {
								default = 16384,
							},
						},
					})
				end,
				gemini1 = function()
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-3.1-flash-lite",
							},
						}
					})
				end,
			}
		},
		extensions = {
			history = {
				enabled = true,
				opts = {
					keymap = "gh",
					save_chat_keymap = "sc",
					auto_save = true,
					expiration_days = 9,
					picker = "snacks",
					chat_filter = nil,
					auto_generate_title = false,
					continue_last_chat = false,
					delete_on_clearing_chat = false,
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					enable_logging = false,
					summary = {
						create_summary_keymap = "gcs",
						browse_summaries_keymap = "gbs",
					},
				}
			}
		}
	},
}
