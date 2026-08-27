# Public API contract for v0.1

This is the frozen public API contract for EqAnnotate v0.1. It is intentionally narrower than the implementation internals. For end-user workflows, see `docs/usage.md`.

## Stable display environments

- `\begin{annotatedequation} ... \end{annotatedequation}` — one display equation, unnumbered by default.
- `\begin{annotatedequation}[numbered] ...` — one numbered display; ordinary `\label` / `\ref` works.
- `\begin{annotatedalign} ... \end{annotatedalign}` — an aligned multi-line block, unnumbered by default.
- `\begin{annotatedalign}[numbered] ...` — one equation number for the entire aligned block.
- `\begin{annotatedgather} ... \end{annotatedgather}` — centered multi-line rows, unnumbered by default.
- `\begin{annotatedgather}[numbered] ...` — one equation number for the entire gathered block.
- `\begin{annotatedmultline} ... \end{annotatedmultline}` — native amsmath multline-style first/last-row alignment, unnumbered by default.
- `\begin{annotatedmultline}[numbered] ...` — one equation number for the whole multline block; `\label` / `\ref` works.

`annotatedalign` and `annotatedgather` deliberately use one outer display number rather than reproducing native `align`/`gather` per-row numbering. `annotatedmultline` matches native multline's one-number model.

## Stable declarations

- `\eqmark[<color>]{<id>}{<math>}` — mark a target term. IDs must be unique within one annotated environment.
  Common punctuation in semantic IDs is supported; IDs are mapped to private numeric TikZ node names rather than used as node syntax.
- `\eqannotate[prefer=auto|above|below]{<id>}{<label>}` — declare an annotation. `prefer` is a soft side hint, never a coordinate.
- `\eqannotatecolortheme{colorful|mono}` — select the color axis.
- `\eqannotatecalloutstyle{leader|arrow}` — select the connector axis.
- `\eqannotatemanual[<label node options>][<to-path options>]{<id>}{<label>}` — manual escape hatch for exceptional layouts. The second optional argument is advanced and may be omitted.

## Manual fallback contract

Manual placement is a real fallback path, not a separate drawing that bypasses document integration. Manual labels inherit the active color theme and callout style, are rendered in the same final overlay pass as automatic labels, and contribute to `.aux`-based vertical space reservation.

The first optional argument is passed to the manual label node (for example `xshift`, `yshift`, `anchor`, or `text width`). The second optional argument is passed to TikZ's `to[...]` path (for example `bend left`, `bend right`, or `out` / `in`). If a target is declared with both `\eqannotate` and `\eqannotatemanual`, the manual declaration wins and a warning is emitted.

Manual mode deliberately disables automatic collision avoidance, column clamping, lane assignment, and crossing optimization for that label. The caller has explicitly taken responsibility for those spatial decisions.

## Guardrails

- `\eqmark`, `\eqannotate`, and `\eqannotatemanual` outside an EqAnnotate display environment produce an explicit package error.
- A missing `\eqmark` for an annotation produces a warning and that annotation is skipped.
- Duplicate mark IDs produce a warning; the first semantic target is retained.
- Duplicate annotation declarations produce a warning; the last declaration is used.
- Long labels are automatically wrapped to a bounded fraction of the active `\linewidth`; measured multi-line height participates in lane spacing and vertical reservation.
- amsmath measuring passes are detected and kept side-effect free, so native `multline` does not capture remembered nodes from its internal measuring copy.

## Advanced tuning hooks: not frozen

Document-wide geometry constants such as label-width limits, lane spacing, route-track spacing, maximum automatic shift, target gap, and background-mask color remain advanced tuning hooks. Their names and exact defaults are not part of the v0.1 stability promise.

Per-label numeric coordinates, anchors, lane numbers, route-track IDs, and raw x/y shifts remain deliberately absent from the automatic path.

## Explicit v0.1 non-goals

- inline-math annotations;
- native `align` semantics with a separate number on every row;
- native `gather` semantics with a separate number on every row;
- arbitrary custom `\tag` behavior;
- `\intertext` / `\shortintertext` inside EqAnnotate multi-line wrappers;
- automatic page-background detection for occlusion masks.
