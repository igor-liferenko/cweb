\ifnum\pageshift0 \else
  \pdfhorigin=1.5cm \advance\pageshift-2\pdfhorigin \fi
% This file is part of CWEB.
% This program by Silvio Levy and Donald E. Knuth
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 3.64 --- February 2002
% (same as Version 3.5 except for minor corrections)
% (also quotes backslashes in file names of #line directives)

% Copyright (C) 1987,1990,1993,2000 Silvio Levy and Donald E. Knuth

% Permission is granted to make and distribute verbatim copies of this
% document provided that the copyright notice and this permission notice
% are preserved on all copies.

% Permission is granted to copy and distribute modified versions of this
% document under the conditions for verbatim copying, provided that the
% entire resulting derived work is given a different name and distributed
% under the terms of a permission notice identical to this one.

% Here is TeX material that gets inserted after \input cwebmac
\def\hang{\hangindent 3em\indent\ignorespaces}
\def\pb{$\.|\ldots\.|$} % C brackets (|...|)
\def\v{\char'174} % vertical (|) in typewriter font
\mathchardef\RA="3221 % right arrow
\mathchardef\BA="3224 % double arrow

\def\title{CTANGLE (Version 3.64)}
\def\topofcontents{\null\vfill
  \centerline{\titlefont The {\ttitlefont CTANGLE} processor}
  \vskip 15pt
  \centerline{(Version 3.64)}
  \vfill}
\def\botofcontents{\vfill
\noindent
Copyright \copyright\ 1987, 1990, 1993, 2000 Silvio Levy and Donald E. Knuth
\bigskip\noindent
Permission is granted to make and distribute verbatim copies of this
document provided that the copyright notice and this permission notice
are preserved on all copies.

\smallskip\noindent
Permission is granted to copy and distribute modified versions of this
document under the conditions for verbatim copying, provided that the
entire resulting derived work is given a different name and distributed
under the terms of a permission notice identical to this one.
}
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iftrue
@s not_eq normal @q unreserve a C++ keyword @>

@** Introduction.
This is the \.{CTANGLE} program by Silvio Levy and Donald E. Knuth,
based on \.{TANGLE} by Knuth.
We are thankful to
Nelson Beebe, Hans-Hermann Bode (to whom the \CPLUSPLUS/ adaptation is due),
Klaus Guntermann, Norman Ramsey, Tomas Rokicki, Joachim Schnitter,
Joachim Schrod, Lee Wittenberg, and others who have contributed improvements.

The ``banner line'' defined here should be changed whenever \.{CTANGLE}
is modified.

@d banner "This is CTANGLE (Version 3.64)\n"

@c
@<Include files@>@/
@h
@<Common code for \.{CWEAVE} and \.{CTANGLE}@>@/
@<Typedef declarations@>@/
@<Global variables@>@/
@<Predeclaration of procedures@>@/

@ We predeclare several standard system functions here instead of including
their system header files, because the names of the header files are not as
standard as the names of the functions. (For example, some \CEE/ environments
have \.{<string.h>} where others have \.{<strings.h>}.)

@<Predecl...@>=
extern int strlen(); /* length of string */
extern int strcmp(); /* compare strings lexicographically */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */

@ \.{CTANGLE} has a fairly straightforward outline.  It operates in
two phases: First it reads the source file, saving the \CEE/ code in
compressed form; then it shuffles and outputs the code.

Please read the documentation for \.{common}, the set of routines common
to \.{CTANGLE} and \.{CWEAVE}, before proceeding further.

@c
int main (ac, av)
int ac;
char **av;
{
  argc=ac; argv=av;
  program=ctangle;
  @<Set initial values@>;
  common_init();
  if (show_banner) printf(banner); /* print a ``banner line'' */
  phase_one(); /* read all the user's text and compress it into |tok_mem| */
  phase_two(); /* output the contents of the compressed tables */
  return wrap_up(); /* and exit gracefully */
}

@ The following parameters were sufficient in the original \.{TANGLE} to
handle \TEX/,
so they should be sufficient for most applications of \.{CTANGLE}.
If you change |max_bytes|, |max_names|, or |hash_size| you should also
change them in the file |"common.w"|.

@d max_bytes 90000 /* the number of bytes in identifiers,
  index entries, and section names; used in |"common.w"| */
@d max_toks 270000 /* number of bytes in compressed \CEE/ code */
@d max_names 4000 /* number of identifiers, strings, section names;
  must be less than 10240; used in |"common.w"| */
@d max_texts 2500 /* number of replacement texts, must be less than 10240 */
@d hash_size 353 /* should be prime; used in |"common.w"| */
@d longest_name 10000 /* section names and strings shouldn't be longer than this */
@d stack_size 50 /* number of simultaneous levels of macro expansion */
@d buf_size 100 /* for \.{CWEAVE} and \.{CTANGLE} */

@ The next few sections contain stuff from the file |"common.w"| that must
be included in both |"ctangle.w"| and |"cweave.w"|. It appears in
file |"common.h"|, which needs to be updated when |"common.w"| changes.

@i common.h

@* Data structures exclusive to {\tt CTANGLE}.
We've already seen that the |byte_mem| array holds the names of identifiers,
strings, and sections;
the |tok_mem| array holds the replacement texts
for sections. Allocation is sequential, since things are deleted only
during Phase II, and only in a last-in-first-out manner.

A \&{text} variable is a structure containing a pointer into
|tok_mem|, which tells where the corresponding text starts, and an
integer |text_link|, which, as we shall see later, is used to connect
pieces of text that have the same name.  All the \&{text}s are stored in
the array |text_info|, and we use a |text_pointer| variable to refer
to them.

The first position of |tok_mem| that is unoccupied by
replacement text is called |tok_ptr|, and the first unused location of
|text_info| is called |text_ptr|.  Thus we usually have the identity
|text_ptr->tok_start==tok_ptr|.

If your machine does not support |unsigned char| you should change
the definition of \&{eight\_bits} to |unsigned short|.
@^system dependencies@>

@<Typed...@>=
typedef struct {
  eight_bits *tok_start; /* pointer into |tok_mem| */
  sixteen_bits text_link; /* relates replacement texts */
} text;
typedef text *text_pointer;

@ @<Glob...@>=
text text_info[max_texts];
text_pointer text_info_end=text_info+max_texts-1;
text_pointer text_ptr; /* first unused position in |text_info| */
eight_bits tok_mem[max_toks];
eight_bits *tok_mem_end=tok_mem+max_toks-1;
eight_bits *tok_ptr; /* first unused position in |tok_mem| */

@ @<Set init...@>=
text_info->tok_start=tok_ptr=tok_mem;
text_ptr=text_info+1; text_ptr->tok_start=tok_mem;
  /* this makes replacement text 0 of length zero */

@ If |p| is a pointer to a section name, |p->equiv| is a pointer to its
replacement text, an element of the array |text_info|.

@d equiv equiv_or_xref /* info corresponding to names */

@ @<Set init...@>=
name_dir->equiv=(char *)text_info; /* the undefined section has no replacement text */

@ Here's the procedure that decides whether a name of length |l|
starting at position |first| equals the identifier pointed to by |p|:

@c
int names_match(p,first,l)
name_pointer p; /* points to the proposed match */
char *first; /* position of first character of string */
int l; /* length of identifier */
{
  if (length(p)!=l) return 0;
  return !strncmp(first,p->byte_start,l);
}

@ The common lookup routine refers to separate routines |init_node| and
|init_p| when the data structure grows. Actually |init_p| is called only by
\.{CWEAVE}, but we need to declare a dummy version so that
the loader won't complain of its absence.

@c
void
init_node(node)
name_pointer node;
{
    node->equiv=(char *)text_info;
}
void
init_p() {}

@* Tokens.
Replacement texts, which represent \CEE/ code in a compressed format,
appear in |tok_mem| as mentioned above. The codes in
these texts are called `tokens'; some tokens occupy two consecutive
eight-bit byte positions, and the others take just one byte.

If $p$ points to a replacement text, |p->tok_start| is the |tok_mem| position
of the first eight-bit code of that text. If |p->text_link==0|,
this is the replacement text for a macro, otherwise it is the replacement
text for a section. In the latter case |p->text_link| is either equal to
|section_flag|, which means that there is no further text for this section, or
|p->text_link| points to a continuation of this replacement text; such
links are created when several sections have \CEE/ texts with the same
name, and they also tie together all the \CEE/ texts of unnamed sections.
The replacement text pointer for the first unnamed section appears in
|text_info->text_link|, and the most recent such pointer is |last_unnamed|.

@d section_flag max_texts /* final |text_link| in section replacement texts */

@<Glob...@>=
text_pointer last_unnamed; /* most recent replacement text of unnamed section */

@ @<Set init...@>= last_unnamed=text_info; text_info->text_link=0;

@ If the first byte of a token is less than |0200|, the token occupies a
single byte. Otherwise we make a sixteen-bit token by combining two consecutive
bytes |a| and |b|. If |0200<=a<0250|, then |(a-0200)@t${}\times2^8$@>+b|
points to an identifier; if |0250<=a<0320|, then
|(a-0250)@t${}\times2^8$@>+b| points to a section name
(or, if it has the special value |output_defs_flag|,
to the area where the preprocessor definitions are stored); and if
|0320<=a<0400|, then |(a-0320)@t${}\times2^8$@>+b| is the number of the section
in which the current replacement text appears.

Codes less than |0200| are 7-bit |char| codes that represent themselves.
Some of the 7-bit codes will not be present, however, so we can
use them for special purposes. The following symbolic names are used:

\yskip \hang |join| denotes the concatenation of adjacent items with no
space or line breaks allowed between them (the \.{@@\&} operation of \.{CWEB}).

\hang |string| denotes the beginning or end of a string, verbatim
construction or numerical constant.
@^ASCII code dependencies@>

@d string 02 /* takes the place of extended ASCII \.{\char2} */
@d join 0177 /* takes the place of ASCII delete */
@d output_defs_flag (2*024000-1)

@ The following procedure is used to enter a two-byte value into
|tok_mem| when a replacement text is being generated.

@c
void
store_two_bytes(x)
sixteen_bits x;
{
  if (tok_ptr+2>tok_mem_end) overflow("token");
  *tok_ptr++=x>>8; /* store high byte */
  *tok_ptr++=x&0377; /* store low byte */
}

@** Stacks for output.  The output process uses a stack to keep track
of what is going on at different ``levels'' as the sections are being
written out.  Entries on this stack have five parts:

\yskip\hang |end_field| is the |tok_mem| location where the replacement
text of a particular level will end;

\hang |byte_field| is the |tok_mem| location from which the next token
on a particular level will be read;

\hang |name_field| points to the name corresponding to a particular level;

\hang |repl_field| points to the replacement text currently being read
at a particular level;

\hang |section_field| is the section number, or zero if this is a macro.

\yskip\noindent The current values of these five quantities are referred to
quite frequently, so they are stored in a separate place instead of in
the |stack| array. We call the current values |cur_end|, |cur_byte|,
|cur_name|, |cur_repl|, and |cur_section|.

The global variable |stack_ptr| tells how many levels of output are
currently in progress. The end of all output occurs when the stack is
empty, i.e., when |stack_ptr==stack|.

@<Typed...@>=
typedef struct {
  eight_bits *end_field; /* ending location of replacement text */
  eight_bits *byte_field; /* present location within replacement text */
  name_pointer name_field; /* |byte_start| index for text being output */
  text_pointer repl_field; /* |tok_start| index for text being output */
  sixteen_bits section_field; /* section number or zero if not a section */
} output_state;
typedef output_state *stack_pointer;

@ @d cur_end cur_state.end_field /* current ending location in |tok_mem| */
@d cur_byte cur_state.byte_field /* location of next output byte in |tok_mem|*/
@d cur_name cur_state.name_field /* pointer to current name being expanded */
@d cur_repl cur_state.repl_field /* pointer to current replacement text */
@d cur_section cur_state.section_field /* current section number being expanded */

@<Global...@>=
output_state cur_state; /* |cur_end|, |cur_byte|, |cur_name|, |cur_repl|,
  and |cur_section| */
output_state stack[stack_size+1]; /* info for non-current levels */
stack_pointer stack_ptr; /* first unused location in the output state stack */
stack_pointer stack_end=stack+stack_size; /* end of |stack| */

@ To get the output process started, we will perform the following
initialization steps. We may assume that |text_info->text_link| is nonzero,
since it points to the \CEE/ text in the first unnamed section that generates
code; if there are no such sections, there is nothing to output, and an
error message will have been generated before we do any of the initialization.

@<Initialize the output stacks@>=
stack_ptr=stack+1; cur_name=name_dir; cur_repl=text_info->text_link+text_info;
cur_byte=cur_repl->tok_start; cur_end=(cur_repl+1)->tok_start; cur_section=0;

@ When the replacement text for name |p| is to be inserted into the output,
the following subroutine is called to save the old level of output and get
the new one going.

We assume that the \CEE/ compiler can copy structures.
@^system dependencies@>

@c
void
push_level(p) /* suspends the current level */
name_pointer p;
{
  if (stack_ptr==stack_end) overflow("stack");
  *stack_ptr=cur_state;
  stack_ptr++;
  if (p!=NULL) { /* |p==NULL| means we are in |output_defs| */
    cur_name=p; cur_repl=(text_pointer)p->equiv;
    cur_byte=cur_repl->tok_start; cur_end=(cur_repl+1)->tok_start;
    cur_section=0;
  }
}

@ When we come to the end of a replacement text, the |pop_level| subroutine
does the right thing: It either moves to the continuation of this replacement
text or returns the state to the most recently stacked level.

@c
void
pop_level(flag) /* do this when |cur_byte| reaches |cur_end| */
int flag; /* |flag==0| means we are in |output_defs| */
{
  if (flag && cur_repl->text_link<section_flag) { /* link to a continuation */
    cur_repl=cur_repl->text_link+text_info; /* stay on the same level */
    cur_byte=cur_repl->tok_start; cur_end=(cur_repl+1)->tok_start;
    return;
  }
  stack_ptr--; /* go down to the previous level */
  if (stack_ptr>stack) cur_state=*stack_ptr;
}

@ The heart of the output procedure is the function |get_output|,
which produces the next token of output and sends it on to the lower-level
function |out_char|. The main purpose of |get_output| is to handle the
necessary stacking and unstacking. It sends the value |section_number|
if the next output begins or ends the replacement text of some section,
in which case |cur_val| is that section's number (if beginning) or the
negative of that value (if ending). (A section number of 0 indicates
not the beginning or ending of a section, but a \&{\#line} command.)
And it sends the value |identifier|
if the next output is an identifier, in which case
|cur_val| points to that identifier name.

@d section_number 0201 /* code returned by |get_output| for section numbers */
@d identifier 0202 /* code returned by |get_output| for identifiers */

@<Global...@>=
int cur_val; /* additional information corresponding to output token */

@ If |get_output| finds that no more output remains, it returns with
|stack_ptr==stack|.
@^high-bit character handling@>

@c
void
get_output() /* sends next token to |out_char| */
{
  sixteen_bits a; /* value of current byte */
  restart: if (stack_ptr==stack) return;
  if (cur_byte==cur_end) {
    cur_val=-((int)cur_section); /* cast needed because of sign extension */
    pop_level(1);
    if (cur_val==0) goto restart;
    out_char(section_number); return;
  }
  a=*cur_byte++;
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    C_putc(a); /* a high-bit character can occur in a string */
  else if (a<0200) out_char(a); /* one-byte token */
  else {
    a=(a-0200)*0400+*cur_byte++;
    switch (a/024000) { /* |024000==(0250-0200)*0400| */
      case 0: cur_val=a; out_char(identifier); break;
      case 1: if (a==output_defs_flag) output_defs();
        else @<Expand section |a-024000|, |goto restart|@>;
        break;
      default: cur_val=a-050000; if (cur_val>0) cur_section=cur_val;
        out_char(section_number);
    }
  }
}

@ The user may have forgotten to give any \CEE/ text for a section name,
or the \CEE/ text may have been associated with a different name by mistake.

@<Expand section |a-...@>=
{
  a-=024000;
  if ((a+name_dir)->equiv!=(char *)text_info) push_level(a+name_dir);
  else if (a!=0) {
    printf("\n! Not present: <");
    print_section_name(a+name_dir); err_print(">");
@.Not present: <section name>@>
  }
  goto restart;
}

@* Producing the output.
The |get_output| routine above handles most of the complexity of output
generation, but there are two further considerations that have a nontrivial
effect on \.{CTANGLE}'s algorithms.

@ First,
we want to make sure that the output has spaces and line breaks in
the right places (e.g., not in the middle of a string or a constant or an
identifier, not at a `\.{@@\&}' position
where quantities are being joined together, and certainly after an \.=
because the \CEE/ compiler thinks \.{=-} is ambiguous).

The output process can be in one of following states:

\yskip\hang |num_or_id| means that the last item in the buffer is a number or
identifier, hence a blank space or line break must be inserted if the next
item is also a number or identifier.

\yskip\hang |unbreakable| means that the last item in the buffer was followed
by the \.{@@\&} operation that inhibits spaces between it and the next item.

\yskip\hang |verbatim| means we're copying only character tokens, and
that they are to be output exactly as stored.  This is the case during
strings, verbatim constructions and numerical constants.

\yskip\hang |post_slash| means we've just output a slash.

\yskip\hang |normal| means none of the above.

\yskip\noindent Furthermore, if the variable |protect| is positive, newlines
are preceded by a `\.\\'.

@d normal 0 /* non-unusual state */
@d num_or_id 1 /* state associated with numbers and identifiers */
@d post_slash 2 /* state following a \./ */
@d unbreakable 3 /* state associated with \.{@@\&} */
@d verbatim 4 /* state in the middle of a string */

@<Global...@>=
eight_bits out_state; /* current status of partial output */
boolean protect; /* should newline characters be quoted? */

@ Here is a routine that is invoked when we want to output the current line.
During the output process, |cur_line| equals the number of the next line
to be output.

@c
void
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
  if (cur_line % 100 == 0 && show_progress) {
    printf(".");
    if (cur_line % 500 == 0) printf("%d",cur_line);
    update_terminal; /* progress report */
  }
  cur_line++;
}

@ Second, we have modified the original \.{TANGLE} so that it will write output
on multiple files.
If a section name is introduced in at least one place by \.{@@(}
instead of \.{@@<}, we treat it as the name of a file.
All these special sections are saved on a stack, |output_files|.
We write them out after we've done the unnamed section.

@d max_files 256
@<Glob...@>=
name_pointer output_files[max_files];
name_pointer *cur_out_file, *end_output_files, *an_output_file;
char cur_section_name_char; /* is it |'<'| or |'('| */
char output_file_name[longest_name]; /* name of the file */

@ We make |end_output_files| point just beyond the end of
|output_files|. The stack pointer
|cur_out_file| starts out there. Every time we see a new file, we
decrement |cur_out_file| and then write it in.
@<Set initial...@>=
cur_out_file=end_output_files=output_files+max_files;

@ @<If it's not there, add |cur_section_name| to the output file stack, or
complain we're out of room@>=
{
  for (an_output_file=cur_out_file;
        an_output_file<end_output_files; an_output_file++)
            if (*an_output_file==cur_section_name) break;
  if (an_output_file==end_output_files) {
    if (cur_out_file>output_files)
        *--cur_out_file=cur_section_name;
    else {
      overflow("output files");
    }
  }
}

@* The big output switch.  Here then is the routine that does the
output.

@<Predecl...@>=
void phase_two();

@ @c
void
phase_two () {
  web_file_open=0;
  cur_line=1;
  @<Initialize the output stacks@>;
  @<Output macro definitions if appropriate@>;
  if (text_info->text_link==0 && cur_out_file==end_output_files) {
    printf("\n! No program text was specified."); mark_harmless;
@.No program text...@>
  }
  else {
    if(cur_out_file==end_output_files) {
      if(show_progress)
        printf("\nWriting the output file (%s):",C_file_name);
    }
    else {
      if (show_progress) {
        printf("\nWriting the output files:");
@.Writing the output...@>
        printf(" (%s)",C_file_name);
        update_terminal;
      }
      if (text_info->text_link==0) goto writeloop;
    }
    while (stack_ptr>stack) get_output();
    flush_buffer();
writeloop:   @<Write all the named output files@>;
    if(show_happiness) printf("\nDone.");
  }
}

@ To write the named output files, we proceed as for the unnamed
section.
The only subtlety is that we have to open each one.

@<Write all the named output files@>=
for (an_output_file=end_output_files; an_output_file>cur_out_file;) {
    an_output_file--;
    sprint_section_name(output_file_name,*an_output_file);
    fclose(C_file);
    C_file=fopen(output_file_name,"w");
    if (C_file ==0) fatal("! Cannot open output file:",output_file_name);
@.Cannot open output file@>
    printf("\n(%s)",output_file_name); update_terminal;
    cur_line=1;
    stack_ptr=stack+1;
    cur_name= (*an_output_file);
    cur_repl= (text_pointer)cur_name->equiv;
    cur_byte=cur_repl->tok_start;
    cur_end=(cur_repl+1)->tok_start;
    while (stack_ptr > stack) get_output();
    flush_buffer();
}

@ If a \.{@@h} was not encountered in the input,
we go through the list of replacement texts and copy the ones
that refer to macros, preceded by the \.{\#define} preprocessor command.

@<Output macro definitions if appropriate@>=
  if (!output_defs_seen)
    output_defs();

@ @<Glob...@>=
boolean output_defs_seen=0;

@ @<Predecl...@>=
void output_defs();

@ @c
void
output_defs()
{
  sixteen_bits a;
  push_level(NULL);
  for (cur_text=text_info+1; cur_text<text_ptr; cur_text++)
    if (cur_text->text_link==0) { /* |cur_text| is the text for a macro */
      cur_byte=cur_text->tok_start;
      cur_end=(cur_text+1)->tok_start;
      C_printf("%s","#define ");
      out_state=normal;
      protect=1; /* newlines should be preceded by |'\\'| */
      while (cur_byte<cur_end) {
        a=*cur_byte++;
        if (cur_byte==cur_end && a=='\n') break; /* disregard a final newline */
        if (out_state==verbatim && a!=string && a!=constant && a!='\n')
          C_putc(a); /* a high-bit character can occur in a string */
@^high-bit character handling@>
        else if (a<0200) out_char(a); /* one-byte token */
        else {
          a=(a-0200)*0400+*cur_byte++;
          if (a<024000) { /* |024000==(0250-0200)*0400| */
            cur_val=a; out_char(identifier);
          }
          else if (a<050000) { confusion("macro defs have strange char");}
          else {
            cur_val=a-050000; cur_section=cur_val; out_char(section_number);
          }
      /* no other cases */
        }
      }
      protect=0;
      flush_buffer();
    }
  pop_level(0);
}

@ A many-way switch is used to send the output.  Note that this function
is not called if |out_state==verbatim|, except perhaps with arguments
|'\n'| (protect the newline), |string| (end the string), or |constant|
(end the constant).

@<Predecl...@>=
static void out_char();

@ @c
static void
out_char(cur_char)
eight_bits cur_char;
{
  char *j, *k; /* pointer into |byte_mem| */
restart:
    switch (cur_char) {
      case '\n': if (protect && out_state!=verbatim) C_putc(' ');
        if (protect || out_state==verbatim) C_putc('\\');
        flush_buffer(); if (out_state!=verbatim) out_state=normal; break;
      @/@t\4@>@<Case of an identifier@>;
      @/@t\4@>@<Case of a section number@>;
      @/@t\4@>@<Cases like \.{!=}@>;
      case '=': case '>': C_putc(cur_char); C_putc(' ');
        out_state=normal; break;
      case join: out_state=unbreakable; break;
      case constant: if (out_state==verbatim) {
          out_state=num_or_id; break;
        }
        if(out_state==num_or_id) C_putc(' '); out_state=verbatim; break;
      case string: if (out_state==verbatim) out_state=normal;
        else out_state=verbatim; break;
      case '/': C_putc('/'); out_state=post_slash; break;
      case '*': if (out_state==post_slash) C_putc(' ');
        /* fall through */
      default: C_putc(cur_char); out_state=normal; break;
    }
}

@ @<Cases like \.{!=}@>=
case plus_plus: C_putc('+'); C_putc('+'); out_state=normal; break;
case minus_minus: C_putc('-'); C_putc('-'); out_state=normal; break;
case minus_gt: C_putc('-'); C_putc('>'); out_state=normal; break;
case gt_gt: C_putc('>'); C_putc('>'); out_state=normal; break;
case eq_eq: C_putc('='); C_putc('='); out_state=normal; break;
case lt_lt: C_putc('<'); C_putc('<'); out_state=normal; break;
case gt_eq: C_putc('>'); C_putc('='); out_state=normal; break;
case lt_eq: C_putc('<'); C_putc('='); out_state=normal; break;
case not_eq: C_putc('!'); C_putc('='); out_state=normal; break;
case and_and: C_putc('&'); C_putc('&'); out_state=normal; break;
case or_or: C_putc('|'); C_putc('|'); out_state=normal; break;
case dot_dot_dot: C_putc('.'); C_putc('.'); C_putc('.'); out_state=normal;
    break;
case colon_colon: C_putc(':'); C_putc(':'); out_state=normal; break;
case period_ast: C_putc('.'); C_putc('*'); out_state=normal; break;
case minus_gt_ast: C_putc('-'); C_putc('>'); C_putc('*'); out_state=normal;
    break;

@ When an identifier is output to the \CEE/ file, characters in the
range 128--255 must be changed into something else, so the \CEE/
compiler won't complain.  By default, \.{CTANGLE} converts the
character with code $16 x+y$ to the three characters `\.X$xy$', but
a different transliteration table can be specified.  Thus a German
might want {\it gr\"un\/} to appear as a still readable \.{gruen}.
This makes debugging a lot less confusing.

@d translit_length 10

@<Glo...@>=
char translit[128][translit_length];

@ @<Set init...@>=
{
  int i;
  for (i=0;i<128;i++) sprintf(translit[i],"X%02X",(unsigned)(128+i));
}

@ @<Case of an identifier@>=
case identifier:
  if (out_state==num_or_id) C_putc(' ');
  j=(cur_val+name_dir)->byte_start;
  k=(cur_val+name_dir+1)->byte_start;
  while (j<k) {
    if ((unsigned char)(*j)<0200) C_putc(*j);
@^high-bit character handling@>
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
    j++;
  }
  out_state=num_or_id; break;

@ @<Case of a sec...@>=
case section_number:
  if (cur_val>0) C_printf("/*%d:*/",cur_val);
  else if(cur_val<0) C_printf("/*:%d*/",-cur_val);
  else if (protect) {
    cur_byte +=4; /* skip line number and file name */
    cur_char = '\n';
    goto restart;
  } else {
    sixteen_bits a;
    a=0400* *cur_byte++;
    a+=*cur_byte++; /* gets the line number */
    C_printf("\n#line %d \"",a);
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) {
      if (*j=='\\' || *j=='"') C_putc('\\');
      C_putc(*j);
    }
    C_printf("%s","\"\n");
  }
  break;

@** Introduction to the input phase.
We have now seen that \.{CTANGLE} will be able to output the full
\CEE/ program, if we can only get that program into the byte memory in
the proper format. The input process is something like the output process
in reverse, since we compress the text as we read it in and we expand it
as we write it out.

There are three main input routines. The most interesting is the one that gets
the next token of a \CEE/ text; the other two are used to scan rapidly past
\TEX/ text in the \.{CWEB} source code. One of the latter routines will jump to
the next token that starts with `\.{@@}', and the other skips to the end
of a \CEE/ comment.

@ Control codes in \.{CWEB} begin with `\.{@@}', and the next character
identifies the code. Some of these are of interest only to \.{CWEAVE},
so \.{CTANGLE} ignores them; the others are converted by \.{CTANGLE} into
internal code numbers by the |ccode| table below. The ordering
of these internal code numbers has been chosen to simplify the program logic;
larger numbers are given to the control codes that denote more significant
milestones.

@d ignore 0 /* control code of no interest to \.{CTANGLE} */
@d ord 0302 /* control code for `\.{@@'}' */
@d control_text 0303 /* control code for `\.{@@t}', `\.{@@\^}', etc. */
@d translit_code 0304 /* control code for `\.{@@l}' */
@d output_defs_code 0305 /* control code for `\.{@@h}' */
@d format_code 0306 /* control code for `\.{@@f}' */
@d definition 0307 /* control code for `\.{@@d}' */
@d begin_C 0310 /* control code for `\.{@@c}' */
@d section_name 0311 /* control code for `\.{@@<}' */
@d new_section 0312 /* control code for `\.{@@\ }' and `\.{@@*}' */

@<Global...@>=
eight_bits ccode[256]; /* meaning of a char following \.{@@} */

@ @<Set ini...@>= {
  int c; /* must be |int| so the |for| loop will end */
  for (c=0; c<256; c++) ccode[c]=ignore;
  ccode[' ']=ccode['\t']=ccode['\n']=ccode['\v']=ccode['\r']=ccode['\f']
   =ccode['*']=new_section;
  ccode['@@']='@@'; ccode['=']=string;
  ccode['d']=ccode['D']=definition;
  ccode['f']=ccode['F']=ccode['s']=ccode['S']=format_code;
  ccode['c']=ccode['C']=ccode['p']=ccode['P']=begin_C;
  ccode['^']=ccode[':']=ccode['.']=ccode['t']=ccode['T']=
   ccode['q']=ccode['Q']=control_text;
  ccode['h']=ccode['H']=output_defs_code;
  ccode['l']=ccode['L']=translit_code;
  ccode['&']=join;
  ccode['<']=ccode['(']=section_name;
  ccode['\'']=ord;
}

@ The |skip_ahead| procedure reads through the input at fairly high speed
until finding the next non-ignorable control code, which it returns.

@c
eight_bits
skip_ahead() /* skip to next control code */
{
  eight_bits c; /* control code found */
  while (1) {
    if (loc>limit && (get_line()==0)) return(new_section);
    *(limit+1)='@@';
    while (*loc!='@@') loc++;
    if (loc<=limit) {
      loc++; c=ccode[(eight_bits)*loc]; loc++;
      if (c!=ignore || *(loc-1)=='>') return(c);
    }
  }
}

@ The |skip_comment| procedure reads through the input at somewhat high
speed in order to pass over comments, which \.{CTANGLE} does not transmit
to the output. If the comment is introduced by \.{/*}, |skip_comment|
proceeds until finding the end-comment token \.{*/} or a newline; in the
latter case |skip_comment| will be called again by |get_next|, since the
comment is not finished.  This is done so that each newline in the
\CEE/ part of a section is copied to the output; otherwise the \&{\#line}
commands inserted into the \CEE/ file by the output routines become useless.
On the other hand, if the comment is introduced by \.{//} (i.e., if it
is a \CPLUSPLUS/ ``short comment''), it always is simply delimited by the next
newline. The boolean argument |is_long_comment| distinguishes between
the two types of comments.

If |skip_comment| comes to the end of the section, it prints an error message.
No comment, long or short, is allowed to contain `\.{@@\ }' or `\.{@@*}'.

@<Global...@>=
boolean comment_continues=0; /* are we scanning a comment? */

@ @c
int skip_comment(is_long_comment) /* skips over comments */
boolean is_long_comment;
{
  char c; /* current character */
  while (1) {
    if (loc>limit) {
      if (is_long_comment) {
        if(get_line()) return(comment_continues=1);
        else{
          err_print("! Input ended in mid-comment");
@.Input ended in mid-comment@>
          return(comment_continues=0);
        }
      }
      else return(comment_continues=0);
    }
    c=*(loc++);
    if (is_long_comment && c=='*' && *loc=='/') {
      loc++; return(comment_continues=0);
    }
    if (c=='@@') {
      if (ccode[(eight_bits)*loc]==new_section) {
        err_print("! Section name ended in mid-comment"); loc--;
@.Section name ended in mid-comment@>
        return(comment_continues=0);
      }
      else loc++;
    }
  }
}

@* Inputting the next token.

@d constant 03

@<Global...@>=
name_pointer cur_section_name; /* name of section just scanned */
int no_where; /* suppress |print_where|? */

@ @<Include...@>=
#include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
#include <stdlib.h> /* definition of |exit| */

@ As one might expect, |get_next| consists mostly of a big switch
that branches to the various special cases that can arise.

@d isxalpha(c) ((c)=='_' || (c)=='$') 
  /* non-alpha characters allowed in identifier */
@d ishigh(c) ((unsigned char)(c)>0177)
@^high-bit character handling@>

@c
eight_bits
get_next() /* produces the next input token */
{
  static int preprocessing=0;
  eight_bits c; /* the current character */
  while (1) {
    if (loc>limit) {
      if (preprocessing && *(limit-1)!='\\') preprocessing=0;
      if (get_line()==0) return(new_section);
      else if (print_where && !no_where) {
          print_where=0;
          @<Insert the line number into |tok_mem|@>;
        }
        else return ('\n');
    }
    c=*loc;
    if (comment_continues || (c=='/' && (*(loc+1)=='*' || *(loc+1)=='/'))) {
      skip_comment(comment_continues||*(loc+1)=='*');
          /* scan to end of comment or newline */
      if (comment_continues) return('\n');
      else continue;
    }
    loc++;
    if (xisdigit(c) || c=='.') @<Get a constant@>@;
    else if (c=='\'' || c=='"' || (c=='L'&&(*loc=='\'' || *loc=='"')))
        @<Get a string@>@;
    else if (isalpha(c) || isxalpha(c) || ishigh(c))
      @<Get an identifier@>@;
    else if (c=='@@') @<Get control code and possible section name@>@;
    else if (xisspace(c)) {
        if (!preprocessing || loc>limit) continue;
          /* we don't want a blank after a final backslash */
        else return(' '); /* ignore spaces and tabs, unless preprocessing */
    }
    else if (c=='#' && loc==buffer+1) preprocessing=1;
    mistake: @<Compress two-symbol operator@>@;
    return(c);
  }
}

@ The following code assigns values to the combinations \.{++},
\.{--}, \.{->}, \.{>=}, \.{<=}, \.{==}, \.{<<}, \.{>>}, \.{!=}, \.{||} and
\.{\&\&}, and to the \CPLUSPLUS/
combinations \.{...}, \.{::}, \.{.*} and \.{->*}.
The compound assignment operators (e.g., \.{+=}) are
treated as separate tokens.

@d compress(c) if (loc++<=limit) return(c)

@<Compress tw...@>=
switch(c) {
  case '+': if (*loc=='+') compress(plus_plus); break;
  case '-': if (*loc=='-') {compress(minus_minus);}
    else if (*loc=='>') if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
  case '.': if (*loc=='*') {compress(period_ast);}
            else if (*loc=='.' && *(loc+1)=='.') {
              loc++; compress(dot_dot_dot);
            }
            break;
  case ':': if (*loc==':') compress(colon_colon); break;
  case '=': if (*loc=='=') compress(eq_eq); break;
  case '>': if (*loc=='=') {compress(gt_eq);}
    else if (*loc=='>') compress(gt_gt); break;
  case '<': if (*loc=='=') {compress(lt_eq);}
    else if (*loc=='<') compress(lt_lt); break;
  case '&': if (*loc=='&') compress(and_and); break;
  case '|': if (*loc=='|') compress(or_or); break;
  case '!': if (*loc=='=') compress(not_eq); break;
}

@ @<Get an identifier@>= {
  id_first=--loc;
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc));
  id_loc=loc; return(identifier);
}

