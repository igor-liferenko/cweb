# type 'make' and then 'gdb cweave'
# to test compatibility with original cweb, type 'make test' - if everything OK, then no output
# is produced
all:
	@./build
	@/var/local/bin/ctangle-git common
	@clang -g -w -c common.c
	@/var/local/bin/ctangle-git ctangle
	@clang -g -w -c ctangle.c
	@clang -g -o ctangle ctangle.o common.o
	@/var/local/bin/ctangle-git cweave
	@clang -g -w -c cweave.c
	@clang -g -o cweave cweave.o common.o

test: all
	@./test

print:
	@./build
	@/var/local/bin/cweave-git cweave cweave >/dev/null
	@/var/local/bin/cweave-git ctangle ctangle >/dev/null
	@/var/local/bin/cweave-git common common >/dev/null
	@/usr/bin/tex cweave >/dev/null
	@/usr/bin/tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
	@touch -d '-5 seconds' cweave.tex ctangle.tex common.tex # for 'test' in prt.fn
	@echo everything is ready - use \"prt ctangle\", \"prt common\", \"prt cweave\" and \"prt cwebman\"

view:
	@./build
	@/var/local/bin/cweave-git cweave >/dev/null
	@/var/local/bin/cweave-git ctangle >/dev/null
	@/var/local/bin/cweave-git common >/dev/null
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@patch -s cwebman.tex cwebman-non-duplex.patch
	@tex cwebman >/dev/null
	@patch -s -R cwebman.tex cwebman-non-duplex.patch
	@echo everything is ready - use \"dvi ctangle\", \"dvi common\", \"dvi cweave\" and \"dvi cwebman\"
