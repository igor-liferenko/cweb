This change-file outputs #line after each #endif.

This change-file is not integrated to cct because I'm not 100% sure that it is correct and it is good to see what changes it makes to be able to control them (for analogous reasons cweav-sub.ch is not integrated to ccw).

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int myline=0;
char myfile[100];
int mycounter=0;
void myputc(int c)
{
  putc(c,C_file);
  if (c=='#') mycounter=1;
  else if (mycounter==1 && c=='e') mycounter=2;
  else if (mycounter==2 && c=='n') mycounter=3;
  else if (mycounter==3 && c=='d') mycounter=4;
  else if (mycounter==4 && c=='i') mycounter=5;
  else if (mycounter==5 && c=='f') mycounter=6;
  else if (mycounter!=6) mycounter=0;
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
  myline++;
  if (mycounter==6) {
    C_printf("#line %d \"",myline); /* not sure how |cur_line| works (it shows incorrect
      line number), so use my own counter */
    C_printf("%s",myfile);
    C_printf("%s","\"\n");
    mycounter=0;
  }
@z

'#' is output by this
@x
      default: C_putc(cur_char); out_state=normal; break;
@y
      default: myputc(cur_char); out_state=normal; break;
@z

'endif' is output by this
@x
    if ((unsigned char)(*j)<0200) C_putc(*j);
@y
    if ((unsigned char)(*j)<0200) myputc(*j);
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
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    char *myfilep=myfile;
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"')
        { C_putc('\\');  *(myfilep++)='\\'; }
      C_putc(*j); *(myfilep++)=*j;
    }
    *myfilep='\0';
    C_printf("%s","\"\n");
    myline=a;
  }
  break;
@z
