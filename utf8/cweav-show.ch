@x
@<Global variables@>@/
@y
@<Global variables@>@/
boolean starred_shown=0;
@z

@x
  if (*(loc-1)=='*' && show_progress) {
@y
  if (*(loc-1)=='*' && show_progress) {
    starred_shown=1;
@z

@x
reset_input(); if (show_progress) printf("\nWriting the output file...");
@y
reset_input();
if (show_progress) {
  if (starred_shown) printf("\n");
  printf("Writing the output file...");
}
@z

@x
  if (show_progress)
  printf("*%d",section_count); update_terminal; /* print a progress report */
@y
  if (show_progress)
  printf("*%d",section_count); update_terminal; /* print a progress report */
@z

@x
if (show_happiness) printf("\nDone.");
@y
if (show_progress) printf("\n");
if (show_happiness) printf("Done.");
@z
