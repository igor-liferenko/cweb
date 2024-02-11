see explanation in tex/close.ch

CWEAVE in phase_two() opens files second time without closing.
So, previous handles just hang in memory without any references left for it,
and closed by OS when program exits. Close them explicitly.
@x
@<Open input files@>=
@y
@<Open input files@>=
if (web_file!=NULL) fclose(web_file);
if (change_file!=NULL) fclose(change_file);
@z

Close files before exit.
@x
  if (history > harmless_message) return(1);
@y
  if (web_file!=NULL) fclose(web_file);
  if (change_file!=NULL) fclose(change_file);
  if (history > harmless_message) return(1);
@z
