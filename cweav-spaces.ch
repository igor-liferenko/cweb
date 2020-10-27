Spaces in the end of a line are never needed, but in the beginning
of a line they may be important (e.g., for verbatim listing).
So, we don't copy spaces or tab marks into the end of a line. This
makes the test for empty lines in |finish_line| work.

@x
finish_line() /* do this at the end of a line */
{
@y
finish_line() /* do this at the end of a line */
{
  while (out_ptr > out_buf) {
    if (!xisspace(*out_ptr)) break;
    out_ptr--;
  }
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
