# Layout model

EqAnnotate treats annotation as a layout problem rather than a drawing command.

## Pipeline

1. Render/measure the equation and marked terms.
2. Measure label text widths and heights; wrap labels that exceed the bounded automatic label width.
3. Choose a side (above/below), honoring only soft preferences.
4. Measure the active `\linewidth` boundary using zero-height remembered edge markers.
5. Build a legal horizontal interval for every label from the column boundary and a maximum automatic shift.
6. Perform bounded horizontal de-overlap while preserving target order; open another lane only when no legal position remains in an existing lane.
7. Relax labels back toward the ideal target-centered positions with a global order bound across lanes; when all constraints cannot be satisfied simultaneously, preserve the collision-free lane solution.
8. Compute each lane height from the tallest label in that lane and reserve vertical space from the solved label extents, not from a fixed single-line assumption.
9. Build label ports, routing corridors, and target sites.
10. Draw connectors first and labels second, so labels automatically mask any connector segment that passes beneath annotation text.
11. Recompile until remembered positions and reserved bands stabilize.

## Vertical spacing and target sites

The annotation band is intentionally separated from the equation boundary. A routing corridor sits between the equation and the nearest label lane, leaving visible whitespace on both sides of the horizontal segment.

Arrow tips terminate outside the marked term rather than on the glyph. The upper target uses a small optical compensation because TeX math glyphs tend to sit visually closer to the north edge of their box than to the south edge; the result is visually symmetric top/bottom spacing rather than numerically identical offsets.

## Callout routing

The label and formula are separate geometric objects. A connector begins at the solved label-side port, leaves a visual gap, enters the routing corridor outside the formula box, travels horizontally there when needed, and terminates at the marked term.

Two callout styles are shipped:

- `leader`: no arrowhead; deliberately quiet and robust.
- `arrow`: an explicit arrowhead points toward the marked term.

Connectors are rendered before labels. Label nodes use an invisible page-colored mask (white by default), so if a connector from an outer lane crosses behind another annotation, the covered segment disappears instead of mixing with the label text. The mask color can be changed with `\eqannotatebackgroundcolor` for non-white pages.

This routing architecture is inspired in part by ScholarPhi's equation-diagram code, which separates label layout and leader generation and models label-side ports / feature-side sites. EqAnnotate does not copy ScholarPhi's JavaScript implementation; the TeX-side solver uses TikZ remembered nodes, TeX dimensions, and `.aux` state.

## Style separation

Color is not geometry. The package exposes independent switches:

```latex
\eqannotatecolortheme{colorful|mono}
\eqannotatecalloutstyle{leader|arrow}
```

The mathematical source and annotation declarations do not change when visual themes change.

## Column-aware bounded horizontal de-overlap

EqAnnotate records two remembered nodes at the current `\linewidth` edges. After measuring labels, each label receives a legal center interval that combines:

- the active column boundary plus an outer pad; and
- `\eqannotatemaxshift`, which prevents automatic de-overlap from moving a label arbitrarily far from its target.

Labels are kept in target x-order. The forward pass places each label at the earliest feasible point in the first lane that can accommodate it. A reverse relaxation pass then moves labels back toward their target-centered positions while preserving spacing and bounds. A new lane is opened only when the label cannot legally fit in an existing one.

This means labels may move horizontally to reduce unnecessary vertical lane count, but the motion is bounded and order-preserving, which also limits leader crossings.

## Wrapped labels and dynamic lane height

A label whose natural width exceeds `\eqannotatemaxlabelwidth` is typeset as a centered paragraph before horizontal packing. The default maximum is `.42\linewidth`, evaluated in the current local width, so two-column and nested `minipage` contexts get a narrower wrap width automatically.

Each lane records the maximum measured label height. The next lane advances by `max(\eqannotatelanestep, lane-height + \eqannotatelanegap)`, and the `.aux` reservation stores the actual outermost label extent. This keeps short-label layouts compact while allowing multi-line labels without vertical collisions.

## Crossing-aware relaxation

Horizontal packing is still lane-based, but the reverse relaxation is no longer independent per lane. A global right-to-left center bound preserves target order across different lanes whenever that is compatible with column bounds, max-shift bounds, and same-lane collision spacing. This removes a class of avoidable leader crossings caused by two lanes independently moving labels past each other. When those constraints are mutually incompatible, collision-free placement takes priority and routing micro-tracks remain as the fallback.


## Native multline measuring passes

Unlike boxed `aligned` / `gathered` math, amsmath's native `multline` performs an internal measuring pass before the final display is emitted. Running `\eqmark` normally in that pass can record a remembered node at the measuring-copy coordinates rather than the visible formula coordinates.

EqAnnotate therefore treats amsmath's measuring pass as read-only: marked terms render with the same visual extent, but mark registration, annotation registration, manual callouts, and multline boundary sentinels are deferred to the final typesetting pass. The full multline vertical envelope is estimated from a boxed `gathered` phantom and anchored to remembered first/last-row sentinels; marked-term extents can only expand that envelope. This keeps annotation bands outside the entire multi-row formula while retaining native multline horizontal alignment.
