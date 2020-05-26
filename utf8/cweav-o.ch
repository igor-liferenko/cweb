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
