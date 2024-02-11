Close files explicitly before exit - see explanation in tex/close.ch
@x
  @<Print the job |history|@>;
@y
  @<Print the job |history|@>;
  if (web_file!=NULL) fclose(web_file);
  if (change_file!=NULL) fclose(change_file);
@z
