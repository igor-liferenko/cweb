For testing use test-pp.w, compiled with clang (go step-by-step in gdb with and without "#if-endif"
block). After you finish this change-file, remove test-pp.w

This change-file must add #line after each #endif

when #line is output, increase global counter on each output of \n, and when you output #endif, output #line

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int myline=0;
@z

@x
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
@y
flush_buffer() /* writes one line to output file */
{
  if (!myline) printf("add if myline check to printf debug\n");
  printf("DEBUG: line %d\n", myline);
  myline++;
  C_putc('\n');
@z


detect #endif here:

      default: C_putc(cur_char); out_state=normal; break;

      if ((unsigned char)(*j)<0200) C_putc(*j);

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
  }
  else if(cur_val<0) {
    C_printf("/*:%d*/",-cur_val);
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
    printf("DEBUG: ");
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"')
        { C_putc('\\');  printf('\\'); }
      C_putc(*j);
      putchar(*j);
    }
    C_printf("%s","\"\n");
    printf(" line %d\n", a);
    myline=a;
  }
  break;
@z
