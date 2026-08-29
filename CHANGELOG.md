# Changelog

## 0.1.1 — 2026-08-28

Maintenance release focused on blank-line compatibility and reproducible release packaging.

- Fixed captured EqAnnotate display bodies containing blank source lines so formula/annotation formatting can include ordinary empty lines safely.
- Added regression coverage for blank-line authoring across the public display wrappers.
- Added tag-driven GitHub Release automation that verifies package/changelog version identity and uploads `eqannotate.sty` from the exact release tag.
- Refreshed release-facing compatibility metadata after the v0.1.0 RC cycle.

## 0.1.0 — 2026-08-27

Initial public release.

- Added final README, installation guide, user guide, and example index.
- Added optional AI-agent skill for declarative EqAnnotate usage.
- Added GitHub Actions CI for core and compatibility regression suites.
- Added repository preview assets and release-facing metadata.

## 0.1.0-rc1 — 2026-08-26

First code-level release candidate.

- Declarative `\eqmark` / `\eqannotate` automatic workflow.
- Automatic side selection, long-label wrapping, dynamic lanes, column-aware bounds, bounded horizontal de-overlap, crossing-aware relaxation, routing micro-tracks, and vertical space reservation.
- Independent `colorful` / `mono` color themes and `leader` / `arrow` callout styles.
- Manual placement with optional connector routing.
- `annotatedequation`, `annotatedalign`, `annotatedgather`, and `annotatedmultline` wrappers with optional block numbering.
- Article-flow, common scientific class, multi-engine, `unicode-math`, `hyperref` / `cleveref`, and `\includeonly` validation.
- RC audit fixes for semantic IDs, readable diagnostics, unnecessary `mathtools` dependency, and include checkpointing.
