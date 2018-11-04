@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int first_line;
extern int custom_cweb_macros;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr='c';
@z

@x
@.Writing the output file...@>
@y
if (custom_cweb_macros) {
  out_ptr=out_buf; limit=buffer; *buffer='@@'; /* avoid outputting "c\n":
    we just |return| from |finish_line| --- see \S79 */
}
else
  tex_printf("\\input cwebma");
@.Writing the output file...@>
@z
