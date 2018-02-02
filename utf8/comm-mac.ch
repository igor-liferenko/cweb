@x
@<Include files@>@/
@y
@<Include files@>@/
int ascii_only=1;
int first_line=1;
@z

We must know before copy_limbo() is started if %&-line is used. This is done with
setting ascii_only flag on phase one and checking it right before phase two.
On phase two depending on ascii_only flag we omit the first %&-line after outputting
%&lhplain\n" and "\input cwebmac-lhplain".
@x
  return(1);
@y
  if (first_line) {
    if (limit-buffer == 9 && strcmp(buffer, "%&lhplain") == 0) {
      ascii_only=0;
      limit=buffer; /* empty the first input line */
    }
    first_line=0;
  }
  return(1);
@z
