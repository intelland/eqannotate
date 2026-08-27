# EqAnnotate v0.1.0-rc1 code audit

Date: 2026-08-26

## Outcome

**PASS — code-level release candidate after four bounded blockers were corrected.**

Publication is still held for the deliberately deferred release-preparation layer: final end-user documentation, optional agent skill, GitHub CI/release metadata, and any later CTAN packaging. No new layout feature was added during this audit.

## Audit scope

The audit covered:

- package-only installation and dependency surface;
- public API consistency and manual/automatic fallback behavior;
- readable warnings and explicit misuse errors;
- multi-pass convergence and `latexmk` behavior;
- pdfLaTeX, LuaLaTeX, and selected XeLaTeX coverage;
- common scientific classes and `hyperref`/`cleveref` integration;
- `fleqn`/`leqno`, `unicode-math`, and semantic-ID edge cases;
- `\include` / `\includeonly` article workflows;
- visual regressions against the pre-audit v0.9 development output;
- repository/test hygiene.

## Corrected blockers

### 1. Semantic IDs leaked into TikZ node names

Previously, user IDs were embedded directly in private node names. IDs such as `a:b` or `foo.bar` could therefore be parsed by PGF as coordinate/anchor syntax and fail compilation.

RC1 assigns each mark a private numeric node name and stores an ID-to-node mapping. Automatic labels, route nodes, sites, and manual nodes all use the private name. The public ID is now semantic rather than geometric.

A grouping bug found while implementing this fix was also corrected: the private mark serial must increment globally within an EqAnnotate environment because numerator/denominator and brace groups can otherwise roll a local counter back and reuse the same private node.

Visual regression: the normal `basic`, `manual-gallery`, `style-gallery`, `amsmath-gallery`, and article fixtures remain pixel-identical after the final fix.

### 2. Package diagnostics lost spaces under expl3 syntax

Warnings/errors were emitted while `\ExplSyntaxOn` was active, so ordinary source spaces vanished in the log. Messages are now explicitly space-safe and readable. The first-build rerun warning is also emitted only once per TeX run instead of once per annotated equation.

### 3. Unnecessary `mathtools` dependency

`mathtools` was loaded only to create an invisible `multlined` copy for vertical measurement. Loading EqAnnotate after `unicode-math` therefore produced a third-party load-order warning.

RC1 uses an amsmath `gathered` phantom only for hidden vertical measurement; the visible environment still uses native amsmath `multline`. Pixel comparison of the multline gallery is unchanged, and `unicode-math` now passes when loaded before EqAnnotate under LuaLaTeX and XeLaTeX.

### 4. `\includeonly` did not checkpoint EqAnnotate's environment serial

The internal environment serial was an expl3 integer, so skipped `\include` files did not restore it. Partial builds could temporarily reuse reserve-cache IDs from another equation.

RC1 uses an internal LaTeX counter (`eqannotateenv`), which participates in the standard `\include` checkpoint system. Full-build and `\includeonly` fixtures retain the same EqAnnotate environment IDs.

## Test-harness correction

Earlier tests ran a fixed three passes. That proves compilability but not convergence. RC1 test helpers now rerun until the `.aux` state is unchanged and no rerun warning remains, with a hard limit of five passes.

Observed fresh-build behavior:

- representative `basic`: stable via `latexmk` after 4 pdfLaTeX runs;
- 21-formula compatibility corpus: stable after 4 pdfLaTeX runs;
- multi-page article integration: stable after 3 pdfLaTeX runs.

`latexmk -pdf` reaches a clean final log on all three representative cases.

## Engine and ecosystem checks

Validated in the available TeX Live 2025/dev environment:

- pdfLaTeX: full core and compatibility corpus;
- LuaLaTeX: full core and formula compatibility corpus;
- XeLaTeX: selected core smoke tests plus `unicode-math`;
- `IEEEtran`, `acmart`, `revtex4-2`, `elsarticle`, `beamer`;
- `hyperref` before and after EqAnnotate, with `cleveref`;
- `fleqn` + `leqno`;
- CJK/Unicode smoke with `ctexart` under XeLaTeX and LuaLaTeX;
- local project installation with only `eqannotate.sty` copied beside the document.

## Visual regression

The audit deliberately avoided changing normal layout. Render comparisons against the pre-audit development package show no changed pixels for representative basic, manual, style, article, and amsmath/multline fixtures after the fixes settled.

The new `fleqn`/`leqno` fixture was also visually inspected; numbering, formula, annotations, and following prose remain separated.

## Non-blocking boundaries retained for v0.1

- inline math is unsupported;
- native per-row `align` / `gather` numbering is unsupported;
- arbitrary custom `\tag` behavior is unsupported;
- `\intertext` / `\shortintertext` inside wrappers is unsupported;
- non-white page backgrounds require manual `\eqannotatebackgroundcolor` configuration;
- manual mode deliberately permits the caller to create collisions or overflow;
- minimum supported historical TeX Live version is not yet established; this audit used the available TeX Live 2025/dev distribution.

## Release-preparation hold

No code blocker remains from this audit. Before a public v0.1.0 release, the remaining work should be release-oriented rather than solver-oriented: final README/user guide, installation instructions, optional agent skill, CI, and release packaging/metadata.
