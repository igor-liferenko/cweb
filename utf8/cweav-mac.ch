@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int first_line;
extern int tex_format;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr='c';
@z

@x
@.Writing the output file...@>
@y
if (tex_format==1) {
  tex_printf("%%&lhplain\n"); out_line++;
  tex_printf("\\input cwebmac-lh");
  out_ptr=out_buf; limit=buffer; *buffer='@@'; /* make |finish_line| not to print
    newline after '\input cwebmac-lh' for it to take the place of the emptied
    first input line */
  first_line=1; /* make the code which empties first line in comm-mac.ch work */
}
else tex_printf("\\input cwebma");
@.Writing the output file...@>
@z
