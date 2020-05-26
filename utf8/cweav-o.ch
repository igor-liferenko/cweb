@x
else if (cat1==stmt || cat1==function) {
  big_app1(pp); big_app(big_force);
  big_app1(pp+1); reduce(pp,2,cat1,-1,41);
}
@y
else if (cat1==stmt || cat1==function) {
  big_app1(pp);
  if(flags['o']) big_app(big_force);
  else big_app(force);
  big_app1(pp+1); reduce(pp,2,cat1,-1,41);
}
@z

@x
if (cat1==stmt||cat1==decl||cat1==function) {
  big_app1(pp);
  if (cat1==function) big_app(big_force);
  else if (cat1==decl) big_app(big_force);
  else if (force_lines) big_app(force);
  else big_app(break_space);
  big_app1(pp+1); reduce(pp,2,cat1,-1,76);
}
@y
if (cat1==stmt||cat1==decl||cat1==function) {
  big_app1(pp);
  if (cat1==function) big_app(big_force);
  else if (cat1==decl) {
    if (flags['o']) big_app(force);
    else big_app(force);
  }
  else if (force_lines) big_app(force);
  else big_app(break_space);
  big_app1(pp+1); reduce(pp,2,cat1,-1,76);
}
@z
