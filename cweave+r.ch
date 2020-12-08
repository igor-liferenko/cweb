@x
*out_ptr=flags['u']?'x':'c'; tex_printf(flags['u']?"\\input cwebmac \\nocon \\input duple":"\\input cwebma");
@y
*out_ptr=flags['u']?'x':(flags['r']?'u':'c');
tex_printf(flags['u']?(flags['r']?"\\input cwebmac-ru \\nocon \\input duple":"\\input cwebmac \\nocon \\input duple"):(flags['r']?"\\input cwebmac-r":"\\input cwebma"));
@z
