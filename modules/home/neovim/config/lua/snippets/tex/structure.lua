-- lua/snippets/tex/structure.lua
-- Document-level and preamble snippets.

local H     = require("snippets.tex._helpers")
local ls    = require("luasnip")
local t     = H.t
local i     = H.i
local c     = H.c
local f     = H.f
local fmta  = H.fmta
local fmt   = H.fmt

local snips = {}

-- ─── Document class ───────────────────────────────────────────────────────────
-- table.insert(snips, ls.snippet("dclass", fmta([[
-- \documentclass{<>}
-- ]], { c(1, { t("article"), t("report"), t("book"), t("beamer") }) })))

-- ─── Full document skeleton ───────────────────────────────────────────────────
table.insert(snips, ls.snippet("docsk", fmta([[
\documentclass{article}

% ---------- Packages ----------
\usepackage{graphicx} % Required for inserting images
\usepackage[<1>]{babel}
\usepackage{lipsum}
\usepackage{indentfirst}
\usepackage{microtype}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath}
\usepackage{hyperref}
\usepackage{cleveref}
\usepackage{circuitikz}
\usepackage{booktabs}

% ---------- Metadata ----------
\title{<2>}
\author{<3>}
\date{\today}

\begin{document}
\maketitle

<4>

\end{document}
]], { i(1, "english"), i(2, "Title"), i(3, "Author"), i(4, "\\lipsum[1-2]") })))

-- ─── Section / subsection ─────────────────────────────────────────────────────
table.insert(snips, ls.snippet({ trig = "sec", condition = H.line_begin },
	fmta("\\section{<>}\n<>", { i(1), i(0) })))

table.insert(snips, ls.snippet({ trig = "ssec", condition = H.line_begin },
	fmta("\\subsection{<>}\n<>", { i(1), i(0) })))

table.insert(snips, ls.snippet({ trig = "sssec", condition = H.line_begin },
	fmta("\\subsubsection{<>}\n<>", { i(1), i(0) })))

table.insert(snips, ls.snippet({ trig = "par", condition = H.line_begin },
	fmta("\\paragraph{<>}\n<>", { i(1), i(0) })))

-- ─── Input / include ──────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("inp", fmta("\\input{<>}", { i(1) })))
table.insert(snips, ls.snippet("inc", fmta("\\include{<>}", { i(1) })))

-- ─── Labels and refs ──────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("lab", fmta("\\label{<>:<>}", { i(1, "sec"), i(2) })))
table.insert(snips, ls.snippet("rf", fmta("\\ref{<>}", { i(1) })))
table.insert(snips, ls.snippet("crf", fmta("\\cref{<>}", { i(1) })))
table.insert(snips, ls.snippet("erf", fmta("\\eqref{<>}", { i(1) })))

-- ─── Citations ────────────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("cit", fmta("\\cite{<>}", { i(1) })))
-- table.insert(snips, ls.snippet("citp", fmta("\\cite[<>]{<>}", { i(1, "p.~1"), i(2) })))
-- table.insert(snips, ls.snippet("bib", fmta([[
-- \bibliographystyle{<>}
-- \bibliography{<>}]], { c(1, { t("plain"), t("alpha"), t("abbrv"), t("unsrt") }), i(2, "references") })))

-- ─── Footnotes / margin ───────────────────────────────────────────────────────
-- table.insert(snips, ls.snippet("fn", fmta("\\footnote{<>}", { i(1) })))
-- table.insert(snips, ls.snippet("mn", fmta("\\marginnote{<>}", { i(1) })))

-- ─── Hyperref ─────────────────────────────────────────────────────────────────
table.insert(snips, ls.snippet("href", fmta("\\href{<>}{<>}", { i(1, "url"), i(2, "text") })))
table.insert(snips, ls.snippet("url", fmta("\\url{<>}", { i(1) })))

return snips
