all:
	@make --no-print-directory -C bin
	tie -c comm-merged.ch common.w common-utf8.ch comm-utf8.ch comm-bhp.ch common-constants.ch comm-constants.ch >/dev/null
	bin/ctangle common comm-merged
	ctie -c cweav-merged.ch cweave.w common-utf8.ch cweav-utf8.ch common-constants.ch cweav-constants.ch >/dev/null
	bin/ctangle cweave cweav-merged
	gcc -w -o cweave cweave.c common.c
	ctie -c ctang-merged.ch ctangle.w common-utf8.ch ctang-utf8.ch ctang-bhp.ch common-constants.ch ctang-constants.ch >/dev/null
	bin/ctangle ctangle ctang-merged
	gcc -w -o ctangle ctangle.c common.c
	@test -z "$$(sed -n 's/\(#define max_sections [0-9]\+\).*/\1\\b/p' common.c | grep -L -f - cweave.c)"
	@test -z "$$(sed -n 's/\(#define buf_size [0-9]\+\).*/\1\\b/p' common.c | grep -L -f - cweave.c ctangle.c)"
	@test -z "$$(sed -n 's/\(#define longest_name [0-9]\+\).*/\1\\b/p' common.c|grep -L -f - cweave.c ctangle.c)"
	@test -z "$$(sed -n 's/\(#define max_bytes [0-9]\+\).*/\1\\b/p' common.c | grep -L -f - cweave.c ctangle.c)"
	@test -z "$$(sed -n 's/\(#define max_names [0-9]\+\).*/\1\\b/p' common.c | grep -L -f - cweave.c ctangle.c)"
	@test -z "$$(sed -n 's/\(#define hash_size [0-9]\+\).*/\1\\b/p' common.c | grep -L -f - cweave.c ctangle.c)"
