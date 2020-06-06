@x
@<Include files@>@/
@y
#include <locale.h>
@<Include files@>@/
extern wchar_t xchr[];
@z

@x
  argc=ac; argv=av;
@y
  setlocale(LC_CTYPE, "C.UTF-8");
  argc=ac; argv=av;
@z

@x
@i common.h
@y
@i comm-utf8.h
@z

@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else {
      wchar_t wc;

      j += mbtowc(&wc, j, MB_CUR_MAX) - 1;

      unsigned char z;
      for (z = 0x80; z <= 0xff; z++)
        if (xchr[z] == wc)
          break;
      C_printf("%s",translit[z-0200]);
    }
@z
