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
#if 1==0
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
#if 1==0

done= 1;
#endif
break;
case'\x12':
-----------------------

Solution: use three phases, instead of two. In phase two do like is now, but output to
an in-memory file and process it with mcpp, and somehow store identifier (a hash of
file content up till current?) together with the section name, and in phase three do the same what is
now in phase two, but before each section expansion grep the identifier in the
file processed with mcpp and decide if the section must be expanded.

Use this command ("2>/dev/null" is to ignore "Can't open include file..." errors - do not pay attention
to them - system header files are just skipped, as required):
mcpp -P -W 0 -I- file.c

call mcpp on partial file? - check
In the following changes instead of stdout use in-memory file like here
https://www.uninformativ.de/blog/postings/2017-02-11/0/POSTING-en.html

@x
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    C_putc(a); /* a high-bit character can occur in a string */
@y
  if (out_state==verbatim && a!=string && a!=constant && a!='\n') {
    C_putc(a); /* a high-bit character can occur in a string */
    putc(a,stdout);
  }
@z

@x
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
@y
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
  putc('\n',stdout);
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
      C_printf("%s","#define ");
      fprintf(stdout,"%s","#define ");
      out_state=normal;
      protect=1; /* newlines should be preceded by |'\\'| */
      while (cur_byte<cur_end) {
        a=*cur_byte++;
        if (cur_byte==cur_end && a=='\n') break; /* disregard a final newline */
        if (out_state==verbatim && a!=string && a!=constant && a!='\n') {
          C_putc(a); /* a high-bit character can occur in a string */
          putc(a,stdout);
        }
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
      case '\n': if (protect && out_state!=verbatim) {
                   C_putc(' ');
                   putc(' ',stdout);
                 }
        if (protect || out_state==verbatim) {
          C_putc('\\');
          putc('\\',stdout);
        }
        flush_buffer(); if (out_state!=verbatim) out_state=normal; break;
      @/@t\4@>@<Case of an identifier@>;
      @/@t\4@>@<Case of a section number@>;
      @/@t\4@>@<Cases like \.{!=}@>;
      case '=': case '>': C_putc(cur_char); C_putc(' ');
                          putc(cur_char,stdout); putc(' ',stdout);
        out_state=normal; break;
      case join: out_state=unbreakable; break;
      case constant: if (out_state==verbatim) {
          out_state=num_or_id; break;
        }
        if(out_state==num_or_id) C_putc(' '); putc(' ',stdout);
                                 out_state=verbatim; break;
      case string: if (out_state==verbatim) out_state=normal;
        else out_state=verbatim; break;
      case '/': C_putc('/'); putc('/',stdout); out_state=post_slash; break;
      case '*': if (out_state==post_slash) C_putc(' '); putc(' ',stdout);
        /* fall through */
      default: C_putc(cur_char); putc(cur_char,stdout); out_state=normal; break;
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
case plus_plus: C_putc('+'); C_putc('+'); putc('+',stdout);putc('+',stdout);
                out_state=normal; break;
case minus_minus: C_putc('-'); C_putc('-'); putc('-',stdout); putc('-',stdout);
                  out_state=normal; break;
case minus_gt: C_putc('-'); C_putc('>'); putc('-',stdout);putc('>',stdout);
               out_state=normal; break;
case gt_gt: C_putc('>'); C_putc('>'); putc('>',stdout);putc('>',stdout);
            out_state=normal; break;
case eq_eq: C_putc('='); C_putc('='); putc('=',stdout);putc('=',stdout);
            out_state=normal; break;
case lt_lt: C_putc('<'); C_putc('<');putc('<',stdout);putc('<',stdout);
            out_state=normal; break;
case gt_eq: C_putc('>'); C_putc('=');putc('>',stdout);putc('=',stdout);
            out_state=normal; break;
case lt_eq: C_putc('<'); C_putc('=');putc('<',stdout);putc('=',stdout);
            out_state=normal; break;
case not_eq: C_putc('!'); C_putc('=');putc('!',stdout);putc('=',stdout);
             out_state=normal; break;
case and_and: C_putc('&'); C_putc('&');putc('&',stdout);putc('&',stdout);
              out_state=normal; break;
case or_or: C_putc('|'); C_putc('|');putc('|',stdout);putc('|',stdout);
            out_state=normal; break;
case dot_dot_dot: C_putc('.'); C_putc('.'); C_putc('.');putc('.',stdout);
                  putc('.',stdout);putc('.',stdout); out_state=normal;
    break;
case colon_colon: C_putc(':'); C_putc(':');putc(':',stdout);
                  putc(':',stdout); out_state=normal; break;
case period_ast: C_putc('.'); C_putc('*');putc('.',stdout);
                 putc('*',stdout); out_state=normal; break;
case minus_gt_ast: C_putc('-'); C_putc('>'); C_putc('*');putc('-',stdout);
                   putc('>',stdout);putc('*',stdout); out_state=normal;
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
  if (out_state==num_or_id) {
    C_putc(' ');
    putc(' ',stdout);
  }
  j=(cur_val+name_dir)->byte_start;
  k=(cur_val+name_dir+1)->byte_start;
  while (j<k) {
    if ((unsigned char)(*j)<0200) {
      C_putc(*j);
      putc(*j,stdout);
    }
@z

@x
      C_printf("%s",translit[z-0200]);
@y
      C_printf("%s",translit[z-0200]);
      fprintf(stdout,"%s",translit[z-0200]);
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
    C_printf("/*%d:*/",cur_val);
    fprintf(stdout,"/*%d:*/",cur_val);
  }
  else if(cur_val<0) {
    C_printf("/*:%d*/",-cur_val);
    fprintf(stdout,"/*:%d*/",-cur_val);
  }
  else if (protect) {
    cur_byte +=4; /* skip line number and file name */
    cur_char = '\n';
    goto restart;
  } else {
    sixteen_bits a;
    a=0400* *cur_byte++;
    a+=*cur_byte++; /* gets the line number */
    C_printf("\n#line %d \"",a);
    fprintf(stdout,"\n#line %d \"",a);
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"') {
        C_putc('\\');
        putc('\\',stdout);
      }
      C_putc(*j);
      putc(*j,stdout);
    }
    C_printf("%s","\"\n");
    fprintf(stdout,"%s","\"\n");
  }
  break;
@z
