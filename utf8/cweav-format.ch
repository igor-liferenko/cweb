Suppose we need to explain some type names in TeX-text part of a section
(suppose also that this section does not have C-code part).
For these type names to be formatted correctly, we need to use @s
(assuming that these type names did not occur earlier in C code).
Problem appears if @s is put to middle part of the section (in contrast with limbo).
In the following CWEB program spurious \Y is added after TeX-text
without using this change-file:

  @ Let's explain |struct x|.
  @s x int

NOTE: in the following example
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

@x
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked){emit_space_if_needed;save_position;}
@y
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked&&format_visible){emit_space_if_needed;save_position;}
@z
