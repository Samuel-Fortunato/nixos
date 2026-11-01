-- lua/snippets/tex/formatting.lua
-- Text-mode formatting: bold, italic, emphasis, fonts, spacing, etc.

local H    = require("snippets.tex._helpers")
local ls   = require("luasnip")
local t    = H.t
local i    = H.i
local c    = H.c
local fmta = H.fmta

local snips = {}

-- ─── Font styles ──────────────────────────────────────────────────────────────
local styles = {
	{ "tbf",  "textbf"  },
	{ "tit",  "textit"  },
	{ "ttt",  "texttt"  },
	{ "tsc",  "textsc"  },
	{ "tsf",  "textsf"  },
	{ "trm",  "textrm"  },
	{ "tsl",  "textsl"  },
	{ "tup",  "textup"  },
	{ "tem",  "emph"    },
	{ "und",  "underline" },
}

for _, pair in ipairs(styles) do
	local trig, cmd = pair[1], pair[2]
	table.insert(snips, ls.snippet(trig, fmta(string.format("\\%s{<>}", cmd), { i(1) })))
end

-- ─── Color ────────────────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("col",  fmta("\\textcolor{<>}{<>}", { i(1, "red"), i(2) })))
-- Needs \usepackage{soul} so i deactivate it for now
-- table.insert(snips, ls.snippet("hl",   fmta("\\hl{<>}", { i(1) })))

-- ─── Sizing ───────────────────────────────────────────────────────────────────
local sizes = {
	"tiny", "scriptsize", "footnotesize", "small", "normalsize",
	"large", "Large", "LARGE", "huge", "Huge",
}
for n, siz in ipairs(sizes) do
	table.insert(snips, ls.snippet("siz" .. (n-5),
		fmta(string.format("{\\%s <>}", siz), { i(1) })))
end

-- ─── Spacing ──────────────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("vs",   fmta("\\vspace{<>}", { i(1, "1em") })))
table.insert(snips, ls.snippet("hs",   fmta("\\hspace{<>}", { i(1, "1em") })))
table.insert(snips, ls.snippet("vfil", t("\\vfill")))
table.insert(snips, ls.snippet("hfil", t("\\hfill")))
-- table.insert(snips, ls.snippet("nl",   t("\\\\")))
-- table.insert(snips, ls.snippet("npp",  t("\\newpage")))
-- table.insert(snips, ls.snippet("clp",  t("\\clearpage")))
table.insert(snips, ls.snippet("noin", t("\\noindent")))

-- ─── Centering / alignment ────────────────────────────────────────────────────
table.insert(snips, ls.snippet("ctr", fmta([[
\begin{center}
	<>
\end{center}]], { i(1) })))

-- ─── Verbatim ─────────────────────────────────────────────────────────────────
-- table.insert(snips, ls.snippet("vrb", fmta([[
-- \begin{verbatim}
-- <>
-- \end{verbatim}]], { i(1) })))

-- table.insert(snips, ls.snippet("vb",  fmta("\\verb|<>|", { i(1) })))

-- ─── Todo / annotations ───────────────────────────────────────────────────────
-- REQUIRES SOME PACKAGE
-- table.insert(snips, ls.snippet("td",  fmta("\\todo{<>}", { i(1) })))
-- table.insert(snips, ls.snippet("tdi", fmta("\\todo[inline]{<>}", { i(1) })))

-- ─── SI units ─────────────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("qty",  fmta("\\qty{<>}{<>}", { i(1), i(2, "\\meter") })))
table.insert(snips, ls.snippet("unt",  fmta("\\unit{<>}", { i(1, "\\meter") })))
table.insert(snips, ls.snippet("num",fmta("\\num{<>}", { i(1) })))

return snips
