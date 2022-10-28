all:
	ctie -c comm-merged.ch common.w common-utf8.ch comm-utf8.ch comm-bhp.ch >/dev/null
	ctangle common comm-merged
	ctie -c cweav-merged.ch cweave.w common-utf8.ch cweav-utf8.ch cweav-sort.ch cweave+c.ch cweave+d.ch cweave+g.ch cweave+y.ch cweave+z.ch >/dev/null # TODO: check what is +g via dvidiff
	ctangle cweave cweav-merged
	gcc -o cweave cweave.c common.c
	ctie -c ctang-merged.ch ctangle.w common-utf8.ch ctang-utf8.ch ctang-bhp.ch ctang-pre.ch ctangle+u.ch >/dev/null
	ctangle ctangle ctang-merged
	gcc -o ctangle ctangle.c common.c
