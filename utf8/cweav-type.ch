@x
id_lookup("wchar_t",NULL,raw_int);
@y
id_lookup("wchar_t",NULL,raw_int);
@z

s/wchar_t/wint_t/; print; s/wint_t/ssize_t/; print; s/ssize_t/uint8_t/; print; s/uint8_t/uint16_t/; print; s/uint16_t/uint32_t/; print; s/uint32_t/int32_t/; print; s/int32_t/cchar_t/; print; s/cchar_t/pid_t/; print; s/pid_t/int16_t/
