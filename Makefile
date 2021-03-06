all:
	tie -c comm-merged.ch common.w common-utf8.ch comm-utf8.ch comm-env.ch comm-bhp.ch >/dev/null
	/bin/ctangle common comm-merged
	gcc -w -c common.c
	ctie -c cweav-merged.ch cweave.w common-utf8.ch cweav-utf8.ch cweav-sort.ch cweave+c.ch cweave+d.ch cweave+g.ch cweave+y.ch cweave+z.ch >/dev/null # TODO: check what is +g via dvidiff
	/bin/ctangle cweave cweav-merged
	gcc -w -c cweave.c
	gcc -o cweave cweave.o common.o
	ctie -c ctang-merged.ch ctangle.w common-utf8.ch ctang-utf8.ch ctang-bhp.ch >/dev/null
	/bin/ctangle ctangle ctang-merged
	gcc -w -c ctangle.c
	gcc -o ctangle ctangle.o common.o
	cp cweave ctangle /usr/local/bin/

print:
# NOTE: use original cweave (not wrapper)
	@/usr/local/bin/cweave cweave
	@/usr/local/bin/cweave ctangle
	@/usr/local/bin/cweave common
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
