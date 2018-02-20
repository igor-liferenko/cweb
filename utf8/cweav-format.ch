Suppose we need to explain some type names in TeX-text part of a section
(suppose also that this section does not have C-code part).
For these type names to be formatted correctly, we need to use @s
(assuming that these type names did not occur earlier in C code).
Problem appears if @s is put to middle part of the section (in contrast with limbo).
In the following CWEB program spurious \Y is added after TeX-text
without using this change-file:

  @ Let's explain |struct x|.
  @s x int

NOTE: If C-text is non-empty (and TeX-text is empty), no spurious \Y is produced,
so it seems such case is handled in cweave. TODO: find where

TODO: Is it right that if we do
@
@c
we get
\M{1}
\Y\B\par
and if we do
@ @c
we get
\M{1}\B\par
?

@x
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked){emit_space_if_needed;save_position;}
@y
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked&&format_visible){emit_space_if_needed;save_position;}
@z
