all:
	@gcc -w -o ctangle ctangle.c common.c
	@./ctangle ctie
	@gcc -w -o ctie ctie.c
	@./ctangle tie tie-stderr
	@gcc -w -o tie tie.c
