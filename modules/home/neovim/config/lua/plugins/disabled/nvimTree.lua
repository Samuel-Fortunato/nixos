return {
	"nvim-tree/nvim-tree.lua",
	enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	keys = {
		{ "<leader>ee", "<cmd>NvimTreeOpen<cr>", desc = "Open Explorer" },
		{ "<leader>ex", "<cmd>NvimTreeClose<cr>", desc = "Close Explorer" },
		{ "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Find Current File" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh Explorer" },
		{ "<leader>ec", "<cmd>NvimTreeCollapse<cr>", desc = "Collapse all directories" },
	},
	opts = {
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			local function map(key, fn, desc)
				vim.keymap.set("n", key, fn, {
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
					desc = "nvim-tree: " .. desc,
				})
			end

			-- open / navigation
			map("<CR>", api.node.open.edit, "Open")
			map("v", api.node.open.vertical, "Vertical Split")
			map("s", api.node.open.horizontal, "Horizontal Split")
			map("t", api.node.open.tab, "Open in New Tab")
			map("<Tab>", api.node.open.preview, "Preview File")

			-- tree control
			map("R", api.tree.reload, "Refresh")
			map("q", api.tree.close, "Close Tree")
			map(">", api.tree.change_root_to_node, "CD into directory")
			map("<", api.tree.change_root_to_parent, "Up one level")

			-- file ops
			map("n", api.fs.create, "New")
			map("r", api.fs.rename, "Rename")
			map("d", api.fs.remove, "Delete")
			map("c", api.fs.copy.node, "Copy")
			map("p", api.fs.paste, "Paste")

			-- QOL
			map(".", api.tree.toggle_hidden_filter, "Toggle Dotfiles")
			map("I", api.tree.toggle_gitignore_filter, "Toggle .gitignore")
			map("C", api.tree.collapse_all, "Collapse All")
		end,
	}
}
