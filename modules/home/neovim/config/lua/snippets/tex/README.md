# LuaSnip LaTeX Snippets — Gilles Castel Style

A modular, extensive LuaSnip snippet collection for LaTeX, inspired by
[Gilles Castel's workflow](https://castel.dev/post/lecture-notes-1/).

---

## File Layout

```
~/.config/nvim/
├── lua/
│   ├── plugins/
│   │   └── luasnip.lua          ← Lazy.nvim plugin spec
│   └── snippets/
│       ├── tex.lua              ← Entry point (loaded by LuaSnip)
│       └── tex/
│           ├── _helpers.lua     ← Shared utilities & node builders
│           ├── greek.lua        ← Greek letters  (;a → \alpha, …)
│           ├── math.lua         ← Core math (fractions, integrals, operators…)
│           ├── matrices.lua     ← Matrix / table environments
│           ├── environments.lua ← LaTeX environments (theorem, figure, align…)
│           ├── structure.lua    ← Document structure & preamble
│           ├── formatting.lua   ← Text formatting (bold, italic, spacing…)
│           └── physics.lua      ← Physics package (bra-ket, derivatives…)
```

---

## Installation

1. **Copy** the entire `lua/` folder into `~/.config/nvim/lua/`.
2. **Replace** your existing `lua/plugins/luasnip.lua` with the one provided
   (or merge the relevant parts).
3. **Restart** Neovim — snippets load automatically via `from_lua`.

> **Tip:** Press `<leader>S` at any time to hot-reload all snippets without
> restarting Neovim.

---

## Key Bindings

| Key       | Action                        |
|-----------|-------------------------------|
| `<Tab>`   | Expand snippet / jump forward |
| `<S-Tab>` | Jump backward                 |
| `<C-E>`   | Cycle through choice nodes    |
| `<leader>S` | Reload all snippets         |

---

## Snippet Reference

### Greek Letters (`tex/greek.lua`)
Trigger prefix `;` — only active **inside math mode**.

| Trigger | Output         | Trigger | Output       |
|---------|----------------|---------|--------------|
| `;a`    | `\alpha`       | `;b`    | `\beta`      |
| `;g`    | `\gamma`       | `;G`    | `\Gamma`     |
| `;d`    | `\delta`       | `;D`    | `\Delta`     |
| `;e`    | `\epsilon`     | `;ve`   | `\varepsilon`|
| `;th`   | `\theta`       | `;Th`   | `\Theta`     |
| `;l`    | `\lambda`      | `;L`    | `\Lambda`    |
| `;s`    | `\sigma`       | `;S`    | `\Sigma`     |
| `;o`    | `\omega`       | `;O`    | `\Omega`     |
| `;f`    | `\phi`         | `;vf`   | `\varphi`    |
| `;p`    | `\pi`          | `;P`    | `\Pi`        |

---

### Math Mode (`tex/math.lua`)

#### Delimiters (text mode)
| Trigger | Output                    |
|---------|---------------------------|
| `mm`    | `$...$` (inline math)     |
| `dm`    | `\[ ... \]` (display)     |

#### Fractions
| Trigger  | Output                      |
|----------|-----------------------------|
| `//`     | `\frac{}{}`                 |
| `3/`     | `\frac{3}{}`  (auto-regex)  |
| `par`    | `\frac{\partial}{\partial}` |
| `ddt`    | `\frac{d}{dt}`              |

#### Integrals & Sums
| Trigger  | Output                              |
|----------|-------------------------------------|
| `int`    | `\int_{-\infty}^{\infty} ... dx`   |
| `sum`    | `\sum_{n=1}^{\infty}`               |
| `prod`   | `\prod_{n=1}^{\infty}`              |
| `lim`    | `\lim_{n \to \infty}`               |

#### Operators & Symbols
| Trigger | Output         | Trigger | Output       |
|---------|----------------|---------|--------------|
| `->`    | `\to`          | `=>`    | `\implies`   |
| `<=>`   | `\iff`         | `!>`    | `\mapsto`    |
| `AA`    | `\forall`      | `EE`    | `\exists`    |
| `inn`   | `\in`          | `notin` | `\notin`     |
| `oo`    | `\infty`       | `xx`    | `\times`     |
| `**`    | `\cdot`        | `nabl`  | `\nabla`     |

#### Decorators
| Trigger | Output           |
|---------|------------------|
| `bar`   | `\bar{}`         |
| `hat`   | `\hat{}`         |
| `vec`   | `\vec{}`         |
| `dot`   | `\dot{}`         |
| `sq`    | `\sqrt{}`        |
| `wh`    | `\widehat{}`     |

#### Blackboard Bold (auto)
| Trigger | Output       |
|---------|--------------|
| `RR`    | `\mathbb{R}` |
| `ZZ`    | `\mathbb{Z}` |
| `QQ`    | `\mathbb{Q}` |
| `CC`    | `\mathbb{C}` |
| `NN`    | `\mathbb{N}` |

---

### Matrices (`tex/matrices.lua`)
Active in **math mode**.

| Trigger   | Output                          |
|-----------|---------------------------------|
| `pmat2`   | 2×2 `pmatrix`                  |
| `pmat3`   | 3×3 `pmatrix`                  |
| `bmat2`   | 2×2 `bmatrix`                  |
| `pmatc2`  | 2×1 column vector `pmatrix`    |
| `cases`   | `cases` environment            |
| `arr`     | `array` environment            |

Supported matrix types: `pmat`, `bmat`, `Bmat`, `vmat`, `Vmat`, `smat`.

---

### Environments (`tex/environments.lua`)

| Trigger  | Environment              |
|----------|--------------------------|
| `beg`    | Generic `\begin{}...\end{}` |
| `thm`    | `theorem`                |
| `lem`    | `lemma`                  |
| `defn`   | `definition`             |
| `prf`    | `proof`                  |
| `ali`    | `align`                  |
| `ali*`   | `align*`                 |
| `eqn`    | `equation`               |
| `fig`    | `figure`                 |
| `tab`    | `table` (with booktabs)  |
| `item`   | `itemize`                |
| `enum`   | `enumerate`              |
| `tikz`   | `tikzpicture`            |
| `frm`    | `frame` (beamer)         |
| `spl`    | `equation`+`split`       |

---

### Structure (`tex/structure.lua`)

| Trigger  | Output                        |
|----------|-------------------------------|
| `docsk`  | Full document skeleton        |
| `dclass` | `\documentclass[]{}`         |
| `sec`    | `\section{}`                  |
| `ssec`   | `\subsection{}`               |
| `lab`    | `\label{:}`                   |
| `rf`     | `\ref{}`                      |
| `crf`    | `\cref{}`                     |
| `ci`     | `\cite{}`                     |
| `fn`     | `\footnote{}`                 |
| `href2`  | `\href{url}{text}`            |

---

### Formatting (`tex/formatting.lua`)

| Trigger | Output           |
|---------|------------------|
| `tbf`   | `\textbf{}`      |
| `tit`   | `\textit{}`      |
| `ttt`   | `\texttt{}`      |
| `tem`   | `\emph{}`        |
| `col`   | `\textcolor{}{}` |
| `vs`    | `\vspace{}`      |
| `vb`    | `\verb\|\|`      |

---

### Physics (`tex/physics.lua`)
Requires the `physics` LaTeX package.

| Trigger | Output                      |
|---------|-----------------------------|
| `bra`   | `\bra{}`                    |
| `ket`   | `\ket{}`                    |
| `brk`   | `\braket{}{}`               |
| `mel`   | `\mel{}{}{}`                |
| `ev`    | `\expval{}`                 |
| `comm`  | `\comm{}{}`                 |
| `dv`    | `\dv{}{}`                   |
| `pdv`   | `\pdv{}{}`                  |
| `norm`  | `\norm{}`                   |
| `grad`  | `\gradient`                 |
| `curl`  | `\curl`                     |
| `div`   | `\divergence`               |
| `Ham`   | `\mathcal{H}`               |
| `Lag`   | `\mathcal{L}`               |

---

## Adding Your Own Snippets

1. Create a new file in `lua/snippets/tex/`, e.g. `statistics.lua`.
2. Require `_helpers` and build your snippets using `H.maths()`, `H.texts()`,
   or raw `ls.snippet()`.
3. Return the list of snippets at the bottom.
4. Add your module to the `modules` table in `lua/snippets/tex.lua`.
5. Press `<leader>S` to reload — no restart needed.

---

## Math Mode Detection

The `_helpers.lua` math detection uses a three-tier fallback:

1. **vimtex** — most accurate for complex documents (install vimtex for best results)
2. **Treesitter** — requires `nvim-treesitter` with `latex` grammar installed
3. **Line heuristic** — counts unescaped `$` on the current line (fast but limited)

For the best experience, install [vimtex](https://github.com/lervag/vimtex).
