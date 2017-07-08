#!/bin/bash

# /bin/ = original (for compatibility testing of /usr/local/bin/ in "cwebtest")
# /var/local/bin/ = original with minimal changes to work in ccw/cct (built in second part of this script)
# /usr/bin/ = by default from distribution (TeX Live)
# /usr/local/bin/ = my (built in first part of this script)

# To test for compatibility of cweave and ctangle in /usr/local/bin/:
# remove cweav-sort.ch and cweav-nospace.ch from "tie -c cweav-merged.ch" in first
# part of this script
# run "build-cweb"
: << EOF
cd /usr/local/cwebtest/
git checkout .
git reset .
git clean -f >/dev/null
./runall.sh -p /bin/ >runall.log 2>/dev/null
git checkout runall-/bin/-V
git add runall.log
git commit -m 'runall'
git checkout master
./runall.sh -p /usr/local/bin/ >runall.log 2>/dev/null
git checkout runall-/usr/local/bin/-V
git add runall.log
git commit -m 'runall'
git checkout master
git archive runall-/bin/-V | command tar -xf -
git add .
git archive runall-/usr/local/bin/-V | command tar -xf -
perl -i -pe 's/cwebmal/cwebmac/' *.tex
git branch -D runall-/bin/-V runall-/usr/local/bin/-V
EOF
# If everything is OK, "git st" must not show any changes in red.


# To test for compatibility of cweave and ctangle in /var/local/bin/:
# replace cweav-sort.ch and cweav-nospace.ch from
# "tie -c cweav-merged.ch" to /dev/null in second part of this script
# run "build-cweb"
: << EOF
cd /usr/local/cwebtest/
git checkout .
git reset .
git clean -f >/dev/null
./runall.sh -p /bin/ >runall.log 2>/dev/null
git checkout runall-/bin/-V
git add runall.log
git commit -m 'runall'
git checkout master
./runall.sh -p /var/local/bin/ >runall.log 2>/dev/null
git checkout runall-/var/local/bin/-V
git add runall.log
git commit -m 'runall'
git checkout master
git archive runall-/bin/-V | command tar -xf -
git add .
git archive runall-/var/local/bin/-V | command tar -xf -
git branch -D runall-/bin/-V runall-/var/local/bin/-V
EOF
# If everything is OK, "git st" must not show any changes in red.

# To test for compatibility of cwebmac.tex, run tex+dvihash in branches runall-/bin/-V and
# runall-/usr/local/bin/-V as follows:
# remove cweav-sort.ch and cweav-nospace.ch from "tie -c cweav-merged.ch" in first part of this script
# run "build-cweb"
: << EOF
cd /usr/local/cwebtest/
git checkout .
git reset .
git clean -f >/dev/null
./runall.sh -p /bin/ >runall.log 2>/dev/null
git checkout runall-/bin/-V
git add runall.log
git commit -m 'runall'
git checkout master
./runall.sh -p /usr/local/bin/ >runall.log 2>/dev/null # OR /var/local/bin/
git checkout runall-/usr/local/bin/-V # OR /var/local/bin/
git add runall.log
git commit -m 'runall'
git checkout master
cd ../
cp -a cwebtest/ cwebtest-local/
cd cwebtest/
git checkout runall-/bin/-V
cd ../cwebtest-local/
git checkout runall-/usr/local/bin/-V
cd ../
EOF
# 1) in cwebtest/ and cwebtest-local/: for i in *.mp; do mpost $i; done
# 2) in cwebtest-local/ apply patch to tcb.tex:
#
#-\input cwebmac
#+\input cwebmal
# \let\INPUT=\input
# \def\input#1 {\def\next{#1}\ifx\next\cwebmac\else\INPUT #1\fi}
#-\def\cwebmac{cwebmac}
#+\def\cwebmac{cwebmal}
# \def\inx{}
# \def\fin{}
# \def\con{\output{\setbox0=\box255
#                 \global\output{\normaloutput\page\lheader\rheader}}\eject}
# \outer\def\N#1#2#3.{% beginning of starred section
#-  \ifacro{\toksF={}\makeoutlinetoks#3\outlinedone\outlinedone}\fi
#   \gdepth=#1\gtitle={#3}\MN{#2}%
#   \ifon\ifnum#1<\secpagedepth \vfil\eject % force page break if depth is small
#     \else\vfil\penalty-100\vfilneg\vskip\intersecskip\fi\fi
#@@ -99,11 +98,6 @@ programs.html} and used without restriction.
#   \def\stripprefix##1>{}\def\gtitletoks{#3}%
#   \edef\gtitletoks{\expandafter\stripprefix\meaning\gtitletoks}%
#  % omit output to contents file
#-  \ifpdftex\expandafter\xdef\csname curr#1\endcsname{\secno}
#-    \ifnum#1>0\countB=#1 \advance\countB by-1
#-      \advancenumber{chunk\the\countB.\expnumber{curr\the\countB}}\fi\fi
#-  \ifpdf\special{pdf: outline #1 << /Title (\the\toksE) /Dest
#-    [ @thispage /FitH @ypos ] >>}\fi
#   \ifon\startsection{\bf#3.\quad}\ignorespaces}
#
# 3) in both cwebtest/ and cwebtest-local/ generate new tex.fmt with following commands:
# cp /usr/local/SUPER_DEBIAN/lhplain.ini .
# perl -i -pe 's/(?=\\dump)/\\def\\time{5}\n/' lhplain.ini
# tex -ini -jobname tex lhplain.ini >/dev/null
# 4) in cwebtest/ fix bug in cwebmac.tex by running the following commands:
# cp /usr/local/cweb/cwebmac.tex . # first check via "git st" that it is not modified
# perl -i -pe 's/\\pageshift=0in/\\pageshift=\\hoffset/' cwebmac.tex # fix bug
# 5) for i in *.tex; do tex $i; done
# for i in *.dvi; do dvihash $i; done >hash.all
# Then just diff cwebtest/hash.all cwebtest-local/hash.all: if they are the same,
# everything is compatible.
# TODO: for what is line "ensure that the contents file isn't empty" in cwebmal.tex? Try to
# remove it and test for compatibility as said here.


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
if ! tie -c cweav-merged.ch cweave.w $DIR/cweav-sort.ch $DIR/cweav-nospace.ch > build-cweb.out
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
