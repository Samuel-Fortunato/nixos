-- lua/snippets/tex/greek.lua
-- Greek letter autosnippets – fire only in math mode.
-- Castel style: short alphabetic triggers prefixed with `;`

local H   = require("snippets.tex._helpers")
local ls  = require("luasnip")
local t   = H.t

local function mg(trig, expansion)
	return H.maths(trig, t(expansion), { trigEngine = "plain", priority = 100 })
end

-- ─── Lowercase ───────────────────────────────────────────────────────────────
return {
	mg(";a",  "\\alpha"),
	mg(";b",  "\\beta"),
	mg(";g",  "\\gamma"),
	mg(";G",  "\\Gamma"),
	mg(";d",  "\\delta"),
	mg(";D",  "\\Delta"),
	mg(";e",  "\\epsilon"),
	mg(";ve", "\\varepsilon"),
	mg(";z",  "\\zeta"),
	mg(";h",  "\\eta"),
	mg(";th", "\\theta"),
	mg(";Th", "\\Theta"),
	mg(";vth","\\vartheta"),
	mg(";i",  "\\iota"),
	mg(";k",  "\\kappa"),
	mg(";l",  "\\lambda"),
	mg(";L",  "\\Lambda"),
	mg(";m",  "\\mu"),
	mg(";n",  "\\nu"),
	mg(";x",  "\\xi"),
	mg(";X",  "\\Xi"),
	mg(";pi",  "\\pi"),
	mg(";Pi",  "\\Pi"),
	mg(";r",  "\\rho"),
	mg(";vr", "\\varrho"),
	mg(";s",  "\\sigma"),
	mg(";S",  "\\Sigma"),
	mg(";ta",  "\\tau"),
	mg(";u",  "\\upsilon"),
	mg(";U",  "\\Upsilon"),
	mg(";ph",  "\\phi"),
	mg(";Ph",  "\\Phi"),
	mg(";vph", "\\varphi"),
	mg(";c",  "\\chi"),
	mg(";ps", "\\psi"),
	mg(";Ps", "\\Psi"),
	mg(";o",  "\\omega"),
	mg(";O",  "\\Omega"),
}
