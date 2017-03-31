all:
	ctangle common
	gcc -g -w -c common.c
	ctangle ctangle
	gcc -g -w -c ctangle.c
	gcc -g -o ctangle ctangle.o common.o
	ctangle cweave
	gcc -g -w -c cweave.c
	gcc -g -o cweave cweave.o common.o

scrn:
	@cweave cweave.w >/dev/null
	@cweave ctangle.w >/dev/null
	@cweave common.w >/dev/null
	@tex cweave.tex >/dev/null
	@tex ctangle.tex >/dev/null
	@tex common.tex >/dev/null
	@tex cwebman.tex >/dev/null
	@dvips cwebman.dvi -o cwebman.ps
	@dvips ctangle.dvi -o ctangle.ps
	@dvips common.dvi -o common.ps
	@dvips cweave.dvi -o cweave.ps
prnt:
	@cweave cweave.w cweave.dpl >/dev/null
	@cweave ctangle.w ctangle.dpl >/dev/null
	@cweave common.w common.dpl >/dev/null
	@tex cweave.tex >/dev/null
	@tex ctangle.tex >/dev/null
	@tex common.tex >/dev/null
	@patch -o cwebman-duplex.tex cwebman.tex cwebman-duplex.patch
	@tex cwebman-duplex.tex >/dev/null
	@dvips ctangle.dvi -o ctangle.ps
	@dvips common.dvi -o common.ps
	@dvips cweave.dvi -o cweave.ps
	@dvips cwebman-duplex.dvi -o cwebman.ps
