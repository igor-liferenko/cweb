#!/bin/bash

# /bin/ = original (for compatibility testing of /usr/local/bin/ in "cwebtest")
# /var/local/bin/ = original with minimal changes to work in ccw/cct (built in second part of this script)
# /usr/bin/ = by default from distribution (TeX Live)
# /usr/local/bin/ = my (built in first part of this script)

# To test for compatibility of cweave and ctangle in /usr/local/bin/:
# remove cweav-sort.ch and cweav-prod.ch from "tie -c cweav-merged.ch" and ctang-pp.ch
# from "tie -c ctang-merged.ch" in first
# part of build.sh and run:
#   build-cweb
#   test-cweb
# If everything is OK, no changes must be shown.

# To test for compatibility of cwebmac.tex:
# remove cweav-sort.ch and cweav-prod.ch from "tie -c cweav-merged.ch" in first
# part of build.sh and run:
#   build-cweb
#   test-cwebmac # before running this ensure that test-cweb produces empty output
# If everything is OK, no changes must be shown.

# NOTE: to build woven outputs for all example programs, run "test-cwebmac >/dev/null"
# (without modifying build.sh) and checkout runall-/bin/-V branch in cwebtest repo


DIR=/home/user/cweb-git/utf8

# NOTE: if you want to make temporary changes (for example, for adding printfs for tracing), remove the first part from this file and edit /home/user/cweb/ directly

