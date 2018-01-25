@x
*out_ptr='c'; tex_printf("\\input cwebma");
@y
*out_ptr='l';
@z

@x
@.Writing the output file...@>
@y
{
  wchar_t line[buf_size];
  FILE *fp = fopen(web_file_name, "r");
  if (fgetws(line, buf_size, fp) != NULL)
    if (wcsstr(line, L"%&") == line)
      fprintf(active_file, "%ls", line);
  fclose(fp);
  if (wcsstr(line, L"%&lhplain") == line)
    *out_ptr='r';
}
tex_printf("\\input cwebma");
@.Writing the output file...@>
@z
