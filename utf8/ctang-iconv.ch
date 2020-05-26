@x
@<Include files@>@/
@y
#include <iconv.h>
@<Include files@>@/
@z

@x
        printf("Writing the output file (%s):",C_file_name);
@y
iconv_t x = iconv_open("CP866", "UTF-8");
if (x != (iconv_t) -1) {
  size_t C_file_name_size = strlen(C_file_name);
  char *C_file_name_p = C_file_name;
  size_t bufout_size = C_file_name_size;
  char bufout[bufout_size+1];
  char *bufoutp = bufout;
  if (iconv(x, &C_file_name_p, &C_file_name_size, &bufoutp, &bufout_size) != (size_t) -1) {
          bufout[C_file_name_size-bufout_size] = '\0';
          printf("Writing the output file (%s):", bufout);
  }
  else printf("iconv failed\n");
  iconv_close(x);
}
else printf("iconv_open failed\n");
@z

@x
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"') C_putc('\\');
      C_putc(*j);
    }
@y
char bufin[1000];
char *bufinp=bufin;
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"') *bufinp++='\\';
      *bufinp++=*j;
    }
iconv_t x = iconv_open("CP866", "UTF-8");
if (x != (iconv_t) -1) {
  size_t C_file_name_size = bufinp-bufin;
  bufinp = bufin;
  size_t bufout_size = C_file_name_size;
  char bufout[bufout_size+1];
  char *bufoutp = bufout;
  if (iconv(x, &bufinp, &C_file_name_size, &bufoutp, &bufout_size) != (size_t) -1) {
          bufout[C_file_name_size-bufout_size] = '\0';
          C_printf("%s",bufout);
  }
  else printf("iconv failed\n");
  iconv_close(x);
}
else printf("iconv_open failed\n");
@z
