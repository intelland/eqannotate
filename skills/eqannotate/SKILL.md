---
name: eqannotate
description: Use EqAnnotate to add declarative, automatically laid-out annotations to LaTeX display equations.
---

# EqAnnotate

Use this skill when editing LaTeX that uses EqAnnotate, or when the user asks to add explanatory callouts to display equations and `eqannotate.sty` is available in the project.

## Core rule

Prefer semantic declarations over geometric drawing.

Use:

```latex
\eqmark[blue]{base}{v_\theta(x,t)}
\eqannotate{base}{Base velocity field}
```

For ordinary EqAnnotate callouts, use `\eqmark` + `\eqannotate` and let the package choose placement.

## Workflow

1. Identify the exact mathematical subexpression to annotate.
2. Wrap only that subexpression in `\eqmark[<color>]{<id>}{...}`.
3. Add `\eqannotate{<id>}{<label>}` inside the same EqAnnotate display environment.
4. Let automatic placement decide the geometry.
5. Compile with `latexmk` or rerun TeX until EqAnnotate's rerun warning disappears.
6. Inspect the compiled result when possible.
7. Use a soft side preference when it reflects the annotation's meaning.
8. Use manual placement when exact label placement or a custom connector route is useful.

## Environment choice

Use:

- `annotatedequation` for a single display;
- `annotatedalign` for aligned multi-line equations;
- `annotatedgather` for centered multi-line rows;
- `annotatedmultline` for a long multline-style equation.

Add `[numbered]` only when the block should receive one equation number.

EqAnnotate v0.1 gives `annotatedalign` and `annotatedgather` one number for the complete block.

## Placement preferences

Automatic placement is the default:

```latex
\eqannotate{term}{Label}
```

If a side is semantically important, use only:

```latex
\eqannotate[prefer=above]{term}{Label}
\eqannotate[prefer=below]{term}{Label}
```

## Manual placement

Use `\eqannotatemanual` when the requested result needs exact label placement or a custom connector route:

```latex
\eqannotatemanual[xshift=8mm,yshift=10mm]{term}{Label}
```

For a custom connector route:

```latex
\eqannotatemanual[xshift=16mm,yshift=12mm][bend right=18]
  {term}{Label}
```

Treat EqAnnotate's private TikZ node names as implementation details.

## Styles

Use document-wide style switches:

```latex
\eqannotatecolortheme{colorful} % or mono
\eqannotatecalloutstyle{leader} % or arrow
```

## Editing discipline

- Preserve the mathematics unless the user asks to change it.
- Annotate the terms that support the requested explanation.
- Keep semantic IDs short and stable.
- Keep labels concise when possible.
- Keep marks and annotations in the same EqAnnotate environment.
- Update an existing manual annotation rather than adding a competing automatic one.

## Compilation checks

Recommended:

```bash
latexmk -pdf main.tex
```

When the log reports `Rerun LaTeX for optimized annotation spacing`, run another pass.

Investigate package errors and relevant warnings: missing marks, duplicate mark IDs, duplicate annotations, and automatic/manual conflicts.

For non-white pages, make sure `\eqannotatebackgroundcolor` matches the page background if connector masking is visible.

## v0.1 boundaries

Inline annotations, per-row numbering, custom `\tag`, and `\intertext` / `\shortintertext` are outside the v0.1 interface. When one of these is required, surface the package boundary rather than substituting private EqAnnotate internals.
