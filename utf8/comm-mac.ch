@x
@<Include files@>@/
@y
@<Include files@>@/
int ascii_only=1;
int first_line=1; /* set to 1 at the beginning of phase two also */
@z

We must know if %& is used before copy_limbo() is started. This is done with
ascii_only flag on phase one. On phase two we omit the %& line after outputting
it and '\input cwebma...' manually.
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
