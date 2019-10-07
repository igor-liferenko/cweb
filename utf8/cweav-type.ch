Do not use @s to define common type names (@s puts type name to index).
FIXME: does it make any difference if @s is used in limbo or in middle part?
@x
id_lookup("wchar_t",NULL,raw_int);
@y
id_lookup("wchar_t",NULL,raw_int);
id_lookup("ssize_t",NULL,raw_int);
id_lookup("uint8_t",NULL,raw_int);
id_lookup("int8_t",NULL,raw_int);
id_lookup("uint16_t",NULL,raw_int);
id_lookup("int16_t",NULL,raw_int);
id_lookup("uint32_t",NULL,raw_int);
id_lookup("int32_t",NULL,raw_int);
id_lookup("cchar_t",NULL,raw_int);
id_lookup("pid_t",NULL,raw_int);
id_lookup("pcre2_match_data",NULL,raw_int);
id_lookup("pcre2_code",NULL,raw_int);
id_lookup("sockaddr_in",NULL,raw_int);
id_lookup("sockaddr",NULL,raw_int);
id_lookup("in_addr",NULL,raw_int);
id_lookup("socklen_t",NULL,raw_int);
id_lookup("termios",NULL,raw_int);
id_lookup("sigaction",NULL,raw_int);
@z

NOTE: keywords which are manipulated via @t + @: (like sigaction) cannot be used via @s - only here (because they will be added to index where they are changed via @t - there is no way to remove them from index; but if they are added here, they are not put to index; this creates problems for naming the included types after #include - to track them. There is no workaround for this, except adding @: explicitly everywhere where they occur)
TODO: leave here only sigaction and keywords which can be compiled without any #include's, and in programs that use sigaction add @:sigaction}\&{sigaction@> for every occurrence of type name
for example, to check that pid_t is in unistd.h, compile this program
void main(void)
{
  pid_t x;
}