@ @<Get a constant@>= {
  id_first=loc-1;
  if (*id_first=='.' && !xisdigit(*loc)) goto mistake; /* not a constant */
  if (*id_first=='0') {
    if (*loc=='x' || *loc=='X') { /* hex constant */
      loc++; while (xisxdigit(*loc)) loc++; goto found;
    }
  }
  while (xisdigit(*loc)) loc++;
  if (*loc=='.') {
  loc++;
  while (xisdigit(*loc)) loc++;
  }
  if (*loc=='e' || *loc=='E') { /* float constant */
    if (*++loc=='+' || *loc=='-') loc++;
    while (xisdigit(*loc)) loc++;
  }
 found: while (*loc=='u' || *loc=='U' || *loc=='l' || *loc=='L'
             || *loc=='f' || *loc=='F') loc++;
  id_loc=loc;
  return(constant);
}

@ \CEE/ strings and character constants, delimited by double and single
quotes, respectively, can contain newlines or instances of their own
delimiters if they are protected by a backslash.  We follow this
convention, but do not allow the string to be longer than |longest_name|.

@<Get a string@>= {
  char delim = c; /* what started the string */
  id_first = section_text+1;
  id_loc = section_text; *++id_loc=delim;
  if (delim=='L') { /* wide character constant */
    delim=*loc++; *++id_loc=delim;
  }
  while (1) {
    if (loc>=limit) {
      if(*(limit-1)!='\\') {
        err_print("! String didn't end"); loc=limit; break;
@.String didn't end@>
      }
      if(get_line()==0) {
        err_print("! Input ended in middle of string"); loc=buffer; break;
@.Input ended in middle of string@>
      }
      else if (++id_loc<=section_text_end) *id_loc='\n'; /* will print as
      \.{"\\\\\\n"} */
    }
    if ((c=*loc++)==delim) {
      if (++id_loc<=section_text_end) *id_loc=c;
      break;
    }
    if (c=='\\') {
      if (loc>=limit) continue;
      if (++id_loc<=section_text_end) *id_loc = '\\';
      c=*loc++;
    }
    if (++id_loc<=section_text_end) *id_loc=c;
  }
  if (id_loc>=section_text_end) {
    printf("\n! String too long: ");
@.String too long@>
    term_write(section_text+1,25);
    err_print("...");
  }
  id_loc++;
  return(string);
}

