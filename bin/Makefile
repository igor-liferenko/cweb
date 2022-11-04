all:
	gcc -w -o ctangle ctangle.c common.c
	./ctangle ctie ctie-blank
	gcc -w -o ctie ctie.c
	./ctie -c tie.ch tie.w tie-stderr.ch tie-blank.ch >/dev/null
	./ctangle tie tie
	gcc -w -o tie tie.c
