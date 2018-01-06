all:
	ctangle common
	gcc -g -w -c common.c
	ctangle ctangle
	gcc -g -w -c ctangle.c
	gcc -g -o ctangle ctangle.o common.o
	ctangle cweave
	gcc -g -w -c cweave.c
	gcc -g -o cweave cweave.o common.o

print:
	@cweave cweave cweave >/dev/null
	@touch -d '-1 seconds' cweave.tex
	@cweave ctangle ctangle >/dev/null
	@touch -d '-1 seconds' ctangle.tex
	@cweave common common >/dev/null
	@touch -d '-1 seconds' common.tex
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
	@echo everything is ready - use \"prt ctangle\", \"prt common\", \"prt cweave\" and \"prt cwebman\"
