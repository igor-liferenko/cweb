This change-file outputs #line after each #endif. It is necessary because if a section is expanded inside a false clause of preprocessor conditional, #line directives that are issued are not honored and thus debugger works incorrectly and error output is wrong.

This change-file is not integrated to cct to ensure that it works correctly (besides, it is the only change-file that is not integrated to "cct", and it is easy to distinguish from possible differences that may appear in output of "cct").
(for analogous reasons cweav-sub.ch is not integrated to ccw; FIXME: add cweav-prod.ch to ccw?)

@x
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400); break;
@y
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400);
  if (*buffer=='#' && id_first==buffer+1 && id_loc-id_first==5 && strncmp("endif",id_first,5)==0) {
    @<Insert the line number into |tok_mem|@>;
  }
  break;
@z
