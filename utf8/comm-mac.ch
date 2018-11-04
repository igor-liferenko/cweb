@x
@<Include files@>@/
@y
@<Include files@>@/
int ascii_only=1;
@z

@x
  return(1);
@y
  if (wlimit-wbuffer != limit-buffer) ascii_only=0;
  return(1);
@z
