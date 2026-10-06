-- lua/snippets/tex/math.lua
-- Core math autosnippets – Gilles Castel style.

local H    = require("snippets.tex._helpers")
local ls   = require("luasnip")
local t    = H.t
local i    = H.i
local f    = H.f
local c    = H.c
local sn   = H.sn
local fmt  = H.fmt
local fmta = H.fmta
local rep  = H.rep

-- Shorthand builders
local function ma(trig, nodes, opts) return H.maths(trig, nodes, opts) end
local function ms(trig, nodes, opts) return H.msnip(trig, nodes, opts) end

-- ─── Inline / display math delimiters (text mode) ────────────────────────────
local text_snips = {
	H.texts("mm", fmta("$<>$<>", { i(1), i(0) })),
	H.texts("dm", fmta([[
\[
	<>
\] <>]], { i(1), i(0) })),
}

-- ─── Subscript / superscript (math mode) ─────────────────────────────────────
local sub_super = {
	-- Single digit auto-subscript: a1 → a_{1}
	ma("__", fmta("_{<>}", { i(1) })),
	ma("tt", fmta("^{<>}", { i(1) })),

	-- Two-char auto-subscript trigger: td → _{...}
	-- Regex: word char followed by digit triggers sub
	H.auto("(%a)(%d)", {
		f(function(_, snip) return snip.captures[1] .. "_{" .. snip.captures[2] .. "}" end, {}),
	}, { condition = H.in_math }),

	-- Superscript shortcuts
	ma("sq", t("^{2}")),
	ma("cb", t("^{3}")),
	ma("inv", t("^{-1}")),
	ma("tp", t("^{\\top}")),
	ma("dag", t("^{\\dagger}")),
}

-- ─── Fractions ────────────────────────────────────────────────────────────────
local fractions = {
	-- // → \frac{}{}
	ma("//", fmta("\\frac{<>}{<>}", { i(1), i(2) })),

	-- Regex fraction: 3/ → \frac{3}{}, expr/ → \frac{expr}{}
	H.auto("([%a%d%.]+)/", {
		f(function(_, snip) return "\\frac{" .. snip.captures[1] .. "}{" end, {}),
		i(1),
		t("}"),
	}, { condition = H.in_math }),

	-- Partial fraction
	ma("par", fmta("\\frac{\\partial <>}{\\partial <>}", { i(1), i(2) })),
	ma("ddt", fmta("\\frac{d<>}{d<>}", { i(1, ""), i(2, "t") })),
}

-- ─── Sums, products, integrals ───────────────────────────────────────────────
local calculus = {
	ma("sum", fmta("\\sum_{<>}^{<>} <>", { i(1, "n=1"), i(2, "\\infty"), i(0) })),
	ma("prod", fmta("\\prod_{<>}^{<>} <>", { i(1, "n=1"), i(2, "\\infty"), i(0) })),

	ma(
		"int",
		fmta("\\int_{<>}^{<>} <> \\, d<>", { i(1, "-\\infty"), i(2, "\\infty"), i(3), i(4, "x") }),
		{ wordTrig = true }
	),
	ma("oint", fmta("\\oint_{<>} <> \\, d<>", { i(1), i(2), i(3) }), { wordTrig = true }),
	ma("iint", fmta("\\iint_{<>} <> \\, d<>", { i(1), i(2), i(3) }), { wordTrig = true }),
	ma("iiint", fmta("\\iiint_{<>} <> \\, d<>", { i(1), i(2), i(3) }), { wordTrig = true }),

	ma("lim", fmta("\\lim_{<> \\to <>} <>", { i(1, "n"), i(2, "\\infty"), i(0) })),
	-- ma("limsup", fmta("\\limsup_{<> \\to <>} <>",   { i(1, "n"), i(2, "\\infty"), i(0) })),
	-- ma("liminf", fmta("\\liminf_{<> \\to <>} <>",   { i(1, "n"), i(2, "\\infty"), i(0) })),
}

