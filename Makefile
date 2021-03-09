all:
	tie -c comm-merged.ch common.w comm-env.ch comm-bhp.ch >/dev/null
	/bin/ctangle common comm-merged
	gcc -g -Og -w -c common.c
	tie -c cweav-merged.ch cweave.w cweave+c.ch cweave+d.ch cweave+g.ch cweave+y.ch cweave+z.ch >/dev/null # TODO: check what is +g via dvidiff
	/bin/ctangle cweave cweav-merged
	gcc -g -Og -w -c cweave.c
	gcc -g -Og -o cweave cweave.o common.o
	tie -c ctang-merged.ch ctangle.w ctang-bhp.ch >/dev/null
	/bin/ctangle ctangle ctang-merged
	gcc -g -Og -w -c ctangle.c
	gcc -g -Og -o ctangle ctangle.o common.o

print:
# NOTE: use original cweave (not wrapper)
	@/usr/local/bin/cweave cweave
	@/usr/local/bin/cweave ctangle
	@/usr/local/bin/cweave common
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
