#include <wchar.h>
#include <locale.h>
int main(void)
{
  setlocale(LC_CTYPE, "C.UTF-8");
  char s[10];
  s[0] = 0176;
  s[1] = 0175;
  s[2] = 0;
  wprintf(L"%s\n", s);
  return 0;
}
