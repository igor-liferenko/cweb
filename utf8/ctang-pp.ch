TODO: debug on mf/window/wl.w and change /bin/ctangle to ctangle in mf/window/Makefile

For testing use test-pp.w, compiled with clang (go step-by-step in gdb with and without "#if-endif"
block).

As the result of this change-file, this part from test-pp.c:
--------------------
#line 7 "test-pp.w"

int done= 0;
int main(void)
{
char c= '\x1a';
switch(c){
case'\x18':
#if 0
/*2:*/
#line 3 "test-pp.w"

(void)c;

/*:2*/
#line 15 "test-pp.w"

done= 1;
#endif
break;
case'\x12':
--------------------
must be this:
-----------------------
#line 7 "test-pp.w"

int done= 0;
int main(void)
{
char c= '\x1a';
switch(c){
case'\x18':
#if 0

done= 1;
#endif
break;
case'\x12':
-----------------------

Solution: use three phases, instead of two. phase three is the same
as phase two. At the beginning of phase three do "fflush(C_file); phase=3;" and
process mcpp-XXXXXX file with mcpp, and save its output to analogous in-memory file.
In phase two output /*some-bizarre-stringN*:/ instead of /*N:*/, and in phase three
grep some-bizarre-stringN in the output of mcpp before deciding if section N must be gobbled.

Use this command ("2>/dev/null" is to ignore "Can't open include file..." errors - do not pay attention
to them - system header files are just skipped, as required):
mcpp -C -P -W 0 -I- file.c

@x
@<Global variables@>@/
@y
@<Global variables@>@/
char cppname[10000], cppoutname[10000];
int gobble_section=0;
void myprintf(char *msg, char *s)
{
  if (!gobble_section) fprintf(C_file, msg, s);
}
void myputc(int c)
{
  if (!gobble_section) putc(c,C_file);
}
@z

@x
  if ((C_file=fopen(C_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", C_file_name);
@.Cannot open output file@>
  phase_two(); /* output the contents of the compressed tables */
@y
  const char *path = "/tmp/mcpp-XXXXXX";
  strcpy(cppname, path);
  strcpy(cppoutname, path);

  int cppfd = mkstemp(cppname);
  if (cppfd == -1) fatal("! Cannot create temporary file ", cppname);
  C_file=fdopen(cppfd,"w");
  boolean prev_show_banner = show_banner;
  boolean prev_show_progress = show_progress;
  boolean prev_show_happiness = show_happiness;
  show_progress=0;
  show_happiness=0;
  phase_two(); /* output the contents of the compressed tables */
  fflush(C_file);

  int cppoutfd = mkstemp(cppoutname);
  if (cppoutfd == -1) fatal("! Cannot create temporary file ", cppoutname);
  char *cmd[500];
  sprintf(cmd, "mcpp -C -P -W 0 -I- %s 2>/dev/null >%s", cppname, cppoutname);
  system(cmd);
  unlink(cppname);

  if ((C_file=fopen(C_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", C_file_name);
  phase = 3;
  show_banner = prev_show_banner;
  show_progress = prev_show_progress;
  show_happiness = prev_show_happiness;
  phase_two();
  unlink(cppoutname);
@z

@x
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    C_putc(a); /* a high-bit character can occur in a string */
@y
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    myputc(a); /* a high-bit character can occur in a string */
@z

@x
    printf("\n! Not present: <");
    print_section_name(a+name_dir); err_print(">");
@y
    if (phase==3) {
      printf("\n! Not present: <");
      print_section_name(a+name_dir); err_print(">");
    }
@z

@x
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
@y
flush_buffer() /* writes one line to output file */
{
  myputc('\n');
@z

@x
    if (show_progress) {
      printf("\n(%s)",output_file_name); update_terminal;
    }
@y
    if (phase == 3 && show_progress) {
      printf("\n(%s)",output_file_name); update_terminal;
    }
@z

@x
      C_printf("%s","#define ");
      out_state=normal;
      protect=1; /* newlines should be preceded by |'\\'| */
      while (cur_byte<cur_end) {
        a=*cur_byte++;
        if (cur_byte==cur_end && a=='\n') break; /* disregard a final newline */
        if (out_state==verbatim && a!=string && a!=constant && a!='\n')
          C_putc(a); /* a high-bit character can occur in a string */
@y
      myprintf("%s","#define ");
      out_state=normal;
      protect=1; /* newlines should be preceded by |'\\'| */
      while (cur_byte<cur_end) {
        a=*cur_byte++;
        if (cur_byte==cur_end && a=='\n') break; /* disregard a final newline */
        if (out_state==verbatim && a!=string && a!=constant && a!='\n')
          myputc(a); /* a high-bit character can occur in a string */
@z

@x
out_char(cur_char)
eight_bits cur_char;
{
  char *j, *k; /* pointer into |byte_mem| */
restart:
    switch (cur_char) {
      case '\n': if (protect && out_state!=verbatim) C_putc(' ');
        if (protect || out_state==verbatim) C_putc('\\');
        flush_buffer(); if (out_state!=verbatim) out_state=normal; break;
      @/@t\4@>@<Case of an identifier@>;
      @/@t\4@>@<Case of a section number@>;
      @/@t\4@>@<Cases like \.{!=}@>;
      case '=': case '>': C_putc(cur_char); C_putc(' ');
        out_state=normal; break;
      case join: out_state=unbreakable; break;
      case constant: if (out_state==verbatim) {
          out_state=num_or_id; break;
        }
        if(out_state==num_or_id) C_putc(' '); out_state=verbatim; break;
      case string: if (out_state==verbatim) out_state=normal;
        else out_state=verbatim; break;
      case '/': C_putc('/'); out_state=post_slash; break;
      case '*': if (out_state==post_slash) C_putc(' ');
        /* fall through */
      default: C_putc(cur_char); out_state=normal; break;
    }
}
@y
out_char(cur_char)
eight_bits cur_char;
{
  char *j, *k; /* pointer into |byte_mem| */
restart:
    switch (cur_char) {
      case '\n': if (protect && out_state!=verbatim) myputc(' ');
        if (protect || out_state==verbatim) myputc('\\');
        flush_buffer(); if (out_state!=verbatim) out_state=normal; break;
      @/@t\4@>@<Case of an identifier@>;
      @/@t\4@>@<Case of a section number@>;
      @/@t\4@>@<Cases like \.{!=}@>;
      case '=': case '>': myputc(cur_char); myputc(' ');
        out_state=normal; break;
      case join: out_state=unbreakable; break;
      case constant: if (out_state==verbatim) {
          out_state=num_or_id; break;
        }
        if (out_state==num_or_id) myputc(' '); out_state=verbatim; break;
      case string: if (out_state==verbatim) out_state=normal;
        else out_state=verbatim; break;
      case '/': myputc('/'); out_state=post_slash; break;
      case '*': if (out_state==post_slash) myputc(' ');
        /* fall through */
      default: myputc(cur_char); out_state=normal; break;
    }
}
@z

@x
@ @<Cases like \.{!=}@>=
case plus_plus: C_putc('+'); C_putc('+'); out_state=normal; break;
case minus_minus: C_putc('-'); C_putc('-'); out_state=normal; break;
case minus_gt: C_putc('-'); C_putc('>'); out_state=normal; break;
case gt_gt: C_putc('>'); C_putc('>'); out_state=normal; break;
case eq_eq: C_putc('='); C_putc('='); out_state=normal; break;
case lt_lt: C_putc('<'); C_putc('<'); out_state=normal; break;
case gt_eq: C_putc('>'); C_putc('='); out_state=normal; break;
case lt_eq: C_putc('<'); C_putc('='); out_state=normal; break;
case not_eq: C_putc('!'); C_putc('='); out_state=normal; break;
case and_and: C_putc('&'); C_putc('&'); out_state=normal; break;
case or_or: C_putc('|'); C_putc('|'); out_state=normal; break;
case dot_dot_dot: C_putc('.'); C_putc('.'); C_putc('.'); out_state=normal;
    break;
case colon_colon: C_putc(':'); C_putc(':'); out_state=normal; break;
case period_ast: C_putc('.'); C_putc('*'); out_state=normal; break;
case minus_gt_ast: C_putc('-'); C_putc('>'); C_putc('*'); out_state=normal;
    break;
@y
@ @<Cases like \.{!=}@>=
case plus_plus: myputc('+'); myputc('+'); out_state=normal; break;
case minus_minus: myputc('-'); myputc('-'); out_state=normal; break;
case minus_gt: myputc('-'); myputc('>'); out_state=normal; break;
case gt_gt: myputc('>'); myputc('>'); out_state=normal; break;
case eq_eq: myputc('='); myputc('='); out_state=normal; break;
case lt_lt: myputc('<'); myputc('<'); out_state=normal; break;
case gt_eq: myputc('>'); myputc('='); out_state=normal; break;
case lt_eq: myputc('<'); myputc('='); out_state=normal; break;
case not_eq: myputc('!'); myputc('='); out_state=normal; break;
case and_and: myputc('&'); myputc('&'); out_state=normal; break;
case or_or: myputc('|'); myputc('|'); out_state=normal; break;
case dot_dot_dot: myputc('.'); myputc('.'); myputc('.'); out_state=normal;
    break;
case colon_colon: myputc(':'); myputc(':'); out_state=normal; break;
case period_ast: myputc('.'); myputc('*'); out_state=normal; break;
case minus_gt_ast: myputc('-'); myputc('>'); myputc('*'); out_state=normal;
    break;
@z

@x
case identifier:
  if (out_state==num_or_id) C_putc(' ');
  j=(cur_val+name_dir)->byte_start;
  k=(cur_val+name_dir+1)->byte_start;
  while (j<k) {
    if ((unsigned char)(*j)<0200) C_putc(*j);
@y
case identifier:
  if (out_state==num_or_id) myputc(' ');
  j=(cur_val+name_dir)->byte_start;
  k=(cur_val+name_dir+1)->byte_start;
  while (j<k) {
    if ((unsigned char)(*j)<0200) myputc(*j);
@z

@x
      C_printf("%s",translit[z-0200]);
@y
      myprintf("%s",translit[z-0200]);
@z

@x
case section_number:
  if (cur_val>0) C_printf("/*%d:*/",cur_val);
  else if(cur_val<0) C_printf("/*:%d*/",-cur_val);
  else if (protect) {
    cur_byte +=4; /* skip line number and file name */
    cur_char = '\n';
    goto restart;
  } else {
    sixteen_bits a;
    a=0400* *cur_byte++;
    a+=*cur_byte++; /* gets the line number */
    C_printf("\n#line %d \"",a);
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"') C_putc('\\');
      C_putc(*j);
    }
    C_printf("%s","\"\n");
  }
  break;
@y
case section_number:
  if (cur_val>0) {
    if (phase == 2) C_printf("/*some-bizarre-string%d:*/",cur_val);
    else {
      if (!gobble_section) {
        char cmd[1000];
        sprintf(cmd,"grep some-bizarre-string%d %s >/dev/null 2>/dev/null",cur_val,cppoutname);
        if (system(cmd)!=0) gobble_section=cur_val;
      }
      myprintf("/*%d:*/",cur_val);
    }
  }
  else if(cur_val<0) {
    myprintf("/*:%d*/",-cur_val);
    if (gobble_section==-cur_val) gobble_section=-1;
  }
  else if (protect) {
    cur_byte +=4; /* skip line number and file name */
    cur_char = '\n';
    goto restart;
  } else {
    sixteen_bits a;
    a=0400* *cur_byte++;
    a+=*cur_byte++; /* gets the line number */
    myprintf("\n#line %d \"",a);
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"')
        myputc('\\');
      myputc(*j);
    }
    myprintf("%s","\"\n");
    if (gobble_section==-1) gobble_section=0;
  }
  break;
@z
