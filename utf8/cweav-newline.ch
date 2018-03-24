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
  char c; /* current character being copied */
  while (1) {
    if (loc>limit && (finish_line(), get_line()==0)) return(new_section);
@y
copy_TeX()
{
  char c; /* current character being copied */
  int do_not_finish_line = 0;
  if (loc>limit && new_section_was_just_started) do_not_finish_line = 1;
  new_section_was_just_started=0;
  while (1) {
    if (loc>limit && !do_not_finish_line) finish_line();
    if (loc>limit && (get_line()==0)) return(new_section);
@z

@x
@ @<Translate the current section@>= {
@y
boolean new_section_was_just_started=0;
@ @<Translate the current section@>= {
  new_section_was_just_started=1;
@z

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

make so that

  @
  X

will produce

  \M{1}X

and not

  \M{1}X 

as now (i.e., without trailing space)

----------------

and after you fix this, check that the following example

  @
  X%
  Y

instead of

  \M{1}X% Y 

will produce

  \M{1}X%
  Y
