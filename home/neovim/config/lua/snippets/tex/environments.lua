-- lua/snippets/tex/environments.lua
-- Document structure environments – fired in text mode (or universally for some).

local H    = require("snippets.tex._helpers")
local ls   = require("luasnip")
local t    = H.t
local i    = H.i
local c    = H.c
local f    = H.f
local fmta = H.fmta
local fmt  = H.fmt
local rep  = H.rep

--- Build a plain environment snippet (text mode, line-begin).
local function env(trig, body_nodes, opts)
	opts = opts or {}
	return ls.snippet(vim.tbl_extend("force", {
		trig            = trig,
		condition       = H.line_begin,
		show_condition  = H.line_begin,
	}, opts), body_nodes)
end

--- Shortcut: \begin{name} ... \end{name} with a single insert node.
local function simple_env(trig, name, opts)
	return env(trig, fmta(string.format([[
\begin{%s}
	<>
\end{%s}]], name, name), { i(1) }), opts)
end

local snips = {}

-- ─── Generic environment (beg trigger) ───────────────────────────────────────
table.insert(snips, env("beg", fmta([[
\begin{<>}
	<>
\end{<>}]], { i(1, "name"), i(2), rep(1) })))

-- ─── Theorem-like environments ────────────────────────────────────────────────
-- local theorem_envs = {
-- 	{ "thm",   "theorem" },
-- 	{ "lem",   "lemma" },
-- 	{ "cor",   "corollary" },
-- 	{ "prop",  "proposition" },
-- 	{ "defn",  "definition" },
-- 	{ "rem",   "remark" },
-- 	{ "exm",   "example" },
-- 	{ "exr",   "exercise" },
-- 	{ "prf",   "proof" },
-- 	{ "clm",   "claim" },
-- 	{ "conj",  "conjecture" },
-- 	{ "ntn",   "notation" },
-- 	{ "obs",   "observation" },
-- }
--
-- for _, pair in ipairs(theorem_envs) do
-- 	local trig, name = pair[1], pair[2]
-- 	-- with optional title: \begin{theorem}[title]
-- 	table.insert(snips, env(trig, fmta(string.format([[
-- \begin{%s}[<>]
-- 	<>
-- \end{%s}]], name, name), { i(1, ""), i(2) })))
-- end

-- ─── List environments ────────────────────────────────────────────────────────
table.insert(snips, env("item", fmta([[
\begin{itemize}
	\item <>
\end{itemize}]], { i(1) })))

table.insert(snips, env("enum", fmta([[
\begin{enumerate}
	\item <>
\end{enumerate}]], { i(1) })))

table.insert(snips, env("desc", fmta([[
\begin{description}
	\item[<>] <>
\end{description}]], { i(1), i(2) })))

-- ─── Figure / subfigure ───────────────────────────────────────────────────────
table.insert(snips, env("fig", fmta([[
\begin{figure}[<>]
	\centering
	\includegraphics[width=<>\linewidth]{<>}
	\caption{<>}
	\label{fig:<>}
\end{figure}]], { i(1, "htbp"), i(2, "0.8"), i(3), i(4), i(5) })))

table.insert(snips, env("sfig", fmta([[
\begin{subfigure}[b]{<>\textwidth}
	\centering
	\includegraphics[width=\linewidth]{<>}
	\caption{<>}
	\label{fig:<>}
\end{subfigure}]], { i(1, "0.45"), i(2), i(3), i(4) })))

-- ─── Table ────────────────────────────────────────────────────────────────────
table.insert(snips, env("tab", fmta([[
\begin{table}[<>]
	\centering
	\begin{tabular}{<>}
		\toprule
		<> \\
		\midrule
		<>
		\bottomrule
	\end{tabular}
	\caption{<>}
	\label{tab:<>}
\end{table}]], { i(1, "htbp"), i(2, "cc"), i(3, "Col1 & Col2"), i(4), i(5), i(6) })))

-- ─── Align environments ───────────────────────────────────────────────────────
table.insert(snips, env("ali", fmta([[
\begin{align}
	<>
\end{align}]], { i(1) })))

table.insert(snips, env("sali", fmta([[
\begin{align*}
	<>
\end{align*}]], { i(1) })))

table.insert(snips, env("eqn", fmta([[
\begin{equation}
	<>
\end{equation}]], { i(1) })))

table.insert(snips, env("seqn", fmta([[
\begin{equation*}
	<>
\end{equation*}]], { i(1) })))

table.insert(snips, env("gat", fmta([[
\begin{gather}
	<>
\end{gather}]], { i(1) })))

table.insert(snips, env("sgat", fmta([[
\begin{gather*}
	<>
\end{gather*}]], { i(1) })))

-- table.insert(snips, env("mlt", fmta([[
-- \begin{multline}
-- 	<>
-- \end{multline}]], { i(1) })))

-- ─── Split ────────────────────────────────────────────────────────────────────
-- table.insert(snips, env("spl", fmta([[
-- \begin{equation}
-- \begin{split}
-- 	<> &= <>\\
-- 	&= <>
-- \end{split}
-- \end{equation}]], { i(1), i(2), i(3) })))

-- ─── Tikz ─────────────────────────────────────────────────────────────────────
-- table.insert(snips, env("tikz", fmta([[
-- \begin{tikzpicture}[<>]
-- 	<>
-- \end{tikzpicture}]], { i(1, "scale=1"), i(2) })))

-- ─── Code listings ────────────────────────────────────────────────────────────
-- table.insert(snips, env("lst", fmta([[
-- \begin{lstlisting}[language=<>, caption={<>}, label={lst:<>}]
-- <>
-- \end{lstlisting}]], { i(1, "Python"), i(2), i(3), i(4) })))

-- table.insert(snips, env("mint", fmta([[
-- \begin{minted}{<>}
-- <>
-- \end{minted}]], { i(1, "python"), i(2) })))

-- ─── Frame (beamer) ───────────────────────────────────────────────────────────
-- table.insert(snips, env("frm", fmta([[
-- \begin{frame}{<>}
-- 	<>
-- \end{frame}]], { i(1, "Title"), i(2) })))

-- ─── Abstract ─────────────────────────────────────────────────────────────────
table.insert(snips, simple_env("abs", "abstract"))

-- ─── Minipage ─────────────────────────────────────────────────────────────────
-- table.insert(snips, env("mp", fmta([[
-- \begin{minipage}{<>\linewidth}
-- 	<>
-- \end{minipage}]], { i(1, "0.5"), i(2) })))

-- ─── Columns (beamer) ─────────────────────────────────────────────────────────
-- table.insert(snips, env("cols", fmta([[
-- \begin{columns}
-- 	\begin{column}{<>\textwidth}
-- 		<>
-- 	\end{column}
-- 	\begin{column}{<>\textwidth}
-- 		<>
-- 	\end{column}
-- \end{columns}]], { i(1, "0.5"), i(2), i(3, "0.5"), i(4) })))

return snips
