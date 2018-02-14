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

@c
@y
@d tex_printf(c) 0
@d tex_new_line if(gobble)out_line--;else putc('\n',active_file)

@c
void c_line_write(int n)
{
  fflush(active_file);
  if (gobble) return;
  fwrite(out_buf+1,sizeof(char),n,active_file);
}
void tex_putc(char c)
{
  if (gobble) return;
  putc(c,active_file);
}
@z

@x
    out_section(cur_xref->num-def_flag);
@y
    out_str(tex_file_name);
@z

@x
  finish_C(1);
@y
  gobble=0;
  finish_C(1);
  gobble=1;
@z
