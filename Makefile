# type 'make' and then 'gdb cweave'
# to test compatibility with original cweb, type 'make test' - if everything OK, then no output
# is produced

all:
	@/usr/local/bin/ctangle -bhp common
	@clang -g -w -c common.c
	@/usr/local/bin/ctangle -bhp ctangle
	@clang -g -w -c ctangle.c
	@clang -g -o ctangle ctangle.o common.o
	@/usr/local/bin/ctangle -bhp cweave
	@clang -g -w -c cweave.c
	@clang -g -o cweave cweave.o common.o

test: all
	@./test

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
