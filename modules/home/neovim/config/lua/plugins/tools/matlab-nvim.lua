return {
	'idossha/matlab.nvim',
	cond = function()
		return vim.fn.executable(vim.fn.expand("~/.local/bin/matlab-distrobox")) == 1
			 and vim.env.TMUX ~= nil
			 and vim.env.TMUX ~= ""
	end,
	ft = 'matlab',
	opts = {
		executable = vim.fn.expand("~/.local/bin/matlab-distrobox"),
		mappings = {
			prefix = "<localleader>m",
		},
	},
}
