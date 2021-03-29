@x
@h
@y
#include <locale.h>
#include <wchar.h>
unsigned char xord[65536];
wchar_t xchr[256];
@h
@z

@x
@c
void
common_init()
{
@y
@d invalid_code 0177 /*ASCII code that many systems prohibit in text files*/
@c void common_init() {
  setlocale(LC_CTYPE, "C.UTF-8");
@i ASCII.w
  int i;
  for (i=0; i<=037; i++) xchr[i]=' ';
  for (i=0177; i<=0377; i++) xchr[i]=' ';
@i mapping.w
  for(i=0;i<=65535;i++) xord[i]=invalid_code;
  for(i=0200;i<=0377;i++) xord[xchr[i]]=i;
  for(i=0;i<=0176;i++) xord[xchr[i]]=i;
@z

@x
  register int  c=EOF; /* character read; initialized so some compilers won't complain */
@y
  wchar_t c; /* character read */
@z

@x
  while (k<=buffer_end && (c=getc(fp)) != EOF && c!='\n')
    if ((*(k++) = c) != ' ') limit = k;
  if (k>buffer_end)
    if ((c=getc(fp))!=EOF && c!='\n') {
      ungetc(c,fp); loc=buffer; err_print("! Input line too long");
@y
  while (k<=buffer_end) {
    c=fgetwc(fp);
    if (ferror(fp)) { fprintf(stderr, "File is not UTF-8\n"); exit(1); }
    if (feof(fp) || c==L'\n') break;
    if (c>65535 || xord[c]==invalid_code) {fprintf(stderr, "Invalid character: %lc\n",c);exit(1);}
    if ((*(k++) = xord[c]) != ' ') limit = k;
  }
  if (k>buffer_end) {
    c=fgetwc(fp);
    if (ferror(fp)) { fprintf(stderr, "File is not UTF-8\n"); exit(1); }
    if (!(feof(fp) || c==L'\n')) {
      ungetwc(c,fp); loc=buffer; err_print("! Input line too long");
    }
@z

@x
  if (c==EOF && limit==buffer) return(0);  /* there was nothing after
@y
  if (feof(fp) && limit==buffer) return(0);  /* there was nothing after
@z

@x
    while (*loc!='"' && k<=cur_file_name_end) *k++=*loc++;
@y
    while (*loc!='"' && k<=cur_file_name_end) {
      char mb[MB_CUR_MAX];
      int len = wctomb(mb, xchr[(unsigned char)*loc++]);
      if (k<=cur_file_name_end)
        for (int i = 0; i < len; i++) *k++=mb[i];
      else k=cur_file_name_end+1;
    }
@z

@x
    while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
@y
    while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) {
      char mb[MB_CUR_MAX];
      int len = wctomb(mb, xchr[(unsigned char)*loc++]);
      if (k<=cur_file_name_end)
        for (int i = 0; i < len; i++) *k++=mb[i];
      else k=cur_file_name_end+1;
    }
@z
