return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		if vim.fn.executable("zathura") == 1 then
			vim.g.vimtex_view_method = "zathura_simple"
		end
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