@ After an \.{@@} sign has been scanned, the next character tells us
whether there is more work to do.

@<Get control code and possible section name@>= {
  c=ccode[(eight_bits)*loc++];
  switch(c) {
    case ignore: continue;
    case translit_code: err_print("! Use @@l in limbo only"); continue;
@.Use @@l in limbo...@>
    case control_text: while ((c=skip_ahead())=='@@');
      /* only \.{@@@@} and \.{@@>} are expected */
      if (*(loc-1)!='>')
        err_print("! Double @@ should be used in control text");
@.Double @@ should be used...@>
      continue;
    case section_name:
      cur_section_name_char=*(loc-1);
      @<Scan the section name and make |cur_section_name| point to it@>;
    case string: @<Scan a verbatim string@>;
    case ord: @<Scan an ASCII constant@>;
    default: return(c);
  }
}

@ After scanning a valid ASCII constant that follows
\.{@@'}, this code plows ahead until it finds the next single quote.
(Special care is taken if the quote is part of the constant.)
Anything after a valid ASCII constant is ignored;
thus, \.{@@'\\nopq'} gives the same result as \.{@@'\\n'}.

@<Scan an ASCII constant@>=
  id_first=loc;
  if (*loc=='\\') {
    if (*++loc=='\'') loc++;
  }
  while (*loc!='\'') {
    if (*loc=='@@') {
      if (*(loc+1)!='@@')
        err_print("! Double @@ should be used in ASCII constant");
@.Double @@ should be used...@>
      else loc++;
    }
    loc++;
    if (loc>limit) {
        err_print("! String didn't end"); loc=limit-1; break;
@.String didn't end@>
    }
  }
  loc++;
  return(ord);

@ @<Scan the section name...@>= {
  char *k; /* pointer into |section_text| */
  @<Put section name into |section_text|@>;
  if (k-section_text>3 && strncmp(k-2,"...",3)==0)
    cur_section_name=section_lookup(section_text+1,k-3,1); /* 1 means is a prefix */
  else cur_section_name=section_lookup(section_text+1,k,0);
  if (cur_section_name_char=='(')
    @<If it's not there, add |cur_section_name| to the output file stack, or
          complain we're out of room@>;
  return(section_name);
}

@ Section names are placed into the |section_text| array with consecutive spaces,
tabs, and carriage-returns replaced by single spaces. There will be no
spaces at the beginning or the end. (We set |section_text[0]=' '| to facilitate
this, since the |section_lookup| routine uses |section_text[1]| as the first
character of the name.)

@<Set init...@>=section_text[0]=' ';

@ @<Put section name...@>=
k=section_text;
while (1) {
  if (loc>limit && get_line()==0) {
    err_print("! Input ended in section name");
@.Input ended in section name@>
    loc=buffer+1; break;
  }
  c=*loc;
  @<If end of name or erroneous nesting, |break|@>;
  loc++; if (k<section_text_end) k++;
  if (xisspace(c)) {
    c=' '; if (*(k-1)==' ') k--;
  }
*k=c;
}
if (k>=section_text_end) {
  printf("\n! Section name too long: ");
@.Section name too long@>
  term_write(section_text+1,25);
  printf("..."); mark_harmless;
}
if (*k==' ' && k>section_text) k--;

@ @<If end of name or erroneous nesting,...@>=
if (c=='@@') {
  c=*(loc+1);
  if (c=='>') {
    loc+=2; break;
  }
  if (ccode[(eight_bits)c]==new_section) {
    err_print("! Section name didn't end"); break;
@.Section name didn't end@>
  }
  if (ccode[(eight_bits)c]==section_name) {
    err_print("! Nesting of section names not allowed"); break;
@.Nesting of section names...@>
  }
  *(++k)='@@'; loc++; /* now |c==*loc| again */
}

@ At the present point in the program we
have |*(loc-1)==string|; we set |id_first| to the beginning
of the string itself, and |id_loc| to its ending-plus-one location in the
buffer.  We also set |loc| to the position just after the ending delimiter.

@<Scan a verbatim string@>= {
  id_first=loc++; *(limit+1)='@@'; *(limit+2)='>';
  while (*loc!='@@' || *(loc+1)!='>') loc++;
  if (loc>=limit) err_print("! Verbatim string didn't end");
@.Verbatim string didn't end@>
  id_loc=loc; loc+=2;
  return(string);
}

@* Scanning a macro definition.
The rules for generating the replacement texts corresponding to macros and
\CEE/ texts of a section are almost identical; the only differences are that

\yskip \item{a)}Section names are not allowed in macros;
in fact, the appearance of a section name terminates such macros and denotes
the name of the current section.

