get rid of spurious \Y - see section 207 in cweave.w
Suppose we need to explain some type names in TeX-text part of a section
(suppose also that this section does not have C-code part).
For these type names to be formatted correctly, we need to use @s
(assuming that these type names did not occur earlier in C code).
Problem appears if @s is put to middle part of the section.
In the following CWEB program spurious \Y is added:
@* Intro. Let's explain |struct x|.

@s x int

@ Next section.
Compare it with the following where there is no spurious \Y:
@* Intro. Let's explain everything.

@ Next section.
If we put @s x int to limbo, no spurious \Y is produced.

@x
  if(!space_checked){emit_space_if_needed;save_position;}
@y
  if(!space_checked&&format_visible){emit_space_if_needed;save_position;}
@z
