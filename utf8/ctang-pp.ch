See explanation of clang patch in vbox-stage.

For testing take example from email thread to Andreas about clang patch.

Solution: take code from cppp, unifdef or sunifdef (whichever is written
cleaner) and put it below - first process the output and only then print
it to file (all output to file goes through below code - to see this,
uncomment the changes to see that resulting .c file is empty)

 @x
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    C_putc(a); /* a high-bit character can occur in a string */
 @y
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    (void) 0; /* a high-bit character can occur in a string */
 @z

 @x
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
 @y
flush_buffer() /* writes one line to output file */
{
  (void) 0;
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
      (void) 0;
      out_state=normal;
      protect=1; /* newlines should be preceded by |'\\'| */
      while (cur_byte<cur_end) {
        a=*cur_byte++;
        if (cur_byte==cur_end && a=='\n') break; /* disregard a final newline */
        if (out_state==verbatim && a!=string && a!=constant && a!='\n')
          (void) 0; /* a high-bit character can occur in a string */
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
      case '\n': if (protect && out_state!=verbatim) (void) 0;
        if (protect || out_state==verbatim) (void) 0;
        flush_buffer(); if (out_state!=verbatim) out_state=normal; break;
      @/@t\4@>@<Case of an identifier@>;
      @/@t\4@>@<Case of a section number@>;
      @/@t\4@>@<Cases like \.{!=}@>;
      case '=': case '>': (void) 0;
        out_state=normal; break;
      case join: out_state=unbreakable; break;
      case constant: if (out_state==verbatim) {
          out_state=num_or_id; break;
        }
        if(out_state==num_or_id) (void) 0; out_state=verbatim; break;
      case string: if (out_state==verbatim) out_state=normal;
        else out_state=verbatim; break;
      case '/': (void) 0; out_state=post_slash; break;
      case '*': if (out_state==post_slash) (void) 0;
        /* fall through */
      default: (void) 0; out_state=normal; break;
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
case plus_plus: (void) 0; out_state=normal; break;
case minus_minus: (void) 0; out_state=normal; break;
case minus_gt: (void) 0; out_state=normal; break;
case gt_gt: (void) 0; out_state=normal; break;
case eq_eq: (void) 0; out_state=normal; break;
case lt_lt: (void) 0; out_state=normal; break;
case gt_eq: (void) 0; out_state=normal; break;
case lt_eq: (void) 0; out_state=normal; break;
case not_eq: (void) 0; out_state=normal; break;
case and_and: (void) 0; out_state=normal; break;
case or_or: (void) 0; out_state=normal; break;
case dot_dot_dot: (void) 0; out_state=normal;
    break;
case colon_colon: (void) 0; out_state=normal; break;
case period_ast: (void) 0; out_state=normal; break;
case minus_gt_ast: (void) 0; out_state=normal;
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
  if (out_state==num_or_id) (void) 0;
  j=(cur_val+name_dir)->byte_start;
  k=(cur_val+name_dir+1)->byte_start;
  while (j<k) {
    if ((unsigned char)(*j)<0200) (void) 0;
 @z

 @x
      C_printf("%s",translit[z-0200]);
 @y
      (void) 0;
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
  if (cur_val>0) (void) 0;
  else if(cur_val<0) (void) 0;
  else if (protect) {
    cur_byte +=4; /* skip line number and file name */
    cur_char = '\n';
    goto restart;
  } else {
    sixteen_bits a;
    a=0400* *cur_byte++;
    a+=*cur_byte++; /* gets the line number */
    (void) 0;
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"') (void) 0;
      (void) 0;
    }
    (void) 0;
  }
  break;
 @z
