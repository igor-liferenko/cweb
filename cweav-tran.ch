@x
@<Global variables@>@/
@y
@<Global variables@>@/
int gobble;
@z

@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr='c';
@z

@x
out_str(s) /* output characters from |s| to end of string */
char *s;
{
@y
out_str(s) /* output characters from |s| to end of string */
char *s;
{
  if (gobble) return;
@z

@x
out_section(n)
sixteen_bits n;
{
@y
out_section(n)
sixteen_bits n;
{
  if (gobble) return;
@z

@x
    out_section(cur_xref->num-def_flag);
@y
    out_str(tex_file_name);
@z

@x
@.Writing the output file...@>
@y
out_ptr=out_buf; limit=buffer; *buffer='@@'; /* the same trick as in cweav-mac.ch */
@.Writing the output file...@>
@z

@x
finish_line(); flush_buffer(out_buf,0,0); /* insert a blank line, it looks nice */
@y
finish_line();
@z

@x
  @<Output the code for the beginning of a new section@>;
@y
  gobble=1;
  @<Output the code for the beginning of a new section@>;
  gobble=0;
@z

@x
  finish_C(1);
@y
  finish_C(1);
  fflush(tex_file);
  tex_file=fopen("/dev/null","w");
  active_file=tex_file;
@z

FIXME: remove "finish_line();" ? (see what finish_line does)
@x
out_str("\\fi"); finish_line();
@.\\fi@>
flush_buffer(out_buf,0,0); /* insert a blank line, it looks nice */
@y
finish_line();
@z

@x
  out_str("\\end");
@.\\end@>
  finish_line();
@y
@z
