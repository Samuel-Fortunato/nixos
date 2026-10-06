return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_forward_search_on_pdf_update = true
		vim.g.vimtex_imaps_leader = "'"

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "tex",
			callback = function()
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "vimtex#fold#level(v:lnum)"
				vim.opt_local.foldtext = "vimtex#fold#text()"
			end,
		})
	end,
}
