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
    return; /* avoid printing blank line (by |flush_buffer(out_buf,0,0);| in |finish_line|)
               in the beginnig of output file (|finish_line| is called the first in |copy_limbo|,
               which is called in the beginning of phase two) */
  }
@z

@x
tex_printf("\\input cwebma");
@y
if (!custom_cwebmac)
  tex_printf("\\input cwebma");
else
  out_ptr=out_buf; /* reinitialize in non-tricky way */
@z
