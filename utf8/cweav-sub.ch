Substitute C text in /dev/null section.

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int not_null=1;
@z

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
