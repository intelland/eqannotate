# Installation

## Overleaf or a local project

1. Download [`eqannotate.sty` from the latest GitHub Release](https://github.com/intelland/eqannotate/releases/latest/download/eqannotate.sty).
2. Upload or copy it to the project root next to `main.tex`.
3. Load it normally:

```latex
\usepackage{eqannotate}
```

EqAnnotate is available through GitHub Releases.

## User-wide TeX Live install

```bash
mkdir -p ~/texmf/tex/latex/eqannotate
cp eqannotate.sty ~/texmf/tex/latex/eqannotate/
```

Most TeX Live setups discover the user tree automatically. If yours does not, refresh the TeX filename database according to the distribution.

## Dependencies

EqAnnotate loads `amsmath`, `xcolor`, `tikz`, `xparse`, and `expl3`, plus the TikZ libraries `tikzmark`, `arrows.meta`, and `calc`.

## Compilation

```bash
latexmk -pdf main.tex
```

LuaLaTeX and XeLaTeX can be selected with `latexmk -lualatex` and `latexmk -xelatex`. A fresh document commonly needs several TeX runs because EqAnnotate combines remembered page positions with `.aux`-based solved spacing.

## Optional agent skill

The repository includes [skills/eqannotate/SKILL.md](../skills/eqannotate/SKILL.md), with conventions for Codex-style workflows.
