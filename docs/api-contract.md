# Public API contract for v0.1

This document defines the stable public API for EqAnnotate v0.1. For end-user workflows, see `docs/usage.md`.

## Stable display environments

- `\begin{annotatedequation} ... \end{annotatedequation}` — one display equation, unnumbered by default.
- `\begin{annotatedequation}[numbered] ...` — one numbered display; ordinary `\label` / `\ref` works.
- `\begin{annotatedalign} ... \end{annotatedalign}` — an aligned multi-line block, unnumbered by default.
- `\begin{annotatedalign}[numbered] ...` — one equation number for the entire aligned block.
- `\begin{annotatedgather} ... \end{annotatedgather}` — centered multi-line rows, unnumbered by default.
- `\begin{annotatedgather}[numbered] ...` — one equation number for the entire gathered block.
- `\begin{annotatedmultline} ... \end{annotatedmultline}` — native amsmath multline-style first/last-row alignment, unnumbered by default.
- `\begin{annotatedmultline}[numbered] ...` — one equation number for the whole multline block; `\label` / `\ref` works.

`annotatedalign` and `annotatedgather` use one equation number for the complete block. `annotatedmultline` follows the same one-number model as amsmath `multline`.

## Stable declarations

- `\eqmark[<color>]{<id>}{<math>}` — mark a target term. IDs must be unique within one annotated environment.
  Common punctuation in semantic IDs is supported because EqAnnotate maps each ID to a private numeric TikZ node name.
- `\eqannotate[prefer=auto|above|below]{<id>}{<label>}` — declare an annotation. `prefer` is a soft side hint interpreted by the automatic layout solver.
- `\eqannotatecolortheme{colorful|mono}` — select the color axis.
- `\eqannotatecalloutstyle{leader|arrow}` — select the connector axis.
- `\eqannotatemanual[<label node options>][<to-path options>]{<id>}{<label>}` — declare a manual annotation with explicit label and connector options. The second optional argument is advanced and may be omitted.

## Manual annotations

Manual labels are rendered in the same overlay pass as automatic labels and participate in theme selection, connector rendering, masking, and `.aux`-based vertical space reservation.

The supplied label-node and `to[...]` path options determine the manual label geometry. The first optional argument is passed to the label node (for example `xshift`, `yshift`, `anchor`, or `text width`); the second is passed to TikZ's `to[...]` path (for example `bend left`, `bend right`, or `out` / `in`). If a target is declared with both `\eqannotate` and `\eqannotatemanual`, the manual declaration takes precedence and a warning is emitted.

## Guardrails

- `\eqmark`, `\eqannotate`, and `\eqannotatemanual` outside an EqAnnotate display environment produce an explicit package error.
- A missing `\eqmark` for an annotation produces a warning and that annotation is skipped.
- Duplicate mark IDs produce a warning; the first semantic target is retained.
- Duplicate annotation declarations produce a warning; the last declaration is used.
- Long labels are automatically wrapped to a bounded fraction of the active `\linewidth`; measured multi-line height participates in lane spacing and vertical reservation.
- amsmath measuring passes are detected and kept side-effect free, so native `multline` does not capture remembered nodes from its internal measuring copy.

## Advanced tuning hooks

Document-wide geometry constants such as label-width limits, lane spacing, route-track spacing, maximum automatic shift, target gap, and background-mask color are advanced tuning hooks and are not covered by the v0.1 stability contract.

## Current scope

The v0.1 API does not include:

- inline-math annotations;
- native `align` semantics with a separate number on every row;
- native `gather` semantics with a separate number on every row;
- arbitrary custom `\tag` behavior;
- `\intertext` / `\shortintertext` inside EqAnnotate multi-line wrappers;
- automatic page-background detection for occlusion masks.
