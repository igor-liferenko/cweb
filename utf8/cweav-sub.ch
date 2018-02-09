Substitute C text in /dev/null section.

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int not_null;
int null_sections[100];
extern int line_cur;
int line_prev=0;
#define line_changed line_prev!=line_cur
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

@x
get_next() /* produces the next input token */
{@+eight_bits c; /* the current character */
@y
get_next() /* produces the next input token */
{@+eight_bits c; /* the current character */
  if (phase==2 && has_null(section_count) && line_changed) {
    printf("%.*s\n",limit-buffer,buffer);
    line_prev=line_cur;
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
    }
    else {
      not_null=1;
    }
  }
@z

Do not make index entries for C-part of /dev/null sections:
@x
    next_control=get_next(); outer_xref();
@y
    next_control=get_next();
    if (not_null) outer_xref();
@z

----------- PHASE THREE -----------

@x
@<Output a section name@>= {
  out_str("\\X");
@.\\X@>
  cur_xref=(xref_pointer)cur_name->xref;
  if (cur_xref->num==file_flag) {an_output=1; cur_xref=cur_xref->xlink;}
  else an_output=0;
  if (cur_xref->num>=def_flag) {
    out_section(cur_xref->num-def_flag);
@y
@<Output a section name@>= {
  sprint_section_name(scratch,cur_name);
  if (phase==3&&strcmp(scratch,"/dev/null")==0) out_ptr=out_buf;
  if (phase==3&&strcmp(scratch,"/dev/null")!=0) out_str("\\X");
@.\\X@>
  cur_xref=(xref_pointer)cur_name->xref;
  if (cur_xref->num==file_flag) {an_output=1; cur_xref=cur_xref->xlink;}
  else an_output=0;
  if (cur_xref->num>=def_flag) {
    if (phase==3&&strcmp(scratch,"/dev/null")!=0) out_section(cur_xref->num-def_flag);
@z

@x
  out(':');
  if (an_output) out_str("\\.{"@q}@>);
@.\\.@>
  @<Output the text of the section name@>;
  if (an_output) out_str(@q{@>" }");
  out_str("\\X");
@y
  if (phase==3&&strcmp(scratch,"/dev/null")!=0) out(':');
  if (phase==3&&strcmp(scratch,"/dev/null")!=0) if (an_output) out_str("\\.{"@q}@>);
@.\\.@>
  @<Output the text of the section name@>;
  if (phase==3&&strcmp(scratch,"/dev/null")!=0) if (an_output) out_str(@q{@>" }");
  if (phase==3&&strcmp(scratch,"/dev/null")!=0) out_str("\\X");
@z

@x
 default: out(b);
@y
 default: if (phase==3&&strcmp(scratch,"/dev/null")!=0) out(b);
@z

----------- PHASE TWO --------------

@x
  finish_C(1);
@y
  finish_C(!has_null(section_count));
  /* TODO: here we call \.{cw} on tex_file_name.section_number
     and print its output to |tex_file| and remove tex_file_name.section_number */
@z

TODO: output |buffer| to tex_file_name.section_number based on |has_null(section_count)|
in phase two
