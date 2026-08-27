# Changelog

## 0.1.0-rc2 — 2026-08-27

Release-preparation candidate. No solver feature expansion relative to rc1.

- Added final README, installation guide, user guide, and example index.
- Added optional AI-agent skill for declarative EqAnnotate usage.
- Added GitHub Actions CI for core and compatibility regression suites.
- Added repository preview assets and release-facing metadata.
- Kept the v0.1 public API frozen.

## 0.1.0-rc1 — 2026-08-26

First code-level release candidate.

- Declarative `\eqmark` / `\eqannotate` automatic workflow.
- Automatic side selection, long-label wrapping, dynamic lanes, column-aware bounds, bounded horizontal de-overlap, crossing-aware relaxation, routing micro-tracks, and vertical space reservation.
- Independent `colorful` / `mono` color themes and `leader` / `arrow` callout styles.
- Manual escape hatch with optional connector routing.
- `annotatedequation`, `annotatedalign`, `annotatedgather`, and `annotatedmultline` wrappers with optional block numbering.
- Article-flow, common scientific class, multi-engine, `unicode-math`, `hyperref` / `cleveref`, and `\includeonly` validation.
- RC audit fixes for semantic IDs, readable diagnostics, unnecessary `mathtools` dependency, and include checkpointing.
