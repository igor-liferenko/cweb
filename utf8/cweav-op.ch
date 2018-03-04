TODO: add the space automatically between sizeof and (type), and
then change 'sizeof @[@](' to 'sizeof (' everywhere
(take changes from
git diff d53c147daeb10f7cf3f8b48625d7acc60c9c5475..71948a02243e4e707c9692c9531d07e922c79977;
NOTE: use "make test" first to check the effect of these changes);
and the same concerns cast if it precedes parentheses - see ~/pcm/generate-tone.w for an example
(because sizeof and (type) are operators, so there _should_ be a space after them)
HINT: compare .tex output with and without (...), e.g.:
  @ @c
  sizeof var;
with
  @ @s type int
  @c
  sizeof (type);
and for cast:
  @ @c
  (int) var;
with
  @ @c
  (int) (var1+var2);
Also, see @[ in cwebman if it explains how to change (type) cast operator.

FIXME: maybe merge cweav-alfop.ch here?
