# EqAnnotate User Guide

EqAnnotate is a declarative package for annotated **display equations**. It builds on the equation-annotation workflow of [`annotate-equations`](https://github.com/st--/annotate-equations) and uses automatic layout by default.

The normal workflow is:

1. choose an EqAnnotate display wrapper;
2. wrap target subexpressions with `\eqmark`;
3. declare labels with `\eqannotate`;
4. compile until positions stabilize.

The automatic interface uses semantic target IDs and labels; placement, lanes, and connector routing are handled by EqAnnotate.

## Minimal example

```latex
\documentclass{article}
\usepackage{eqannotate}

\begin{document}
\begin{annotatedequation}
p(x)=
\frac{1}{\sqrt{2\pi}\eqmark[blue]{sigma}{\sigma}}
\exp\left(-\frac{(x-\eqmark[yellow]{mu}{\mu})^2}{2\sigma^2}\right)

\eqannotate{mu}{Mean}
\eqannotate{sigma}{Scale}
\end{annotatedequation}
\end{document}
```

## Marking terms

```latex
\eqmark[<color>]{<id>}{<math>}
```

The ID is semantic and local to one EqAnnotate display. Common punctuation such as `.`, `:`, `_`, `-`, and `/` is supported. IDs are unique within the display; when an ID is repeated, EqAnnotate reports it and keeps the first target.

The optional color is used by the `colorful` theme. In `mono`, the mathematical term is shown without a colored background.

## Automatic annotations

```latex
\eqannotate{<id>}{<label>}
```

EqAnnotate decides side, horizontal position, lane, and connector route.

A soft side preference is available:

```latex
\eqannotate[prefer=above]{base}{Base velocity field}
\eqannotate[prefer=below]{result}{Resulting field}
```

These preferences keep automatic layout active while expressing which side is preferred.


## Agent-based workflows

A coding or writing agent can annotate an expression by identifying the target term and providing its label:

```latex
\eqmark[blue]{velocity}{v_\theta(x,t)}
\eqannotate{velocity}{Velocity field}
```

For agent-assisted projects, the repository includes [`skills/eqannotate/SKILL.md`](../skills/eqannotate/SKILL.md) with conventions for semantic IDs, convergence, side preferences, and manual placement.

## Display environments

### `annotatedequation`

One display equation, unnumbered by default:

```latex
\begin{annotatedequation}
  ...
\end{annotatedequation}
```

Add one equation number with:

```latex
\begin{annotatedequation}[numbered]
E=\eqmark[blue]{energy}{mc^2}
\eqannotate{energy}{Mass-energy term}
\label{eq:energy}
\end{annotatedequation}
```

Ordinary `\label` / `\ref` works.

### `annotatedalign`

Aligned multi-line mathematics:

```latex
\begin{annotatedalign}
r_0 &= \eqmark[blue]{start}{x_0-y},\\
r_{k+1} &= \eqmark[orange]{update}{r_k-\alpha_kAp_k},\\
x_{k+1} &= x_k+\eqmark[green]{step}{\alpha_kp_k}

\eqannotate{start}{Initial residual}
\eqannotate{update}{Residual update}
\eqannotate{step}{State update}
\end{annotatedalign}
```

With `[numbered]`, the entire block receives one equation number.

### `annotatedgather`

Centered multi-line rows:

```latex
\begin{annotatedgather}
a = \eqmark[blue]{first}{b+c},\\
d = \eqmark[orange]{second}{e+f}

\eqannotate{first}{First relation}
\eqannotate{second}{Second relation}
\end{annotatedgather}
```

With `[numbered]`, the whole block receives one number.

### `annotatedmultline`

Use `annotatedmultline` for long expressions that need a line break. It retains amsmath's first/last-row alignment; use `annotatedalign` for short expressions that need aligned rows.

```latex
\begin{annotatedmultline}
\eqmark[blue]{objective}{\mathcal{L}(\theta)}
=\mathrm{E}_{x\sim p_{\rm data}}\!\left[\ell_{\rm rec}(x;\theta)\right]
+\eqmark[orange]{adversarial}{\lambda_1\mathrm{E}_{z\sim p(z)}\!\left[\ell_{\rm adv}(z;\theta)\right]}\\
{}+\lambda_2\mathcal{L}_{\rm consistency}(\theta)
+\lambda_3\mathrm{E}_{t}\!\left[\|v_\theta(x_t,t)-u_t\|_2^2\right]
+\eqmark[green]{prior}{\lambda_4\mathcal{R}_{\rm prior}(\theta)}

\eqannotate{objective}{Total training objective}
\eqannotate{adversarial}{Adversarial objective}
\eqannotate{prior}{Prior regularizer}
\end{annotatedmultline}
```

`\shoveleft` and `\shoveright` are supported. With `[numbered]`, the entire block receives one equation number, like amsmath `multline`.

## Themes and callout styles

Theme and connector style can be selected independently:

```latex
\eqannotatecolortheme{colorful} % or mono
\eqannotatecalloutstyle{leader} % or arrow
```

- `colorful`: pastel term backgrounds plus corresponding colored labels/connectors.
- `mono`: no term background; labels/connectors are black.
- `leader`: plain connector without an arrowhead (the default).
- `arrow`: arrowhead points toward the marked term.

The four combinations can be switched without changing equation source or annotation declarations.

## Long labels and dense equations

Long labels are automatically wrapped to a bounded fraction of the active local `\linewidth`. The resulting multi-line height participates in lane spacing and vertical space reservation.

For dense equations, EqAnnotate first attempts bounded horizontal movement. It opens another lane only when the label cannot fit in an existing lane. Horizontal movement is bounded so labels remain visually connected to their targets.

The solver preserves target order where possible and uses separated routing micro-tracks when several connectors need horizontal motion.

## Manual control

For an equation that needs exact spatial control:

```latex
\eqannotatemanual[<label TikZ options>][<to-path options>]
  {<id>}{<label>}
```

Examples:

```latex
\eqannotatemanual[xshift=8mm,yshift=10mm]
  {mu}{Mean}
```

```latex
\eqannotatemanual[xshift=18mm,yshift=12mm][bend right=18]
  {mu}{Mean}
```

The first optional argument is passed to the label node; useful options include `xshift`, `yshift`, `anchor`, and `text width`. The second is passed to TikZ's `to[...]` path; examples include `bend left`, `bend right`, or `out` / `in`.

Manual annotations keep the active color theme, callout style, label masking, and vertical space reservation. The label position and connector route come directly from the options you provide.

If a target has both automatic and manual declarations, manual placement takes precedence and EqAnnotate reports the overlap.

## Article and column integration

EqAnnotate measures the active local `\linewidth`, so automatic layout adapts to single-column pages, two-column classes, and local-width contexts such as `minipage`.

Automatic and manual labels both contribute to vertical space reservation, allowing annotated displays to sit naturally inside continuous prose.

The regression corpus includes `article`, `IEEEtran`, `acmart`, `revtex4-2`, `elsarticle`, and `beamer` fixtures.

## Compilation

Recommended:

```bash
latexmk -pdf main.tex
```

EqAnnotate uses TikZ remembered positions together with `.aux`-based solved spacing. If compiling manually, rerun while the log contains:

```text
Rerun LaTeX for optimized annotation spacing
```

## Diagnostics

EqAnnotate reports common authoring mistakes directly in the log:

- annotation has no matching mark -> warning and skip;
- duplicate mark ID -> warning, first target retained;
- duplicate annotation declaration -> warning, last annotation retained;
- automatic and manual declaration for one target -> warning, manual wins;
- `\eqmark`, `\eqannotate`, or `\eqannotatemanual` outside an EqAnnotate display -> explicit package error.

## Colored page backgrounds

Labels use a page-colored mask to hide connector segments that pass beneath label text.

For a colored page:

```latex
\renewcommand\eqannotatebackgroundcolor{<color>}
```

## Roadmap

- [ ] Inline-math annotations
- [ ] Per-row numbering for aligned/gathered multi-line equations
- [ ] Custom `\tag` support
- [ ] `\intertext` / `\shortintertext` inside EqAnnotate multi-line wrappers
- [ ] Automatic page-background detection
- [ ] CTAN distribution

## Choosing automatic vs manual

Use `\eqannotate` for the automatic-layout workflow.

Use `prefer=above|below` when you want to suggest a side while keeping the solver active.

Use `\eqannotatemanual` when you want direct control over the final position or connector route.
