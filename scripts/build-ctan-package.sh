#!/usr/bin/env sh
# Build an allowlisted CTAN preview archive. This script never uploads it.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST="$ROOT/dist/ctan"
STAGE="$DIST/eqannotate"
ARCHIVE="$DIST/eqannotate-ctan.zip"
LATEXMK=latexmk
BUILD=$(mktemp -d)
CHECK=$(mktemp -d)
trap 'rm -rf "$BUILD" "$CHECK"' EXIT HUP INT TERM

texinputs_for() {
  path=$1
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
      path=$(cygpath -m "$path")
      printf '%s;' "$path"
      ;;
    *) printf '%s:' "$path" ;;
  esac
}

if ! command -v "$LATEXMK" >/dev/null 2>&1; then
  printf '%s\n' "latexmk is required; add the TeX Live bin directory to PATH." >&2
  exit 127
fi

# The destination is derived from ROOT and is intentionally limited to the
# generated staging area; source files are never deleted by this build.
case "$DIST" in
  "$ROOT"/dist/ctan) ;;
  *) printf '%s\n' "Refusing unexpected staging path: $DIST" >&2; exit 2 ;;
esac
rm -rf "$DIST"
mkdir -p "$STAGE/examples"

TEXINPUTS="$(texinputs_for "$ROOT")" \
  "$LATEXMK" -pdf -interaction=nonstopmode -halt-on-error \
  -outdir="$BUILD/manual" "$ROOT/eqannotate.tex"

cp "$ROOT/README.md" "$ROOT/LICENSE" "$ROOT/eqannotate.sty" \
  "$ROOT/eqannotate.tex" "$BUILD/manual/eqannotate.pdf" "$STAGE/"
for example in basic style-gallery amsmath-gallery manual-gallery; do
  cp "$ROOT/examples/$example.tex" "$STAGE/examples/"
done

if command -v zip >/dev/null 2>&1; then
  (cd "$DIST" && zip -qr "$(basename "$ARCHIVE")" eqannotate)
elif command -v powershell.exe >/dev/null 2>&1; then
  (cd "$DIST" &&
    powershell.exe -NoProfile -NonInteractive -Command \
      "Compress-Archive -LiteralPath 'eqannotate' -DestinationPath 'eqannotate-ctan.zip' -Force")
else
  printf '%s\n' "A ZIP creator is required (zip or PowerShell Compress-Archive)." >&2
  exit 127
fi

# Verify the unpacked archive rather than borrowing repository files.
unzip -q "$ARCHIVE" -d "$CHECK"
CHECK_ROOT="$CHECK/eqannotate"
(
  cd "$CHECK_ROOT"
  TEXINPUTS="$(texinputs_for "$CHECK_ROOT")" \
    "$LATEXMK" -pdf -interaction=nonstopmode -halt-on-error \
    -outdir="$CHECK/manual" eqannotate.tex
)
for example in basic style-gallery amsmath-gallery manual-gallery; do
  (
    cd "$CHECK_ROOT/examples"
    TEXINPUTS="$(texinputs_for ..)" \
      "$LATEXMK" -pdf -interaction=nonstopmode -halt-on-error \
      -outdir="$CHECK/$example" "$example.tex"
  )
done

printf '%s\n' "Built and verified $ARCHIVE"
