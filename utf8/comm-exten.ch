This change turns this ... :

$ cweave nonexistent
This is CWEAVE (Version 3.64)
! Cannot open input file nonexistent.web
(That was a fatal error, my friend.)
$ cweave nonexistent.w
This is CWEAVE (Version 3.64)
! Cannot open input file nonexistent.web
(That was a fatal error, my friend.)
$ cweave nonexistent.any
This is CWEAVE (Version 3.64)
! Cannot open input file nonexistent.web
(That was a fatal error, my friend.)

... into this:

$ cweave nonexistent
This is CWEAVE (Version 3.64)
! Cannot open input file nonexistent.w
(That was a fatal error, my friend.)
$ cweave nonexistent.w
This is CWEAVE (Version 3.64)
! Cannot open input file nonexistent.w
(That was a fatal error, my friend.)
$ cweave nonexistent.any
This is CWEAVE (Version 3.64)
! Cannot open input file nonexistent.any
(That was a fatal error, my friend.)

@x
  strcpy(web_file_name,alt_web_file_name);
  if ((web_file=fopen(web_file_name,"r"))==NULL)
       fatal("! Cannot open input file ", web_file_name);
@y
  if ((web_file=fopen(alt_web_file_name,"r"))==NULL)
       fatal("! Cannot open input file ", web_file_name);
  strcpy(web_file_name,alt_web_file_name);
@z
