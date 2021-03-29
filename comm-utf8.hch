@x
@d term_write(a,b) fflush(stdout),fwrite(a,sizeof(char),b,stdout)
@y
@d term_write(a,b) do { fflush(stdout);
  for (int i = 0; i < b; i++)
    if (*(a+i)=='\n') new_line;
    else printf("%lc",xchr[(unsigned char) *(a+i)]);
} while (0)
@z
