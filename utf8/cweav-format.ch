In the following example

  @ %
  @c

we get

  \M{1}%
  \Y\B\par

and if we do

  @ @c

we get

  \M{1}\B\par

The following code in |copy_TeX| causes this behavior:

  if (loc>limit && (finish_line(), get_line()==0)) return(new_section);

This |finish_line| call makes |out_line| and |out_ptr| change, which causes |emit_space_if_needed|
in @<Translate the \CEE/...@> produce the spurious \Y.

Notice, that

  @ %
  hello
  @c

must give the \Y

@x
copy_TeX()
{
  char c; /* current character being copied */
  while (1) {
    if (loc>limit && (finish_line(), get_line()==0)) return(new_section);
@y
copy_TeX()
{
  int do_not_emit_space=0;
  int reset_position=0;
  if (new_section_was_just_started && limit-buffer == 3 && *loc == '%') /* determine
                                                          if the line is `\.{@@ \%}' */
    do_not_emit_space=1;
  new_section_was_just_started=0;
  char c; /* current character being copied */
  while (1) {
    if (loc>limit && do_not_emit_space) reset_position=1;
    if (loc>limit && (finish_line(), get_line()==0)) return(new_section);
    if (reset_position) {
      save_position;
      do_not_emit_space=0;
      reset_position=0;
    }
@z

@x
@ @<Translate the current section@>= {
@y
boolean new_section_was_just_started=0;
@ @<Translate the current section@>= {
  new_section_was_just_started=1;
@z

+++++++++++++++++++++++++++++++++++++++++++++++++++

Suppose we need to explain some type names in TeX-text part of a section
(suppose also that this section does not have C-code part).
For these type names to be formatted correctly, we need to use @s
(assuming that these type names did not occur earlier in C code);
for explanation of why it is necessary, see #8 in "Additional features and caveats" in cwebman,
together with this example:

  @ @c
  my x;
  typedef struct {
    int z;
  } my;
  my y;

Problem appears if @s is put to middle part of the section (in contrast with limbo).
In the following CWEB program spurious \Y is added after TeX-text
without using this change-file:

  @ Let's explain |struct x|.
  @s x int

NOTE: now this problem is not so common because I use /dev/null-sections instead of writing
pre-formatted C code in TeX-part

This change-file also fixes the case when @s is not preceded by TeX-part and followed by @d;
without this change-file the #define is backspaced, but it must not be:

  @ @s line normal
  @d line something

The following line plays the role in this case:

  if (save_line!=out_line || save_place!=out_ptr || space_checked) app(backup);

So, without this change, emit_space_if_needed is called (between @x-@y below),
which sets space_checked=1 and triggers above "app(backup)".

@x
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked){emit_space_if_needed;save_position;}
@y
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked&&format_visible){emit_space_if_needed;save_position;}
@z
