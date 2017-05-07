#!/bin/bash

# NOTE: you may test cweave and ctangle on cwebtest/
#       If you want to test cweave on cwebtest/, remove cweav-sort.ch from
#       "./ctangle cweave.w" in second part of this script.
# You may also test cw and ct on cwebtest/, because there all files are ASCII-only.
# If you want to test cw, remove cweav-sort.ch from "tie -c cweav-merged.ch" in first
# part of this script, and run "perl -i -pe 's/cwebmal/cwebmac/' *.tex" after running cw.

DIR=/usr/local/cweb-git/utf8

# NOTE: if you want to make temporary changes (for example, for adding printfs for tracing), remove the first part from this file and edit /usr/local/cweb/ directly

# Build UTF-8 CWEB from source:
cd /usr/local/cweb/
git rev-parse --abbrev-ref HEAD | grep -v master && exit
git diff --exit-code HEAD || exit
mkdir /tmp/cwebbuild/ || exit # do not remove automatically in order not to step over an already running build
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
perl -i -pe 'print if /wchar_t/; s/wchar_t/wint_t/; print; s/wint_t/cchar_t/; print; s/cchar_t/ssize_t/' cweave.w
if ! tie -c cweav-merged.ch cweave.w $DIR/cweav-utf8.ch $DIR/cweav-sort.ch $DIR/cweav-file.ch $DIR/cweav-mac.ch > build-cweb.out # ATTENTION: cweav-file.ch must be before cweav-mac.ch
  then cat build-cweb.out; exit; fi
if ! ./ctangle cweave.w cweav-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c cweave.c || exit
gcc -g -o cw cweave.o common.o uniweb.o
if ! tie -c ctang-merged.ch ctangle.w $DIR/ctang-utf8.ch $DIR/ctang-file.ch > build-cweb.out
  then cat build-cweb.out; exit; fi
if ! ./ctangle ctangle.w ctang-merged.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c ctangle.c || exit
gcc -g -o ct ctangle.o common.o uniweb.o
cp cw ct /usr/local/bin/
cd /
rm -fr /tmp/cwebbuild/

# Build original CWEB for cct and ccw:
mkdir /tmp/cwebbuild/ || exit # do not remove automatically because the above part may be deleted as said in second NOTE at the beginning of this file, and then this line will be the same as analogous line above - see comment after that line
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
perl -i -pe 'print if /wchar_t/; s/wchar_t/wint_t/; print; s/wint_t/cchar_t/; print; s/cchar_t/ssize_t/' cweave.w
if ! ./ctangle cweave.w $DIR/cweav-sort.ch > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c cweave.c || exit
gcc -g -o cweave cweave.o common.o
if ! ./ctangle ctangle.w > build-cweb.out; then cat build-cweb.out; exit; fi
gcc -g -w -c ctangle.c || exit
gcc -g -o ctangle ctangle.o common.o
cp cweave ctangle /usr/local/bin/
cd /
rm -fr /tmp/cwebbuild/
