@x
@<Include files@>@/
@y
@<Include files@>@/
int custom_cwebmac=0;
int first_line=1;
@z

@x
  return(1);
@y
  if (!changing && first_line) {
    if (limit-buffer > 14 && strncmp(buffer, "\\input cwebmac", 14) == 0)
      custom_cwebmac=1;
    first_line=0;
  }
  return(1);
@z
