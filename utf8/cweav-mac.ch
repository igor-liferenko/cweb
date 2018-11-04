@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int first_line;
extern int custom_cwebmac;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr='c';
@z

@x
@.Writing the output file...@>
@y
if (!custom_cwebmac)
  tex_printf("\\input cwebma");
else
  out_ptr=out_buf, *buffer='x'; /* avoid outputting "c\n":
    we just |return| from |finish_line| --- see \S79 */
@.Writing the output file...@>
@z
