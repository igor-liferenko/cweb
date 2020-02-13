@x
@d max_bytes 90000 /* the number of bytes in identifiers,
@y
@d max_bytes 150000 /* the number of bytes in identifiers,
@z

@x
@d max_names 4000 /* number of identifiers, strings, section names;
@y
@d max_names 6000 /* number of identifiers, strings, section names;
@z

@x
@d max_sections 2000 /* greater than the total number of sections */
@y
@d max_sections 4000 /* greater than the total number of sections */
@z

@x
@d buf_size 100 /* maximum length of input line, plus one */
@y
@d buf_size 5000 /* maximum length of input line, plus one */
@z

@x
@d line_length 80 /* lines of \TEX/ output have at most this many characters;
@y
@d line_length 255 /* lines of \TEX/ output have at most this many characters;
@z

@x
@d max_refs 20000 /* number of cross-references; must be less than 65536 */
@d max_toks 20000 /* number of symbols in \CEE/ texts being parsed;
@y
@d max_refs 40000 /* number of cross-references; must be less than 65536 */
@d max_toks 65000 /* number of symbols in \CEE/ texts being parsed;
@z

@x
@d max_texts 4000 /* number of phrases in \CEE/ texts being parsed;
@y
@d max_texts 10200 /* number of phrases in \CEE/ texts being parsed;
@z

@x
@d max_scraps 2000 /* number of tokens in \CEE/ texts being parsed */
@d stack_size 400 /* number of simultaneous output levels */
@y
@d max_scraps 65000 /* number of tokens in \CEE/ texts being parsed */
@d stack_size 4000 /* number of simultaneous output levels */
@z
