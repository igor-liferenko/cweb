Pass section number as third argument to "cw" in order to produce proper section name:
@x
    out_section(cur_xref->num-def_flag);
@y
    out_str(tex_file_name);
@z
