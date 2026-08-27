# EqAnnotate

**Declarative equation annotations with automatic layout for LaTeX.**

> Tell EqAnnotate what to label, not where to put the label.

EqAnnotate is a self-layouting LaTeX package for annotated display equations. Mark a mathematical term, declare its label, and let the package handle placement, spacing, de-overlap, column bounds, lane allocation, and connector routing.

```latex
\begin{annotatedequation}
p(x)=
\frac{1}{\sqrt{2\pi}\eqmark[blue]{sigma}{\sigma}}
\exp\left(-\frac{(x-\eqmark[yellow]{mu}{\mu})^2}{2\sigma^2}\right)

\eqannotate{mu}{Mean}
\eqannotate{sigma}{Scale}
\end{annotatedequation}
```

<p align="center">
  <img src="docs/images/basic.png" alt="EqAnnotate basic example" width="760">
</p>

## Why EqAnnotate?

EqAnnotate is built on the equation-annotation workflow introduced by [`annotate-equations`](https://github.com/st--/annotate-equations): mark a term in the equation, attach a callout, and render it with TikZ.

`annotate-equations` provides concise primitives for manual equation annotation. The caller still chooses the side, offset, and other spatial details, for example:

```latex
\eqnmarkbox[blue]{velocity}{v_\theta(x,t)}
\annotate[yshift=1em]{above}{velocity}{Velocity field}
```

EqAnnotate keeps the same basic idea but moves the common path one level higher:

```latex
\eqmark[blue]{velocity}{v_\theta(x,t)}
\eqannotate{velocity}{Velocity field}
```

The difference is simple: **EqAnnotate asks the caller to decide less.** The package measures the equation and labels, chooses placement, respects the active `\linewidth`, moves labels horizontally when needed, opens extra lanes only when necessary, reserves article space, and routes connectors outside the formula.

That makes the interface useful in two ways:

- **For people:** annotation code becomes shorter and easier to maintain because the common case no longer requires hand-tuning anchors, offsets, lanes, or connector paths.
- **For coding and writing agents:** the task is shifted away from fragile 2D layout decisions and toward semantic declarations such as “this term is the velocity field.” LLM-based agents are typically much stronger at understanding and manipulating language and symbolic structure than at repeatedly tuning visual coordinates. Reducing the spatial degrees of freedom therefore makes generated LaTeX more consistent and less error-prone.

In normal use, both humans and agents only specify **what** a term means. EqAnnotate decides **where** the annotation should go. When a particular formula needs exact spatial control, the same package keeps a manual interface.

## Install

### Overleaf

Upload `eqannotate.sty` to the project root and add:

```latex
\usepackage{eqannotate}
```

### Local project

Copy `eqannotate.sty` next to `main.tex` and use the same `\usepackage{eqannotate}` line.

See [Installation](docs/installation.md) for a user-wide TeX Live install and the optional agent skill.

## Compile

EqAnnotate uses TikZ remembered positions and `.aux`-based space reservation, so several TeX runs can be required on a fresh document. The easiest route is:

```bash
latexmk -pdf main.tex
```

With `pdflatex`, `lualatex`, or `xelatex` directly, rerun until EqAnnotate no longer asks for another pass.

## Core API

```latex
\eqmark[<color>]{<id>}{<math>}

\eqannotate{<id>}{<label>}
\eqannotate[prefer=above]{<id>}{<label>}
\eqannotate[prefer=below]{<id>}{<label>}

\eqannotatecolortheme{colorful} % or mono
\eqannotatecalloutstyle{leader} % or arrow
```

<p align="center">
  <img src="docs/images/style-gallery.png" alt="EqAnnotate style gallery" width="760">
</p>

Supported display wrappers in v0.1:

```text
annotatedequation
annotatedalign
annotatedgather
annotatedmultline
```

Each accepts optional `[numbered]`. `annotatedalign` and `annotatedgather` use one number for the whole block; `annotatedmultline` follows amsmath `multline`'s one-number model.

See the [User Guide](docs/usage.md) for numbering, multi-line equations, manual placement, themes, diagnostics, and examples.

## Automatic layout

- equation- and term-aware above/below placement;
- real label measurement and automatic long-label wrapping;
- dynamic lane heights;
- active-column / local-`\linewidth` bounds;
- bounded horizontal de-overlap before opening new lanes;
- order-aware relaxation to reduce leader crossings;
- separated routing micro-tracks for dense callouts;
- vertical space reservation for automatic **and manual** annotations;
- connector masking behind annotation labels;
- independent `colorful` / `mono` and `leader` / `arrow` style axes.

## Manual control

For a formula that benefits from exact positioning, switch only that annotation to the manual interface:

```latex
\eqannotatemanual[xshift=12mm,yshift=10mm][bend right=18]
  {velocity}{Velocity field}
```

Manual annotations keep the active theme, callout style, label masking, and article-space reservation while giving direct TikZ control over label placement and connector shape.

## Compatibility

EqAnnotate is covered by regression tests across:

- pdfLaTeX and LuaLaTeX full suites;
- selected XeLaTeX coverage and `unicode-math`;
- `IEEEtran`, `acmart`, `revtex4-2`, `elsarticle`, and `beamer`;
- single-column, two-column, `fleqn` / `leqno`, `hyperref` / `cleveref`, and local-width contexts;
- full article-flow fixtures with prose, floats, references, page boundaries, automatic placement, and manual placement.

See [Compatibility Results](tests/compatibility/RESULTS.md) and the [RC Audit](docs/rc-audit.md).

## Roadmap

- [ ] Inline-math annotations
- [ ] Per-row numbering for aligned/gathered multi-line equations
- [ ] Custom `\tag` support
- [ ] `\intertext` / `\shortintertext` inside EqAnnotate multi-line wrappers
- [ ] Automatic page-background detection for annotation masking
- [ ] CTAN distribution

For a colored page today, set `\eqannotatebackgroundcolor` to the page color.

## Agent-based LaTeX workflows

EqAnnotate is especially well suited to agent-based projects. Instead of asking an agent to invent TikZ coordinates or repeatedly adjust `xshift`, `yshift`, anchors, and route geometry, the agent can emit a small semantic interface:

```latex
\eqmark[blue]{velocity}{v_\theta(x,t)}
\eqannotate{velocity}{Velocity field}
```

This matches the strengths of LLM-based coding agents: interpreting natural-language intent, identifying symbolic subexpressions, and producing structured text. EqAnnotate takes over the spatial layout that is harder for an agent to reason about reliably. The result is a smaller decision space, more reproducible output, and fewer layout mistakes.

The repository also ships an optional skill at [`skills/eqannotate/SKILL.md`](skills/eqannotate/SKILL.md). It teaches coding/writing agents to:

- prefer the declarative automatic path;
- compile until layout converges;
- use `prefer=above|below` only as a lightweight hint;
- switch to the manual interface only for genuinely difficult cases;
- avoid generating raw TikZ coordinates for ordinary equation annotations.

EqAnnotate itself remains a regular LaTeX/TikZ package; the skill is simply a ready-to-use interface guide for agent workflows.

## Documentation

- [Installation](docs/installation.md)
- [User Guide](docs/usage.md)
- [Public API Contract](docs/api-contract.md)
- [Layout Design](docs/layout.md)
- [Validation](docs/validation.md)

## Acknowledgements

EqAnnotate grows directly from earlier work on making mathematical notation easier to explain visually:

- [`annotate-equations`](https://github.com/st--/annotate-equations) by ST John is the main foundation for EqAnnotate's author-side equation-annotation workflow. EqAnnotate keeps the idea of marking equation terms and attaching TikZ callouts, then adds automatic self-layout as the default interaction.
- [`annotated_latex_equations`](https://github.com/synercys/annotated_latex_equations) by synercys demonstrated the colorful annotated-equation style in LaTeX/TikZ and inspired the package ecosystem around this use case.
- [`ScholarPhi`](https://github.com/allenai/scholarphi) was an engineering reference for automatic equation diagrams, especially the separation of label measurement, placement, and leader routing.

EqAnnotate also relies on the LaTeX ecosystem around `amsmath`, PGF/TikZ, and `tikzmark`.

## Development

```bash
./tests/run.sh
./tests/compatibility/run.sh
```

Both suites require layout convergence rather than merely surviving a fixed number of TeX passes.

## License

MIT. See [LICENSE](LICENSE).
