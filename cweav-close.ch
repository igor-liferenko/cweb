Close open input files before opening them second time.

See also comm-close.ch

@x
void phase_two();
@y
void phase_two();
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
