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
  if (!changing && first_line) {
    if (limit-buffer == 9 && strncmp(buffer, "%&lhplain", 9) == 0) {
      if (phase==1) tex_format=1;
      if (phase==2) limit=buffer; /* empty the input line */
    }
    first_line=0;
  }
  return(1);
@z
