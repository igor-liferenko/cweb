@x
@h
@y
extern wchar_t xchr[];
@h
@z

@x
    C_putc(a); /* a high-bit character can occur in a string */
@y
    fprintf(C_file,"%lc",xchr[(eight_bits)a]); /* a high-bit character can occur in a string */
@z

@x
          C_putc(a); /* a high-bit character can occur in a string */
@y
          fprintf(C_file,"%lc",xchr[(eight_bits)a]); /* a high-bit character can occur in a string */
@z
