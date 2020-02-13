@x
@d max_bytes 90000 /* the number of bytes in identifiers,
@y
@d max_bytes 150000 /* the number of bytes in identifiers,
@z

@x
@d max_toks 270000 /* number of bytes in compressed \CEE/ code */
@d max_names 4000 /* number of identifiers, strings, section names;
@y
@d max_toks 300000 /* number of bytes in compressed \CEE/ code */
@d max_names 6000 /* number of identifiers, strings, section names;
@z

@x
@d max_texts 2500 /* number of replacement texts, must be less than 10240 */
@y
@d max_texts 10200 /* number of replacement texts, must be less than 10240 */
@z

@x
@d stack_size 50 /* number of simultaneous levels of macro expansion */
@d buf_size 100 /* for \.{CWEAVE} and \.{CTANGLE} */
@y
@d stack_size 4000 /* number of simultaneous levels of macro expansion */
@d buf_size 5000 /* for \.{CWEAVE} and \.{CTANGLE} */
@z
