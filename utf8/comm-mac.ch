@x
@<Include files@>@/
@y
@<Include files@>@/
int custom_cweb_macros=0;
int first_line=1;
@z

We must know if '\input ...' is used, before |copy_limbo| is started in phase two. This is done with
setting |custom_cweb_macros| on phase one and checking it in cweav-mac.ch right before phase two.
@x
  return(1);
@y
  if (!changing && first_line) {
    if (limit-buffer > 7 && strncmp(buffer, "\\input ", 7) == 0)
      custom_cweb_macros=1;
    first_line=0;
  }
  return(1);
@z
