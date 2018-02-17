Translate C code into TeX-formatted C code:

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int gobble=1;
@z

@x
@d c_line_write(c) fflush(active_file),fwrite(out_buf+1,sizeof(char),c,active_file)
@d tex_putc(c) putc(c,active_file)
@d tex_new_line putc('\n',active_file)
@d tex_printf(c) fprintf(active_file,c)
@y
@d c_line_write(c) fflush(active_file); if (!gobble) fwrite(out_buf+1,sizeof(char),c,active_file)
@d tex_putc(c) if (!gobble) putc(c,active_file)
@d tex_new_line if (!gobble) putc('\n',active_file)
@d tex_printf(s)
@z

@x
  finish_C(1);
@y
  gobble=0;
  finish_C(1);
  gobble=1;
@z
