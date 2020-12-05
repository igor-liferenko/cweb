TODO: gcc/clang now support UTF-8 identifiers, so instead of
translit impliment outputting UTF-8, and then add replacing
sigаction to sigaction to bin/ctangle wrapper
and remove ctang-atl.ch and ctang-translit.ch

@x
@<Include files@>@/
@y
@<Include files@>@/
extern wchar_t xchr[];
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
      for (z = 0; z <= 0xff; z++)
        if (xchr[z] == wc)
          break;
      C_printf("%s",translit[z-0200]);
    }
@z
