Use only CWEBINPUTS (TL's ctangle and ctie use ".:" prefix).
@x
    if ((l=strlen(kk))>max_file_name_length-2) too_long();
    strcpy(temp_file_name,kk);
@y
    if ((l=strlen(strchr(kk,':')+1))>max_file_name_length-2) too_long();
    strcpy(temp_file_name,strchr(kk,':')+1);
@z
