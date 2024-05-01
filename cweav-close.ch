see explanation in tex/close.ch

CWEAVE in phase_two() opens files second time without closing.
So, previous handles just hang in memory without any references left for it.

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
