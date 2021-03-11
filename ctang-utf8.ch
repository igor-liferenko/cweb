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
    if ((unsigned char)(*j)<0200) C_putc(*j);
@^high-bit character handling@>
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    fprintf(C_file, "%lc",xchr[(eight_bits) *j]);
@z
