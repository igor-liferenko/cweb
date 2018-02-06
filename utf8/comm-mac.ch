TODO: what will be if we use fopen again without fclose after reading a line?
will it have effect of resetting file? If we use a different filehandle, will
the previous hold ins position?
(this concerns reset_input in phase two - it opens the already opened file without
closing it first)

@x
@<Include files@>@/
@y
@<Include files@>@/
int tex_format=0;
int first_line=1;
@z

We must know if %&-line is used, before |copy_limbo| is started in phase two. This is done with
setting |tex_format| on phase one and checking it in cweav-mac.ch right before phase two.
@x
  return(1);
@y
  if (first_line) {
    if (limit-buffer == 9 && strncmp(buffer, "%&lhplain", 9) == 0) {
      tex_format=1;
      limit=buffer; /* empty the first input line */
    }
    first_line=0;
  }
  return(1);
@z
