Close open input files before opening them second time.
Otherwise they will be closed automatically (when the program exits),
which may result to "Segmentation fault" on
old systems (due to the glibc bug in handling
wide-character streams).

@x
@c @<Include files@>@/
@y
@c @<Include files@>@/
extern FILE *file[];
extern FILE *change_file;
@z

@x
phase_two() {
@y
phase_two() {
fclose(file[0]); /* web_file */
fclose(change_file);
@z
