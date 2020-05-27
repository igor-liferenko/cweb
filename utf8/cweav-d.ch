@x
@ @<Cases for |sizeof_like|@>=
if (cat1==cast) squash(pp,2,exp,-2,23);
@y
@ @<Cases for |sizeof_like|@>=
if (cat1==cast) {
  if (flags['d']) {
    big_app1(pp);
    big_app(' ');
    big_app1(pp+1);
    reduce(pp,2,exp,-2,23);
  }
  else squash(pp,2,exp,-2,23);
}
@z
