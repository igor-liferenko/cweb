TODO: add the space automatically between sizeof and (type), and
then change 'sizeof @[@](' to 'sizeof (' everywhere;
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
