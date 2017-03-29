all:
	ctangle common
	gcc -g -w -c common.c
	ctangle ctangle
	gcc -g -w -c ctangle.c
	gcc -g -o ctangle ctangle.o common.o
	ctangle cweave
	gcc -g -w -c cweave.c
	gcc -g -o cweave cweave.o common.o

docs:
sudo -u user mkdir /tmp/cwebdoc/
cd /tmp/cwebdoc/
sudo -u user cp /usr/local/cweb-git/* .
sudo -u user cweave cweave.w >/dev/null
sudo -u user cweave ctangle.w >/dev/null
sudo -u user cweave common.w >/dev/null
sudo -u user tex cweave.tex # >/dev/null
sudo -u user tex ctangle.tex >/dev/null
sudo -u user tex common.tex >/dev/null
sudo -u user tex cwebman.tex >/dev/null
sudo -u user dvips cwebman.dvi /usr/local/share/cwebman.ps
sudo -u user dvips ctangle.dvi /usr/local/share/ctangle.ps
sudo -u user dvips common.dvi /usr/local/share/common.ps
sudo -u user dvips cweave.dvi /usr/local/share/cweave.ps
sudo -u user mkdir -p /usr/local/share/for_printing/
sudo -u user cweave cweave.w cweave.dpl >/dev/null
sudo -u user cweave ctangle.w ctangle.dpl >/dev/null
sudo -u user cweave common.w common.dpl >/dev/null
sudo -u user tex cweave.tex >/dev/null
sudo -u user tex ctangle.tex >/dev/null
sudo -u user tex common.tex >/dev/null
sudo -u user patch cwebman.tex cwebman-duplex.patch
sudo -u user tex cwebman.tex >/dev/null
sudo -u user dvips ctangle.dvi -o /usr/local/share/for_printing/ctangle_a4.ps
sudo -u user dvips common.dvi -o /usr/local/share/for_printing/common_a4.ps
sudo -u user dvips cweave.dvi -o /usr/local/share/for_printing/cweave_a4.ps
sudo -u user dvips cwebman.dvi -o /usr/local/share/for_printing/cwebman_a4.ps
cd -
rm -fr /tmp/cwebdoc/
