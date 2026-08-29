# Maintainer release checklist

## Before tagging

1. Review `docs/api-contract.md` for versioned public API changes.
2. Run:

```bash
./tests/run.sh
./tests/compatibility/run.sh
```

3. Compile and visually inspect representative examples (`basic`, `style-gallery`, `manual-gallery`, `amsmath-gallery`, and `article-integration`).
4. Verify `eqannotate.sty`, `CHANGELOG.md`, and release notes agree on version/date.
5. Verify no generated `.aux`, `.log`, `.pdf`, `.fls`, `.fdb_latexmk`, or similar build files are tracked.
6. Verify GitHub Actions CI is green on the release commit.

## GitHub Release asset rule

Every GitHub Release must include a standalone `eqannotate.sty` asset extracted from the exact release tag. Never upload the current `main` copy to an older release: it may contain later development or bug-fix changes.

For example, extract `eqannotate.sty` from the release tag, upload that file to the matching GitHub Release, and verify its package header/version before publishing the release.

## CTAN

Build the preview archive with `scripts/build-ctan-package.sh` and review
`dist/ctan/eqannotate-ctan.zip` before a CTAN submission.
