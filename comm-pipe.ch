@x
if ((web_file=fopen(web_file_name,"r"))==NULL) {
  strcpy(web_file_name,alt_web_file_name);
  if ((web_file=fopen(web_file_name,"r"))==NULL)
       fatal("! Cannot open input file ", web_file_name);
}
@.Cannot open input file@>
@.Cannot open change file@>
web_file_open=1;
if ((change_file=fopen(change_file_name,"r"))==NULL)
@y
int pipefd;
if (phase==1) {
  sscanf(web_file_name, "%d", &pipefd);
}
if (phase==2) {
  sscanf(change_file_name, "%d", &pipefd);
}
web_file=fdopen(pipefd,"r");
web_file_open=1;

if ((change_file=fopen("/dev/null","r"))==NULL)
@z

@x
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
@y
@z

@x
  if (dot_pos==NULL)
    sprintf(web_file_name,"%s.w",*argv);
  else {
    strcpy(web_file_name,*argv);
    *dot_pos=0; /* string now ends where the dot was */
  }
  sprintf(alt_web_file_name,"%s.web",*argv);
@y
  strcpy(web_file_name,*argv);
@z

@x
  if (strcmp(*argv,"-")==0) found_change=-1;
  else {
    if (s-*argv > max_file_name_length-4)
      @<Complain about argument length@>;
    if (dot_pos==NULL)
      sprintf(change_file_name,"%s.ch",*argv);
    else strcpy(change_file_name,*argv);
    found_change=1;
  }
@y
  found_change=-1;
  if (s-*argv > max_file_name_length-4)
    @<Complain about argument length@>;
  strcpy(change_file_name,*argv);
@z
