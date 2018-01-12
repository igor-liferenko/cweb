Fix:
@x
@:caddr_t}{\bf caddr_t@>
@y
@:caddr_t}{\bf caddr\_t@>
@z

@x
  char *dot_pos; /* position of |'.'| in the argument */
@y
  char *dot_pos; /* position of |'.'| in the argument */
  char *name_pos; /* file name beginning, sans directory */
@z

Fix:
@x
    if (**(++argv)=='-' || **argv=='+') @<Handle flag argument@>@;
@y
    if ((**(++argv)=='-'||**argv=='+')&&*(*argv+1)) @<Handle flag argument@>@;
@z

@x
      s=*argv;@+dot_pos=NULL;
@y
      s=name_pos=*argv;@+dot_pos=NULL;
@z

@x
        else if (*s=='/') dot_pos=NULL,++s;
@y
        else if (*s=='/') dot_pos=NULL,name_pos=++s;
@z

@x
  *out_file_name='\0'; /* this will print to stdout */
@y
  sprintf(out_file_name,"%s.web",name_pos); /* strip off directory name */
@z
