Do not use @s to define common type names (@s puts type name to index).
FIXME: does it make any difference if @s is used in limbo or in middle part?
@x
id_lookup("wchar_t",NULL,raw_int);
@y
id_lookup("wchar_t",NULL,raw_int);
id_lookup("ssize_t",NULL,raw_int);
id_lookup("uint8_t",NULL,raw_int);
id_lookup("uint16_t",NULL,raw_int);
id_lookup("int16_t",NULL,raw_int);
id_lookup("uint32_t",NULL,raw_int);
id_lookup("int32_t",NULL,raw_int);
id_lookup("cchar_t",NULL,raw_int);
id_lookup("pid_t",NULL,raw_int);
id_lookup("pcre2_match_data",NULL,raw_int);
id_lookup("pcre2_code",NULL,raw_int);
id_lookup("sigset_t",NULL,raw_int);
id_lookup("sockaddr_in",NULL,raw_int);
id_lookup("sockaddr",NULL,raw_int);
id_lookup("in_addr",NULL,raw_int);
id_lookup("socklen_t",NULL,raw_int);
@z