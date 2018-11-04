@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int custom_cwebmac;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
if (!custom_cwebmac) {
  *out_ptr='c'; tex_printf("\\input cwebma");
}
else {
  out_ptr=out_buf; *buffer='x'; /* avoid outputting newline:
    we just |return| from |finish_line| --- see \S79 */
}
@z