# Build UTF-8 CWEB from source:
cd /home/user/cweb/
git rev-parse --abbrev-ref HEAD | grep -v master && exit
git diff --exit-code HEAD || exit
rm -fr /tmp/cwebbuild/
mkdir /tmp/cwebbuild/
cd /tmp/cwebbuild/
cp -r /home/user/cweb/* .
clang -g -w -c ctangle.c
perl -i -pe '$m+=s/history> harmless_message/history > spotless/;END{$?=!$m}' common.c || echo revise regexp
sed -i 's/wrap_up(){/wrap_up(){if(show_happiness)/' common.c
clang -g -w -c common.c
clang -g -o ctangle ctangle.o common.o
tie -bhp -c comm-merged.ch common.w $DIR/comm-utf8.ch $DIR/comm-file.ch $DIR/comm-mac.ch $DIR/comm-exten.ch $DIR/comm-show.ch $DIR/comm-fclose.ch || exit
./ctangle -bhp common.w comm-merged.ch || exit
clang -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit
tie -bhp -m comm-utf8.h common.h $DIR/comm-utf8.hch || exit
tie -bhp -c cweav-merged.ch cweave.w $DIR/cweav-utf8.ch $DIR/cweav-sort.ch $DIR/cweav-prod.ch $DIR/cweav-sub.ch $DIR/cweav-format.ch $DIR/cweav-type.ch $DIR/cweav-show.ch $DIR/cweav-fclose.ch $DIR/cweav-file.ch $DIR/cweav-mac.ch || exit # ATTENTION: cweav-file.ch must be before cweav-mac.ch
./ctangle -bhp cweave.w cweav-merged.ch || exit
clang -g -w -c cweave.c || exit
clang -g -o cweave cweave.o common.o
tie -bhp -c ctang-merged.ch ctangle.w $DIR/ctang-utf8.ch $DIR/ctang-show.ch $DIR/ctang-file.ch $DIR/ctang-pp.ch || exit
./ctangle -bhp ctangle.w ctang-merged.ch || exit
clang -g -w -c ctangle.c || exit
clang -g -o ctangle ctangle.o common.o
cp cweave ctangle /usr/local/bin/
cd /
rm -fr /tmp/cwebbuild/

# Build wmerge:
/bin/ctangle /home/user/cweb/examples/wmerge.w $DIR/wmerge.ch /tmp/wmerge.c >/dev/null && clang -g -w -DCWEBINPUTS=\"/home/user/0000-git/cweb\" /tmp/wmerge.c -o /usr/local/bin/wmerge
rm /tmp/wmerge.c

# Build original CWEB with minimal changes for cct and ccw:
rm -fr /tmp/cwebbuild/
mkdir /tmp/cwebbuild/
cd /tmp/cwebbuild/
cp -r /home/user/cweb/* .
clang -g -w -c ctangle.c
perl -i -pe '$m+=s/history> harmless_message/history > spotless/;END{$?=!$m}' common.c || echo revise regexp
sed -i 's/wrap_up(){/wrap_up(){if(show_happiness)/' common.c
clang -g -w -c common.c
clang -g -o ctangle ctangle.o common.o
./ctangle -bhp common.w $DIR/comm-show.ch || exit
clang -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit # WARNING: instead of "Cannot open include file" it can give "Include file name too long" error message
perl -i -pe 's/^\@h/#include <locale.h>\n$&/' cweave.w
perl -i -pe 's/  argc=ac; argv=av;/  setlocale(LC_CTYPE,"ru_RU.CP1251");\n$&/' cweave.w
perl -i -pe 's/xislower\(/islower((unsigned char)/' cweave.w # if we do not use cast, islower('я') returns 0
perl -i -pe 's/xisupper/isupper/' cweave.w
perl -i -pe 's[\Q\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277]'"'"'\260\261\262\263\264\265\266\267\272\273\274\275\276\277\300\301'"'" cweave.w
perl -i -pe 's[\Q\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317]'"'"'\302\303\304\305\306\307\310\311\312\313\314\315\316\317\320\321'"'" cweave.w
perl -i -pe 's[\Q\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337]'"'"'\322\323\324\325\326\327\330\331\332\333\334\335\336\337\340\341'"'" cweave.w
perl -i -pe 's[\Q\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357]'"'"'\342\343\344\345\270\346\347\350\351\352\353\354\355\356\357\360'"'" cweave.w
perl -i -pe 's[\Q\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377]'"'"'\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377\271'"'" cweave.w
tie -bhp -c cweav-merged.ch cweave.w $DIR/cweav-sort.ch $DIR/cweav-prod.ch $DIR/cweav-type.ch $DIR/cweav-show.ch || exit
./ctangle -bhp cweave.w cweav-merged.ch || exit
clang -g -w -c cweave.c || exit
clang -g -o cweave cweave.o common.o
./ctangle -bhp ctangle.w $DIR/ctang-show.ch || exit
clang -g -w -c ctangle.c || exit
clang -g -o ctangle ctangle.o common.o
mkdir -p /var/local/bin/
cp cweave ctangle /var/local/bin/
cd /
rm -fr /tmp/cwebbuild/

# For /dev/null-sections:
rm -fr /tmp/cwebbuild/
mkdir /tmp/cwebbuild/
cd /tmp/cwebbuild/
cp -r /home/user/cweb/* .
clang -g -w -c ctangle.c
perl -i -pe '$m+=s/history> harmless_message/history > spotless/;END{$?=!$m}' common.c || echo revise regexp
clang -g -w -c common.c
clang -g -o ctangle ctangle.o common.o
if ! tie -c comm-merged.ch common.w $DIR/../comm-opts.ch $DIR/../comm-out.ch $DIR/../comm-pipe.ch > build-cweb.out
  then cat build-cweb.out; exit; fi
if ! ./ctangle common.w comm-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
clang -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit
if ! tie -c cweav-merged.ch cweave.w $DIR/../cweav-opts.ch $DIR/../cweav-tran.ch $DIR/../cweav-pipe.ch $DIR/cweav-prod.ch $DIR/cweav-type.ch > build-cweb.out
  then cat build-cweb.out; exit; fi
if ! ./ctangle cweave.w cweav-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
clang -g -w -c cweave.c || exit
clang -g -o /var/local/bin/cweave-null cweave.o common.o
cd /
rm -fr /tmp/cwebbuild/
