@x
@h
@y
extern unsigned char xord[];
extern wchar_t xchr[];
@h
@z

@x
@i common.h
@y
@i comm-utf8.h
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
      if (xisupper(c)) c=tolower(c);
@y
      if (iswupper(xchr[(eight_bits) c])) c=xord[towlower(xchr[(eight_bits) c])];
@z

@x
        if (xislower(*j)) goto lowcase;
@y
        if (iswlower(xchr[(eight_bits)*j])) goto lowcase;
@z
