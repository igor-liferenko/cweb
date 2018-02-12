#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv)
{
  (void) argc;
  int pipe1;
  int pipe2;
  char line[100000];
  sscanf(argv[1], "%d", &pipe1);
  sscanf(argv[2], "%d", &pipe2);
  FILE *f1 = fdopen(pipe1,"r");
  FILE *f2 = fdopen(pipe2,"r");
  FILE *out1=fopen("/tmp/1","w");
  FILE *out2=fopen("/tmp/2","w");
  while (fgets(line, 100000, f1) != NULL)
    fprintf(out1,"%s",line);
  fclose(f1);
  fclose(out1);
    while (fgets(line, 100000, f2) != NULL)
    fprintf(out2,"%s",line);
  fclose(f2);
  fclose(out2);
  if (system("diff /tmp/1 /tmp/2")==0) {
    FILE *out=fopen("/tmp/1","r");
    while (fgets(line, 100000, out) != NULL)
      printf("%s",line);
    fclose(out);
  }
  return 0;
}
