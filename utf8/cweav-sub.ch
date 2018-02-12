Substitute C text in /dev/null section.

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int print=0;
int not_null;
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

@x
    @<Check if we're at the end of a preprocessor command@>;
    if (loc>limit && get_line()==0) return(new_section);
@y
    @<Check if we're at the end of a preprocessor command@>;
    if (loc>limit && get_line()==0) return(new_section);
    if(print){if(loc==limit)printf("\n");else if (*loc!='@@')printf("%c",*loc);}
@z

@x
while (loc<=buffer_end-7 && xisspace(*loc)) loc++;
@y
while (loc<=buffer_end-7 && xisspace(*loc)) {if(print)printf("%c",*loc);loc++;}
@z

@x
  while (loc==limit-1 && preprocessing && *loc=='\\')
    if (get_line()==0) return(new_section); /* still in preprocessor mode */
@y
  while (loc==limit-1 && preprocessing && *loc=='\\') {
    if (print) printf("%c", *loc);
    if (get_line()==0) return(new_section); /* still in preprocessor mode */
  }
@z

@x
@d compress(c) if (loc++<=limit) return(c)
@y
@d compress(c) do{if(loc++<=limit){if(print)printf("%c",*(loc-1));return(c);}}while(0)
@z

@x
    else if (*loc=='>') if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
  case '.': if (*loc=='*') {compress(period_ast);}
            else if (*loc=='.' && *(loc+1)=='.') {
              loc++; compress(dot_dot_dot);
@y
    else if (*loc=='>') if (*(loc+1)=='*') {if(print)printf("%c",*loc);
      loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
  case '.': if (*loc=='*') {compress(period_ast);}
            else if (*loc=='.' && *(loc+1)=='.') {
              if(print)printf("%c",*loc);loc++; compress(dot_dot_dot);
@z

@x
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc));
@y
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc))
    if(print)printf("%c",*loc);
@z

