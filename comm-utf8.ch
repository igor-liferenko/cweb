@x
@<Include files@>@/
@y
#include <wchar.h>
#include <limits.h>
@<Include files@>@/
wchar_t xchr[256];
@z

@x
@c
void
common_init()
{
@y
@c
void
common_init()
{
  for (int i = 128; i < 256; i++) xchr[i] = L'\177';
  #include "mapping"
@z

@x
@d long_buf_size (buf_size+longest_name) /* for \.{CWEAVE} */
@y
@d long_buf_size (buf_size*MB_LEN_MAX+longest_name*MB_LEN_MAX) /* for \.{CWEAVE} */
@z

@x
char *buffer_end=buffer+buf_size-2; /* end of |buffer| */
@y
char *buffer_end=buffer+buf_size*MB_LEN_MAX-2; /* end of |buffer| */
@z

@x
int input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
{
  register int  c=EOF; /* character read; initialized so some compilers won't complain */
  register char *k;  /* where next character goes */
  if (feof(fp)) return(0);  /* we have hit end-of-file */
  limit = k = buffer;  /* beginning of buffer */
  while (k<=buffer_end && (c=getc(fp)) != EOF && c!='\n')
    if ((*(k++) = c) != ' ') limit = k;
  if (k>buffer_end)
    if ((c=getc(fp))!=EOF && c!='\n') {
      ungetc(c,fp); loc=buffer; err_print("! Input line too long");
@.Input line too long@>
  }
  if (c==EOF && limit==buffer) return(0);  /* there was nothing after
    the last newline */
@y
size_t wcsntombs(char *mbs, wchar_t *s, size_t len)
{
  size_t n = 0;
  size_t l = 0;
  char mb[MB_CUR_MAX]; /* |wctomb| does not count number of bytes
    when first argument is |NULL| ---~this dummy array is used to work around this */
  while (l<len) {
    n+=wctomb(mbs==NULL?mb:mbs+n, *(s+l));
    l++;
  }
  return n;
}

wchar_t wbuffer[buf_size + longest_name];
wchar_t *wbuffer_end = wbuffer + buf_size - 2;
wchar_t *wlimit = wbuffer;

/* use |getwc| to ensure that input is valid UTF-8 */

int input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
{
  register wchar_t c; /* character read */
  register wchar_t *k;  /* where next character goes */
  if (feof(fp)) return(0);  /* we have hit end-of-file */
  wlimit = k = wbuffer;  /* beginning of buffer */
  while (k<=wbuffer_end && (c=getwc(fp)) != WEOF && c!=L'\n')
    if ((*(k++) = c) != L' ') wlimit = k;

  if (ferror(fp)) {
    printf("\n! getwc: %m");
    fatal("","");
  }

  if (buffer + wcsntombs(NULL, wbuffer, wlimit-wbuffer) > buffer_end) {
    printf("\n! multibyte buffer too small"); fatal("","");
  }

  limit = buffer + wcsntombs(buffer, wbuffer, wlimit-wbuffer);
  if (k>wbuffer_end)
    if ((c=getwc(fp))!=WEOF && c!=L'\n') {
      ungetwc(c,fp); loc=buffer; err_print("! Input line too long");
@.Input line too long@>
  }
  if (c==WEOF && wlimit==wbuffer) return(0);  /* there was nothing after
    the last newline */
@z

@x
char change_buffer[buf_size]; /* next line of |change_file| */
@y
char change_buffer[buf_size*MB_LEN_MAX]; /* next line of |change_file| */
@z
