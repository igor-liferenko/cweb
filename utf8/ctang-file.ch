@x
  phase_one(); /* read all the user's text and compress it into |tok_mem| */
  phase_two(); /* output the contents of the compressed tables */
@y
  phase_one(); /* read all the user's text and compress it into |tok_mem| */

  const char tmpl[] = "/mcpp-XXXXXX";
  const char *path;
  path = getenv("XDG_RUNTIME_DIR"); /* stored in volatile memory instead of a persistent storage
                                       device */
//  if (path == NULL) return 0;
  strcat(strcpy(cppname, path), tmpl);
  int cppfd = mkstemp(cppname);
//  if (cppfd == -1) return 0;
  if ((C_file=fdopen(cppfd,"w"))==NULL)
    fatal("! Cannot open output file ", C_file_name);
@.Cannot open output file@>
  boolean prev_show_progress = show_progress;
  boolean prev_show_happiness = show_happiness;
  show_progress=0;
  show_happiness=0;
  phase_two(); /* output the contents of the compressed tables */
  fflush(C_file);
  strcat(strcpy(cppoutname, path), tmpl);
  int cppoutfd = mkstemp(cppoutname);
//  if (cppoutfd == -1) return 0;
  char *cmd[500];
  sprintf(cmd, "mcpp -C -P -W 0 -I- %s 2>/dev/null >%s", cppname, cppoutname);
  system(cmd);
  if ((C_file=fopen(C_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", C_file_name);
@.Cannot open output file@>
  phase = 3;
  show_progress = prev_show_progress;
  show_happiness = prev_show_happiness;
  phase_two();
/*  if (cppfd != -1)
    unlink(cppname);
  if (cppoutfd != -1)
    unlink(cppoutname);
*/
@z
