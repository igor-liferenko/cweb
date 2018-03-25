remove unneeded blank line here:
--------------
ctangle -b -p cweave

Done.
(No errors were found.)
--------------
and here:
----------------
ctangle -b -h -p cweave

-----------------

@x
int wrap_up() {
  putchar('\n');
@y
int wrap_up() {
  if (show_happiness) putchar('\n');
@z
