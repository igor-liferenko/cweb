TODO: remove this change-file and restore "@s not_eq normal..." in cweave.w - this
will ensure that original cweave compiles my programs the same way as my cweave
(this is a major difference, whereas for example cweav-prod.ch may be used because
my programs compiled with original cweave will not differ too much), and also
maybe I will need to use C++ (now that I know how to interpret production table
and @2-trace output)

Treat "not_eq" as an identifier (not as an operator), because I use cweave, to which this
change-file is applied, to compile cweb-git/cweave.w,ctangle.w,common.w from which
all extra code was purged (specifically, the "@s not_eq normal" line).

@x
id_lookup("not_eq",NULL,alfop);
@y
@z
