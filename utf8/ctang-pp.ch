This change-file outputs #line after each #endif.

This change-file is not integrated to cct because I'm not 100% sure that it is correct and it is good to see what changes it makes to be able to control them (for analogous reasons cweav-sub.ch is not integrated to ccw; FIXME: add cweav-prod.ch to ccw?).

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
