@x
@<Global variables@>@/
@y
@<Global variables@>@/
extern int first_line;
extern int ascii_only;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr='c';
@z

@x
@.Writing the output file...@>
@y
if (ascii_only==0) {
  tex_printf("%%&lhplain\n");
  tex_printf("\\input cwebmac-lhplain");
  out_ptr=out_buf;
  limit=buffer;
  *buffer='x'; /* make finish_line() not to print newline after '\input cwebmar' for
    it to take the place of the emptied first input line */
  first_line=1; /* make the code which empties first line in input_ln() work */
}
else tex_printf("\\input cwebma");
@.Writing the output file...@>
@z
