#!/bin/bash
cd /home/user/cwebtest/
git checkout .
git reset >/dev/null
git checkout .
git clean -f >/dev/null
git checkout master &>/dev/null
git branch -D runall-/bin/-V runall-/usr/local/bin/-V &>/dev/null
sed -i '0,/^@ /s//@* Intro. /' reflect.w # see tex/question2.tex
./runall.sh -p /bin/ >runall.log 2>/dev/null
git checkout runall-/bin/-V &>/dev/null
git add runall.log
git commit -m 'runall' >/dev/null
git checkout master &>/dev/null
./runall.sh -p /usr/local/bin/ >runall.log 2>/dev/null
git checkout runall-/usr/local/bin/-V &>/dev/null
git add runall.log
git commit -m 'runall' >/dev/null
git checkout master &>/dev/null
git diff runall-/bin/-V runall-/usr/local/bin/-V
git checkout reflect.w
