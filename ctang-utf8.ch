@x
@<Include files@>@/
@y
@<Include files@>@/
#include <limits.h>
@z

@x
@d longest_name 10000 /* section names and strings shouldn't be longer than this */
@y
@d longest_name 10000*MB_LEN_MAX /* section names and strings shouldn't be longer than this */
@z

@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else C_putc(*j);
@z
