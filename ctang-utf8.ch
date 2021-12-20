@x
@h
@y
extern wchar_t xchr[];
@h
@z

@x
    C_putc(a); /* a high-bit character can occur in a string */
@y
    fprintf(C_file,"%lc",xchr[(eight_bits)a]);
@z

@x
          C_putc(a); /* a high-bit character can occur in a string */
@y
          fprintf(C_file,"%lc",xchr[(eight_bits)a]);
@z

@x
  for (i=0;i<128;i++) sprintf(translit[i],"X%02X",(unsigned)(128+i));
@y
  for (i=0;i<128;i++) *translit[i] = 0;
@z

If a program must be built by compiler which does not support UTF-8 identifiers,
use @l control codes in such a program.

@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else if (*translit[(unsigned char)(*j)-128]) C_printf("%s",translit[(unsigned char)(*j)-0200]);
    else fprintf(C_file, "%lc",xchr[(eight_bits) *j]);
@z
