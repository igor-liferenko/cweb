@x
@ @<Cases for |sizeof_like|@>=
if (cat1==cast) squash(pp,2,exp,-2,23);
@y
@ @<Cases for |sizeof_like|@>=
if (cat1==cast) {
  big_app1(pp);
  big_app(' ');
  big_app1(pp+1);
  reduce(pp,2,exp,-2,23);
}
@z

-----------------------

Here is the output from @2 of "1*(1+1);" when "d" in rule #11 is -2, -1 and 0 respectively:

11:*exp +ubinop+ +exp+ ;...
11: exp*+ubinop+ +exp+ ;...
11: exp +ubinop+*+exp+ ;...

+ read "The production rules listed above..." section in cweave.w + read cwebman "Further
details about formatting" + read prod.w

@x
if ((cat1==exp||cat1==ubinop) && cat2==rpar) squash(pp,3,exp,-2,11);
@y
if ((cat1==exp||cat1==ubinop) && cat2==rpar) squash(pp,3,exp,-1,11);
@z
