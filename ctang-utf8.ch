@x
@i common.h
@y
@i comm-utf8.h
@z

@x
char output_file_name[longest_name]; /* name of the file */
@y
char output_file_name[longest_name*MB_LEN_MAX]; /* name of the file */
@z

@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else C_putc(*j);
@z
