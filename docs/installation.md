# Installation

EqAnnotate is currently distributed as a source package. It is not yet published on CTAN.

## Overleaf

1. Download `eqannotate.sty`.
2. Upload it to the root of the Overleaf project, next to `main.tex`.
3. Add:

```latex
\usepackage{eqannotate}
```

No shell escape, Python process, external service, or API key is required.

## Per-project local install

```text
paper/
├── main.tex
└── eqannotate.sty
```

Then load it normally:

```latex
\usepackage{eqannotate}
```

## User-wide TeX Live install

```bash
mkdir -p ~/texmf/tex/latex/eqannotate
cp eqannotate.sty ~/texmf/tex/latex/eqannotate/
```

Most TeX Live setups discover the user tree automatically. If yours does not, refresh the TeX filename database according to the distribution.

## Dependencies

EqAnnotate loads `amsmath`, `xcolor`, `tikz`, `xparse`, and `expl3`, plus TikZ libraries `tikzmark`, `arrows.meta`, and `calc`.

## Compilation

Recommended:

```bash
latexmk -pdf main.tex
```

LuaLaTeX:

```bash
latexmk -lualatex main.tex
```

XeLaTeX:

```bash
latexmk -xelatex main.tex
```

A fresh document commonly needs several TeX runs because EqAnnotate combines remembered page positions with `.aux`-based solved spacing.

## Optional AI-agent skill

The package works without any agent integration. The repository includes:

```text
skills/eqannotate/SKILL.md
```

For a Codex-style filesystem skill installation:

```bash
mkdir -p ~/.agents/skills/eqannotate
cp skills/eqannotate/SKILL.md ~/.agents/skills/eqannotate/SKILL.md
```

The skill contains instructions only; it does not call a model or API.
