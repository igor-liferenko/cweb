@x
*out_ptr='c';
@y
*out_ptr='c';
char *web_file_name_p = web_file_name;
while (*web_file_name_p) {
  if (*web_file_name_p < 0) {
    *out_ptr = 'u';
    break;
  }
  web_file_name_p++;
}
@z

@x
tex_printf("\\input cwebma");
@y
if (*out_ptr == 'u') tex_printf("\\input cwebmac-r");
else tex_printf("\\input cwebma");
@z
