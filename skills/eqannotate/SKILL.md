---
name: eqannotate
description: Use EqAnnotate to add declarative annotations to LaTeX display equations without hand-tuning TikZ coordinates.
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

Do **not** create a separate raw `tikzpicture`, `tikzmarknode`, per-label `xshift` / `yshift`, anchors, lane numbers, or route-track layout for ordinary annotations.

## Workflow

1. Identify the exact mathematical subexpression to annotate.
2. Wrap only that subexpression in `\eqmark[<color>]{<id>}{...}`.
3. Add `\eqannotate{<id>}{<label>}` inside the same EqAnnotate display environment.
4. Let automatic placement decide the geometry.
5. Compile with `latexmk` or rerun TeX until EqAnnotate's rerun warning disappears.
6. Inspect the compiled result when possible.
7. If automatic placement is unsatisfactory, try a soft side preference first.
8. Use manual placement only for a genuine difficult case.

## Environment choice

Use:

- `annotatedequation` for a single display;
- `annotatedalign` for aligned multi-line equations;
- `annotatedgather` for centered multi-line rows;
- `annotatedmultline` for a long multline-style equation.

Add `[numbered]` only when the block should receive one equation number.

Do not emulate native per-row `align` / `gather` numbering; it is outside EqAnnotate v0.1.

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

Do not add numeric positioning to the automatic path.

## Manual fallback

For a case automatic placement cannot solve satisfactorily:

```latex
\eqannotatemanual[xshift=8mm,yshift=10mm]{term}{Label}
```

For a custom connector route:

```latex
\eqannotatemanual[xshift=16mm,yshift=12mm][bend right=18]
  {term}{Label}
```

Manual mode is the last fallback. It bypasses automatic collision avoidance, column clamping, lane assignment, and crossing optimization.

Do not expose or depend on EqAnnotate's private TikZ node names.

## Styles

Use document-wide style switches:

```latex
\eqannotatecolortheme{colorful} % or mono
\eqannotatecalloutstyle{leader} % or arrow
```

## Editing discipline

- Preserve the mathematics unless the user asked to change it.
- Do not annotate every symbol by default; annotate the terms that help the requested explanation.
- Keep semantic IDs short and stable.
- Keep labels concise when possible.
- Keep annotations inside the EqAnnotate environment containing their marks.
- If a target already has a manual annotation, do not add a competing automatic annotation unless intentionally replacing it.

## Compilation checks

Recommended:

```bash
latexmk -pdf main.tex
```

Treat `Rerun LaTeX for optimized annotation spacing` as a request for another pass, not a failure.

Investigate package errors and relevant warnings: missing marks, duplicate mark IDs, duplicate annotations, and automatic/manual conflicts.

For non-white pages, make sure `\eqannotatebackgroundcolor` matches the page background if connector masking is visible.

## v0.1 boundaries

Do not try to force EqAnnotate to support inline annotations, native per-row `align` / `gather` numbering, arbitrary `\tag`, or `\intertext` / `\shortintertext` inside EqAnnotate wrappers. Preserve the original requirement or explain the package boundary instead of inventing fragile raw TikZ machinery.
