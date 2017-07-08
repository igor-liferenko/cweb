#!/bin/bash
cd /usr/local/cwebtest/
git checkout .
git reset .
git checkout .
git clean -f >/dev/null
git checkout master &>/dev/null
git branch -D runall-/bin/-V runall-/usr/local/bin/-V &>/dev/null
./runall.sh -p /bin/ &>/dev/null
./runall.sh -p /usr/local/bin/ &>/dev/null
git checkout runall-/bin/-V &>/dev/null
for i in *.mp; do mpost $i; done >/dev/null
cp /usr/local/SUPER_DEBIAN/lhplain.ini .
perl -i -pe 's/(?=\\dump)/\\def\\time{5}\n/' lhplain.ini
tex -ini -jobname tex lhplain.ini >/dev/null
cd /usr/local/cweb/
git rev-parse --abbrev-ref HEAD | grep -v master && exit
git diff --exit-code HEAD || exit
cd - >/dev/null
cp /usr/local/cweb/cwebmac.tex .
perl -i -pe 's/\\pageshift=0in/\\pageshift=\\hoffset/' cwebmac.tex # fix bug
for i in *.tex; do [ $i = cwebmac.tex ] && continue; tex $i; done &>/dev/null
for i in *.dvi; do dvihash $i; done >hash.all
git add hash.all
git commit -m 'hash' >/dev/null
git checkout .
git reset .
git checkout .
git clean -f >/dev/null
git checkout runall-/usr/local/bin/-V &>/dev/null
for i in *.mp; do mpost $i; done >/dev/null
patch -F0 tcb.tex << EOF >/dev/null || exit
@@ -82,16 +82,15 @@
 
 % Now I bring in the program files created with cweave
 
-\input cwebmac
+\input cwebmal
 \let\INPUT=\input
 \def\input#1 {\def\next{#1}\ifx\next\cwebmac\else\INPUT #1\fi}
-\def\cwebmac{cwebmac}
+\def\cwebmac{cwebmal}
 \def\inx{}
 \def\fin{}
 \def\con{\output{\setbox0=\box255
                 \global\output{\normaloutput\page\lheader\rheader}}\eject}
 \outer\def\N#1#2#3.{% beginning of starred section
-  \ifacro{\toksF={}\makeoutlinetoks#3\outlinedone\outlinedone}\fi
   \gdepth=#1\gtitle={#3}\MN{#2}%
   \ifon\ifnum#1<\secpagedepth \vfil\eject % force page break if depth is small
     \else\vfil\penalty-100\vfilneg\vskip\intersecskip\fi\fi
@@ -99,11 +98,6 @@
   \def\stripprefix##1>{}\def\gtitletoks{#3}%
   \edef\gtitletoks{\expandafter\stripprefix\meaning\gtitletoks}%
  % omit output to contents file
-  \ifpdftex\expandafter\xdef\csname curr#1\endcsname{\secno}
-    \ifnum#1>0\countB=#1 \advance\countB by-1
-      \advancenumber{chunk\the\countB.\expnumber{curr\the\countB}}\fi\fi
-  \ifpdf\special{pdf: outline #1 << /Title (\the\toksE) /Dest
-    [ @thispage /FitH @ypos ] >>}\fi
   \ifon\startsection{\bf#3.\quad}\ignorespaces}
 
 \def\datethis{\def\startsection{\centerline{\bf Program 1}\bigskip
EOF
cp /usr/local/SUPER_DEBIAN/lhplain.ini .
perl -i -pe 's/(?=\\dump)/\\def\\time{5}\n/' lhplain.ini
tex -ini -jobname tex lhplain.ini >/dev/null
for i in *.tex; do [ $i = cwebmac.tex ] && continue; tex $i; done &>/dev/null
for i in *.dvi; do dvihash $i; done >hash.all
git add hash.all
git commit -m 'hash' >/dev/null
git checkout .
git reset .
git checkout .
git clean -f >/dev/null
git checkout master &>/dev/null
git diff runall-/bin/-V runall-/usr/local/bin/-V -- hash.all