\item{b)}The symbols \.{@@d} and \.{@@f} and \.{@@c} are not allowed after
section names, while they terminate macro definitions.

\item{c)}Spaces are inserted after right parentheses in macros, because the
ANSI \CEE/ preprocessor sometimes requires it.

\yskip Therefore there is a single procedure |scan_repl| whose parameter
|t| specifies either |macro| or |section_name|. After |scan_repl| has
acted, |cur_text| will point to the replacement text just generated, and
|next_control| will contain the control code that terminated the activity.

@d macro  0
@d app_repl(c)  {if (tok_ptr==tok_mem_end) overflow("token"); *tok_ptr++=c;}

@<Global...@>=
text_pointer cur_text; /* replacement text formed by |scan_repl| */
eight_bits next_control;

@ @c
void
scan_repl(t) /* creates a replacement text */
eight_bits t;
{
  sixteen_bits a; /* the current token */
  if (t==section_name) {@<Insert the line number into |tok_mem|@>;}
  while (1) switch (a=get_next()) {
      @<In cases that |a| is a non-|char| token (|identifier|,
        |section_name|, etc.), either process it and change |a| to a byte
        that should be stored, or |continue| if |a| should be ignored,
        or |goto done| if |a| signals the end of this replacement text@>@;
      case ')': app_repl(a);
        if (t==macro) app_repl(' ');
        break;
      default: app_repl(a); /* store |a| in |tok_mem| */
    }
  done: next_control=(eight_bits) a;
  if (text_ptr>text_info_end) overflow("text");
  cur_text=text_ptr; (++text_ptr)->tok_start=tok_ptr;
}

