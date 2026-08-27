#!/usr/bin/env sh
# Shared convergence helper for EqAnnotate regression tests.
# Usage: eqa_compile_until_stable <engine> <tex-basename> <texinputs-root> [max-passes]
eqa_compile_until_stable() {
  engine=$1
  test=$2
  texroot=$3
  max=${4:-5}
  rm -f "$test.aux" "$test.log" "$test.pdf" "$test.out" "$test.fls" "$test.fdb_latexmk"
  prev=''
  pass=1
  stable=0
  while [ "$pass" -le "$max" ]; do
    TEXINPUTS="$texroot:" "$engine" -interaction=nonstopmode -halt-on-error "$test.tex" >/dev/null
    if [ -f "$test.aux" ]; then
      cur=$(cksum "$test.aux" | awk '{print $1 ":" $2}')
    else
      cur='no-aux'
    fi
    rerun=0
    if grep -Eq 'Label\(s\) may have changed|Rerun to get cross-references right|Rerun LaTeX for optimized annotation spacing' "$test.log"; then
      rerun=1
    fi
    if [ "$cur" = "$prev" ] && [ "$rerun" -eq 0 ]; then
      stable=1
      break
    fi
    prev=$cur
    pass=$((pass + 1))
  done
  if [ "$stable" -ne 1 ]; then
    echo "EqAnnotate did not converge within $max passes: $engine $test" >&2
    return 1
  fi
}
