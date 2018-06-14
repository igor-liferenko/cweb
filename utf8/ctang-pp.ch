parse preprocessor directives in phase two of ctangle (i.e., after all @d statements were
scanned in phase one) and if there is a false condition,
substitute each input line to empty line on output (non-empty lines
are already output as empty line - e.g., @^...@> HINT: see example below and find in ctangle.w code which does it) in its body - see explanation of clang patch
in vbox-stage

<<<example:
@ @c
int x;
@^test@>
int y;
>>>

for testing take example from email thread to Andreas about clang patch

HINT: find in cweave.w code which corresponds to this extract from cwebman.tex:

    If a \CEE/ preprocessor command is enclosed in \pb,
    the \.\# that introduces it must be at the beginning of a line,
    or \.{CWEAVE} won't print it correctly.

See mcpp.pdf

Solution: make one more program based on ctangle.w which just substitutes @d to #define, and run this program, mcpp and ctangle in a pipeline
