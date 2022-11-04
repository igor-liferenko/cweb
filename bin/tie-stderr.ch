@x
@d print3(a,b,c)  fprintf(term_out,a,b,c) /* same with three arguments */
@y
@d print3(a,b,c)  fprintf(stderr,a,b,c) /* same with three arguments */
@z

@x
@d err_print(m)  { @+ print_nl(m); error_loc
@y
@d err_print(m)  { @+ new_line(stderr); print3("%s%s",m,""); error_loc
@z

@x
         print(m); print_c('.'); history=fatal;
	 term_new_line; jump_out();
@y
         print3("%s%s",m,""); fputc('.',stderr); history=fatal;
	 new_line(stderr); jump_out();
@z

@x
      case spotless: msg="No errors were found"; break;
@y
      case spotless: msg="No errors were found";
        print2_nl("(%s.)",msg); term_new_line;
        break;
@z

@x
      case troublesome: msg="Pardon me, but I think I spotted something wrong.";
@y
      case troublesome: msg="Pardon me, but I think I spotted something wrong.";
        new_line(stderr); print3("(%s.)%s",msg,""); new_line(stderr);
@z

@x
      case fatal: msg="That was a fatal error, my friend";  break;
@y
      case fatal: msg="That was a fatal error, my friend";
        new_line(stderr); print3("(%s.)%s",msg,""); new_line(stderr);
        break;
@z

@x
   print2_nl("(%s.)",msg);  term_new_line;
@y
@z
