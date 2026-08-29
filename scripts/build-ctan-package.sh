#!/usr/bin/env sh
# Build an allowlisted CTAN preview archive. This script never uploads it.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST="$ROOT/dist/ctan"
STAGE="$DIST/eqannotate"
ARCHIVE="$DIST/eqannotate-ctan.zip"
LATEXMK=latexmk

die() {
  printf '%s\n' "build-ctan-package.sh: error: $*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 ||
    die "required tool not found: $1"
}

has_exact_line() {
  tr -d '\015' < "$1" | grep -Fqx -e "$2"
}

PACKAGE_META=$(
  tr -d '\015' < "$ROOT/eqannotate.sty" |
    LC_ALL=C sed -n 's/^[[:space:]]*\\ProvidesPackage{eqannotate}\[\([0-9][0-9][0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]\) \(v[0-9][0-9.]*\)[[:space:]].*\]$/\1 \2/p'
)
set -- $PACKAGE_META
if [ "$#" -ne 2 ]; then
  die "could not parse exactly one YYYY/MM/DD vX.Y.Z header from eqannotate.sty"
fi
DATE=$1
VERSION=$2
if ! printf '%s\n' "$DATE" | grep -Eq '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'; then
  die "invalid canonical date in eqannotate.sty: $DATE"
fi
if ! printf '%s\n' "$VERSION" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$'; then
  die "invalid canonical version in eqannotate.sty: $VERSION"
fi
MANUAL_DATE=$(printf '%s\n' "$DATE" | tr '/' '-')
if ! has_exact_line "$ROOT/eqannotate.tex" "\\date{Version $VERSION \\quad $MANUAL_DATE}"; then
  die "eqannotate.tex must contain \\date{Version $VERSION \\quad $MANUAL_DATE} (from eqannotate.sty)"
fi
if ! has_exact_line "$ROOT/README.md" "- Current stable version: $VERSION"; then
  die "README.md must contain Current stable version: $VERSION (from eqannotate.sty)"
fi

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

require_command "$LATEXMK"
require_command unzip
require_command date
if command -v zip >/dev/null 2>&1; then
  ZIP_CREATOR=zip
elif command -v powershell.exe >/dev/null 2>&1 &&
  powershell.exe -NoProfile -NonInteractive -Command \
    "if (Get-Command -Name Compress-Archive -ErrorAction SilentlyContinue) { exit 0 }; exit 1" \
    >/dev/null 2>&1; then
  ZIP_CREATOR=powershell
else
  die "a ZIP creator is required: install zip or make PowerShell Compress-Archive available"
fi

if ! SOURCE_DATE_EPOCH=$(date -u -d "$MANUAL_DATE 00:00:00 UTC" +%s); then
  die "could not derive SOURCE_DATE_EPOCH from canonical date: $DATE"
fi
case "$SOURCE_DATE_EPOCH" in
  ''|*[!0-9]*)
    die "invalid SOURCE_DATE_EPOCH derived from canonical date: $SOURCE_DATE_EPOCH"
    ;;
esac
FORCE_SOURCE_DATE=1
PDF_TRAILER_ID=$(printf '%032x' "$SOURCE_DATE_EPOCH")
if ! printf '%s\n' "$PDF_TRAILER_ID" | grep -Eq '^[0-9a-f]{32}$'; then
  die "could not derive a 32-digit PDF trailer ID from SOURCE_DATE_EPOCH"
fi
MANUAL_PRETEX="\\pdftrailerid{<$PDF_TRAILER_ID>}"

BUILD=$(mktemp -d)
CHECK=$(mktemp -d)
trap 'rm -rf "$BUILD" "$CHECK"' EXIT HUP INT TERM

# The destination is derived from ROOT and is intentionally limited to the
# generated staging area; source files are never deleted by this build.
case "$DIST" in
  "$ROOT"/dist/ctan) ;;
  *) printf '%s\n' "Refusing unexpected staging path: $DIST" >&2; exit 2 ;;
esac
rm -rf "$DIST"
mkdir -p "$STAGE/examples"

SOURCE_DATE_EPOCH="$SOURCE_DATE_EPOCH" FORCE_SOURCE_DATE="$FORCE_SOURCE_DATE" \
  TEXINPUTS="$(texinputs_for "$ROOT")" \
  "$LATEXMK" -pdf -interaction=nonstopmode -halt-on-error \
  "-usepretex=$MANUAL_PRETEX" \
  -outdir="$BUILD/manual" "$ROOT/eqannotate.tex"

MANUAL_PDF="$BUILD/manual/eqannotate.pdf"
if [ ! -f "$MANUAL_PDF" ]; then
  die "manual build did not produce eqannotate.pdf"
fi
cp "$MANUAL_PDF" "$ROOT/eqannotate.pdf"

cp "$ROOT/README.md" "$ROOT/LICENSE" "$ROOT/eqannotate.sty" \
  "$ROOT/eqannotate.tex" "$ROOT/eqannotate.pdf" "$STAGE/"
if ! cmp -s "$ROOT/eqannotate.pdf" "$STAGE/eqannotate.pdf"; then
  die "root eqannotate.pdf and staging eqannotate.pdf differ"
fi
for example in basic style-gallery amsmath-gallery manual-gallery; do
  cp "$ROOT/examples/$example.tex" "$STAGE/examples/"
done

case "$ZIP_CREATOR" in
  zip)
    (cd "$DIST" && zip -qr "$(basename "$ARCHIVE")" eqannotate)
    ;;
  powershell)
    (cd "$DIST" &&
      powershell.exe -NoProfile -NonInteractive -Command \
        "Compress-Archive -LiteralPath 'eqannotate' -DestinationPath 'eqannotate-ctan.zip' -Force")
    ;;
esac

# Verify the unpacked archive rather than borrowing repository files.
unzip -q "$ARCHIVE" -d "$CHECK"
CHECK_ROOT="$CHECK/eqannotate"
(
  cd "$CHECK_ROOT"
  SOURCE_DATE_EPOCH="$SOURCE_DATE_EPOCH" FORCE_SOURCE_DATE="$FORCE_SOURCE_DATE" \
    TEXINPUTS="$(texinputs_for "$CHECK_ROOT")" \
    "$LATEXMK" -pdf -interaction=nonstopmode -halt-on-error \
    "-usepretex=$MANUAL_PRETEX" \
    -outdir="$CHECK/manual" eqannotate.tex
)
for example in basic style-gallery amsmath-gallery manual-gallery; do
  (
    cd "$CHECK_ROOT/examples"
    SOURCE_DATE_EPOCH="$SOURCE_DATE_EPOCH" FORCE_SOURCE_DATE="$FORCE_SOURCE_DATE" \
      TEXINPUTS="$(texinputs_for ..)" \
      "$LATEXMK" -pdf -interaction=nonstopmode -halt-on-error \
      -outdir="$CHECK/$example" "$example.tex"
  )
done

printf '%s\n' "Version metadata check passed: $VERSION ($DATE)"
printf '%s\n' "Manual PDF source date: $MANUAL_DATE (SOURCE_DATE_EPOCH=$SOURCE_DATE_EPOCH)"
printf '%s\n' "Manual PDF trailer ID is derived from SOURCE_DATE_EPOCH"
printf '%s\n' "Root/manual PDF synchronization passed"
printf '%s\n' "Built and verified $ARCHIVE"
