#!/bin/bash
cd /home/user/cwebtest/
git checkout .
git reset >/dev/null
git checkout .
git clean -f >/dev/null
git checkout master &>/dev/null
git branch -D runall-/bin/-V runall-/var/local/bin/-V &>/dev/null
./runall.sh -p /bin/ >runall.log 2>/dev/null
git checkout runall-/bin/-V &>/dev/null
git add runall.log
git commit -m 'runall' >/dev/null
git checkout master &>/dev/null
./runall.sh -p /var/local/bin/ >runall.log 2>/dev/null
git checkout runall-/var/local/bin/-V &>/dev/null
git add runall.log
git commit -m 'runall' >/dev/null
git commit -m 'cwebmac' . >/dev/null
git checkout master &>/dev/null
git diff runall-/bin/-V runall-/var/local/bin/-V