@x
  if (*(loc-1)=='0') {
    if (*loc=='x' || *loc=='X') {*id_loc++='^'; loc++;
      while (xisxdigit(*loc)) *id_loc++=*loc++;} /* hex constant */
    else if (xisdigit(*loc)) {*id_loc++='~';
      while (xisdigit(*loc)) *id_loc++=*loc++;} /* octal constant */
@y
  if (*(loc-1)=='0') {
    if (*loc=='x' || *loc=='X') {*id_loc++='^'; if (print) printf("%c", *loc); loc++;
      while (xisxdigit(*loc)) {if (print) printf("%c", *loc);
      *id_loc++=*loc++;}} /* hex constant */
    else if (xisdigit(*loc)) {*id_loc++='~';
      while (xisdigit(*loc)) {if (print) printf("%c", *loc);
      *id_loc++=*loc++;}} /* octal constant */
@z

@x
    while (xisdigit(*loc) || *loc=='.') *id_loc++=*loc++;
    if (*loc=='e' || *loc=='E') { /* float constant */
      *id_loc++='_'; loc++;
      if (*loc=='+' || *loc=='-') *id_loc++=*loc++;
      while (xisdigit(*loc)) *id_loc++=*loc++;
    }
  }
  while (*loc=='u' || *loc=='U' || *loc=='l' || *loc=='L'
         || *loc=='f' || *loc=='F') {
    *id_loc++='$'; *id_loc++=toupper(*loc); loc++;
@y
    while (xisdigit(*loc) || *loc=='.') {if(print)printf("%c",*loc);*id_loc++=*loc++;}
    if (*loc=='e' || *loc=='E') { /* float constant */
      *id_loc++='_'; if(print)printf("%c",*loc);loc++;
      if (*loc=='+' || *loc=='-') {if(print)printf("%c",*loc);*id_loc++=*loc++;}
      while (xisdigit(*loc)) {if(print)printf("%c",*loc);*id_loc++=*loc++;}
    }
  }
  while (*loc=='u' || *loc=='U' || *loc=='l' || *loc=='L'
         || *loc=='f' || *loc=='F') {
    *id_loc++='$'; *id_loc++=toupper(*loc); if(print)printf("%c",*loc);loc++;
@z

@x
    delim=*loc++; *++id_loc=delim;
@y
    if(print)printf("%c",*loc);delim=*loc++; *++id_loc=delim;
@z

Gives nothing:
@x
    if (loc>=limit) {
@y
    if (loc>=limit) {
      if(print)printf("\n");
@z

@x
    if ((c=*loc++)==delim) {
@y
    if(print)printf("%c",*loc);
    if ((c=*loc++)==delim) {
@z

@x
        *id_loc = '\\'; c=*loc++;
@y
        *id_loc = '\\'; if(print)printf("%c",*loc);c=*loc++;
@z

@x
@<Get control code and possible section name@>= {
@y
@<Get control code and possible section name@>= {
  if(print&&ccode[(eight_bits)*loc]!=new_section) printf("%c%c",*(loc-1),*loc);
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
    else not_null=1;
  }
@z

@x
  loc++; if (k<section_text_end) k++;
@y
  if(print)printf("%c", *loc);loc++; if (k<section_text_end) k++;
@z

@x
@ @<If end of name...@>=
if (c=='@@') {
  c=*(loc+1);
  if (c=='>') {
@y
@ @<If end of name...@>=
if (c=='@@') {
  if(print)printf("%c",*loc);
  c=*(loc+1);
  if (c=='>') {
    if(print)printf("%c",*(loc+1));
@z

@x
  *(++k)='@@'; loc++; /* now |c==*loc| again */
@y
  *(++k)='@@'; if(print)printf("%c",*loc);loc++; /* now |c==*loc| again */
@z

@x
@<Scan a verbatim string@>= {
  id_first=loc++; *(limit+1)='@@'; *(limit+2)='>';
  while (*loc!='@@' || *(loc+1)!='>') loc++;
  if (loc>=limit) err_print("! Verbatim string didn't end");
@.Verbatim string didn't end@>
  id_loc=loc; loc+=2;
@y
@<Scan a verbatim string@>= {
  if(print)printf("%c",*loc);id_first=loc++; *(limit+1)='@@'; *(limit+2)='>';
  while (*loc!='@@' || *(loc+1)!='>') {if(print)printf("%c",*loc);loc++;}
  if (loc>=limit) err_print("! Verbatim string didn't end");
@.Verbatim string didn't end@>
  id_loc=loc; if(print)printf("%c%c",*loc,*(loc+1));loc+=2;
@z

Do not make index entries for C-part of /dev/null sections:
@x
    next_control=get_next(); outer_xref();
@y
    next_control=get_next();
    if (not_null) outer_xref();
@z

@x
    if (loc<=limit) return(ccode[(eight_bits)*(loc++)]);
@y
    if (loc<=limit) {
      if (ccode[(eight_bits)*loc]>=format_code) {
        if (has_null(section_count)) {
          print = 1;
          fork
          printf("@ ");
          printf("%c%c", *(loc-1), *loc);
        }
      }
      return(ccode[(eight_bits)*(loc++)]);
    }
@z

@x
    if (loc>limit) {
@y
    if (loc>limit) {
      if(print)printf("\n");
@z

@x
    if (c=='|') return(bal);
@y
    if (c=='|') {if(print)printf("%c",*(loc-1));return(bal);}
@z

@x
if (c=='*' && *loc=='/') {
@y
if (c=='*' && *loc=='/') {
  if(print)printf("%c%c",*(loc-1),*loc);
@z

@x
    loc-=2; if (phase==2) *(tok_ptr-1)=' '; goto done;
  }
}
else if (c=='\\' && *loc!='@@')
  if (phase==2) app_tok(*(loc++))@; else loc++;
@y
    loc-=2; if (phase==2) *(tok_ptr-1)=' '; goto done;
  }
  else if(print)printf("%c%c",*(loc-2),*(loc-1));
}
else if (c=='\\' && *loc!='@@')
  if (phase==2) {
    if(print)printf("%c%c",*(loc-1),*loc);
    app_tok(*(loc++))@;
  }
  else loc++;
else if(print&&(loc-1)!=limit)printf("%c",*(loc-1));
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
    if (phase==3) {
      cur_xref=cur_xref->xlink;
      while (cur_xref->num>=def_flag) {
        out_str(", ");
        out_section(cur_xref->num-def_flag);
@y
@<Output a section name@>= {
  sprint_section_name(scratch,cur_name);
  if (phase==3&&strcmp(scratch,"/dev/null")==0) out_ptr=out_buf;
  if (phase==3) {
    if (strcmp(scratch,"/dev/null")!=0) {out_str("\\X");}
  }
  else {out_str("\\X");}
@.\\X@>
  cur_xref=(xref_pointer)cur_name->xref;
  if (cur_xref->num==file_flag) {an_output=1; cur_xref=cur_xref->xlink;}
  else an_output=0;
  if (cur_xref->num>=def_flag) {
    if (phase==3) {
      if (strcmp(scratch,"/dev/null")!=0) {out_section(cur_xref->num-def_flag);}
    }
    else {out_section(cur_xref->num-def_flag);}
    if (phase==3) {
      cur_xref=cur_xref->xlink;
      while (cur_xref->num>=def_flag) {
        if (strcmp(scratch,"/dev/null")!=0) {out_str(", ");}
        if (strcmp(scratch,"/dev/null")!=0) {out_section(cur_xref->num-def_flag);}
@z

@x
  out(':');
  if (an_output) out_str("\\.{"@q}@>);
@.\\.@>
  @<Output the text of the section name@>;
  if (an_output) out_str(@q{@>" }");
  out_str("\\X");
@y
  if (phase==3) {
    if (strcmp(scratch,"/dev/null")!=0) {out(':');}
  }
  else {out(':');}
  if (phase==3) {
    if (strcmp(scratch,"/dev/null")!=0) {if (an_output) out_str("\\.{"@q}@>);}
  }
  else {if (an_output) out_str("\\.{"@q}@>);}
@.\\.@>
  @<Output the text of the section name@>;
  if (phase==3) {
    if (strcmp(scratch,"/dev/null")!=0) {if (an_output) out_str(@q{@>" }");}
  }
  else {if (an_output) out_str(@q{@>" }");}
  if (phase==3) {
    if (strcmp(scratch,"/dev/null")!=0) {out_str("\\X");}
  }
  else {out_str("\\X");}
@z

@x
 default: out(b);
@y
 default: if (phase==3) { if (strcmp(scratch,"/dev/null")!=0) {out(b);}}else{out(b);}
@z

----------- PHASE TWO --------------

@x
  @<Translate the \TEX/ part of the current section@>;
@y
  print=0;
  @<Translate the \TEX/ part of the current section@>;
@z

@x
  finish_C(1);
@y
  finish_C(!has_null(section_count));
  /* TODO: here we call \.{cw} on tex_file_name.section_number
     and print its output to |tex_file| and remove tex_file_name.section_number */
@z

@x
footnote(flag) /* outputs section cross-references */
sixteen_bits flag;
{
@y
footnote(flag) /* outputs section cross-references */
sixteen_bits flag;
{
  if (phase==2&&has_null(section_count)) return;
@z
