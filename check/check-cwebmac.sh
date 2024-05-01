#!/bin/bash
cd /home/user/cwebtest/
git checkout -q .
git reset >/dev/null
git checkout -q .
git clean -f >/dev/null
git checkout master &>/dev/null
git branch -D runall-/var/local/bin/-V3.64 runall-/usr/local/bin/-V3.64 &>/dev/null
./runall.sh -p /var/local/bin/ &>/dev/null
./runall.sh -p /usr/local/bin/ &>/dev/null
git checkout runall-/var/local/bin/-V3.64 &>/dev/null
for i in *.mp; do mpost $i; done >/dev/null
cp /usr/share/texlive/texmf-dist/tex/plain/cweb/cwebmac.tex .
for i in *.tex; do [ $i = cwebmac.tex ] && continue; echo '\def\time{5} \input '$i | tex; done &>/dev/null
for i in *.dvi; do dvihash `basename $i .dvi`; done >hash.all
for i in *.toc; do perl -i -0777 -pe 's/\n(?=\\catcode `\\@=12\\relax)//' $i; done # after .dvi file is generated we can do whatever we want with .toc file
git add .
git commit -m 'tex' >/dev/null
git checkout runall-/usr/local/bin/-V3.64 &>/dev/null
for i in *.mp; do mpost $i; done >/dev/null
patch tcb.tex <<EOF >/dev/null || exit # pdf mode is not used in my cwebmac
@@ -94 +93,0 @@
-  \ifacro{\toksF={}\makeoutlinetoks#3\outlinedone\outlinedone}\fi
@@ -102,5 +100,0 @@
-  \ifpdftex\expandafter\xdef\csname curr#1\endcsname{\secno}
-    \ifnum#1>0\countB=#1 \advance\countB by-1
-      \advancenumber{chunk\the\countB.\expnumber{curr\the\countB}}\fi\fi
-  \ifpdf\special{pdf: outline #1 << /Title (\the\toksE) /Dest
-    [ @thispage /FitH @ypos ] >>}\fi
EOF
for i in *.tex; do echo '\def\time{5} \input '$i | tex; done &>/dev/null
for i in *.dvi; do dvihash $i; done >hash.all
git add .
git commit -m 'tex' >/dev/null
git checkout master &>/dev/null
git diff runall-/var/local/bin/-V3.64 runall-/usr/local/bin/-V3.64 -- . ':!*.tex' ':!*.log' ':!*.dvi' ':!*.fmt' ':!*.600pk' ':!*.0' ':!*.1' ':!*.2' ':!*.3' ':!*.4' ':!*.5' ':!*.6' ':!*.7' ':!*.8' ':!*.9' ':!*.10' ':!*.11' ':!*.12' ':!*.13' ':!*.14' ':!*.20' ':!*.21' ':!*.22' ':!*.23' ':!*.24' ':!*.25' ':!*.30' ':!*.31' ':!*.32' ':!*.33' ':!*.34' ':!*.35' ':!*.36' ':!*.37' ':!*.38' ':!*.39' ':!*.40' ':!*.41' ':!*.42' ':!*.50' ':!*.51' ':!*.52' ':!*.81' ':!*.82' ':!*.84' ':!*.90' ':!*.91' ':!*.92' ':!*.93' ':!*.94' ':!*.95' ':!*.96' ':!*.97' ':!*.98' ':!*.99' ':!*.100' ':!*.101' ':!*.102' ':!*.103' ':!*.104' ':!*.105' ':!*.106' ':!*.107' ':!*.108' ':!*.109' ':!*.110' ':!*.200' ':!*.201' ':!*.202' ':!*.203' ':!*.204' ':!*.205' ':!*.206' ':!*.207'
