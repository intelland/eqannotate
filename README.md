# EqAnnotate

[English](README.md) | [简体中文](https://github.com/intelland/eqannotate/blob/main/README.zh-CN.md)

[![CI](https://github.com/intelland/eqannotate/actions/workflows/ci.yml/badge.svg)](https://github.com/intelland/eqannotate/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/v/release/intelland/eqannotate)](https://github.com/intelland/eqannotate/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Declarative equation annotations with automatic layout for LaTeX.**

> Tell EqAnnotate what to label, not where to put the label.

EqAnnotate is a self-layouting LaTeX package for annotated display equations. Mark a mathematical term, declare its label, and let the package handle placement, wrapping, spacing, de-overlap, lane allocation, and connector routing.

<p align="center">
  <img src="https://raw.githubusercontent.com/intelland/eqannotate/main/docs/images/hero-complex.png"
       alt="EqAnnotate automatically lays out four annotations around a multi-term objective"
       width="900">
</p>

EqAnnotate keeps the source focused on mathematical meaning while automatically arranging a genuinely dense annotation set.

```latex
\begin{annotatedequation}
\mathcal{L}(\theta)
=
\eqmark[blue]{rec}{\lambda_{\mathrm{rec}}\mathcal{L}_{\mathrm{rec}}}
+
\eqmark[orange]{adv}{\lambda_{\mathrm{adv}}\mathcal{L}_{\mathrm{adv}}}
+
\eqmark[green]{cyc}{\lambda_{\mathrm{cyc}}\mathcal{L}_{\mathrm{cyc}}}
+
\eqmark[purple]{reg}{\lambda_{\mathrm{reg}}\|\theta\|_2^2}

\eqannotate{rec}{Reconstruction fidelity}
\eqannotate{adv}{Adversarial realism}
\eqannotate{cyc}{Cycle consistency}
\eqannotate{reg}{Regularization}
\end{annotatedequation}
```

## Same annotation intent, fewer spatial decisions

<p align="center">
  <img src="https://raw.githubusercontent.com/intelland/eqannotate/main/docs/images/layout-comparison.png"
       alt="Comparison of a lower-level annotated-equation workflow and EqAnnotate for the same four-label formula"
       width="1000">
</p>

[`annotate-equations`](https://github.com/st--/annotate-equations) established a convenient TikZ-based workflow for annotated equations and is the direct foundation/predecessor of EqAnnotate. EqAnnotate moves the common workflow one abstraction level higher: the caller declares the target and label, while the layout solver handles placement, wrapping, de-overlap, lane allocation, column bounds, and connector routing.

The difference is the abstraction level: EqAnnotate keeps the common annotation workflow declarative, with placement and routing handled by the layout solver.

## Why this matters for humans and agents

For human authors, fewer coordinates and TikZ adjustments mean shorter, more maintainable source and a more consistent annotation style.

For coding and writing agents, the useful decisions are semantic: which term matters, what it means, and what its label should say. EqAnnotate handles the associated placement, lane allocation, and connector routing.

> In normal use, both humans and agents specify what a term means; EqAnnotate decides where the annotation goes.

The optional [EqAnnotate skill](https://github.com/intelland/eqannotate/tree/main/skills/eqannotate) guides Codex- and Claude Code-style workflows toward automatic layout, convergence checks, and manual placement when exact control is useful. EqAnnotate itself is a LaTeX/TikZ package; the agent skill is optional.

## Release information

- Current stable version: v0.1.1
- License: MIT
- Requires: LaTeX2e, amsmath, xcolor, TikZ/tikzmark, expl3/xparse
- Tested engines: pdfLaTeX, LuaLaTeX, XeLaTeX
- Repository: https://github.com/intelland/eqannotate
- Issues: https://github.com/intelland/eqannotate/issues
- Documentation: [eqannotate.pdf](eqannotate.pdf)

## Install

### Overleaf or a local project

1. Download [`eqannotate.sty` from the latest GitHub Release](https://github.com/intelland/eqannotate/releases/latest/download/eqannotate.sty).
2. Upload or copy it next to `main.tex`.
3. Load it normally:

```latex
\usepackage{eqannotate}
```

See the [installation guide](https://github.com/intelland/eqannotate/blob/main/docs/installation.md) for user-wide TeX Live installation and the [user guide](https://github.com/intelland/eqannotate/blob/main/docs/usage.md) for the complete workflow.

## Core API

```latex
\eqmark[<color>]{<id>}{<math>}
\eqannotate[prefer=auto|above|below]{<id>}{<label>}

\eqannotatecolortheme{colorful} % or mono
\eqannotatecalloutstyle{leader} % or arrow
```

The display wrappers are `annotatedequation`, `annotatedalign`, `annotatedgather`, and `annotatedmultline`; each accepts optional `[numbered]`.

Use direct control for an annotation when exact placement is useful:

```latex
\eqannotatemanual[xshift=12mm,yshift=10mm][bend right=18]
  {velocity}{Velocity field}
```

Automatic labels measure and wrap themselves, respect the active `\linewidth`, reserve article space, and route connectors outside the formula. Manual labels retain the active theme, callout style, masking, and space reservation.

<p align="center">
  <img src="https://raw.githubusercontent.com/intelland/eqannotate/main/docs/images/style-gallery.png" alt="EqAnnotate color and callout style combinations" width="760">
</p>

## Roadmap

- [ ] Inline equation annotations
- [ ] Richer multi-row numbering
- [ ] Custom `\tag` support
- [ ] `\intertext` / `\shortintertext` in multi-line wrappers
- [ ] Improved non-white-background handling
- [ ] CTAN distribution

For a colored page today, set `\eqannotatebackgroundcolor` to the page color.

## Documentation

- [Package manual](eqannotate.pdf)
- [Installation](https://github.com/intelland/eqannotate/blob/main/docs/installation.md)
- [User Guide](https://github.com/intelland/eqannotate/blob/main/docs/usage.md)
- [Public API Contract](https://github.com/intelland/eqannotate/blob/main/docs/api-contract.md)
- [Layout Design](https://github.com/intelland/eqannotate/blob/main/docs/layout.md)
- [Validation](https://github.com/intelland/eqannotate/blob/main/docs/validation.md)

## Acknowledgements

EqAnnotate builds directly on the annotated-equation workflow and TikZ techniques demonstrated by [`annotate-equations`](https://github.com/st--/annotate-equations), adding a lower-configuration self-layouting layer.

It also draws inspiration from [`annotated_latex_equations`](https://github.com/synercys/annotated_latex_equations) for colorful annotated-equation presentation. [`ScholarPhi`](https://github.com/allenai/scholarphi) was an engineering reference for separating label measurement, placement, and leader routing.

Thank you to the LaTeX ecosystem around PGF/TikZ, `tikzmark`, and `amsmath`.

## Development

```bash
./tests/run.sh
./tests/compatibility/run.sh
```

Both suites run until layout state converges.

## License

MIT. See [LICENSE](LICENSE).
