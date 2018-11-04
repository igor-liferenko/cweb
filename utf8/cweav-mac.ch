@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int ascii_only;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
@z

@x
@.Writing the output file...@>
@y
if (ascii_only)
  *out_ptr='c', tex_printf("\\input cwebma");
else
  *out_ptr='h', tex_printf("\\input cwebmac-l");
@.Writing the output file...@>
@z
