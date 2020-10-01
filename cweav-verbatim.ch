@x
finish_line() /* do this at the end of a line */
{
@y
finish_line() /* do this at the end of a line */
{
  char *p = out_buf+1;
  while (p <= out_ptr) {
    if (!xisspace(*p)) break;
    p++;
  }
  if (p > out_ptr) out_ptr = out_buf;
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
