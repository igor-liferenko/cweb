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
diff --git a/cweave.w b/cweave.w
index 9550e6d..f77ca90 100644
--- a/cweave.w
+++ b/cweave.w
@@ -71,6 +71,8 @@ is modified.
 @d banner "This is CWEAVE (Version 3.64)\n"
 
 @c @<Include files@>@/
+extern unsigned char xord[];
+extern wchar_t xchr[];
 @h
 @<Common code for \.{CWEAVE} and \.{CTANGLE}@>@/
 @<Typedef declarations@>@/
@@ -684,6 +686,7 @@ char cur_section_char; /* the character just before that name */
 @ @<Include...@>=
 #include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
 #include <stdlib.h> /* definition of |exit| */
+#include <wctype.h>
 
 @ As one might expect, |get_next| consists mostly of a big switch
 that branches to the various special cases that can arise.
@@ -1316,7 +1319,8 @@ if the |carryover| parameter is true, a |"%"| in that line will be
 carried over to the next line (so that \TEX/ will ignore the completion
 of commented-out text).
 
-@d c_line_write(c) fflush(active_file),fwrite(out_buf+1,sizeof(char),c,active_file)
+@d c_line_write(c) fflush(active_file); for (int i = 0; i < c; i++)
+  fprintf(active_file, "%lc",xchr[(eight_bits) *(out_buf+1+i)])
 @d tex_putc(c) putc(c,active_file)
 @d tex_new_line putc('\n',active_file)
 @d tex_printf(c) fprintf(active_file,c)
@@ -3752,7 +3756,7 @@ if (a==identifier) {
 @.\\|@>
   else { delim='.';
     for (p=cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
-      if (xislower(*p)) { /* not entirely uppercase */
+      if (iswlower(xchr[(eight_bits)*p])) { /* not entirely uppercase */
          delim='\\'; break;
       }
   out(delim);
@@ -4387,7 +4391,7 @@ for (h=hash; h<=hash_end; h++) {
     cur_name=next_name; next_name=cur_name->link;
     if (cur_name->xref!=(char*)xmem) {
       c=(eight_bits)((cur_name->byte_start)[0]);
-      if (xisupper(c)) c=tolower(c);
+      if (iswupper(xchr[(eight_bits) c])) c=xord[towlower(xchr[(eight_bits) c])];
       blink[cur_name-name_dir]=bucket[c]; bucket[c]=cur_name;
     }
   }
@@ -4512,7 +4516,7 @@ while (sort_ptr>scrap_info) {
     if (cur_byte==(cur_name+1)->byte_start) c=0; /* hit end of the name */
     else {
       c=(eight_bits) *cur_byte;
-      if (xisupper(c)) c=tolower(c);
+      if (iswupper(xchr[(eight_bits) c])) c=xord[towlower(xchr[(eight_bits) c])];
     }
   blink[cur_name-name_dir]=bucket[c]; bucket[c]=cur_name;
   } while (next_name);
@@ -4536,7 +4540,7 @@ switch (cur_name->ilk) {
   case normal: case func_template: if (is_tiny(cur_name)) out_str("\\|");
     else {char *j;
       for (j=cur_name->byte_start;j<(cur_name+1)->byte_start;j++)
-        if (xislower(*j)) goto lowcase;
+        if (iswlower(xchr[(eight_bits)*j])) goto lowcase;
       out_str("\\."); break;
 lowcase: out_str("\\\\");
     }
