@x
finish_line() /* do this at the end of a line */
{
@y
finish_line() /* do this at the end of a line */
{
  int all_spaces = 1;
  for (char *p = out_buf+1; p <= out_ptr; p++)
    if (!xisspace(*p)) all_spaces = 0;
  if (all_spaces) out_ptr = out_buf;
@z

@x
We don't copy spaces or tab marks into the beginning of a line. This
makes the test for empty lines in |finish_line| work.
@y
@z

@x
      if (out_ptr==out_buf+1 && (xisspace(c))) out_ptr--;
@y
@z
