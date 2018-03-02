Treat "not_eq" as an identifier (not as an operator), even if "@s not_eq normal" is
not used, because I do not use C++:
@x
id_lookup("not_eq",NULL,alfop);
@y
@z

TODO: see if other "alfop" are necessary in cweave.w

CWEAVE (if "id_lookup...not_eq" is present in cweave.w) uses "not_eq" in a CWEB
program as representative of the "!=" operator:
any occurrence of "not_eq" in a CWEB program is printed as "!=" in TeX output
("@s not_eq normal" in cweave.w is needed to cancel the effect of this id_lookup).
This is necessary in order to correctly process C++ source code that might use
the "not_eq" operator.
This id_lookup call puts the definition of "not_eq" as "alfop" to cweave's tables.
And the @s... line does not make any difference if the id_lookup is not used.