@x
@<Include files@>@/
@y
#include <wchar.h>
#include <limits.h>
@<Include files@>@/
#include <errno.h>
#include "uni.h"
char *encTeX[256];
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
  /* this mapping table mirrors encTeX definitions */
  encTeX[0x80] = "А";
  encTeX[0xa0] = "а";
  encTeX[0x81] = "Б";
  encTeX[0xa1] = "б";
  encTeX[0x82] = "В";
  encTeX[0xa2] = "в";
  encTeX[0x83] = "Г";
  encTeX[0xa3] = "г";
  encTeX[0x84] = "Д";
  encTeX[0xa4] = "д";
  encTeX[0x85] = "Е";
  encTeX[0xa5] = "е";
  encTeX[0xf0] = "Ё";
  encTeX[0xf1] = "ё";
  encTeX[0x86] = "Ж";
  encTeX[0xa6] = "ж";
  encTeX[0x87] = "З";
  encTeX[0xa7] = "з";
  encTeX[0x88] = "И";
  encTeX[0xa8] = "и";
  encTeX[0x89] = "Й";
  encTeX[0xa9] = "й";
  encTeX[0x8a] = "К";
  encTeX[0xaa] = "к";
  encTeX[0x8b] = "Л";
  encTeX[0xab] = "л";
  encTeX[0x8c] = "М";
  encTeX[0xac] = "м";
  encTeX[0x8d] = "Н";
  encTeX[0xad] = "н";
  encTeX[0x8e] = "О";
  encTeX[0xae] = "о";
  encTeX[0x8f] = "П";
  encTeX[0xaf] = "п";
  encTeX[0x90] = "Р";
  encTeX[0xe0] = "р";
  encTeX[0x91] = "С";
  encTeX[0xe1] = "с";
  encTeX[0x92] = "Т";
  encTeX[0xe2] = "т";
  encTeX[0x93] = "У";
  encTeX[0xe3] = "у";
  encTeX[0x94] = "Ф";
  encTeX[0xe4] = "ф";
  encTeX[0x95] = "Х";
  encTeX[0xe5] = "х";
  encTeX[0x96] = "Ц";
  encTeX[0xe6] = "ц";
  encTeX[0x97] = "Ч";
  encTeX[0xe7] = "ч";
  encTeX[0x98] = "Ш";
  encTeX[0xe8] = "ш";
  encTeX[0x99] = "Щ";
  encTeX[0xe9] = "щ";
  encTeX[0x9a] = "Ъ";
  encTeX[0xea] = "ъ";
  encTeX[0x9b] = "Ы";
  encTeX[0xeb] = "ы";
  encTeX[0x9c] = "Ь";
  encTeX[0xec] = "ь";
  encTeX[0x9d] = "Э";
  encTeX[0xed] = "э";
  encTeX[0x9e] = "Ю";
  encTeX[0xee] = "ю";
  encTeX[0x9f] = "Я";
  encTeX[0xef] = "я";
  encTeX[0xfc] = "№";
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
size_t wcsntomos(wchar_t *s, size_t len, char *mbs)
{
  size_t n = 0;
  size_t l = 0;
  while (l<len) {
    n+=wctomo(*(s+l), mbs==NULL?mbs:mbs+n);
    l++;
  }
  return n;
}

wchar_t wbuffer[buf_size + longest_name];
wchar_t *wbuffer_end = wbuffer + buf_size - 2;
wchar_t *wlimit = wbuffer;

int input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
{
  register wint_t c; /* character read */
  register wchar_t *k;  /* where next character goes */
  if (feof(fp)) return(0);  /* we have hit end-of-file */
  wlimit = k = wbuffer;  /* beginning of buffer */
  while (k<=wbuffer_end && (c=getwc(fp)) != WEOF && c!=L'\n')
    if ((*(k++) = c) != L' ') wlimit = k;

  if (ferror(fp)) { printf("\n! getwc: %s", strerror(errno)); fatal("",""); }

  if (buffer + wcsntomos(wbuffer, wlimit-wbuffer, NULL) > buffer_end) {
    printf("\n! multibyte buffer too small"); fatal("","");
  }

  limit = buffer + wcsntomos(wbuffer, wlimit-wbuffer, buffer);
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
