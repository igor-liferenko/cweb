@x
char alt_web_file_name[max_file_name_length]; /* alternate name to try */
@y
@z

Fix:
@x
@:caddr_t}{\bf caddr_t@>
@y
@:caddr_t}{\bf caddr\_t@>
@z

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

@x
@ We use all of |*argv| for the |web_file_name| if there is a |'.'| in it,
otherwise we add |".w"|. If this file can't be opened, we prepare an
|alt_web_file_name| by adding |"web"| after the dot.
The other file names come from adding other things
@y
@ We use all of |*argv| for the |web_file_name| if there is a |'.'| in it,
otherwise we add |".w"|.
The other file names come from adding corresponding things
@z

@x
  sprintf(alt_web_file_name,"%s.web",*argv);
@y
@z

@x
  if (dot_pos==NULL) sprintf(out_file_name,"%s.out",*argv);
@y
  if (dot_pos==NULL) sprintf(out_file_name,"%s.web",*argv);
@z

@x
  fatal("! Usage: wmerge webfile[.w] [changefile[.ch] [outfile[.out]]]\n","")@;
@y
  fatal("! Usage: wmerge webfile[.w] [changefile[.ch] [outfile[.web]]]\n","")@;
@z

TODO: remove substituting .web
