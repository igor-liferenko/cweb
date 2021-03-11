diff --git a/common.w b/common.w
index 406e631..196f6fd 100644
--- a/common.w
+++ b/common.w
@@ -88,10 +88,21 @@ The global variable |phase| tells which phase we are in.
 \.{CWEAVE} off to a good start. We will fill in the details of this
 procedure later.
 
+@d invalid_code 0177 /*ASCII code that many systems prohibit in text files*/
 @c
 void
 common_init()
 {
+  setlocale(LC_CTYPE, "C.UTF-8");
+@i ASCII.w
+  int i;
+  for (i=0; i<=037; i++) xchr[i]=' ';
+  for (i=0177; i<=0377; i++) xchr[i]=' ';
+@i mapping.w
+  for(i=0;i<=65535;i++) xord[i]=invalid_code;
+  for(i=0200;i<=0377;i++) xord[xchr[i]]=i;
+  for(i=0;i<=0176;i++) xord[xchr[i]]=i;
+
   @<Initialize pointers@>;
   @<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>;
   @<Scan arguments and open output files@>;
@@ -103,6 +114,7 @@ common_init()
 
 @<Include files@>=
 #include <ctype.h>
+#include <locale.h>
 
 @ A few character pairs are encoded internally as single characters,
 using the definitions below. These definitions are consistent with
@@ -164,6 +176,9 @@ char *buffer_end=buffer+buf_size-2; /* end of |buffer| */
 char *limit=buffer; /* points to the last character in the buffer */
 char *loc=buffer; /* points to the next character to be read from the buffer */
 
+unsigned char xord[65536];
+wchar_t xchr[256];
+
 @ @<Include files@>=
 #include <stdio.h>
 
@@ -175,18 +190,26 @@ support |feof|, |getc|, and |ungetc| you may have to change things here.
 int input_ln(fp) /* copies a line into |buffer| or returns 0 */
 FILE *fp; /* what file to read from */
 {
-  register int  c=EOF; /* character read; initialized so some compilers won't complain */
+  wchar_t c; /* character read */
   register char *k;  /* where next character goes */
   if (feof(fp)) return(0);  /* we have hit end-of-file */
   limit = k = buffer;  /* beginning of buffer */
-  while (k<=buffer_end && (c=getc(fp)) != EOF && c!='\n')
-    if ((*(k++) = c) != ' ') limit = k;
-  if (k>buffer_end)
-    if ((c=getc(fp))!=EOF && c!='\n') {
-      ungetc(c,fp); loc=buffer; err_print("! Input line too long");
+  while (k<=buffer_end) {
+    c=fgetwc(fp);
+    if (ferror(fp)) { fprintf(stderr, "File is not UTF-8\n"); exit(1); }
+    if (feof(fp) || c==L'\n') break;
+    if (xord[c] == invalid_code) { fprintf(stderr, "Invalid code\n"); exit(1); }
+    if ((*(k++) = xord[c]) != ' ') limit = k;
+  }
+  if (k>buffer_end) {
+    c=fgetwc(fp);
+    if (ferror(fp)) { fprintf(stderr, "File is not UTF-8\n"); exit(1); }
+    if (!(feof(fp) || c==L'\n')) {
+      ungetwc(c,fp); loc=buffer; err_print("! Input line too long");
 @.Input line too long@>
+    }
   }
-  if (c==EOF && limit==buffer) return(0);  /* there was nothing after
+  if (feof(fp) && limit==buffer) return(0);  /* there was nothing after
     the last newline */
   return(1);
 }
