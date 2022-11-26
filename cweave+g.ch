First line of function on the same line as opening brace (not on the next line).
In @d with braces put opening brace on the same line an #define (not on a separate line).

@x
  big_app(force); big_app1(pp);  big_app(indent); big_app(force);
@y
  big_app(flags['g'] ? break_space : force); big_app1(pp);
  big_app(indent); big_app(flags['g'] ? break_space : force); 
@z
