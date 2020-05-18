#!/bin/bash
cd /home/user/cwebtest/
git checkout -q .
git reset >/dev/null
git checkout -q .
git clean -f >/dev/null
git checkout master &>/dev/null
git branch -D runall-/bin/-V3.64 runall-/usr/local/bin/-V3.64 &>/dev/null
sed -i '0,/^@ /s//@* Intro. /' reflect.w # see tex/question2.tex
./runall.sh -p /bin/ >runall.log 2>/dev/null
git checkout runall-/bin/-V3.64 &>/dev/null
git add runall.log
git commit -m 'runall' >/dev/null
git checkout master &>/dev/null
./runall.sh -p /usr/local/bin/ >runall.log 2>/dev/null
git checkout runall-/usr/local/bin/-V3.64 &>/dev/null
git add runall.log
git commit -m 'runall' >/dev/null
git checkout master &>/dev/null
git diff runall-/bin/-V3.64 runall-/usr/local/bin/-V3.64
git checkout -q reflect.w
