@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int custom_cwebmac;
@z

@x
finish_line() /* do this at the end of a line */
{
@y
finish_line() /* do this at the end of a line */
{
  if (custom_cwebmac) {
    custom_cwebmac=0;
    return;
  }
@z

@x
tex_printf("\\input cwebma");
@y
if (!custom_cwebmac)
  tex_printf("\\input cwebma");
else
  out_ptr=out_buf;
@z
