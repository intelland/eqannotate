# Validation

EqAnnotate is validated through automated regression, document-class coverage, rendered examples, and release checks.

## Automated regression

- The core convergence suite covers the public display wrappers and automatic layout under pdfLaTeX and LuaLaTeX.
- Selected smoke tests run under XeLaTeX.
- The compatibility suite covers formula structures, two-column and local-`\linewidth` layouts, `hyperref` / `cleveref`, `fleqn` / `leqno`, Unicode math, warnings, and include checkpoints.
- Test documents compile until their layout state converges, with a maximum of five TeX runs.

## Scientific document classes

The compatibility corpus includes:

- `IEEEtran`;
- `acmart`;
- `revtex4-2`;
- `elsarticle`; and
- `beamer`.

## Layout coverage

Regression and compatibility tests cover:

- long-label wrapping and de-overlap;
- lane allocation, vertical reservation, and connector routing;
- label masking and themes;
- `annotatedequation`, `annotatedalign`, `annotatedgather`, and `annotatedmultline`;
- numbering and references;
- two-column and local-width layouts;
- manual placement and connector routes; and
- `\include` / `\includeonly` workflows.

## Visual validation

The Visual Validation workflow compiles and renders five canonical examples:

- `basic`;
- `style-gallery`;
- `manual-gallery`;
- `amsmath-gallery`; and
- `article-integration`.

Each page is rendered to PNG at 150 DPI and uploaded as the `eqannotate-visual-validation` GitHub Actions artifact for visual review. The examples cover automatic layout, themes, manual placement, amsmath wrappers, and continuous article flow.

## Release validation

The tag-triggered release workflow runs the core and compatibility suites, verifies that the tag, package header, and changelog version agree, and creates the release asset from the exact tagged `eqannotate.sty` file.

## Status

GitHub Actions runs regression, compatibility, and visual validation on every push and pull request. See the [Actions page](https://github.com/intelland/eqannotate/actions) for current results.
