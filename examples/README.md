# Examples

## Start here

- `basic.tex` — minimal automatic annotations plus a denser four-term formula.
- `style-gallery.tex` — `colorful` / `mono` crossed with `leader` / `arrow`.
- `manual-gallery.tex` — manual placement and mixed automatic/manual annotations.

## Layout behavior

- `column-aware.tex` — active-column bounds in two-column layout.
- `deoverlap.tex` — bounded horizontal de-overlap.
- `crossing-regression.tex` — order-aware dense placement.
- `routing-regression.tex` — aligned target rails and separated connector micro-tracks.
- `occlusion.tex` — label masking over connector segments.
- `long-labels.tex` — automatic wrapping and dynamic lane height.
- `stress.tex` — clustered marks and mixed geometry.

## Math environments

- `amsmath-gallery.tex` — `annotatedalign`, `annotatedgather`, and `annotatedmultline`.

## Article integration

- `article-integration.tex` — multi-page standard article with prose, floats, references, automatic and manual annotations.
- `article-two-column.tex` — standard two-column article.
- `ieee-article-integration.tex` — IEEEtran conference-style fixture.
- `acmart-article-integration.tex` — ACM sigconf-style fixture.
- `pagebreak-integration.tex` — annotations near page boundaries.

From the repository root:

```bash
latexmk -pdf examples/basic.tex
```
