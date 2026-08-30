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
5. Verify no generated TeX by-products (`.aux`, `.log`, `.fls`, `.fdb_latexmk`, or similar) are tracked. The root `eqannotate.pdf` is the versioned canonical manual.
6. Verify GitHub Actions CI is green on the release commit.

## GitHub Release asset rule

Every GitHub Release includes a standalone `eqannotate.sty` asset extracted from its matching tag. Verify the package header and version before publishing.

## CTAN

Build the preview archive with `scripts/build-ctan-package.sh` and review
`dist/ctan/eqannotate-ctan.zip` before a CTAN submission.
