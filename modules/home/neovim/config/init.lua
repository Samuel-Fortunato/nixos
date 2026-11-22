-- Disable netrw in favour of nvim-tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Neovim server socket
local socket_dir = vim.fn.stdpath("run")

-- Fallback for environments without a writable runtime directory
if vim.fn.isdirectory(socket_dir) == 0
    or vim.fn.filewritable(socket_dir) ~= 2 then
    socket_dir = vim.fn.stdpath("state") .. "/run"
    vim.fn.mkdir(socket_dir, "p")
end

vim.fn.serverstart(socket_dir .. "/nvim-" .. vim.fn.getpid() .. ".pipe")

require("core.set")
require("core.mappings")
require("core.lazy")
