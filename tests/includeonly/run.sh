#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
HERE="$ROOT/tests/includeonly"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
cp "$HERE"/part1.tex "$HERE"/part2.tex "$WORK"/
cp "$HERE"/main-full.tex "$WORK"/main.tex
cd "$WORK"
for i in 1 2 3 4; do
  TEXINPUTS="$ROOT:" pdflatex -interaction=nonstopmode -halt-on-error main.tex >/dev/null
done
if ! grep -Fq 'eqa@top@1' part1.aux || ! grep -Fq 'eqa@top@2' part2.aux; then
  echo 'Full include build did not assign stable distinct EqAnnotate IDs' >&2
  exit 1
fi
if ! grep -Fq '\setcounter{eqannotateenv}{1}' part1.aux || ! grep -Fq '\setcounter{eqannotateenv}{2}' part2.aux; then
  echo 'EqAnnotate environment counter is not checkpointed by include' >&2
  exit 1
fi
cp "$HERE"/main-part2.tex main.tex
TEXINPUTS="$ROOT:" pdflatex -interaction=nonstopmode -halt-on-error main.tex >/dev/null
if ! grep -Fq 'eqa@top@2' part2.aux || grep -Fq 'eqa@top@1' part2.aux; then
  echo 'includeonly renumbered EqAnnotate environments unexpectedly' >&2
  exit 1
fi
printf '%s\n' 'EqAnnotate include/includeonly checkpoint test passed.'
