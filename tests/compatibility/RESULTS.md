# Compatibility gate results — v0.1.1

Tested on the current TeX Live environment with pdfLaTeX and LuaLaTeX unless stated otherwise.

## Formula-structure corpus

PASS on the current corpus for:

- nested fractions and radicals;
- `\exp`, `\log`, nested delimiters and `\left` / `\right`;
- superscripts and subscripts, including marked terms in script style;
- `\sum`, `\int`, expectations and KL-style expressions;
- vector/matrix notation and whole `bmatrix` subexpressions;
- norms, `\arg\min`, long subexpressions and nested functions;
- `cases` / piecewise definitions;
- single-column, two-column, and nested local-`\linewidth` layouts;
- numbered displays with `\label` / `\ref`;
- wrapped labels, dynamic lane heights, bounded horizontal de-overlap, crossing-aware relaxation, and connector masking.

The corpus uses patterns common in attention, cross-entropy, variational objectives, diffusion, probability-flow ODEs, flow matching, InfoNCE, Adam, constrained optimization, and linear algebra.

## Multi-line math wrappers

PASS:

- `annotatedalign` — aligned rows, one optional outer equation number;
- `annotatedgather` — centered rows, one optional outer equation number;
- `annotatedmultline` — native amsmath multline-style first/last-row alignment, one optional number;
- `annotatedmultline` with `\shoveleft` / `\shoveright`;
- labels on terms from different rows;
- `\label` / `\ref` on numbered gathered and multline blocks;
- two-column use of gathered and multline wrappers.

The native `multline` path requires special handling because amsmath performs an internal measuring pass. EqAnnotate makes semantic declarations inert during that pass and records target nodes only from the final typeset pass.

## Paper-class smoke tests

PASS with pdfLaTeX for:

- `IEEEtran` (`conference`);
- `acmart` (`sigconf,nonacm`);
- `revtex4-2` (`reprint`);
- `elsarticle` (`preprint`);
- `beamer` (single-frame smoke test).

The article-class compatibility corpus additionally runs with LuaLaTeX.

## Manual placement

PASS:

- manual label placement in all four directions;
- active color theme and leader/arrow style inherited by manual labels;
- optional manual TikZ `to[...]` routing (`bend left/right`, `out` / `in` style paths);
- automatic and manual labels mixed in one display;
- manual declaration overriding automatic placement for the same target with a warning;
- manual labels contributing to `.aux`-based vertical space reservation;
- manual placement in aligned multi-line blocks;
- duplicate/missing manual declarations producing controlled warnings;
- explicit error for manual use outside an EqAnnotate display.

Manual label-node and `to[...]` options determine placement and connector routes. Manual labels continue to use the active theme, callout style, masking, and vertical space reservation.

## Article-flow integration

Visual PASS on full-page fixtures:

- multi-page standard `article` with title/abstract/sections, numbered references, figure/table floats, consecutive annotated displays, long wrapped labels, aligned mathematics, and mixed automatic/manual placement;
- standard two-column article with long labels, dense automatic annotations, and manual placement;
- IEEEtran conference-style two-column article;
- acmart sigconf-style two-column article;
- automatic and manual annotation cases near page boundaries.

No annotation/prose collisions, detached overlays, lost equation references, or automatic-placement column overflows were observed. Normal LaTeX float reordering remains controlled by the document class/page builder.

## Failure behavior

PASS:

- missing target mark -> package warning, annotation skipped, compile continues;
- duplicate target ID -> package warning, first semantic target retained;
- duplicate annotation declaration -> package warning, last declaration retained;
- long annotation -> automatic bounded wrapping and dynamic-height layout without overfull annotation boxes;
- `\eqmark` / `\eqannotate` outside an EqAnnotate display -> explicit package error instead of broken remembered nodes.


## Release coverage

PASS:

- semantic mark IDs containing common punctuation (`.`, `:`, `_`, `-`, `/`) are mapped to private numeric TikZ node names;
- `hyperref` loaded before or after EqAnnotate, with `cleveref` references to numbered annotated equations;
- `fleqn` + `leqno` document-class options;
- `unicode-math` with LuaLaTeX and XeLaTeX, including the load order where `unicode-math` precedes EqAnnotate;
- package-only project installation (`eqannotate.sty` beside `main.tex`) under pdfLaTeX, LuaLaTeX, and XeLaTeX;
- LaTeX `\include` / `\includeonly` counter checkpointing, so cached annotation reserves keep stable environment IDs across partial builds;
- convergence-based test execution: test documents stabilize within five TeX runs.

Hidden multline measurement uses amsmath's `gathered` environment, so the package does not require `mathtools` and remains compatible with the tested `unicode-math` load orders.

## Current v0.1 scope

- inline math;
- per-row numbering semantics of native `align` and native `gather`;
- arbitrary custom equation tags;
- `\intertext` / `\shortintertext` inside EqAnnotate wrappers;
- automatic detection of non-white page backgrounds for label occlusion masks.
