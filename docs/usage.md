# EqAnnotate User Guide

EqAnnotate is a declarative package for annotated **display equations**. It is built on the equation-annotation workflow of [`annotate-equations`](https://github.com/st--/annotate-equations), with automatic self-layout as the default interaction.

The normal workflow is:

1. choose an EqAnnotate display wrapper;
2. wrap target subexpressions with `\eqmark`;
3. declare labels with `\eqannotate`;
4. compile until positions stabilize.

The automatic interface stays detail-free: no per-label coordinates, anchors, lane numbers, or route-track IDs are needed. This is convenient for human authors and particularly useful for coding/writing agents, because the agent can operate on semantic labels and symbolic LaTeX instead of solving a separate 2D placement problem.

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

EqAnnotate is designed to keep the ordinary annotation interface semantic rather than geometric. A coding or writing agent only needs to identify the target term and provide the label:

```latex
\eqmark[blue]{velocity}{v_\theta(x,t)}
\eqannotate{velocity}{Velocity field}
```

This avoids asking the agent to choose low-level TikZ details such as coordinates, anchors, lane numbers, or connector paths. In practice, LLM-based agents are generally more reliable at natural-language intent and symbolic code editing than at iterative visual-coordinate tuning, so the reduced layout decision space makes agent-generated annotations more consistent.

For agent projects, the repository includes [`skills/eqannotate/SKILL.md`](../skills/eqannotate/SKILL.md). The skill instructs the agent to use automatic layout first, compile to convergence, use side preferences sparingly, and reserve manual placement for difficult formulas.

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

With `[numbered]`, the whole block receives one outer equation number.

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

Long expressions with native amsmath multline-style first/last-row alignment:

```latex
\begin{annotatedmultline}
A = \eqmark[blue]{head}{x_1+x_2+x_3+x_4} \\
{} + x_5+x_6+x_7 \\
{} + \eqmark[orange]{tail}{x_8+x_9}

\eqannotate{head}{First contribution}
\eqannotate{tail}{Final contribution}
\end{annotatedmultline}
```

`\shoveleft` and `\shoveright` are supported. `[numbered]` follows the one-number model of amsmath `multline`.

## Themes and callout styles

Color and connector geometry are independent axes:

```latex
\eqannotatecolortheme{colorful} % or mono
\eqannotatecalloutstyle{leader} % or arrow
```

- `colorful`: pastel term backgrounds plus corresponding colored labels/connectors.
- `mono`: no term background; labels/connectors are black.
- `leader`: no arrowhead; quiet default.
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

Labels use a page-colored mask so connector segments passing beneath a label disappear rather than mixing with its text.

For a colored page:

```latex
\renewcommand\eqannotatebackgroundcolor{<color>}
```

Automatic background detection is on the roadmap.

## Roadmap

- [ ] Inline-math annotations
- [ ] Per-row numbering for aligned/gathered multi-line equations
- [ ] Custom `\tag` support
- [ ] `\intertext` / `\shortintertext` inside EqAnnotate multi-line wrappers
- [ ] Automatic page-background detection
- [ ] CTAN distribution

## Choosing automatic vs manual

Use `\eqannotate` for the default self-layouting path.

Use `prefer=above|below` when you want to suggest a side while keeping the solver active.

Use `\eqannotatemanual` when you want direct control over the final position or connector route.