-- ─── Operators & relations ───────────────────────────────────────────────────
local operators = {
	-- Arrows
	ma("->", t("\\rightarrow ")),
	ma("<-", t("\\leftarrow ")),
	ma("=>", t("\\Rightarrow ")),
	ma("<=", t("\\Leftarrow")),
	ma("<=>", t("\\Leftrightarrow ")),
	-- ma("!>",   t("\\mapsto ")),
	-- ma("~>",   t("\\leadsto ")),
	-- ma(">>",   t("\\gg ")),
	-- ma("<<",   t("\\ll ")),

	-- Logic
	-- ma("AA",   t("\\forall ")),
	-- ma("EE",   t("\\exists ")),
	-- ma("!EE",  t("\\nexists ")),
	-- ma("inn",  t("\\in ")),
	-- ma("notin",t("\\notin ")),
	-- ma("cc",   t("\\subset ")),
	-- ma("cce",  t("\\subseteq ")),
	-- ma("and",  t("\\cap ")),
	-- ma("or",   t("\\cup ")),
	-- ma("\\\\\\\\", t("\\setminus ")),
	-- ma("compl",t("^{\\complement}")),

	-- Equality / inequality
	ma("!=", t("\\neq ")),
	ma("~~", t("\\approx ")),
	ma("~=", t("\\cong ")),
	ma("=~", t("\\simeq ")),
	ma("leq", t("\\leq ")),
	ma("geq", t("\\geq ")),
	ma("<<", t("\\ll ")),
	ma(">>", t("\\gg ")),
	-- ma("prop", t("\\propto ")),
	-- ma("perp", t("\\perp ")),
	-- ma("pll",  t("\\parallel ")),

	-- Misc math symbols
	ma("inf", t("\\infty")),
	ma("oo", t("\\infty")),
	ma("pm", t("\\pm ")),
	ma("mp", t("\\mp ")),
	ma("xx", t("\\times ")),
	ma("**", t("\\cdot ")),
	ma("...", t("\\ldots ")),
	ma("c..", t("\\cdots ")),
	-- ma("v..",  t("\\vdots ")),
	-- ma("d..",  t("\\ddots ")),
	ma("nabl", t("\\nabla ")),
	ma("del", t("\\partial ")),
	ma("hbar", t("\\hbar ")),
	ma("ell", t("\\ell ")),
	ma("Re", t("\\operatorname{Re}")),
	ma("Im", t("\\operatorname{Im}")),
	-- ma("Res",  t("\\operatorname{Res}")),
}

-- ─── Delimiters ───────────────────────────────────────────────────────────────
local delimiters = {
	ma("lrp", fmta("\\left( <> \\right)", { i(1) })),
	ma("lrs", fmta("\\left[ <> \\right]", { i(1) })),
	ma("lrb", fmta("\\left\\{ <> \\right\\}", { i(1) })),
	ma("lrv", fmta("\\left| <> \\right|", { i(1) })),
	ma("lrn", fmta("\\left\\| <> \\right\\|", { i(1) })),
	ma("lra", fmta("\\left\\langle <> \\right\\rangle", { i(1) })),
	ma("lrc", fmta("\\left\\lceil <> \\right\\rceil", { i(1) })),
	ma("lrf", fmta("\\left\\lfloor <> \\right\\rfloor", { i(1) })),
	ma("lrlr", fmta("\\left<> <> \\right<>", { i(1), i(3), i(2)})),
}

-- ─── Functions & decorators ───────────────────────────────────────────────────
fmta("%\\{<>\\}", { i(1) })

