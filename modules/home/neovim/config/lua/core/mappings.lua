-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set


-- ── Insert mode ────────────────────────────────────────────

-- Exit insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Move cursor without leaving insert mode
map("i", "<A-h>", "<Left>",  { desc = "Move left" })
map("i", "<A-j>", "<Down>",  { desc = "Move down" })
map("i", "<A-k>", "<Up>",    { desc = "Move up" })
map("i", "<A-l>", "<Right>", { desc = "Move right" })


-- ── Navigation ─────────────────────────────────────────────

-- Navigate visual lines when no count is given;
-- otherwise, navigate actual buffer lines.
map("n", "j", "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    silent = true,
    desc = "Move down (wrapped lines)",
})

map("n", "k", "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    silent = true,
    desc = "Move up (wrapped lines)",
})

-- Jump to exact mark position instead of beginning of line
map("n", "'", "`", { desc = "Jump to exact mark position" })


-- ── Window navigation ──────────────────────────────────────

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })


-- ── Visual mode ────────────────────────────────────────────

-- Move selected lines while keeping the selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })


-- ── Search ─────────────────────────────────────────────────

-- Clear search highlights without disabling hlsearch
map("n", "<Esc>", vim.cmd.nohlsearch, {
    desc = "Clear search highlights",
})


-- ── Snippets ───────────────────────────────────────────────

-- Remove Neovim's built-in snippet navigation mappings.
-- Blink handles Tab/Shift-Tab using LuaSnip instead.
for _, key in ipairs({ "<Tab>", "<S-Tab>" }) do
    vim.keymap.del({ "i", "s" }, key)
end
