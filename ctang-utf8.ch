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
@z

@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else if (*translit[(unsigned char)(*j)-0200]) C_printf("%s",translit[(unsigned char)(*j)-0200]);
    else fprintf(C_file, "%lc",xchr[(eight_bits) *j]);
@z
