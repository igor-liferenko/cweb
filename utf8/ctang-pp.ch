parse preprocessor directives in phase two of ctangle (i.e., after all @d statements were
scanned in phase one) and if there is a false condition,
substitute each input line to empty line on output (with the exception of non-empty lines
which are normally not output - see S79 of cweave.w ???) in its body - see explanation of clang patch
in vbox-stage

for testing take example from email thread to Andreas about clang patch 

HINT: find in cweave.w code which corresponds to this extract from cwebman.tex:

    If a \CEE/ preprocessor command is enclosed in \pb,
    the \.\# that introduces it must be at the beginning of a line,
    or \.{CWEAVE} won't print it correctly.
