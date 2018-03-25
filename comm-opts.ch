@x
show_banner=show_happiness=show_progress=1;
@y
@z

This is necessary to suppress all the output (disabling three options above is not enough):

@x
int wrap_up() {
  putchar('\n');
@y
int wrap_up() {
@z
