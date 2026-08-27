#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
. "$ROOT/tests/testlib.sh"
cd "$ROOT/tests"
for engine in pdflatex lualatex; do
  for test in smoke column-smoke occlusion-smoke deoverlap-smoke routing-smoke numbered-smoke wrap-smoke crossing-smoke amsmath-smoke manual-smoke article-flow-smoke; do
    eqa_compile_until_stable "$engine" "$test" "$ROOT" 5
    if grep -Eq '(^! |Overfull \\hbox|Package eqannotate Error)' "$test.log"; then
      cat "$test.log"
      exit 1
    fi
  done
done

# Selected XeLaTeX smoke coverage for the third mainstream engine.
for test in smoke numbered-smoke amsmath-smoke manual-smoke; do
  eqa_compile_until_stable xelatex "$test" "$ROOT" 5
  if grep -Eq '(^! |Overfull \\hbox|Package eqannotate Error)' "$test.log"; then
    cat "$test.log"
    exit 1
  fi
done

"$ROOT/tests/includeonly/run.sh"
printf '%s\n' 'EqAnnotate smoke tests passed and converged within five runs (pdfLaTeX/LuaLaTeX; selected XeLaTeX; includeonly checkpoint).'
