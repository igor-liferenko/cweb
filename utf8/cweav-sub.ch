Substitute C text in /dev/null section.

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int not_null;
@z

-------------- PHASE ONE --------------

Beginning of new section:
@x
  cur_section_char=*(loc-1);
@y
  cur_section_char=*(loc-1);
  if (cur_section_char == '(') not_null = 0; else not_null = 1;
  /* TODO: check section name and set not_null to zero only if it is /dev/null */
@z

Do not make cross-references for /dev/null sections:
@x
    if (next_control==section_name && cur_section!=name_dir)
      new_section_xref(cur_section);
    next_control=get_next(); outer_xref();
@y
    if (not_null)
      if (next_control==section_name && cur_section!=name_dir)
        new_section_xref(cur_section);
    next_control=get_next();
    if (not_null) outer_xref();
@z

----------- PHASE TWO --------------

@x
  @<Translate the \CEE/ part of the current section@>;
@y
  not_null=1;
  @<Translate the \CEE/ part of the current section@>;
@z

@x
  finish_C(1);
@y
  finish_C(not_null);
  /* TODO: here we call \.{cw} on tex_file_name.section_number
     and print its output to |tex_file| and remove tex_file_name.section_number */
@z

@x
if(cur_xref->num==file_flag) cur_xref=cur_xref->xlink;
@y
if(cur_xref->num==file_flag) {
  char scratch[longest_name];
  sprint_section_name(scratch,this_section);
  if (strcmp(scratch,"/dev/null")==0) not_null=0;
  cur_xref=cur_xref->xlink;
}
@z

TODO: output |buffer| to tex_file_name.section_number
