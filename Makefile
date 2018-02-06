all:
	@/bin/ctangle -b -h -p common|sed /^$$/d
	@clang -g -w -c common.c
	@/bin/ctangle -b -h -p ctangle|sed /^$$/d
	@clang -g -w -c ctangle.c
	@clang -g -o ctangle ctangle.o common.o
	@/bin/ctangle -b -h -p cweave|sed /^$$/d
	@clang -g -w -c cweave.c
	@clang -g -o cweave cweave.o common.o

test: all
	@./test

print:
	@cweave cweave cweave >/dev/null
	@cweave ctangle ctangle >/dev/null
	@cweave common common >/dev/null
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
	@touch -d '-5 seconds' cweave.tex ctangle.tex common.tex # for 'test' in prt.fn
	@echo everything is ready - use \"prt ctangle\", \"prt common\", \"prt cweave\" and \"prt cwebman\"

view:
	@cweave cweave >/dev/null
	@cweave ctangle >/dev/null
	@cweave common >/dev/null
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@patch -s cwebman.tex cwebman-non-duplex.patch
	@tex cwebman >/dev/null
	@patch -s -R cwebman.tex cwebman-non-duplex.patch
	@echo everything is ready - use \"dvi ctangle\", \"dvi common\", \"dvi cweave\" and \"dvi cwebman\"
