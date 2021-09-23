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

doc:
# NOTE: use original cweave - not wrapper (i.e., without formatting options)
	/usr/local/bin/cweave cweave
	tex cweave >/dev/null
	/usr/local/bin/cweave ctangle
	tex ctangle >/dev/null
	/usr/local/bin/cweave common
	tex common >/dev/null
	tex cwebman >/dev/null
