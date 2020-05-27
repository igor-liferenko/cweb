@x
@ @<Cases for |cast|@>=
if (cat1==lpar) squash(pp,2,lpar,-1,21);
@y
@ @<Cases for |cast|@>=
if (cat1==lpar) {
  if (flags['c']) {
    big_app1(pp);
    big_app(' ');
    big_app1(pp+1);
    reduce(pp,2,lpar,-1,21);
  }
  else squash(pp,2,lpar,-1,21);
}
@z
