Close files explicitly before exit - see explanation in tex/close.ch
@x
  if (history > harmless_message) return(1);
@y
  if (web_file!=NULL) fclose(web_file);
  if (change_file!=NULL) fclose(change_file);
  if (history > harmless_message) return(1);
@z
