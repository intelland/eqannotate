# EqAnnotate v0.1.0-rc2 release-activation audit

Date: 2026-08-27

## Outcome

**PASS — repository-level release preparation is complete. Public v0.1.0 activation remains intentionally held until the pushed release candidate receives a green GitHub Actions run.**

No solver feature was added in rc2. The only change to `eqannotate.sty` relative to rc1 is the package version/date string.

## Release-preparation surface

Added and checked:

- release-facing `README.md` with minimal example and rendered previews;
- `docs/installation.md`;
- final `docs/usage.md` covering automatic and manual workflows;
- `examples/README.md` as an example index;
- `CHANGELOG.md`;
- maintainer `docs/releasing.md`;
- optional `skills/eqannotate/SKILL.md`;
- `.github/workflows/ci.yml` running core and compatibility gates;
- repository preview assets under `docs/images/`.

The v0.1 API remains frozen by `docs/api-contract.md`.

## Documentation/API consistency

PASS:

- all repository-local Markdown links resolve;
- all public commands and four public environments described in the README/user guide exist in `eqannotate.sty`;
- automatic mode documentation does not expose private lane/track/node identifiers;
- manual fallback documentation matches the two-optional-argument implementation contract;
- v0.1 exclusions in the user guide match the frozen API contract;
- Overleaf/local-project installation uses only `eqannotate.sty` and normal `\\usepackage{eqannotate}` loading.

## Package-code freeze check

A direct diff against v0.1.0-rc1 shows the package implementation is unchanged except:

```text
2026/08/26 v0.1.0-rc1
->
2026/08/27 v0.1.0-rc2
```

Therefore the rc1 code-level solver audit remains applicable to rc2.

## Local regression re-check

Selected release-facing regressions were rerun after the release-preparation edits:

- pdfLaTeX: smoke, manual, amsmath, numbered, article-flow;
- LuaLaTeX: smoke, manual, amsmath, numbered;
- XeLaTeX: smoke and amsmath;
- compatibility: IEEEtran, acmart, `unicode-math`, `hyperref`/`cleveref`, semantic-ID punctuation;
- representative examples: basic, style gallery, manual gallery, amsmath gallery, full article integration, IEEE article integration.

All selected tests converged and produced no EqAnnotate package error or unexpected overfull annotation box.

The exhaustive core/compatibility suites remain encoded in `tests/run.sh` and `tests/compatibility/run.sh` and are invoked by GitHub Actions on push/PR. The previous rc1 audit already ran the full local gate; rc2 changes no solver code.

## Visual check

Representative rc2 outputs were rendered and visually inspected for:

- basic automatic placement;
- all four style combinations;
- manual fallback and auto/manual mixing;
- aligned/gathered/multline wrappers;
- continuous multi-page article flow.

No visual regression was observed relative to the code-frozen rc1 behavior.

## CI audit

`.github/workflows/ci.yml`:

- is valid YAML;
- uses read-only repository permissions;
- installs the TeX Live families needed by the current tests;
- runs both the core convergence suite and the broader compatibility gate;
- has a 30-minute job limit.

The remaining external release condition is a green run on GitHub after the repository is pushed, because that remote Actions environment cannot be proven from the local artifact alone.

## Agent skill audit

The optional skill is deliberately lightweight. It:

- instructs agents to use `\\eqmark` + `\\eqannotate` first;
- forbids ordinary raw TikZ coordinate tuning;
- uses `prefer=above|below` only as a soft hint;
- reserves `\\eqannotatemanual` for difficult cases;
- requires compilation to convergence and output inspection when possible;
- states the v0.1 feature boundaries instead of encouraging fragile workarounds.

The package itself remains completely independent of AI or agent infrastructure.

## Repository hygiene

The release archive is source-only apart from intentional PNG documentation assets. TeX build products are excluded by `.gitignore` and removed from the release archive.

## Activation sequence

After pushing rc2:

1. wait for the GitHub Actions `CI` workflow to pass;
2. if CI is green and no repository-only issue appears, change the package header to `v0.1.0`;
3. finalize the CHANGELOG entry;
4. rerun the same gates without adding functionality;
5. tag `v0.1.0` and create the GitHub Release;
6. defer CTAN packaging until after initial real-world GitHub use.

If remote CI exposes a real functional issue, create another RC rather than patching the final release in place.
