@x
@h
@y
extern wchar_t xchr[];
@h
@z

@x
@i common.h
@y
@i comm-utf8.h
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
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else fprintf(C_file, "%lc",xchr[(eight_bits) *j]);
@z
