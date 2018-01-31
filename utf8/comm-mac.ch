@x
@<Include files@>@/
@y
@<Include files@>@/
int ascii_only=1;
@z

@x
  return(1);
@y
  if (wlimit-wbuffer == 9 && wcscmp(wbuffer, L"%&lhplain") == 0) ascii_only=0;
  return(1);
@z
