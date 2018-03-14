@x
ccode[' ']=ccode['\t']=ccode['\n']=ccode['\v']=ccode['\r']=ccode['\f']
@y
ccode[' ']=ccode['\t']=ccode['\v']=ccode['\r']=ccode['\f']
@z

@x
copy_TeX()
{
  char c; /* current character being copied */
  while (1) {
    if (loc>limit && (finish_line(), get_line()==0)) return(new_section);
@y
copy_TeX()
{
  char c; /* current character being copied */
  int do_not_finish_line = 0;
  if (loc>limit && next_control==new_section) do_not_finish_line = 1;
  while (1) {
    if (loc>limit && !do_not_finish_line) finish_line();
    if (loc>limit && (get_line()==0)) return(new_section);
@z
