Suppose we need to explain some type names in TeX-text part of a section
(suppose also that this section does not have C-code part).
For these type names to be formatted correctly, we need to use @s
(assuming that these type names did not occur earlier in C code).
Problem appears if @s is put to middle part of the section (in contrast with limbo).
In the following CWEB program spurious \Y is added after TeX-text
without using this change-file:

  @ Let's explain |struct x|.
  @s x int

This change-file also fixes the case when @s is not preceded by TeX-part and followed by @d;
without this change-file the #define is backspaced, but it must not be:

  @ @s line normal
  @d line something

The following line plays the role in this case:

  if (save_line!=out_line || save_place!=out_ptr || space_checked) app(backup);

So, without this change-file emit_space_if_needed is called (between @x-@y below),
which sets space_checked=1 and triggers above "app(backup)".

@x
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked){emit_space_if_needed;save_position;}
@y
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked&&format_visible){emit_space_if_needed;save_position;}
@z

NOTE (concerning the need for @s in "@s x int" example above): we use @s if type is defined after it is first used, like in the following example:
@ @c
my x;
typedef struct {
  int z;
} my;
my y;
This is due to the fact that typedef is not treated in phase one - syntax analysis is made and scraps are formed only in phase two, where it is too late. TODO: find which function exactly is used to mark an identifier when typedef is encountered - |id_lookup|?

TODO: in the following example
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
It makes out_line and out_ptr change, which causes |emit_space_if_needed|
in @<Translate the \CEE/...@> produce the \Y
BUT, according to this code from cweave.w, the first variant is valid syntax:
  ccode[' ']=ccode['\t']=ccode['\n']=ccode['\v']=ccode['\r']=ccode['\f']
     =ccode['*']=new_section;
