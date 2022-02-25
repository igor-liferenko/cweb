@x
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400); break;
@y
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400);
  if (*buffer=='#' && (
      ( id_loc-id_first==5 && strncmp("endif",id_first,5)==0 ) ||
      ( id_loc-id_first==4 && strncmp("else",id_first,4)==0 ) ||
      ( id_loc-id_first==4 && strncmp("elif",id_first,4)==0 ) ) )
    print_where=true;
  break;
@z
