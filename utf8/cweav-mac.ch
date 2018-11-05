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
out_ptr=out_buf+1; out_line=1; active_file=tex_file;
*out_ptr='c'; tex_printf("\\input cwebma");
@y
out_line=1; active_file=tex_file;
if (!custom_cwebmac) {
  out_ptr=out_buf+1;
  *out_ptr='c'; tex_printf("\\input cwebma");
}
else
  out_ptr=out_buf;
@z