@ Here is the code for the line number: first a |sixteen_bits| equal
to |0150000|; then the numeric line number; then a pointer to the
file name.

@<Insert the line...@>=
store_two_bytes(0150000);
if (changing && include_depth==change_depth) { /* correction made Feb 2017 */
  id_first=change_file_name;
   store_two_bytes((sixteen_bits)change_line);
}@+else {
  id_first=cur_file_name;
  store_two_bytes((sixteen_bits)cur_line);
}
id_loc=id_first+strlen(id_first);
{int a=id_lookup(id_first,id_loc,0)-name_dir; app_repl((a / 0400)+0200);
  app_repl(a % 0400);}

@ @<In cases that |a| is...@>=
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400); break;
case section_name: if (t!=section_name) goto done;
  else {
    @<Was an `@@' missed here?@>;
    a=cur_section_name-name_dir;
    app_repl((a / 0400)+0250);
    app_repl(a % 0400);
    @<Insert the line number into |tok_mem|@>; break;
  }
case output_defs_code: if (t!=section_name) err_print("! Misplaced @@h");
@.Misplaced @@h@>
  else {
    output_defs_seen=1;
    a=output_defs_flag;
    app_repl((a / 0400)+0200);
    app_repl(a % 0400);
    @<Insert the line number into |tok_mem|@>;
  }
 break;
case constant: case string:
  @<Copy a string or verbatim construction or numerical constant@>;
case ord:
  @<Copy an ASCII constant@>;
case definition: case format_code: case begin_C: if (t!=section_name) goto done;
  else {
    err_print("! @@d, @@f and @@c are ignored in C text"); continue;
@.@@d, @@f and @@c are ignored in C text@>
  }
case new_section: goto done;

@ @<Was an `@@'...@>= {
  char *try_loc=loc;
  while (*try_loc==' ' && try_loc<limit) try_loc++;
  if (*try_loc=='+' && try_loc<limit) try_loc++;
  while (*try_loc==' ' && try_loc<limit) try_loc++;
  if (*try_loc=='=') err_print ("! Missing `@@ ' before a named section");
@.Missing `@@ '...@>
  /* user who isn't defining a section should put newline after the name,
     as explained in the manual */
}

@ @<Copy a string...@>=
  app_repl(a); /* |string| or |constant| */
  while (id_first < id_loc) { /* simplify \.{@@@@} pairs */
    if (*id_first=='@@') {
      if (*(id_first+1)=='@@') id_first++;
      else err_print("! Double @@ should be used in string");
@.Double @@ should be used...@>
    }
    app_repl(*id_first++);
  }
  app_repl(a); break;

@ This section should be rewritten on machines that don't use ASCII
code internally.
@^ASCII code dependencies@>

@<Copy an ASCII constant@>= {
  int c=(eight_bits) *id_first;
  if (c=='\\') {
    c=*++id_first;
    if (c>='0' && c<='7') {
      c-='0';
      if (*(id_first+1)>='0' && *(id_first+1)<='7') {
        c=8*c+*(++id_first) - '0';
        if (*(id_first+1)>='0' && *(id_first+1)<='7' && c<32)
          c=8*c+*(++id_first)- '0';
      }
    }
    else switch (c) {
    case 't':c='\t';@+break;
    case 'n':c='\n';@+break;
    case 'b':c='\b';@+break;
    case 'f':c='\f';@+break;
    case 'v':c='\v';@+break;
    case 'r':c='\r';@+break;
    case 'a':c='\7';@+break;
    case '?':c='?';@+break;
    case 'x':
      if (xisdigit(*(id_first+1))) c=*(++id_first)-'0';
      else if (xisxdigit(*(id_first+1))) {
        ++id_first;
        c=toupper(*id_first)-'A'+10;
      }
      if (xisdigit(*(id_first+1))) c=16*c+*(++id_first)-'0';
      else if (xisxdigit(*(id_first+1))) {
        ++id_first;
        c=16*c+toupper(*id_first)-'A'+10;
      }
      break;
    case '\\':c='\\';@+break;
    case '\'':c='\'';@+break;
    case '\"':c='\"';@+break;
    default: err_print("! Unrecognized escape sequence");
@.Unrecognized escape sequence@>
    }
  }@/
  /* at this point |c| should have been converted to its ASCII code number */
  app_repl(constant);
  if (c>=100) app_repl('0'+c/100);
  if (c>=10) app_repl('0'+(c/10)%10);
  app_repl('0'+c%10);
  app_repl(constant);
}
break;

@* Scanning a section.
The |scan_section| procedure starts when `\.{@@\ }' or `\.{@@*}' has been
sensed in the input, and it proceeds until the end of that section.  It
uses |section_count| to keep track of the current section number; with luck,
\.{CWEAVE} and \.{CTANGLE} will both assign the same numbers to sections.

@<Global...@>=
extern sixteen_bits section_count; /* the current section number */

@ The body of |scan_section| is a loop where we look for control codes
that are significant to \.{CTANGLE}: those
that delimit a definition, the \CEE/ part of a module, or a new module.

@c
void
scan_section()
{
  name_pointer p; /* section name for the current section */
  text_pointer q; /* text for the current section */
  sixteen_bits a; /* token for left-hand side of definition */
  section_count++; @+ no_where=1;
  if (*(loc-1)=='*' && show_progress) { /* starred section */
    printf("*%d",section_count); update_terminal;
  }
  next_control=0;
  while (1) {
    @<Skip ahead until |next_control| corresponds to \.{@@d}, \.{@@<},
      \.{@@\ } or the like@>;
    if (next_control == definition) {  /* \.{@@d} */
        @<Scan a definition@>@;
        continue;
    }
    if (next_control == begin_C) {  /* \.{@@c} or \.{@@p} */
      p=name_dir; break;
    }
    if (next_control == section_name) { /* \.{@@<} or \.{@@(} */
      p=cur_section_name;
      @<If section is not being defined, |continue| @>;
      break;
    }
    return; /* \.{@@\ } or \.{@@*} */
  }
  no_where=print_where=0;
  @<Scan the \CEE/ part of the current section@>;
}

@ At the top of this loop, if |next_control==section_name|, the
section name has already been scanned (see |@<Get control code
and...@>|).  Thus, if we encounter |next_control==section_name| in the
skip-ahead process, we should likewise scan the section name, so later
processing will be the same in both cases.

@<Skip ahead until |next_control| ...@>=
while (next_control<definition)
      /* |definition| is the lowest of the ``significant'' codes */
  if((next_control=skip_ahead())==section_name){
    loc-=2; next_control=get_next();
  }

@ @<Scan a definition@>= {
  while ((next_control=get_next())=='\n'); /*allow newline before definition */
  if (next_control!=identifier) {
    err_print("! Definition flushed, must start with identifier");
@.Definition flushed...@>
    continue;
  }
  app_repl(((a=id_lookup(id_first,id_loc,0)-name_dir) / 0400)+0200);
        /* append the lhs */
  app_repl(a % 0400);
  if (*loc!='(') { /* identifier must be separated from replacement text */
    app_repl(string); app_repl(' '); app_repl(string);
  }
  scan_repl(macro);
  cur_text->text_link=0; /* |text_link==0| characterizes a macro */
}

@ If the section name is not followed by \.{=} or \.{+=}, no \CEE/
code is forthcoming: the section is being cited, not being
defined.  This use is illegal after the definition part of the
current section has started, except inside a comment, but
\.{CTANGLE} does not enforce this rule; it simply ignores the offending
section name and everything following it, up to the next significant
control code.

@<If section is not being defined, |continue| @>=
while ((next_control=get_next())=='+'); /* allow optional \.{+=} */
if (next_control!='=' && next_control!=eq_eq)
  continue;

@ @<Scan the \CEE/...@>=
@<Insert the section number into |tok_mem|@>;
scan_repl(section_name); /* now |cur_text| points to the replacement text */
@<Update the data structure so that the replacement text is accessible@>;

@ @<Insert the section number...@>=
store_two_bytes((sixteen_bits)(0150000+section_count));
  /* |0150000==0320*0400| */

@ @<Update the data...@>=
if (p==name_dir||p==0) { /* unnamed section, or bad section name */
  (last_unnamed)->text_link=cur_text-text_info; last_unnamed=cur_text;
}
else if (p->equiv==(char *)text_info) p->equiv=(char *)cur_text;
  /* first section of this name */
else {
  q=(text_pointer)p->equiv;
  while (q->text_link<section_flag)
    q=q->text_link+text_info; /* find end of list */
  q->text_link=cur_text-text_info;
}
cur_text->text_link=section_flag;
  /* mark this replacement text as a nonmacro */

@ @<Predec...@>=
void phase_one();

@ @c
void
phase_one() {
  phase=1;
  section_count=0;
  reset_input();
  skip_limbo();
  while (!input_has_ended) scan_section();
  check_complete();
  phase=2;
}

@ Only a small subset of the control codes is legal in limbo, so limbo
processing is straightforward.

@<Predecl...@>=
void skip_limbo();

@ @c
void
skip_limbo()
{
  char c;
  while (1) {
    if (loc>limit && get_line()==0) return;
    *(limit+1)='@@';
    while (*loc!='@@') loc++;
    if (loc++<=limit) {
      c=*loc++;
      if (ccode[(eight_bits)c]==new_section) break;
      switch (ccode[(eight_bits)c]) {
        case translit_code: @<Read in transliteration of a character@>; break;
        case format_code: case '@@': break;
        case control_text: if (c=='q' || c=='Q') {
          while ((c=skip_ahead())=='@@');
          if (*(loc-1)!='>')
            err_print("! Double @@ should be used in control text");
@.Double @@ should be used...@>
          break;
          } /* otherwise fall through */
        default: err_print("! Double @@ should be used in limbo");
@.Double @@ should be used...@>
      }
    }
  }
}

@ @<Read in transliteration of a character@>=
  while(xisspace(*loc)&&loc<limit) loc++;
  loc+=3;
  if (loc>limit || !xisxdigit(*(loc-3)) || !xisxdigit(*(loc-2)) @|
         || (*(loc-3)>='0' && *(loc-3)<='7') || !xisspace(*(loc-1)))
    err_print("! Improper hex number following @@l");
@.Improper hex number...@>
  else {
    unsigned i;
    char *beg;
    sscanf(loc-3,"%x",&i);
    while(xisspace(*loc)&&loc<limit) loc++;
    beg=loc;
    while(loc<limit&&(xisalpha(*loc)||xisdigit(*loc)||*loc=='_')) loc++;
    if (loc-beg>=translit_length)
      err_print("! Replacement string in @@l too long");
@.Replacement string in @@l...@>
    else{
      strncpy(translit[i-0200],beg,loc-beg);
      translit[i-0200][loc-beg]='\0';
    }
  }

@ Because on some systems the difference between two pointers is a |long|
but not an |int|, we use \.{\%ld} to print these quantities.

@c
void
print_stats() {
  printf("\nMemory usage statistics:\n");
  printf("%ld names (out of %ld)\n",
          (long)(name_ptr-name_dir),(long)max_names);
  printf("%ld replacement texts (out of %ld)\n",
          (long)(text_ptr-text_info),(long)max_texts);
  printf("%ld bytes (out of %ld)\n",
          (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf("%ld tokens (out of %ld)\n",
          (long)(tok_ptr-tok_mem),(long)max_toks);
}

@** Index.
Here is a cross-reference table for \.{CTANGLE}.
All sections in which an identifier is
used are listed with that identifier, except that reserved words are
indexed only when they appear in format definitions, and the appearances
of identifiers in section names are not indexed. Underlined entries
correspond to where the identifier was declared. Error messages and
a few other things like ``ASCII code dependencies'' are indexed here too.
