#!/bin/bash

# /bin/ = original (for compatibility testing of /usr/local/bin/ in "cwebtest")
# /var/local/bin/ = original with minimal changes to work in ccw/cct (built in second part of this script)
# /usr/bin/ = by default from distribution (TeX Live)
# /usr/local/bin/ = my (built in first part of this script)

# NOTE: you may test /var/local/bin/ on cwebtest/
#       If you want to test /var/local/bin/, remove cweav-sort.ch and cweav-nospace.ch from
#       "tie -c cweav-merged.ch" in second part of this script.
# You may also test /usr/local/bin/ on cwebtest/, because there all files are ASCII-only.
# If you want to test /usr/local/bin/, remove cweav-sort.ch and cweav-nospace.ch from
# "tie -c cweav-merged.ch" in first
# part of this script, and run "perl -i -pe 's/cwebmal/cwebmac/' *.tex" after running
# "test for compatibility" commands below.

# To test for compatibility:
#
# cd /usr/local/cwebtest/
# git checkout .
# git reset .
# git clean -f >/dev/null
# ./runall.sh -p /bin/ >runall.log 2>/dev/null
# NOTE: we use runall2.log instead of putting the next line before second "git archive" and redirecting to runall.log, because otherwise you will get "your local changes would be overwritten by checkout" error on runall.log when you will run runall.sh for the second time
# ./runall.sh -p /usr/local/bin/ >runall2.log 2>/dev/null # OR /var/local/bin/
# git archive runall-/bin/-V | command tar -xf -
# git add .
# git reset runall2.log
# mv runall2.log runall.log
# git archive runall-/usr/local/bin/-V | command tar -xf - # OR /var/local/bin/
# git branch -D runall-/bin/-V runall-/usr/local/bin/-V # OR /var/local/bin/
#
# If everything is OK, "git st" must not show any changes.


DIR=/usr/local/cweb-git/utf8

# NOTE: if you want to make temporary changes (for example, for adding printfs for tracing), remove the first part from this file and edit /usr/local/cweb/ directly

# Build UTF-8 CWEB from source:
cd /usr/local/cweb/
git rev-parse --abbrev-ref HEAD | grep -v master && exit
git diff --exit-code HEAD || exit
rm -fr /tmp/cwebbuild/
mkdir /tmp/cwebbuild/
cd /tmp/cwebbuild/
cp -r /usr/local/cweb/* .
gcc -g -w -c ctangle.c
perl -i -pe '$m+=s/history> harmless_message/history > spotless/;END{$?=!$m}' common.c || echo revise regexp
gcc -g -w -c common.c
gcc -g -o ctangle ctangle.o common.o
if ! ./ctangle /usr/local/uniweb/uniweb.w > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -c uniweb.c
if ! tie -c comm-merged.ch common.w $DIR/comm-utf8.ch $DIR/comm-file.ch $DIR/comm-mac.ch > build-cweb.out
  then cat build-cweb.out; exit; fi
if ! ./ctangle common.w comm-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit
if ! tie -m comm-utf8.h common.h $DIR/comm-utf8.hch > build-cweb.out; then cat build-cweb.out; exit; fi
perl -i -pe 'print if /wchar_t/; s/wchar_t/wint_t/' cweave.w
perl -i -pe 'print if /size_t/; s/size_t/ssize_t/' cweave.w
if ! tie -c cweav-merged.ch cweave.w $DIR/cweav-utf8.ch $DIR/cweav-sort.ch $DIR/cweav-nospace.ch $DIR/cweav-file.ch $DIR/cweav-mac.ch > build-cweb.out # ATTENTION: cweav-file.ch must be before cweav-mac.ch
  then cat build-cweb.out; exit; fi
if ! ./ctangle cweave.w cweav-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c cweave.c || exit
gcc -g -o cweave cweave.o common.o uniweb.o
if ! tie -c ctang-merged.ch ctangle.w $DIR/ctang-utf8.ch $DIR/ctang-file.ch > build-cweb.out
  then cat build-cweb.out; exit; fi
if ! ./ctangle ctangle.w ctang-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c ctangle.c || exit
gcc -g -o ctangle ctangle.o common.o uniweb.o
cp cweave ctangle /usr/local/bin/
cd /
rm -fr /tmp/cwebbuild/

# Build original CWEB for cct and ccw:
rm -fr /tmp/cwebbuild/
mkdir /tmp/cwebbuild/
cd /tmp/cwebbuild/
cp -r /usr/local/cweb/* .
gcc -g -w -c ctangle.c
perl -i -pe '$m+=s/history> harmless_message/history > spotless/;END{$?=!$m}' common.c || echo revise regexp
gcc -g -w -c common.c
gcc -g -o ctangle ctangle.o common.o
if ! ./ctangle common.w > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit
perl -i -pe 's/^\@h/#include <locale.h>\n$&/' cweave.w
perl -i -pe 's/  argc=ac; argv=av;/  setlocale(LC_CTYPE,"ru_RU.CP1251");\n$&/' cweave.w
perl -i -pe 's/xislower\(/islower((unsigned char)/' cweave.w
perl -i -pe 's/xisupper/isupper/' cweave.w
perl -i -pe 's[\Q\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277]'"'"'\260\261\262\263\264\265\266\267\272\273\274\275\276\277\300\301'"'" cweave.w
perl -i -pe 's[\Q\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317]'"'"'\302\303\304\305\306\307\310\311\312\313\314\315\316\317\320\321'"'" cweave.w
perl -i -pe 's[\Q\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337]'"'"'\322\323\324\325\326\327\330\331\332\333\334\335\336\337\340\341'"'" cweave.w
perl -i -pe 's[\Q\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357]'"'"'\342\343\344\345\270\346\347\350\351\352\353\354\355\356\357\360'"'" cweave.w
perl -i -pe 's[\Q\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377]'"'"'\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377\271'"'" cweave.w
perl -i -pe 'print if /wchar_t/; s/wchar_t/wint_t/' cweave.w
perl -i -pe 'print if /size_t/; s/size_t/ssize_t/' cweave.w
if ! tie -c cweav-merged.ch cweave.w $DIR/cweav-sort.ch $DIR/cweav-nospace.ch /dev/null > build-cweb.out
  then cat build-cweb.out; exit; fi
if ! ./ctangle cweave.w cweav-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c cweave.c || exit
gcc -g -o cweave cweave.o common.o
if ! ./ctangle ctangle.w > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c ctangle.c || exit
gcc -g -o ctangle ctangle.o common.o
mkdir -p /var/local/bin/
cp cweave ctangle /var/local/bin/
cd /
rm -fr /tmp/cwebbuild/
