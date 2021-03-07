TODO: instead of current method use the same method as in TeX
(HINT: CWEAVE is based on WEAVE, so search places where xord is used in WEAVE and use it in CWEAVE
in analogous place; then use changes which were removed in commit c775b2147d53ea3f0183368cf261f4940955a619 of utf8/build.sh)

@x
@c @<Include files@>@/
@y
@c
#include <wchar.h>
#include <wctype.h>
#include <limits.h>
@<Include files@>@/
extern wchar_t xchr[];
unsigned char xord(char *p)
{
  wchar_t wc;

  mbtowc(&wc, p, MB_CUR_MAX);
  if (iswupper(wc)) wc=towlower(wc);

  unsigned char z;
  for (z = 0; z <= 0xff; z++)
    if (xchr[z] == wc)
      return z;
}
int mbsntowcslen(char *mbs, int len);
@z

@x
@d longest_name 10000 /* section names and strings shouldn't be longer than this */
@d long_buf_size (buf_size+longest_name)
@y
@d longest_name 10000*MB_LEN_MAX /* section names and strings shouldn't be longer than this */
@d long_buf_size (buf_size*MB_LEN_MAX+longest_name)
@z

Removes `extern char *buffer_end;'
@x
@i common.h
@y
@i comm-utf8.h
@z

@x
@d is_tiny(p) ((p+1)->byte_start==(p)->byte_start+1)
@y
@d is_tiny(p) ((p+1)->byte_start==(p)->byte_start+mblen((p)->byte_start,MB_CUR_MAX))
@z

@x
while (loc<=buffer_end-7 && xisspace(*loc)) loc++;
if (loc<=buffer_end-6 && strncmp(loc,"include",7)==0) sharp_include_line=1;
@y
while (loc<=(buffer+buf_size*MB_LEN_MAX-2)-7 && xisspace(*loc)) loc++;
if (loc<=(buffer+buf_size*MB_LEN_MAX-2)-6 && strncmp(loc,"include",7)==0) sharp_include_line=1;
@z

@x
char out_buf[line_length+1]; /* assembled characters */
@y
char out_buf[line_length*MB_LEN_MAX+1]; /* assembled characters */
@z

@x
char *out_buf_end = out_buf+line_length; /* end of |out_buf| */
@y
char *out_buf_end = out_buf+line_length*MB_LEN_MAX; /* end of |out_buf| */
@z

@x
@d out(c) {if (out_ptr>=out_buf_end) break_out(); *(++out_ptr)=c;}
@y
@d out(c) {
  if (mbsntowcslen(out_buf+1, out_ptr-(out_buf+1)+1) >= line_length) break_out();
  *++out_ptr=c;
}
@z

@x
  term_write(out_buf+1, out_ptr-out_buf-1);
  new_line; mark_harmless;
  flush_buffer(out_ptr-1,1,1); return;
@y
  k=out_ptr;
  while (mblen(k,MB_CUR_MAX)==-1) k--;
  term_write(out_buf+1, out_ptr-out_buf-mblen(k,MB_CUR_MAX));
  new_line; mark_harmless;
  flush_buffer(out_ptr-mblen(k,MB_CUR_MAX),1,1); return;
@z

@x
  if((eight_bits)(*id_first)>0177) {
    app_tok(quoted_char);
    app_tok((eight_bits)(*id_first++));
  }
@y
  if((eight_bits)(*id_first)>0177) {
    for (int w = mblen(id_first,MB_CUR_MAX); w > 0; w--) {
      app_tok(quoted_char);
      app_tok((eight_bits)(*id_first++));
    }
  }
@z

@x
      if (xislower(*p)) { /* not entirely uppercase */
         delim='\\'; break;
      }
@y
    {
      wchar_t wc;
      mbtowc(&wc, p, MB_CUR_MAX);
      if (iswlower(wc)) { /* not entirely uppercase */
        delim='\\'; break;
      }
    }
@z

@x
  out((cur_name->byte_start)[0]);
@y
  for (int w = 0; w < mblen(cur_name->byte_start,MB_CUR_MAX); w++)
    out(*(cur_name->byte_start + w));
@z

@x
      if (xisupper(c)) c=tolower(c);
@y
      if (xisupper(c)) c=tolower(c);
      else if (ishigh(c)) c=xord(cur_name->byte_start);
@z

Move 'ё' down next to 'е' and shift the rest of the sequence:

@x
strcpy(collate+133,"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257");
/* 16 characters + 133 = 149 */
strcpy(collate+149,"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277");
/* 16 characters + 149 = 165 */
strcpy(collate+165,"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317");
/* 16 characters + 165 = 181 */
strcpy(collate+181,"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337");
/* 16 characters + 181 = 197 */
strcpy(collate+197,"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357");
/* 16 characters + 197 = 213 */
strcpy(collate+213,"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377");
@y
strcpy(collate+133,"\240\241\242\243\244\245\361\246\247\250\251\252\253\254\255\256");
/* 16 characters + 133 = 149 */
strcpy(collate+149,"\257\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276");
/* 16 characters + 149 = 165 */
strcpy(collate+165,"\277\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316");
/* 16 characters + 165 = 181 */
strcpy(collate+181,"\317\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336");
/* 16 characters + 181 = 197 */
strcpy(collate+197,"\337\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356");
/* 16 characters + 197 = 213 */
strcpy(collate+213,"\357\360\362\363\364\365\366\367\370\371\372\373\374\375\376\377");
@z

@x
    cur_byte=cur_name->byte_start+cur_depth;
    if (cur_byte==(cur_name+1)->byte_start) c=0; /* hit end of the name */
    else {
      c=(eight_bits) *cur_byte;
      if (xisupper(c)) c=tolower(c);
@y
    cur_byte=cur_name->byte_start;
    for (int w = 0; w < cur_depth; w++)
      cur_byte+=mblen(cur_byte,MB_CUR_MAX);
    if (cur_byte==(cur_name+1)->byte_start) c=0; /* hit end of the name */
    else {
      c=(eight_bits) *cur_byte;
      if (xisupper(c)) c=tolower(c);
      else if (ishigh(c)) c=xord(cur_byte);
@z

@x
      for (j=cur_name->byte_start;j<(cur_name+1)->byte_start;j++)
        if (xislower(*j)) goto lowcase;
@y
      for (j=cur_name->byte_start;j<(cur_name+1)->byte_start;j++) {
        wchar_t wc;
        mbtowc(&wc, j, MB_CUR_MAX);
        if (iswlower(wc)) goto lowcase;
      }
@z
