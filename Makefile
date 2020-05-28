all:
	tie -c comm-merged.ch common.w comm-utf8.ch comm-file.ch comm-exten.ch comm-show.ch >/dev/null || exit
	/usr/bin/ctangle -bhp common.w comm-merged.ch || exit
	clang -g -w -c -DCWEBINPUTS=\"/home/user/cweb\" common.c || exit
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

print:
	@/usr/local/bin/cweave cweave cweave >/dev/null
	@/usr/local/bin/cweave ctangle ctangle >/dev/null
	@/usr/local/bin/cweave common common >/dev/null
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
	@touch -d '-5 seconds' cweave.tex ctangle.tex common.tex # for 'test' in prt.fn
	@echo everything is ready - use \"prt ctangle\", \"prt common\", \"prt cweave\" and \"prt cwebman\"

view:
	@/usr/local/bin/cweave cweave >/dev/null
	@/usr/local/bin/cweave ctangle >/dev/null
	@/usr/local/bin/cweave common >/dev/null
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@patch -s cwebman.tex cwebman-non-duplex.patch
	@tex cwebman >/dev/null
	@patch -s -R cwebman.tex cwebman-non-duplex.patch
	@echo everything is ready - use \"dvi ctangle\", \"dvi common\", \"dvi cweave\" and \"dvi cwebman\"
