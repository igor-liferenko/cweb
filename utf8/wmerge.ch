TODO: only print status if error

Fix:
@x
@:caddr_t}{\bf caddr_t@>
@y
@:caddr_t}{\bf caddr\_t@>
@z

Remove alt file name:
@x
char alt_web_file_name[max_file_name_length]; /* alternate name to try */
@y
@z

Remove alt file name:
@x
  strcpy(web_file_name,alt_web_file_name);
  if ((web_file=fopen(web_file_name,"r"))==NULL)
@y
@z

Fix:
@x
    if (**(++argv)=='-' || **argv=='+') @<Handle flag argument@>@;
@y
    if ((**(++argv)=='-'||**argv=='+')&&*(*argv+1)) @<Handle flag argument@>@;
@z

Remove alt file name:
@x
@ We use all of |*argv| for the |web_file_name| if there is a |'.'| in it,
otherwise we add |".w"|. If this file can't be opened, we prepare an
|alt_web_file_name| by adding |"web"| after the dot.
The other file names come from adding other things
after the dot.  We must check that there is enough room in
|web_file_name| and the other arrays for the argument.
@y
@ We use all of |*argv| for the |web_file_name| if there is a |'.'| in it,
otherwise we add |".w"|.
We must check that there is enough room in
|web_file_name| for the argument.

@z

Remove alt file name:
@x
  sprintf(alt_web_file_name,"%s.web",*argv);
@y
@z

Change default extension of output file:
@x
  if (dot_pos==NULL) sprintf(out_file_name,"%s.out",*argv);
@y
  if (dot_pos==NULL) sprintf(out_file_name,"%s.web",*argv);
@z

Change default extension of output file:
@x
  fatal("! Usage: wmerge webfile[.w] [changefile[.ch] [outfile[.out]]]\n","")@;
@y
  fatal("! Usage: wmerge webfile[.w] [changefile[.ch] [outfile[.web]]]\n","")@;
@z
