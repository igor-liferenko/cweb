@x
@i common.h
@y
@i comm-utf8.h
@z

@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else C_putc(*j);
@z
