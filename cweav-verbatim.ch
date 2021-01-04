@x
@<Global variables@>@/
@y
@<Global variables@>@/
int space_count;
@z

@x
  if (out_ptr>out_buf) flush_buffer(out_ptr,0,0);
  else {
@y
  if (out_ptr>out_buf) {
    while (space_count > 0) {
      space_count--;
      fprintf(active_file, " ");
    }
    flush_buffer(out_ptr,0,0);
  }
  else {
    space_count = 0;
@z

@x
      if (out_ptr==out_buf+1 && (xisspace(c))) out_ptr--;
@y
      if (out_ptr==out_buf+1 && (xisspace(c))) {
        out_ptr--;
        space_count++;
      }
@z
