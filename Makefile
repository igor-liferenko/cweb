all: check
	@make --no-print-directory -C bin
	tie -c comm-merged.ch common.w common-utf8.ch comm-utf8.ch comm-bhp.ch >/dev/null
	bin/ctangle common comm-merged
	ctie -c cweav-merged.ch cweave.w common-utf8.ch cweav-utf8.ch cweav-va.ch cweave+c.ch cweave+d.ch cweave+g.ch cweave+y.ch cweave+z.ch >/dev/null
	bin/ctangle cweave cweav-merged
	gcc -w -o cweave cweave.c common.c
	ctie -c ctang-merged.ch ctangle.w common-utf8.ch ctang-utf8.ch ctang-bhp.ch ctang-pre.ch ctangle+u.ch >/dev/null
	bin/ctangle ctangle ctang-merged
	gcc -w -o ctangle ctangle.c common.c

check:
	@test -z "$$(sed -n 's/\(@d max_file_name_length [0-9]\+\).*/\1\\b/p' common.w | grep -L -f - common.h)"
	@test -z "$$(sed -n 's/\(@d max_sections [0-9]\+\).*/\1\\b/p' common.w | grep -L -f - cweave.w)"
	@test -z "$$(sed -n 's/\(@d buf_size [0-9]\+\).*/\1\\b/p' common.w | grep -L -f - cweave.w ctangle.w)"
	@test -z "$$(sed -n 's/\(@d longest_name [0-9]\+\).*/\1\\b/p' common.w|grep -L -f - cweave.w ctangle.w)"
	@test -z "$$(sed -n 's/\(@d max_bytes [0-9]\+\).*/\1\\b/p' common.w | grep -L -f - cweave.w ctangle.w)"
	@test -z "$$(sed -n 's/\(@d max_names [0-9]\+\).*/\1\\b/p' common.w | grep -L -f - cweave.w ctangle.w)"
	@test -z "$$(sed -n 's/\(@d hash_size [0-9]\+\).*/\1\\b/p' common.w | grep -L -f - cweave.w ctangle.w)"
