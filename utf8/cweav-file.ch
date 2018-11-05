Do not create empty output file if input file does not exist
(works in conjunction with comm-file.ch and ctang-file.ch).

@x
out_ptr=out_buf+1; out_line=1; active_file=tex_file;
*out_ptr='c'; tex_printf("\\input cwebma");
@y
out_ptr=out_buf+1; out_line=1;
*out_ptr='c';
@z

@x
@.Writing the output file...@>
@y
@.Writing the output file...@>
if ((tex_file=fopen(tex_file_name,"w"))==NULL)
  fatal("! Cannot open output file ", tex_file_name);
@.Cannot open output file@>
active_file=tex_file;
tex_printf("\\input cwebma");
@z
