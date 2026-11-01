-- lua/snippets/tex/_helpers.lua
-- Shared utilities for LaTeX snippets (Gilles Castel style)

local M = {}

local ls = require("luasnip")

-- ─── Condition helpers ───────────────────────────────────────────────────────

--- Returns true when the cursor is inside a math zone.
--- Uses treesitter if available, falls back to vimtex, then a simple regex.
function M.in_math()
	-- 1. Try vimtex (most accurate for complex documents)
	local ok, vimtex = pcall(function() return vim.fn["vimtex#syntax#in_mathzone"]() end)
	if ok and vimtex == 1 then return true end

	-- 2. Try treesitter math nodes
	local ts_ok, _ = pcall(require, "nvim-treesitter")
	if ts_ok then
		local buf       = vim.api.nvim_get_current_buf()
		local row, col  = unpack(vim.api.nvim_win_get_cursor(0))
		row             = row - 1 -- treesitter is 0-indexed
		local ok2, node = pcall(vim.treesitter.get_node, { bufnr = buf, pos = { row, col } })
		if ok2 and node then
			local n = node
			while n do
				local t = n:type()
				if t == "math_environment" or t == "inline_formula" or
					 t == "displayed_equation" or t == "math_zone" then
					return true
				end
				n = n:parent()
			end
		end
	end

	-- 3. Simple line-based heuristic (fallback)
	local line3   = vim.api.nvim_get_current_line()
	local col3    = vim.api.nvim_win_get_cursor(0)[2]
	local before3 = line3:sub(1, col3)
	local dollars = 0
	for _ in before3:gmatch("%$") do dollars = dollars + 1 end
	return dollars % 2 == 1
end

--- Returns true when NOT in a math zone.
function M.in_text()
	return not M.in_math()
end

--- Returns true when inside a LaTeX comment.
function M.in_comment()
	local line   = vim.api.nvim_get_current_line()
	local col    = vim.api.nvim_win_get_cursor(0)[2]
	local before = line:sub(1, col)
	return before:match("%%") ~= nil
end

--- Returns true when the trigger is at the beginning of a line (modulo whitespace).
--- Written nil-safe: matched_trigger may be nil during completion scanning.
function M.line_begin(line_to_cursor, matched_trigger)
	local before = line_to_cursor
	if matched_trigger and #matched_trigger > 0 then
		before = line_to_cursor:sub(1, #line_to_cursor - #matched_trigger)
	end
	return before:match("^%s*$") ~= nil
end

-- ─── Shorthand node builders ─────────────────────────────────────────────────

M.s    = ls.snippet
M.sn   = ls.snippet_node
M.t    = ls.text_node
M.i    = ls.insert_node
M.f    = ls.function_node
M.c    = ls.choice_node
M.d    = ls.dynamic_node
M.r    = ls.restore_node
M.l    = require("luasnip.extras").lambda
M.rep  = require("luasnip.extras").rep
M.p    = require("luasnip.extras").partial
M.m    = require("luasnip.extras").match
M.n    = require("luasnip.extras").nonempty
M.dl   = require("luasnip.extras").dynamic_lambda
M.fmt  = require("luasnip.extras.fmt").fmt
M.fmta = require("luasnip.extras.fmt").fmta

-- ─── Auto-snippet builder (saves boilerplate) ────────────────────────────────

--- Build an autosnippet with common defaults.
---@param trig string
---@param nodes table
---@param opts table|nil  extra opts merged into snippet opts
function M.auto(trig, nodes, opts)
	opts = opts or {}
	return ls.snippet(
		vim.tbl_extend("force", {
			trig        = trig,
			regTrig     = true,
			snippetType = "autosnippet",
		}, opts),
		nodes
	)
end

--- Auto-snippet that only fires in math mode.
function M.maths(trig, nodes, opts)
	opts = opts or {}
	return M.auto(trig, nodes, vim.tbl_extend("force", {
		condition      = M.in_math,
		show_condition = M.in_math,
		trigEngine     = "plain",
		wordTrig       = false,
	}, opts))
end

--- Auto-snippet that only fires in text mode.
function M.texts(trig, nodes, opts)
	opts = opts or {}
	return M.auto(trig, nodes, vim.tbl_extend("force", {
		condition      = M.in_text,
		show_condition = M.in_text,
		trigEngine     = "plain",
	}, opts))
end

--- Regular snippet (not auto) that fires in math mode.
function M.msnip(trig, nodes, opts)
	opts = opts or {}
	return ls.snippet(vim.tbl_extend("force", {
		trig = trig,
		condition = M.in_math,
		show_condition = M.in_math,
	}, opts), nodes)
end

return M
