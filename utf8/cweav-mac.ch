@x
@<Global variables@>@/
@y
@<Global variables@>@/
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
if (ascii_only==0) tex_printf("%%&lhplain\n");
tex_printf("\\input cwebma");
if (ascii_only==0) *out_ptr='r';
@.Writing the output file...@>
@z
