@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int custom_cwebmac;
@z

@x
out_ptr=out_buf+1; out_line=1;
*out_ptr='c';
@y
out_line=1;
if (!custom_cwebmac) {
  out_ptr=out_buf+1;
  *out_ptr='c';
}
else {
  out_ptr=out_buf;
  *buffer='x';
}
@z


@x
tex_printf("\\input cwebma");
@y
if (!custom_cwebmac) tex_printf("\\input cwebma");
@z
