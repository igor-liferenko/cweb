#!/bin/bash

cd /home/user/cweb/utf8/

# Build UTF-8 CWEB from source:
tie -c comm-merged.ch common.w comm-utf8.ch comm-file.ch comm-exten.ch comm-show.ch >/dev/null || exit
/usr/bin/ctangle -bhp common.w comm-merged.ch || exit
clang -g -w -c -DCWEBINPUTS=\"/home/user/0000-git/cweb\" common.c || exit
tie -m comm-utf8.h common.h comm-utf8.hch >/dev/null || exit
tie -c cweav-merged.ch cweave.w cweav-utf8.ch cweav-show.ch cweav-c.ch cweav-d.ch cweav-y.ch cweav-z.ch cweav-file.ch cweav-mac.ch >/dev/null || exit # ATTENTION: cweav-file.ch must be before cweav-mac.ch
/usr/bin/ctangle -bhp cweave.w cweav-merged.ch || exit
clang -g -w -c cweave.c || exit
clang -g -o cweave cweave.o common.o
tie -c ctang-merged.ch ctangle.w ctang-utf8.ch ctang-show.ch ctang-file.ch ctang-pp.ch >/dev/null || exit
/usr/bin/ctangle -bhp ctangle.w ctang-merged.ch || exit
clang -g -w -c ctangle.c || exit
clang -g -o ctangle ctangle.o common.o
cp cweave ctangle /usr/local/bin/
