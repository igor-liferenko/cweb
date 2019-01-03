This change-file outputs #line after each #endif.

This change-file is not integrated to cct because I'm not 100% sure that it is correct and it is good to see what changes it makes to be able to control them (for analogous reasons cweav-sub.ch is not integrated to ccw; FIXME: add cweav-prod.ch to ccw?).

@x
@<Global variables@>@/
@y
@<Global variables@>@/
int endif=0;
@z

@x
    else if (c=='#' && loc==buffer+1) preprocessing=1;
@y
    else if (c=='#' && loc==buffer+1) {
      preprocessing=1;
      if (limit-loc>=5 && strncmp("endif",loc,5)==0)
        endif=1;
    }
@z

@x
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400); break;
@y
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400);
  if (endif) {
    if (id_loc-id_first==5) {
      @<Insert the line number into |tok_mem|@>;
    }
    endif=0;
  }
  break;
@z
