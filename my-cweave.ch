NOTE: this file is used in texdoc.fn

Use |limit| instead of |buffer_end|.
@x
while (loc<=buffer_end-7 && xisspace(*loc)) loc++;
if (loc<=buffer_end-6 && strncmp(loc,"include",7)==0) sharp_include_line=1;
@y
while (loc<=limit-7 && xisspace(*loc)) loc++;
if (loc<=limit-6 && strncmp(loc,"include",7)==0) sharp_include_line=1;
@z
