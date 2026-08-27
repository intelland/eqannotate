# EqAnnotate v0.1.0-rc1 validation

This gate validates two areas that were not covered deeply by the earlier formula galleries: the manual escape hatch and behavior inside continuous articles.

## Manual escape hatch

The manual path is intentionally separate from the automatic solver. Its v0.1 contract is:

```latex
\eqannotatemanual[<label TikZ node options>][<TikZ to-path options>]{<id>}{<label>}
```

The second optional argument is advanced and may be omitted. Existing calls with one optional argument keep the original syntax.

Validated behavior:

| Case | Result |
| --- | --- |
| manual label above / below / left / right | PASS |
| colorful + leader | PASS |
| mono + arrow | PASS |
| manual label inherits the marked term color in colorful mode | PASS |
| manual label becomes black in mono mode | PASS |
| straight manual connector | PASS |
| manually bent connector via `bend left/right` | PASS |
| automatic and manual labels in one display | PASS |
| manual and automatic declarations for the same target | PASS; manual wins with warning |
| manual-only display reserves vertical article space | PASS |
| manual label with explicit `text width` | PASS |
| manual annotations in `annotatedalign` | PASS |
| duplicate manual declaration | PASS; last declaration wins with warning |
| missing manual target | PASS; warning and skip |
| manual command outside an EqAnnotate display | PASS; explicit package error |
| pdfLaTeX manual smoke test | PASS |
| LuaLaTeX manual smoke test | PASS |

Manual placement deliberately does **not** receive automatic collision avoidance, horizontal clamping, lane assignment, or crossing minimization. Those are the geometry choices the caller has explicitly taken over. The package still handles theming, connector rendering, label masking, and vertical space reservation.

## Article-flow integration

The package was compiled and visually inspected as part of full pages rather than isolated formula galleries.

| Fixture | Coverage | Result |
| --- | --- | --- |
| standard `article`, 3 pages | title/abstract/sections, continuous prose, numbered equations and refs, auto+manual, long wrapped label, aligned block, figure/table floats, consecutive displays | PASS |
| standard `article`, two columns | narrow-column wrapping, column-aware automatic layout, manual fallback, dense annotations, surrounding prose | PASS |
| `IEEEtran` conference article | compact two-column article flow, numbering/ref, wrapped label, manual fallback | PASS |
| `acmart` sigconf article | compact two-column article flow, wrapped label, manual fallback | PASS |
| page-boundary fixture | automatic and manual labels near page boundaries, following prose below the reserved band | PASS |
| pdfLaTeX article-flow smoke | automatic + manual + numbering/reference | PASS |
| LuaLaTeX article-flow smoke | automatic + manual + numbering/reference | PASS |

Visual inspection found no annotation/prose collisions, detached overlays, column overflow in automatic placement, or lost equation references. Normal LaTeX float reordering remains under the document class/page builder and is intentionally not altered by EqAnnotate.

## Regression status

The pre-existing automatic-layout smoke suite still passes under pdfLaTeX after the manual-path changes: single column, two column, occlusion masks, bounded de-overlap, micro-track routing, numbered displays, wrapping, crossing-aware relaxation, and amsmath multi-line wrappers.

## Remaining boundaries

- Manual placement can intentionally move a label outside the column or onto another label; this is expected because manual mode bypasses the automatic solver.
- The second manual optional argument accepts TikZ `to[...]` routing options, not arbitrary standalone TikZ statements. It covers straight, bent, and `out`/`in` style routes without exposing EqAnnotate's internal node names.
- Inline-math annotations, per-row native `align`/`gather` numbering, arbitrary custom `\tag`, and automatic non-white page-background detection remain outside v0.1.
