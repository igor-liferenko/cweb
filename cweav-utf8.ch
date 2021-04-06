@x
@h
@y
extern unsigned char xord[];
extern wchar_t xchr[];
@h
@z

@x
#include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
@y
#include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
#include <wctype.h>
@z
 
@x
@d c_line_write(c) fflush(active_file),fwrite(out_buf+1,sizeof(char),c,active_file)
@y
@d c_line_write(c) fflush(active_file); for (int i = 0; i < c; i++)
  fprintf(active_file, "%lc",xchr[(eight_bits) *(out_buf+1+i)])
@z

@x
      if (xislower(*p)) { /* not entirely uppercase */
@y
      if (iswlower(xchr[(eight_bits)*p])) { /* not entirely uppercase */
@z

@x
      if (xisupper(c)) c=tolower(c);
@y
      if (iswupper(xchr[(eight_bits) c])) c=xord[towlower(xchr[(eight_bits) c])];
@z

@x
      if (xisupper(c)) c=tolower(c);
@y
      if (iswupper(xchr[(eight_bits) c])) c=xord[towlower(xchr[(eight_bits) c])];
@z

@x
        if (xislower(*j)) goto lowcase;
@y
        if (iswlower(xchr[(eight_bits)*j])) goto lowcase;
@z
