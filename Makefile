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
	@cweave cweave.w cweave.dpl >/dev/null
	@cweave ctangle.w ctangle.dpl >/dev/null
	@cweave common.w common.dpl >/dev/null
	@tex cweave.tex >/dev/null
	@tex ctangle.tex >/dev/null
	@tex common.tex >/dev/null
	@tex cwebman.tex >/dev/null
	@echo everything is ready - use \"prt ctangle\", \"prt common\", \"prt cweave\" and \"prt cwebman\"
