@x
@<Include files@>@/
@y
@<Include files@>@/
#include <limits.h> /* this is for MB_LEN_MAX */
@z

In ctangle this influences only output_file_name, section_text and section_text_end
@x
@d longest_name 10000 /* section names and strings shouldn't be longer than this */
@y
@d longest_name 10000*MB_LEN_MAX /* section names and strings shouldn't be longer than this */
@z

Modern compilers can handle UTF-8 identifiers (translit array should also be purged, but it is left to keep number of changes to minimum)
@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else C_putc(*j);
@z
