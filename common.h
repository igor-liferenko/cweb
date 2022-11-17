% This file is part of CWEB.
% This program by Silvio Levy and Donald E. Knuth
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 3.64 --- February 2017 (works also with later versions)

% Copyright (C) 1987,1990,1993 Silvio Levy and Donald E. Knuth

% Permission is granted to make and distribute verbatim copies of this
% document provided that the copyright notice and this permission notice
% are preserved on all copies.

% Permission is granted to copy and distribute modified versions of this
% document under the conditions for verbatim copying, provided that the
% entire resulting derived work is distributed under the terms of a
% permission notice identical to this one.

% Please send comments, suggestions, etc. to levy@@math.berkeley.edu.

% The next few sections contain stuff from the file |"common.w"| that has
% to be included in both |"ctangle.w"| and |"cweave.w"|. It appears in this
% file |"common.h"|, which needs to be updated when |"common.w"| changes.

First comes general stuff:

@i program.h

@<Common code for \.{CWEAVE} and \.{CTANGLE}@>=
typedef short boolean;
typedef char unsigned eight_bits;
extern boolean program; /* \.{CWEAVE} or \.{CTANGLE}? */
extern int phase; /* which phase are we in? */

@ @<Include files@>=
#include <stdio.h>

@ Code related to the character set:
@^ASCII code dependencies@>

@i charset.h

@<Common code...@>=
char section_text[longest_name+1]; /* name being sought for */
char *section_text_end = section_text+longest_name; /* end of |section_text| */
char *id_first; /* where the current identifier begins in the buffer */
char *id_loc; /* just after the current identifier in the buffer */

@ Code related to input routines:

@d xisalpha(c) (isalpha(c)&&((eight_bits)c<0200))
@d xisdigit(c) (isdigit(c)&&((eight_bits)c<0200))
@i xisspace.h
@d xislower(c) (islower(c)&&((eight_bits)c<0200))
@i xisupper.h
@d xisxdigit(c) (isxdigit(c)&&((eight_bits)c<0200))

@<Common code...@>=
extern char buffer[]; /* where each line of input goes */
extern char *buffer_end; /* end of |buffer| */
extern char *loc; /* points to the next character to be read from the buffer*/
extern char *limit; /* points to the last character in the buffer */

@ Code related to identifier and section name storage:
@i length.h
@i print_id.h
@i llink.h
@i rlink.h
@i root.h
@d chunk_marker 0

@<Common code...@>=
typedef struct name_info {
  char *byte_start; /* beginning of the name in |byte_mem| */
  struct name_info *link;
  union {
    struct name_info *Rlink; /* right link in binary search tree for section
      names */
    char Ilk; /* used by identifiers in \.{CWEAVE} only */
  } dummy;
  char *equiv_or_xref; /* info corresponding to names */
} name_info; /* contains information about an identifier or section name */
typedef name_info *name_pointer; /* pointer into array of \&{name\_info}s */
typedef name_pointer *hash_pointer;
extern char byte_mem[]; /* characters of names */
extern char *byte_mem_end; /* end of |byte_mem| */
extern name_info name_dir[]; /* information about names */
extern name_pointer name_dir_end; /* end of |name_dir| */
extern name_pointer name_ptr; /* first unused position in |name_dir| */
extern char *byte_ptr; /* first unused position in |byte_mem| */
extern name_pointer hash[]; /* heads of hash lists */
extern hash_pointer hash_end; /* end of |hash| */
extern hash_pointer h; /* index into hash-head array */
extern name_pointer id_lookup(); /* looks up a string in the identifier table */
extern name_pointer section_lookup(); /* finds section name */
extern void print_section_name(), sprint_section_name();

@ Code related to error handling:
@i history.h
@d confusion(s) fatal("! This can't happen: ",s)

@<Common...@>=
extern history; /* indicates how bad this run was */
extern err_print(); /* print error message and context */
extern wrap_up(); /* indicate |history| and exit */
extern void fatal(); /* issue error message and die */
extern void overflow(); /* succumb because a table has overflowed */

@ Code related to file handling:
@f line x /* make |line| an unreserved word */
@i max_file_name_length.h
@i cur_file.h
@i cur_file_name.h
@i web_file_name.h
@i cur_line.h

@<Common code...@>=
extern include_depth; /* current level of nesting */
extern FILE *file[]; /* stack of non-change files */
extern FILE *change_file; /* change file */
extern char C_file_name[]; /* name of |C_file| */
extern char tex_file_name[]; /* name of |tex_file| */
extern char idx_file_name[]; /* name of |idx_file| */
extern char scn_file_name[]; /* name of |scn_file| */
extern char file_name[][max_file_name_length];
  /* stack of non-change file names */
extern char change_file_name[]; /* name of change file */
extern line[]; /* number of current line in the stacked files */
extern change_line; /* number of current line in change file */
extern change_depth; /* where \.{@@y} originated during a change */
extern boolean input_has_ended; /* if there is no more input */
extern boolean changing; /* if the current line is from |change_file| */
extern boolean web_file_open; /* if the web file is being read */
extern reset_input(); /* initialize to read the web file and change file */
extern get_line(); /* inputs the next line */
extern check_complete(); /* checks that all changes were picked up */

@ Code related to section numbers:
@<Common code...@>=
typedef unsigned short sixteen_bits;
extern sixteen_bits section_count; /* the current section number */
extern boolean changed_section[]; /* is the section changed? */
extern boolean change_pending; /* is a decision about change still unclear? */
extern boolean print_where; /* tells \.{CTANGLE} to print line and file info */

@ Code related to command line arguments:
@i flags.h

@<Common code...@>=
extern int argc; /* copy of |ac| parameter to |main| */
extern char **argv; /* copy of |av| parameter to |main| */
extern boolean flags[]; /* an option for each 7-bit code */

@ Code relating to output:
@i update_terminal.h
@i term_write.h

@<Common code...@>=
extern FILE *C_file; /* where output of \.{CTANGLE} goes */
extern FILE *tex_file; /* where output of \.{CWEAVE} goes */
extern FILE *idx_file; /* where index from \.{CWEAVE} goes */
extern FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
extern FILE *active_file; /* currently active file for \.{CWEAVE} output */

@ The procedure that gets everything rolling:

@<Common code...@>=
extern void common_init();
