@x
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
@y
    else {
      if (flags['u']) fprintf(C_file, "%lc",xchr[(eight_bits) *j]);
      else C_printf("%s",translit[(unsigned char)(*j)-0200]);
    }
@z
