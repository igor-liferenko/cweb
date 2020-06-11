@x
@<Include files@>@/
@y
#include <wchar.h>
#include <locale.h>
#include <limits.h>
@<Include files@>@/
wchar_t xchr[256];
int mbsntowcslen(char *mbs, int len)
{
  int n = 0;
  int l = 0;
  int r;
  while (l<len) {
    if ((r=mblen(mbs+l, len-l))==-1) break;
    l+=r;
    n++;
  }
  return n;
}
@z

@x
common_init()
{
@y
common_init()
{
@i /home/user/tex/mapping
  setlocale(LC_CTYPE, "C.UTF-8");
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
  while (k<=buffer_end && (c=getc(fp)) != EOF && c!='\n')
    if ((*(k++) = c) != ' ') limit = k;
  if (k>buffer_end)
@y
  while (mbsntowcslen(buffer,k-buffer)<buf_size-1 && (c=getc(fp)) != EOF && c!='\n')
    if ((*(k++) = c) != ' ') limit = k;
  if (mbsntowcslen(buffer,k-buffer)>=buf_size-1)
@z

@x
char change_buffer[buf_size]; /* next line of |change_file| */
@y
char change_buffer[buf_size*MB_LEN_MAX]; /* next line of |change_file| */
@z
