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
