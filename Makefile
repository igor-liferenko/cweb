all:
	tie -c comm-merged.ch common.w comm-utf8.ch comm-env.ch comm-bhp.ch >/dev/null
	/bin/ctangle common comm-merged
	gcc -g -Og -w -c common.c
	tie -m comm-utf8.h common.h comm-utf8.hch >/dev/null
	tie -c cweav-merged.ch cweave.w cweav-utf8.ch cweave+c.ch cweave+d.ch cweave+g.ch cweave+y.ch cweave+z.ch >/dev/null # TODO: check what is +g via pdfdiff
	/bin/ctangle cweave cweav-merged
	gcc -g -Og -w -c cweave.c
	gcc -g -Og -o cweave cweave.o common.o
	tie -c ctang-merged.ch ctangle.w ctang-utf8.ch ctang-bhp.ch >/dev/null
	/bin/ctangle ctangle ctang-merged
	gcc -g -Og -w -c ctangle.c
	gcc -g -Og -o ctangle ctangle.o common.o
	cp cweave ctangle /usr/local/bin/

print:
# NOTE: explicit path is used to use original formatting (that's why --duplex is not used)
#       (cwebman is duplex by default)
	@/usr/local/bin/cweave cweave
	@/usr/local/bin/cweave ctangle
	@/usr/local/bin/cweave common
	@tex cweave >/dev/null
	@tex ctangle >/dev/null
	@tex common >/dev/null
	@tex cwebman >/dev/null
