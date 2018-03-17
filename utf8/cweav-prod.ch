TODO: remove @[@] everywhere in grep ~/
TODO: apply this change-file to cweb-git/cweave.w
Change 'sizeof(' to 'sizeof (' and '(type)(' to '(type) (' in woven output
(because sizeof and (type) are operators, so there _should_ be a space after them, and because
if an ordinary variable follows sizeof and cast there is a space).

Compare .tex output with and without (...), e.g.:
  @ @c
  sizeof var;
with
  @ @s type int
  @c
  sizeof (type);
and for cast:
  @ @c
  (int) var;
and
  @ @c
  x = (char)~(1<<7);
with
  @ @c
  (int) (var1+var2);
TODO: see diff of woven output from 2nd and 5th examples above before and after
applying this change-file---разобраться с mathness и что значит + - в @2

@x
@ @<Cases for |cast|@>=
if (cat1==lpar) squash(pp,2,lpar,-1,21);
@y
@ @<Cases for |cast|@>=
if (cat1==lpar) {
  big_app1(pp);
  big_app(' ');
  big_app1(pp+1);
  reduce(pp,2,lpar,-1,21);
}
@z

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

Explanation of |d| argument of |reduce|:

Here is the output from @2 of "1*(1+1);" when |d| in rule #11 is -2, -1 and 0 respectively:

11:*exp +ubinop+ +exp+ ;...
11: exp*+ubinop+ +exp+ ;...
11: exp +ubinop+*+exp+ ;...

+ read "The production rules listed above..." section in cweave.w + read cwebman "Further
details about formatting" + read prod.w
