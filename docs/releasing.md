# Maintainer release checklist

## Before tagging

1. Keep `docs/api-contract.md` frozen unless a deliberate compatibility decision is made.
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

CTAN packaging is intentionally deferred until after the GitHub release has had a period of real-world use.