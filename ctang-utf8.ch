diff --git a/ctangle.w b/ctangle.w
index cc878e3..3b13373 100644
--- a/ctangle.w
+++ b/ctangle.w
@@ -65,6 +65,7 @@ is modified.
 
 @c
 @<Include files@>@/
+extern wchar_t xchr[];
 @h
 @<Common code for \.{CWEAVE} and \.{CTANGLE}@>@/
 @<Typedef declarations@>@/
@@ -404,7 +405,7 @@ get_output() /* sends next token to |out_char| */
   }
   a=*cur_byte++;
   if (out_state==verbatim && a!=string && a!=constant && a!='\n')
-    C_putc(a); /* a high-bit character can occur in a string */
+    fprintf(C_file,"%lc",xchr[(eight_bits)a]); /* a high-bit character can occur in a string */
   else if (a<0200) out_char(a); /* one-byte token */
   else {
     a=(a-0200)*0400+*cur_byte++;
@@ -724,9 +725,7 @@ case identifier:
   j=(cur_val+name_dir)->byte_start;
   k=(cur_val+name_dir+1)->byte_start;
   while (j<k) {
-    if ((unsigned char)(*j)<0200) C_putc(*j);
-@^high-bit character handling@>
-    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
+    fprintf(C_file, "%lc",xchr[(eight_bits) *j]);
     j++;
   }
   out_state=num_or_id; break;
