# Maintainer release checklist

## Before tagging

1. Review `docs/api-contract.md` for versioned public API changes.
2. Confirm that the release tag, the `\ProvidesPackage` header in `eqannotate.sty`, and the matching `CHANGELOG.md` heading use the same version.
3. Run:

```bash
./tests/run.sh
./tests/compatibility/run.sh
scripts/build-ctan-package.sh
```

4. Review the canonical examples and generated manual.
5. Confirm that no generated TeX by-products (`.aux`, `.log`, `.fls`, `.fdb_latexmk`, or similar) are tracked. The root `eqannotate.pdf` is the versioned canonical manual.
6. Confirm GitHub Actions is green on the release commit.

## Automated release flow

Pushing a version tag runs:

```text
tag → regression/compatibility gates → metadata validation
→ reproducible CTAN package build → tracked-file cleanliness check
→ GitHub Release
```

The workflow checks the tag, package header, and matching `CHANGELOG.md` heading, then uses that section as the Release notes.

## GitHub Release assets

Each GitHub Release contains assets built from its matching tag:

- `eqannotate.sty`
- `eqannotate.pdf`
- `eqannotate-ctan.zip`

## CTAN

Review `dist/ctan/eqannotate-ctan.zip` before submitting the same tagged snapshot to CTAN.
