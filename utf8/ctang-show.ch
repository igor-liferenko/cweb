@x
@<Global variables@>@/
@y
@<Global variables@>@/
boolean starred_shown=0;
@z

@x
      if(show_progress)
        printf("\nWriting the output file (%s):",C_file_name);
@y
      if(show_progress) {
        if (starred_shown) printf("\n");
        printf("Writing the output file (%s):",C_file_name);
      }
@z

@x
        printf("\nWriting the output files:");
@y
        if (starred_shown) printf("\n");
        printf("Writing the output files:");
@z

@x
    if(show_happiness) printf("\nDone.");
@y
    if (show_progress) printf("\n");
    if(show_happiness) printf("Done.");
@z

@x
  if (*(loc-1)=='*' && show_progress) { /* starred section */
@y
  if (*(loc-1)=='*' && show_progress) { /* starred section */
    starred_shown=1;
@z

@x
  printf("\nMemory usage statistics:\n");
@y
  printf("Memory usage statistics:\n");
@z
