@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr=flags['r']?'u':'c'; tex_printf(flags['r']?"\\input cwebmac-r":"\\input cwebma");
@z
