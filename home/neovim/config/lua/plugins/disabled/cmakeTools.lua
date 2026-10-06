return {
	'Civitasv/cmake-tools.nvim',
	enabled = false,
	event = "VeryLazy",
	dependencies = {
		'nvim-lua/plenary.nvim',
		'stevearc/overseer.nvim',
		"akinsho/toggleterm.nvim",
	},
	opts = {
		cmake_executor = {
			name = "overseer",
			opts = {
				on_new_task = function(_)
					require("overseer").open()
				end,
			}
		},
		-- cmake_runner = {
		-- 	name = "overseer",
		-- 	opts = {
		-- 		task_list = {
		-- 			direction = "bottom"
		-- 		}
		-- 	}
		-- }
	}
}
