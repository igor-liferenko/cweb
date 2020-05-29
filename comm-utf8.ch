@x
@<Include files@>@/
@y
#include <wchar.h>
#include <limits.h>
@<Include files@>@/
char *xchr[256];
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
  /* TODO: do via `#include "mapping"' and `-I/home/user/tex' */
  xchr[0x80] = "А";
  xchr[0xa0] = "а";
  xchr[0x81] = "Б";
  xchr[0xa1] = "б";
  xchr[0x82] = "В";
  xchr[0xa2] = "в";
  xchr[0x83] = "Г";
  xchr[0xa3] = "г";
  xchr[0x84] = "Д";
  xchr[0xa4] = "д";
  xchr[0x85] = "Е";
  xchr[0xa5] = "е";
  xchr[0xf0] = "Ё";
  xchr[0xf1] = "ё";
  xchr[0x86] = "Ж";
  xchr[0xa6] = "ж";
  xchr[0x87] = "З";
  xchr[0xa7] = "з";
  xchr[0x88] = "И";
  xchr[0xa8] = "и";
  xchr[0x89] = "Й";
  xchr[0xa9] = "й";
  xchr[0x8a] = "К";
  xchr[0xaa] = "к";
  xchr[0x8b] = "Л";
  xchr[0xab] = "л";
  xchr[0x8c] = "М";
  xchr[0xac] = "м";
  xchr[0x8d] = "Н";
  xchr[0xad] = "н";
  xchr[0x8e] = "О";
  xchr[0xae] = "о";
  xchr[0x8f] = "П";
  xchr[0xaf] = "п";
  xchr[0x90] = "Р";
  xchr[0xe0] = "р";
  xchr[0x91] = "С";
  xchr[0xe1] = "с";
  xchr[0x92] = "Т";
  xchr[0xe2] = "т";
  xchr[0x93] = "У";
  xchr[0xe3] = "у";
  xchr[0x94] = "Ф";
  xchr[0xe4] = "ф";
  xchr[0x95] = "Х";
  xchr[0xe5] = "х";
  xchr[0x96] = "Ц";
  xchr[0xe6] = "ц";
  xchr[0x97] = "Ч";
  xchr[0xe7] = "ч";
  xchr[0x98] = "Ш";
  xchr[0xe8] = "ш";
  xchr[0x99] = "Щ";
  xchr[0xe9] = "щ";
  xchr[0x9a] = "Ъ";
  xchr[0xea] = "ъ";
  xchr[0x9b] = "Ы";
  xchr[0xeb] = "ы";
  xchr[0x9c] = "Ь";
  xchr[0xec] = "ь";
  xchr[0x9d] = "Э";
  xchr[0xed] = "э";
  xchr[0x9e] = "Ю";
  xchr[0xee] = "ю";
  xchr[0x9f] = "Я";
  xchr[0xef] = "я";
  xchr[0xfc] = "№";
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
