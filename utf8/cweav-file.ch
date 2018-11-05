Do not create empty output file if input file does not exist
(works in conjunction with comm-file.ch and ctang-file.ch).

@x
`\.{\\input cwebmac}'.

@<Set init...@>=
@y
`\.{\\input cwebmac}'.

@<Start writing the output file@>=
@z

@x
@.Writing the output file...@>
@y
@.Writing the output file...@>
if ((tex_file=fopen(tex_file_name,"w"))==NULL)
  fatal("! Cannot open output file ", tex_file_name);
@.Cannot open output file@>
@<Start writing...@>@;
@z
