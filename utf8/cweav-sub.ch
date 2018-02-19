Substitute C text in /dev/null section.

TODO: use myprintf(...) instead of two consecutive
calls to fprintf(cw_in1, ...) and fprintf(cw_in2, ...)
and remove extra braces

@x
@<Global variables@>@/
@y
@<Global variables@>@/
#include <signal.h>
#include <sys/prctl.h>
FILE *cw_in1;
FILE *cw_in2;
int pipe_read[2];
int pipe_write1[2];
int pipe_write2[2];
int print=0;
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
#define myprintf(...) fprintf(cw_in1, __VA_ARGS__),fprintf(cw_in2, __VA_ARGS__)
@z

@x
    @<Check if we're at the end of a preprocessor command@>;
    if (loc>limit && get_line()==0) return(new_section);
@y
    @<Check if we're at the end of a preprocessor command@>;
    if (loc>limit && get_line()==0) return(new_section);
    if (print) {
      if (loc == limit) myprintf("\n");
      else
        if (*loc != '@@') myprintf("%c", *loc);
    }
@z

@x
while (loc<=buffer_end-7 && xisspace(*loc)) loc++;
@y
while (loc<=buffer_end-7 && xisspace(*loc)) {if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}loc++;}
@z

@x
  while (loc==limit-1 && preprocessing && *loc=='\\')
    if (get_line()==0) return(new_section); /* still in preprocessor mode */
@y
  while (loc==limit-1 && preprocessing && *loc=='\\') {
    if (print) {fprintf(cw_in1,"%c", *loc);fprintf(cw_in2,"%c", *loc);}
    if (get_line()==0) return(new_section); /* still in preprocessor mode */
  }
@z

@x
@d compress(c) if (loc++<=limit) return(c)
@y
@d compress(c) do{if(loc++<=limit){if(print){fprintf(cw_in1,"%c",*(loc-1));
fprintf(cw_in2,"%c",*(loc-1));}return(c);}}while(0)
@z

@x
    else if (*loc=='>') if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
  case '.': if (*loc=='*') {compress(period_ast);}
            else if (*loc=='.' && *(loc+1)=='.') {
              loc++; compress(dot_dot_dot);
@y
    else if (*loc=='>') if (*(loc+1)=='*') {if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}
      loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
  case '.': if (*loc=='*') {compress(period_ast);}
            else if (*loc=='.' && *(loc+1)=='.') {
              if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}loc++; compress(dot_dot_dot);
@z

@x
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc));
@y
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc))
    if(print){fprintf(cw_in1,"%c",*loc);fprintf(cw_in2,"%c",*loc);}
@z

@x
  if (*(loc-1)=='0') {
    if (*loc=='x' || *loc=='X') {*id_loc++='^'; loc++;
      while (xisxdigit(*loc)) *id_loc++=*loc++;} /* hex constant */
    else if (xisdigit(*loc)) {*id_loc++='~';
      while (xisdigit(*loc)) *id_loc++=*loc++;} /* octal constant */
@y
  if (*(loc-1)=='0') {
    if (*loc=='x' || *loc=='X') {*id_loc++='^'; if (print) {fprintf(cw_in1,"%c", *loc);
fprintf(cw_in2,"%c", *loc);} loc++;
      while (xisxdigit(*loc)) {if (print) {fprintf(cw_in1,"%c", *loc);
fprintf(cw_in2,"%c", *loc);}
      *id_loc++=*loc++;}} /* hex constant */
    else if (xisdigit(*loc)) {*id_loc++='~';
      while (xisdigit(*loc)) {if (print) {fprintf(cw_in1,"%c", *loc);
fprintf(cw_in2,"%c", *loc);}
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
    while (xisdigit(*loc) || *loc=='.') {if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}*id_loc++=*loc++;}
    if (*loc=='e' || *loc=='E') { /* float constant */
      *id_loc++='_'; if(print){fprintf(cw_in1,"%c",*loc);fprintf(cw_in2,"%c",*loc);}loc++;
      if (*loc=='+' || *loc=='-') {if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}*id_loc++=*loc++;}
      while (xisdigit(*loc)) {if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}*id_loc++=*loc++;}
    }
  }
  while (*loc=='u' || *loc=='U' || *loc=='l' || *loc=='L'
         || *loc=='f' || *loc=='F') {
    *id_loc++='$'; *id_loc++=toupper(*loc); if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}loc++;
@z

@x
    delim=*loc++; *++id_loc=delim;
@y
    if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}delim=*loc++; *++id_loc=delim;
@z

