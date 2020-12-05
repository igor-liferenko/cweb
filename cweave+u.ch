NOTE: \nocon is explained in README.contentspagenumber
@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr=flags['u']?'x':'c'; tex_printf(flags['u']?"\\input cwebmac \\nocon \\input duple":"\\input cwebma");
@z
