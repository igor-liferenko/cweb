In the following example

  @
  @c

we get

  \M{1}
  \Y\B\par

and if we do

  @ @c

we get

  \M{1}\B\par

The following code in |copy_TeX| causes this behavior:

  if (loc>limit && (finish_line(), get_line()==0)) return(new_section);

This |finish_line| call makes |out_line| and |out_ptr| change, which causes |emit_space_if_needed|
in @<Translate the \CEE/...@> produce the spurious \Y.

BUT, according to this code from cweave.w, the first variant is valid syntax:

  ccode[' ']=ccode['\t']=ccode['\n']=ccode['\v']=ccode['\r']=ccode['\f']
     =ccode['*']=new_section;

This influences nothing because '\n' is not used directly:
@x
ccode[' ']=ccode['\t']=ccode['\n']=ccode['\v']=ccode['\r']=ccode['\f']
@y
ccode[' ']=ccode['\t']=ccode['\v']=ccode['\r']=ccode['\f']
@z

@x
copy_TeX()
{
@y
copy_TeX()
{
  if (!(loc>limit) && new_section_was_just_started) skip_space=1;
  new_section_was_just_started=0;
@z

@x
@d emit_space_if_needed if (save_line!=out_line || save_place!=out_ptr)
  out_str("\\Y");
  space_checked=1
@y
@d emit_space_if_needed if ((save_line!=out_line ||
  save_place!=out_ptr) && !skip_space)
  out_str("\\Y");
  space_checked=1;
  skip_space=0
@z

@x
@ @<Translate the current section@>= {
@y
boolean new_section_was_just_started=0;
boolean skip_space=0;
@ @<Translate the current section@>= {
  new_section_was_just_started=1;
@z
