-- Disable netrw in favour of nvim-tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Start a named server socket for remote theme reloading
local socket_dir = vim.fn.stdpath("run")
if vim.fn.isdirectory(socket_dir) == 0 then
    vim.fn.mkdir(socket_dir, "p")
end

vim.fn.serverstart(socket_dir .. "/nvim-" .. vim.fn.getpid() .. ".pipe")

require("core.set")
require("core.mappings")
require("core.lazy")
