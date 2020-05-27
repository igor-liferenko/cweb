#!/bin/bash

cd /home/user/cweb/utf8/

# Build UTF-8 CWEB from source:
tie -c comm-merged.ch common.w comm-utf8.ch comm-file.ch comm-exten.ch comm-show.ch >/dev/null || exit
/usr/bin/ctangle -bhp common.w comm-merged.ch || exit
clang -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit
tie -m comm-utf8.h common.h comm-utf8.hch >/dev/null || exit
tie -c cweav-merged.ch cweave.w cweav-utf8.ch cweav-sort.ch cweav-show.ch cweav-c.ch cweav-d.ch cweav-y.ch cweav-z.ch cweav-file.ch cweav-mac.ch >/dev/null || exit # ATTENTION: cweav-file.ch must be before cweav-mac.ch
/usr/bin/ctangle -bhp cweave.w cweav-merged.ch || exit
clang -g -w -c cweave.c || exit
clang -g -o cweave cweave.o common.o
tie -c ctang-merged.ch ctangle.w ctang-utf8.ch ctang-show.ch ctang-file.ch ctang-pp.ch >/dev/null || exit
/usr/bin/ctangle -bhp ctangle.w ctang-merged.ch || exit
clang -g -w -c ctangle.c || exit
clang -g -o ctangle ctangle.o common.o
cp cweave ctangle /usr/local/bin/

# Build original CWEB with minimal changes for check-ctangle and check-cweave:
rm -fr /tmp/cwebbuild/
mkdir /tmp/cwebbuild/
cd /tmp/cwebbuild/
cp /home/user/cweb/utf8/{common.h,common.w,ctangle.w,cweave.w,prod.w} .
/usr/bin/ctangle -bhp common.w || exit
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
/usr/bin/ctangle -bhp cweave.w /home/user/cweb/utf8/cweav-sort.ch || exit
clang -g -w -c cweave.c || exit
clang -g -o cweave cweave.o common.o
/usr/bin/ctangle -bhp ctangle.w /home/user/cweb/utf8/ctang-iconv.ch || exit
clang -g -w -c ctangle.c || exit
clang -g -o ctangle ctangle.o common.o
mkdir -p /var/local/bin/
cp cweave ctangle /var/local/bin/
cd /
rm -fr /tmp/cwebbuild/
