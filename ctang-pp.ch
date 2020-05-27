This change-file outputs #line after each #endif. It is necessary because if a section is expanded inside a false clause of preprocessor conditional, #line directives that are issued are not honored.
This means that when the compiler gives you error messages, or when you debug your program,
the messages refer to wrong line numbers in the CWEB file.

@x
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400); break;
@y
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400);
  if (flags['l'] &&
      *buffer=='#' && id_first==buffer+1 && id_loc-id_first==5 && strncmp("endif",id_first,5)==0)
    {@<Insert the line number into |tok_mem|@>}
  break;
@z
