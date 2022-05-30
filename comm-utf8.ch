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
@d invalid_code 0177 /* ASCII code that many systems prohibit in text files */
@c void common_init() {
  setlocale(LC_CTYPE, "C.UTF-8");
  xchr[040]=' '; xchr[041]='!'; xchr[042]='"'; xchr[043]='#'; xchr[044]='$'; xchr[045]='%';
  xchr[046]='&'; xchr[047]='\''; xchr[050]='('; xchr[051]=')'; xchr[052]='*'; xchr[053]='+';
  xchr[054]=','; xchr[055]='-'; xchr[056]='.'; xchr[057]='/'; xchr[060]='0'; xchr[061]='1';
  xchr[062]='2'; xchr[063]='3'; xchr[064]='4'; xchr[065]='5'; xchr[066]='6'; xchr[067]='7';
  xchr[070]='8'; xchr[071]='9'; xchr[072]=':'; xchr[073]=';'; xchr[074]='<'; xchr[075]='=';
  xchr[076]='>'; xchr[077]='?'; xchr[0100]='@@'; xchr[0101]='A'; xchr[0102]='B'; xchr[0103]='C';
  xchr[0104]='D'; xchr[0105]='E'; xchr[0106]='F'; xchr[0107]='G'; xchr[0110]='H'; xchr[0111]='I';
  xchr[0112]='J'; xchr[0113]='K'; xchr[0114]='L'; xchr[0115]='M'; xchr[0116]='N'; xchr[0117]='O';
  xchr[0120]='P'; xchr[0121]='Q'; xchr[0122]='R'; xchr[0123]='S'; xchr[0124]='T'; xchr[0125]='U';
  xchr[0126]='V'; xchr[0127]='W'; xchr[0130]='X'; xchr[0131]='Y'; xchr[0132]='Z'; xchr[0133]='[';
  xchr[0134]='\\'; xchr[0135]=']'; xchr[0136]='^'; xchr[0137]='_'; xchr[0140]='`'; xchr[0141]='a';
  xchr[0142]='b'; xchr[0143]='c'; xchr[0144]='d'; xchr[0145]='e'; xchr[0146]='f'; xchr[0147]='g';
  xchr[0150]='h'; xchr[0151]='i'; xchr[0152]='j'; xchr[0153]='k'; xchr[0154]='l'; xchr[0155]='m';
  xchr[0156]='n'; xchr[0157]='o'; xchr[0160]='p'; xchr[0161]='q'; xchr[0162]='r'; xchr[0163]='s';
  xchr[0164]='t'; xchr[0165]='u'; xchr[0166]='v'; xchr[0167]='w'; xchr[0170]='x'; xchr[0171]='y';
  xchr[0172]='z'; xchr[0173]='{'; xchr[0174]='|'; xchr[0175]='}'; xchr[0176]='~';
  int i;
  for (i=0; i<32; i++) xchr[i]=invalid_code;
  for (i=127; i<=255; i++) xchr[i]=invalid_code;
@i mapping.w
  for(i=0;i<=65535;i++) xord[i]=invalid_code;
  for(i=0; i<=255; i++) xord[xchr[i]]=i;
  xord[invalid_code]=invalid_code;
@z

@x
  register int  c=EOF; /* character read; initialized so some compilers won't complain */
@y
  wchar_t c;
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
    if (!(!feof(fp) && c!=L'\n')) break;
    if ((c & 0xffff) != c || xord[c] == invalid_code) {
      fprintf(stderr, "Invalid character: %lc\n",c);
      exit(1);
    }
    if ((*(k++) = xord[c]) != ' ') limit = k;
  }
  if (k>buffer_end) {
    c=fgetwc(fp);
    if (ferror(fp)) { fprintf(stderr, "File is not UTF-8\n"); exit(1); }
    if (!feof(fp) && c!=L'\n') {
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

@x
    else putchar(*k); /* print the characters already read */
@y
    else printf("%lc",xchr[(unsigned char)*k]);
@z

@x
for (k=l; k<limit; k++) putchar(*k); /* print the part not yet read */
@y
for (k=l; k<limit; k++) printf("%lc",xchr[(unsigned char)*k]);
@z
