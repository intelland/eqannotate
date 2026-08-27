#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$ROOT/tests/testlib.sh"
HERE="$ROOT/tests/compatibility"
cd "$HERE"

for engine in pdflatex lualatex; do
  for test in real-formulas two-column wrap-crossing multiline-wrappers rc-identifiers hyperref-before hyperref-after fleqn-leqno; do
    eqa_compile_until_stable "$engine" "$test" "$ROOT" 5
    if grep -Eq '(^! |Overfull \\hbox|Package eqannotate Error)' "$test.log"; then
      echo "Compatibility failure: $engine $test" >&2
      grep -E '(^! |Overfull \\hbox|Package eqannotate Error)' "$test.log" >&2 || true
      exit 1
    fi
  done
done

for test in class-ieee class-acm class-revtex class-elsevier class-beamer; do
  eqa_compile_until_stable pdflatex "$test" "$ROOT" 5
  if grep -Eq '(^! |Package eqannotate Error)' "$test.log"; then
    echo "Class compatibility failure: $test" >&2
    exit 1
  fi
done

# unicode-math smoke in both Unicode engines. EqAnnotate intentionally has no
# mathtools dependency, so either package load order stays quiet and valid.
for engine in lualatex xelatex; do
  eqa_compile_until_stable "$engine" unicode-math "$ROOT" 5
  if grep -Eq '(^! |Overfull \\hbox|Package eqannotate Error|Package mathtools Warning)' unicode-math.log; then
    echo "Unicode-math compatibility failure: $engine" >&2
    exit 1
  fi
done

# Warning behavior is checked with pdfLaTeX.
eqa_compile_until_stable pdflatex warnings "$ROOT" 5
for expected in \
  'Annotation `missing'"'"' has no matching' \
  'Duplicate mark id `dup'"'"' in one annotated equation' \
  'Annotation id `dup'"'"' declared more than once'; do
  if ! grep -Fq "$expected" warnings.log; then
    echo "Missing readable expected warning: $expected" >&2
    exit 1
  fi
done
if grep -Eq 'Overfull \\hbox|Package eqannotate Error' warnings.log; then
  echo "Warning-regression document produced an overfull box or package error" >&2
  exit 1
fi

# Misuse outside an EqAnnotate environment must fail clearly.
rm -f misuse-outside.aux misuse-outside.log misuse-outside.pdf misuse-outside.out
if TEXINPUTS="$ROOT:" pdflatex -interaction=nonstopmode -halt-on-error misuse-outside.tex >/dev/null 2>&1; then
  echo "Expected misuse-outside.tex to fail, but it compiled" >&2
  exit 1
fi
if ! tr -d '\n' < misuse-outside.log | grep -Fq '\\eqmark used outside an EqAnnotate display environment'; then
  echo "Missing readable outside-environment error" >&2
  exit 1
fi

printf '%s\n' 'EqAnnotate compatibility corpus passed and converged; identifier, hyperref, fleqn/leqno, and unicode-math RC edges included.'