@x
    if ((c=*loc++)==delim) {
@y
    if(print){fprintf(cw_in1,"%c",*loc);fprintf(cw_in2,"%c",*loc);}
    if ((c=*loc++)==delim) {
@z

@x
        *id_loc = '\\'; c=*loc++;
@y
        *id_loc = '\\'; if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}c=*loc++;
@z

@x
@<Get control code and possible section name@>= {
@y
@<Get control code and possible section name@>= {
  if(print&&ccode[(eight_bits)*loc]!=new_section){fprintf(cw_in1,"%c%c",*(loc-1),*loc);
fprintf(cw_in2,"%c%c",*(loc-1),*loc);}
@z

In phase one mark beginning of new /dev/null section by putting its number into array:
@x
  @<Put section name into |section_text|@>;
@y
  char *k0 = section_text;
  @<Put section name into |section_text|@>;
  if (phase == 1)
    if (cur_section_char=='(' && strncmp("/dev/null",k0+1,k-k0)==0)
      add_null(section_count);
@z

@x
  loc++; if (k<section_text_end) k++;
@y
  if(print){fprintf(cw_in1,"%c", *loc);
fprintf(cw_in2,"%c", *loc);}loc++; if (k<section_text_end) k++;
@z

@x
@ @<If end of name...@>=
if (c=='@@') {
  c=*(loc+1);
  if (c=='>') {
@y
@ @<If end of name...@>=
if (c=='@@') {
  if(print){fprintf(cw_in1,"%c",*loc);fprintf(cw_in2,"%c",*loc);}
  c=*(loc+1);
  if (c=='>') {
    if(print){fprintf(cw_in1,"%c",*(loc+1));fprintf(cw_in2,"%c",*(loc+1));}
@z

@x
  *(++k)='@@'; loc++; /* now |c==*loc| again */
@y
  *(++k)='@@'; if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}loc++; /* now |c==*loc| again */
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
  if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}id_first=loc++; *(limit+1)='@@'; *(limit+2)='>';
  while (*loc!='@@' || *(loc+1)!='>') {if(print){fprintf(cw_in1,"%c",*loc);
fprintf(cw_in2,"%c",*loc);}loc++;}
  if (loc>=limit) err_print("! Verbatim string didn't end");
@.Verbatim string didn't end@>
  id_loc=loc; if(print){fprintf(cw_in1,"%c%c",*loc,*(loc+1));
fprintf(cw_in2,"%c%c",*loc,*(loc+1));}loc+=2;
@z

------------- PHASE ONE ------------------------

Do not make index entries for C-part of /dev/null sections:
@x
    next_control=get_next(); outer_xref();
@y
    next_control=get_next();
    if (!has_null(section_count)) outer_xref();
@z

------------------------------------------------

@x
copy_TeX()
{
  char c; /* current character being copied */
  while (1) {
    if (loc>limit && (finish_line(), get_line()==0)) return(new_section);
    *(limit+1)='@@';
    while ((c=*(loc++))!='|' && c!='@@') {
      out(c);
      if (out_ptr==out_buf+1 && (xisspace(c))) out_ptr--;
    }
    if (c=='|') return('|');
    if (loc<=limit) return(ccode[(eight_bits)*(loc++)]);
  }
}
@y
copy_TeX() /* TeX-part influences how section name in C-part is formed, so start output
              to "cw" with it */
{
  char c; /* current character being copied */
  while (1) {
    if (loc>limit && (finish_line(), get_line()==0)) return(new_section);
    *(limit+1)='@@';
        if (!print && has_null(section_count)) {
          print = 1;
          pid_t cpid;
          if (pipe(pipe_read) == -1) exit(EXIT_FAILURE);
          if (pipe(pipe_write1) == -1) exit(EXIT_FAILURE);
          if (pipe(pipe_write2) == -1) exit(EXIT_FAILURE);
          if ((cpid = fork()) == -1) {
            printf("fork failed\n");
            exit(EXIT_FAILURE);
          }
          if (cpid == 0) {
            dup2(pipe_read[1], 1);
            close(pipe_write1[1]);
            close(pipe_write2[1]);
            char writefd1[10];
            char writefd2[10];
            char secstr[10];
            snprintf(writefd1, 10, "%d", pipe_write1[0]);
            snprintf(writefd2, 10, "%d", pipe_write2[0]);
            snprintf(secstr, 10, "%d", section_count);
            if (prctl(PR_SET_PDEATHSIG, SIGINT) != -1 && /* automatically close window when
                                                    parent exits */
                getppid() != 1) /* make sure that parent did not exit just before |prctl| call */
              execl("/usr/local/bin/cw", "cw", writefd1, writefd2, secstr, (char *) NULL);
            exit(EXIT_FAILURE);
          }
          close(pipe_read[1]);
          cw_in1 = fdopen(pipe_write1[1],"w");
          cw_in2 = fdopen(pipe_write2[1],"w");
          close(pipe_write1[0]);
          close(pipe_write2[0]);
          fprintf(cw_in1,"@@ ");fprintf(cw_in2,"@@ ");
        }
    while ((c=*(loc++))!='|' && c!='@@') {
      out(c);
      if (out_ptr==out_buf+1 && (xisspace(c))) out_ptr--;
      else if (print) {
        if (loc!=(limit+1)) {
          fprintf(cw_in1,"%c",*(loc-1));
          fprintf(cw_in2,"%c",*(loc-1));
        }
        else {fprintf(cw_in1,"\n");fprintf(cw_in2,"\n");}
      }
    }
    if (c=='|') {if(print){fprintf(cw_in1,"%c",*(loc-1));
fprintf(cw_in2,"%c",*(loc-1));}return('|');}
    if (loc<=limit) {if(print){fprintf(cw_in1,"%c%c",*(loc-1),*loc);
fprintf(cw_in2,"%c%c",*(loc-1),*loc);}
return(ccode[(eight_bits)*(loc++)]);}
  }
}
@z

@x
    if (loc>limit) {
@y
    if (loc>limit) {
      if(print){fprintf(cw_in1,"\n");fprintf(cw_in2,"\n");}
@z

@x
    if (c=='|') return(bal);
@y
    if (c=='|') {if(print){fprintf(cw_in1,"%c",*(loc-1));
fprintf(cw_in2,"%c",*(loc-1));}return(bal);}
@z

@x
if (c=='*' && *loc=='/') {
@y
if (c=='*' && *loc=='/') {
  if(print){fprintf(cw_in1,"%c%c",*(loc-1),*loc);fprintf(cw_in2,"%c%c",*(loc-1),*loc);}
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
  else if(print){fprintf(cw_in1,"%c%c",*(loc-2),*(loc-1));
fprintf(cw_in2,"%c%c",*(loc-2),*(loc-1));}
}
else if (c=='\\' && *loc!='@@')
  if (phase==2) {
    if(print){fprintf(cw_in1,"%c%c",*(loc-1),*loc);fprintf(cw_in2,"%c%c",*(loc-1),*loc);}
    app_tok(*(loc++))@;
  }
  else loc++;
else if(print&&(loc-1)!=limit){fprintf(cw_in1,"%c",*(loc-1));fprintf(cw_in2,"%c",*(loc-1));}
@z

----------- PHASE THREE (suppress output of /dev/null section to .scn file) -----------

TODO: check that there are no macros here and remove extra braces

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

-----------------------------------------

FIXME: maybe think if it can be done without "cw" - just substituting proper section number in
section names and changing += to =
Check if it is possible by using finish_C(1) and not using fprintf(active_file...
and then use "ccw" - if its output will be the same as output of "ccw" as it is now, then
it makes no difference and thus can be done without "cw".
@x
  finish_C(1);
@y
  finish_C(!has_null(section_count));
  if (has_null(section_count)) { /* stop output to "cw" and put its output to .tex file */
    print = 0;
    fclose(cw_in1);
    fclose(cw_in2);
    out_ptr = out_buf;
    wchar_t line[buf_size];
    FILE *cw_out = fdopen(pipe_read[0], "r");
    while (fgetws(line, buf_size, cw_out) != NULL)
      fprintf(active_file,"%ls",line); out_line++;
    fclose(cw_out);
    int wstatus;
    wait(&wstatus);
    if (!(WIFEXITED(wstatus)&&WEXITSTATUS(wstatus)==0)) {
      printf("child exited with error\n");
      exit(EXIT_FAILURE);
    }
  }
@z

In |phase_two| skip "See also section(s)" at the end of first /dev/null-section.
In |phase_three| it outputs to .scn file "Used in section(s)"
and "Cited in section(s)" after section name, and |section_count|
stops being updated after |phase_two|, so it has the number of
the last section when |phase_three| is entered into, so if
last section happened to be /dev/null-section, we will break the
.scn file, so we add |phase!=3| check to execute this function in
|phase_three| for all sections.
@x
footnote(flag) /* outputs section cross-references */
sixteen_bits flag;
{
@y
footnote(flag) /* outputs section cross-references */
sixteen_bits flag;
{
  if (section_count == null_sections[0] && phase!=3) return;
@z