local functions_ = {
	-- Common functions (auto-operator)
	ma("sin", fmta("\\sin{<>}", { i(1) })),
	ma("cos", fmta("\\cos{<>}", { i(1) })),
	ma("tan", fmta("\\tan{<>}", { i(1) })),
	-- ma("asin", t("\\arcsin")),
	-- ma("acos", t("\\arccos")),
	-- ma("atan", t("\\arctan")),
	-- ma("sinh", fmta("\\sinh{<>}", { i(1) })),
	-- ma("cosh", fmta("\\cosh{<>}", { i(1) })),
	-- ma("tanh", fmta("\\tanh{<>}", { i(1) })),
	ma("cot", fmta("\\cot{<>}", { i(1) })),
	ma("csc", fmta("\\csc{<>}", { i(1) })),
	ma("sec", fmta("\\sec{<>}", { i(1) })),
	ma("log", fmta("\\log{<>}", { i(1) })),
	ma("ln", fmta("\\ln{<>}", { i(1) })),
	ma("exp", fmta("\\exp{<>}", { i(1) })),
	-- ma("det", fmta("\\det\\{<>\\}", { i(1) })),
	-- ma("dim", fmta("\\dim\\{<>\\}", { i(1) })),
	-- ma("ker", fmta("\\ker\\{<>\\}", { i(1) })),
	-- ma("rank", t("\\operatorname{rank}")),
	-- ma("tr", t("\\operatorname{tr}")),
	-- ma("diag", t("\\operatorname{diag}")),
	-- ma("span", t("\\operatorname{span}")),
	-- ma("sgn", t("\\operatorname{sgn}")),
	-- ma("supp", t("\\operatorname{supp}")),
	-- ma("hom", t("\\operatorname{Hom}")),
	-- ma("max", fmta("\\max\\{<>\\}", { i(1) })),
	-- ma("min", fmta("\\min\\{<>\\}", { i(1) })),
	-- ma("sup", fmta("\\sup\\{<>\\}", { i(1) })),
	-- ma("inf2", fmta("\\inf\\{<>\\}", { i(1) })),
	-- ma("arg", fmta("\\arg\\{<>\\}", { i(1) })),

	-- Decorated letters
	ma("bar", fmta("\\bar{<>}", { i(1) })),
	ma("hat", fmta("\\hat{<>}", { i(1) })),
	ma("til", fmta("\\tilde{<>}", { i(1) })),
	ma("vec", fmta("\\vec{<>}", { i(1) })),
	ma("dot", fmta("\\dot{<>}", { i(1) })),
	ma("ddot", fmta("\\ddot{<>}", { i(1) })),
	ma("udr", fmta("\\underline{<>}", { i(1) })),
	ma("ovl", fmta("\\overline{<>}", { i(1) })),
	ma("wh", fmta("\\widehat{<>}", { i(1) })),
	ma("wt", fmta("\\widetilde{<>}", { i(1) })),

	-- Roots
	ma("sq", fmta("\\sqrt{<>}", { i(1) })),
	ma("sqn", fmta("\\sqrt[<>]{<>}", { i(1), i(2) })),
}

-- ─── Fonts ────────────────────────────────────────────────────────────────────
local fonts = {
	-- ma("mbf", fmta("\\mathbf{<>}", { i(1) })),
	-- ma("mrm", fmta("\\mathrm{<>}", { i(1) })),
	-- ma("mbb", fmta("\\mathbb{<>}", { i(1) })),
	-- ma("mcal", fmta("\\mathcal{<>}", { i(1) })),
	-- ma("mscr", fmta("\\mathscr{<>}", { i(1) })),
	-- ma("mfr", fmta("\\mathfrak{<>}", { i(1) })),
	-- ma("msf", fmta("\\mathsf{<>}", { i(1) })),
	-- ma("mtt", fmta("\\mathtt{<>}", { i(1) })),

	-- Common blackboard bold shortcuts (auto)
	H.maths("RR", t("\\mathbb{R}")),
	H.maths("QQ", t("\\mathbb{Q}")),
	H.maths("ZZ", t("\\mathbb{Z}")),
	H.maths("NN", t("\\mathbb{N}")),
	H.maths("CC", t("\\mathbb{C}")),
	H.maths("FF", t("\\mathbb{F}")),
	H.maths("HH", t("\\mathbb{H}")),
	H.maths("PP", t("\\mathbb{P}")),
	H.maths("EE", t("\\mathbb{E}")), -- expectation
}

-- ─── Text inside math ─────────────────────────────────────────────────────────
local text_in_math = {
	ma("txt", fmta("\\text{<>}", { i(1) })),
	ma("tbf", fmta("\\textbf{<>}", { i(1) })),
}

local all = {}
vim.list_extend(all, text_snips)
vim.list_extend(all, sub_super)
vim.list_extend(all, fractions)
vim.list_extend(all, calculus)
vim.list_extend(all, operators)
vim.list_extend(all, delimiters)
vim.list_extend(all, functions_)
vim.list_extend(all, fonts)
vim.list_extend(all, text_in_math)
return all
