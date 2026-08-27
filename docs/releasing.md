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

## v0.1.0 activation

1. Change the package header from `v0.1.0-rcN` to `v0.1.0`.
2. Finalize the CHANGELOG entry.
3. Rerun all gates without adding solver behavior.
4. Commit, tag `v0.1.0`, and create the GitHub Release.

If a functional bug appears, fix it in a new release candidate rather than mixing the fix into release activation.

## CTAN

CTAN packaging is intentionally deferred until after the GitHub v0.1.0 release has had a short period of real-world use.
