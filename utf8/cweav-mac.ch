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
  tex_printf("\\input cwebmar");
  out_ptr=out_buf;
  limit=buffer;
  *buffer='x'; /* make finish_line() skip first line */
  first_line=1;
}
else tex_printf("\\input cwebma");
@.Writing the output file...@>
@z

NOTE: if you need to use lhplain format and english names in cwebmac.tex,
use this algorithm (but you will have to use '\input cwebmac' or '\input cwebmar'
explicitly every time when you use %&lhplain):
after %&lhplain output code which transforms font cmtex10 (like in lhplain.ini)
and overrides '\input cwebmar' to use this tansformation code, and '\input cwebmac'
and '\input cwebmar' must restore original '\input' (like in cwebtest/tcb.tex)
