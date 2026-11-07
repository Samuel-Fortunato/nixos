local function notification_hist()
	require("noice.integrations.snacks").open({
		confirm = function(picker, item)
			if not item or not item.message then
				vim.notify("No message selected", vim.log.levels.ERROR, { title = "Noice History", })
				return
			end

			local message = item.message
			local title = message.opts.title or message.title or ""
			local content = message:content()

			local text = title ~= ""
				 and (title .. "\n\n" .. content)
				 or content

			vim.fn.setreg("+", text)
			picker:close()
		end,
	})
end

return {
	"folke/noice.nvim",
	-- enabled = false,
	event = "VeryLazy",
	keys = {
		{ "<leader>nn", "<cmd>Noice dismiss<cr>", desc = "Dismiss Notifications" },
		{
			"<leader>nh",
			notification_hist,
			desc = "Message History",
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		presets = {
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		}
	},
}
