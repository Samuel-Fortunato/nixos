return {
	"Aietes/esp32.nvim",
	cond = function()
		return vim.fn.executable("idf.py") == 1
	end,
	lazy = false,
	dependencies = {
		"folke/snacks.nvim",
	},
	opts = {
		idf_cmd = {
			"idf.py",
			"-D",
			"_CMAKE_TOOLCHAIN_PREFIX=riscv32-esp-elf-",
		},
	},
}
