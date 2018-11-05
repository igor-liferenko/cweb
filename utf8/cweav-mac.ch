@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int custom_cwebmac;
@z

@x
tex_printf("\\input cwebma");
@y
if (!custom_cwebmac)
  tex_printf("\\input cwebma");
else {
  out_ptr=out_buf; *buffer='x'; /* to |return| from |finish_line| --- see \S79 and \S80 */
}
@z
