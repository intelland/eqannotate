# EqAnnotate User Guide

EqAnnotate is a declarative package for annotated **display equations**. The normal workflow is:

1. choose an EqAnnotate display wrapper;
2. wrap target subexpressions with `\eqmark`;
3. declare labels with `\eqannotate`;
4. compile until positions stabilize.

The automatic path intentionally does not expose per-label coordinates, anchors, lane numbers, or route-track IDs.

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

The ID is semantic and local to one EqAnnotate display. Common punctuation such as `.`, `:`, `_`, `-`, and `/` is supported. IDs must be unique within the display; a duplicate mark produces a warning and keeps the first target.

The optional color is used by the `colorful` theme. In `mono`, the mathematical term remains visually unhighlighted.

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

These are preferences, not coordinates; automatic layout remains active.

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

For dense equations, EqAnnotate first attempts bounded horizontal movement. It opens another lane only when the label cannot fit legally in an existing lane. Horizontal movement is bounded so labels are not moved arbitrarily far from their targets.

The solver preserves target order where possible and uses separated routing micro-tracks when several connectors need horizontal motion.

## Manual escape hatch

For an exceptional formula that automatic layout cannot express satisfactorily:

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

Manual annotations:

- inherit the active color theme and callout style;
- participate in vertical space reservation;
- use the same label masking behavior as automatic labels;
- deliberately bypass automatic collision avoidance, column clamping, lane assignment, and crossing optimization.

If a target has both automatic and manual declarations, manual placement wins with a warning.

## Article and column integration

EqAnnotate measures the active local `\linewidth`, so automatic layout adapts to single-column pages, two-column classes, and local-width contexts such as `minipage`.

Automatic and manual labels both contribute to vertical space reservation. This is what allows annotation-heavy displays to coexist with continuous prose rather than simply overlaying the following paragraph.

The regression corpus includes `article`, `IEEEtran`, `acmart`, `revtex4-2`, `elsarticle`, and `beamer` fixtures.

## Compilation

Recommended:

```bash
latexmk -pdf main.tex
```

EqAnnotate needs multiple passes because it combines TikZ remembered positions with `.aux`-based spacing. If compiling manually, rerun while the log contains:

```text
Rerun LaTeX for optimized annotation spacing
```

This is expected during convergence.

## Diagnostics

Controlled diagnostics include:

- annotation has no matching mark -> warning and skip;
- duplicate mark ID -> warning, first target retained;
- duplicate annotation declaration -> warning, last annotation retained;
- automatic and manual declaration for one target -> warning, manual wins;
- `\eqmark`, `\eqannotate`, or `\eqannotatemanual` outside an EqAnnotate display -> explicit package error.

## Non-white backgrounds

Labels use a page-colored mask so connector segments passing beneath a label disappear rather than mixing with its text. v0.1 assumes a white page by default.

For a different page color:

```latex
\renewcommand\eqannotatebackgroundcolor{<color>}
```

Automatic page-background detection is not implemented in v0.1.

## v0.1 limitations

Deliberate non-goals:

- inline-math annotations;
- native per-row numbering for `align` / `gather`;
- arbitrary custom `\tag` behavior;
- `\intertext` / `\shortintertext` inside EqAnnotate multi-line wrappers;
- automatic page-background detection.

## Choosing automatic vs manual

Use automatic placement by default. It receives column awareness, wrapping, de-overlap, lane assignment, and routing optimization.

Use `prefer=above|below` when only the side matters.

Use manual placement only when a difficult formula genuinely needs precise spatial control that the automatic solver cannot find.
