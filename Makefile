all:
	ctangle common
	gcc -g -w -c common.c
	ctangle ctangle
	gcc -g -w -c ctangle.c
	gcc -g -o ctangle ctangle.o common.o
	ctangle cweave
	gcc -g -w -c cweave.c
	gcc -g -o cweave cweave.o common.o

prnt:
	@cw cweave.w cweave.dpl >/dev/null
	@cw ctangle.w ctangle.dpl >/dev/null
	@cw common.w common.dpl >/dev/null
	@tex cweave.tex >/dev/null
	@tex ctangle.tex >/dev/null
	@tex common.tex >/dev/null
	@patch -s -o cwebman-duplex.tex cwebman.tex cwebman-duplex.patch
	@tex cwebman-duplex.tex >/dev/null
	@dvips -u /dev/null -q ctangle.dvi
	@dvips -u /dev/null -q common.dvi
	@dvips -u /dev/null -q cweave.dvi
	@dvips -u /dev/null -q cwebman-duplex.dvi -o cwebman.ps

utf8:
	UNIWEB=/usr/local/uniweb/uniweb.w ./build.sh
