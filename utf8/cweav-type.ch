Do not use @s to define common type names (@s puts type name to index).
FIXME: does it make any difference if @s is used in limbo or in middle part?

TODO: move from here to types.w which do not compile without any includes (see example in end of file)

@x
id_lookup("wchar_t",NULL,raw_int);
@y
id_lookup("sigaction",NULL,raw_int);
@z

NOTE: keywords which are manipulated via @t + @: (like sigaction) cannot be used via @s - only here (because they will be added to index where they are changed via @t - there is no way to remove them from index; but if they are added here, they are not put to index; this creates problems for naming the included types after #include - to track them. There is no workaround for this, except adding @: explicitly everywhere where they occur)
TODO: leave here only sigaction and keywords which can be compiled without any #include's, and in programs that use sigaction add @:sigaction}\&{sigaction@> for every occurrence of type name
