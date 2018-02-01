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
%&lhplain\n" and "\input cwebmar".
@x
  return(1);
@y
  if (first_line) {
    if (wlimit-wbuffer == 9 && wcscmp(wbuffer, L"%&lhplain") == 0) ascii_only=0;
    first_line=0;
    limit=buffer; /* empty the first input line; it makes no difference on phase one,
      because limbo is skipped in it anyway */
  }
  return(1);
@z
