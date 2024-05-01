see explanation in tex/close.ch

Close files before exit.

@x
  if (history > harmless_message) return(1);
@y
  fclose(web_file);
  fclose(change_file);
  if (history > harmless_message) return(1);
@z
