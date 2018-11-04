@x
@<Include files@>@/
@y
@<Include files@>@/
int custom_cweb_macros=0;
int first_line=1;
@z

We must know if '\input cwebmac...' is used, before |copy_limbo| is started in phase two.
This is done by setting |custom_cweb_macros| on phase one and checking it in cweav-mac.ch
before phase two.
@x
  return(1);
@y
  if (!changing && first_line) {
    if (limit-buffer > 14 && strncmp(buffer, "\\input cwebmac", 14) == 0)
      custom_cweb_macros=1;
    first_line=0;
  }
  return(1);
@z
