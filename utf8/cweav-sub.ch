Substitute C text in /dev/null section.

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int not_null;
int printing=0;
int null_sections[100];
void add_null(int n)
{
  for (int i = 0; i<100; i++)
    if (null_sections[i]==0) { null_sections[i]=n; return; }
}
int has_null(int n)
{
  for (int i = 0; i<100; i++)
    if (null_sections[i]==n) return 1;
  return 0;
}
@z

-------------- PHASE ONE --------------

Beginning of new section:
@x
  cur_section_char=*(loc-1);
  @<Put section name into |section_text|@>;
@y
  cur_section_char=*(loc-1);
  char *k0 = section_text;
  @<Put section name into |section_text|@>;
  if (phase == 1) {
    if (cur_section_char=='(' && strncmp("/dev/null",k0+1,k-k0)==0) {
      add_null(section_count);
      not_null=0;
      printing=1;
    }
    else {
      not_null=1;
      printing=0;
    }
  }
  if (phase==2) {
    if (cur_section_char=='(' && strncmp("/dev/null",k0+1,k-k0)==0)
      printing=1;
    else printing=0;
  }
  /* FIXME: maybe even do not put section name into |section_text| in order that it will
     not appear in .scn file */
@z

Do not make index entries for C-part of /dev/null sections:
@x
    next_control=get_next(); outer_xref();
@y
    next_control=get_next();
    if (not_null) outer_xref();
@z

----------- PHASE TWO --------------

@x
  finish_C(1);
@y
  finish_C(!has_null(section_count));
  /* TODO: here we call \.{cw} on tex_file_name.section_number
     and print its output to |tex_file| and remove tex_file_name.section_number */
@z

TODO: output |buffer| to tex_file_name.section_number based on |printing|
(decide where it is better to do it - in phase one or two)
