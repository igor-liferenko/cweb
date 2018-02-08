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
  save_position;
  @<Translate the \TEX/ part of the current section@>;
  @<Translate the definition part of the current section@>;
  @<Translate the \CEE/ part of the current section@>;
  @<Show cross-references to this section@>;
  @<Output the code for the end of a section@>;
@y
  gobble=1; @<Output the code for the beginning of a new section@>; gobble=0;
  save_position;
  @<Translate the \TEX/ part of the current section@>;
  @<Translate the definition part of the current section@>;
  @<Translate the \CEE/ part of the current section@>;
  finish_line();
@z

@x
  out_str("\\end");
@.\\end@>
  finish_line();
@y
@z
