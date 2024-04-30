Close open input files before exiting.
Otherwise they will be closed automatically,
which may result to "Segmentation fault" on
old systems (due to the glibc bug in handling
wide-character streams).

See also cweav-close.ch

@x
  if (history > harmless_message) return(1);
@y
  fclose(web_file);
  fclose(change_file);
  if (history > harmless_message) return(1);
@z
