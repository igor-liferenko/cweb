Suppose we need to explain some type names in TeX-text part of a section
(suppose also that this section does not have C-code part).
For these type names to be formatted correctly, we need to use @s
(assuming that these type names did not occur earlier in C code).
Problem appears if @s is put to middle part of the section (in contrast with limbo).
In the following CWEB program spurious \Y is added after TeX-text
without using this change-file:

  @ Let's explain |struct x|.
  @s x int

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

TODO: understand why on the following file
@ @s not_eq normal
@d not_eq 032
we get the following difference without and with this change-file, and fix it, and then fix and
enable this change, and then fix the same in cweb-git/cweave.w, and understand why the
same difference is when we roll back all changes to
cweb-git/common.w, cweb-git/cweave.w, cweb-git/ctangle.w to the very first commit in this repo,
the difference is the same:
-\M{1}\B\4\D$\\{not\_eq}$ \5
+\M{1}\B\D$\\{not\_eq}$ \5
HINT: the following line plays the role in this case:
  if (save_line!=out_line || save_place!=out_ptr || space_checked) app(backup);

 @x
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked){emit_space_if_needed;save_position;}
 @y
  if(*(loc-1)=='s' || *(loc-1)=='S') format_visible=0;
  if(!space_checked&&format_visible){emit_space_if_needed;save_position;}
 @z

NOTE: we use @s if type is defined after it is first used, like in the following example:
@ @c
my x;
typedef struct {
  int z;
} my;
my y;
This is due to the fact that typedef is not treated in phase one - syntax analysis is made and scraps are formed only in phase two, where it is too late.
