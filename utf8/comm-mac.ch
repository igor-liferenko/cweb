@x
@<Include files@>@/
@y
@<Include files@>@/
int tex_format=0;
int first_line=1;
@z

We must know before |copy_limbo| is started if %&-line is used. This is done with
setting |tex_format| on phase one and checking it right before phase two.
On phase two depending on |tex_format| we omit the first %&-line after outputting
%&lhplain\n" and "\input cwebmac-lh".
@x
  return(1);
@y
  if (first_line) {
    if (limit-buffer == 9 && strcmp(buffer, "%&lhplain") == 0) {
      tex_format=1;
      limit=buffer; /* empty the first input line */
    }
    first_line=0;
  }
  return(1);
@z
