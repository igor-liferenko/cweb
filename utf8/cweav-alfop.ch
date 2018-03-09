Treat "not_eq" as an identifier (not as an operator), because I use cweave to which this
change-file is applied to compile cweb-git/cweave.w,ctangle.w,common.w from which
all extra code was purged (specifically, the "@s not_eq normal" line), and using the cweave
makes no differnce for files which have this line.

@x
id_lookup("not_eq",NULL,alfop);
@y
@z
