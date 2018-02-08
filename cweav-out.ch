Allow to use trick in cweav-tran.ch and output to stdout
(works in conjunction with utf8/comm-file.ch).

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
tex_file=stdout;
@<Start writing...@>@;
@.Writing the output file...@>
@z
