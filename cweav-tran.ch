@x
finish_line(); flush_buffer(out_buf,0,0); /* insert a blank line, it looks nice */
@y
@z

@x
@ @<Translate the current section@>= {
  section_count++;
  @<Output the code for the beginning of a new section@>;
  save_position;
  @<Translate the \TEX/ part of the current section@>;
  @<Translate the definition part of the current section@>;
  @<Translate the \CEE/ part of the current section@>;
  @<Show cross-references to this section@>;
  @<Output the code for the end of a section@>;
}
@y
@ @<Translate the current section@>= {
//  section_count++;
  @<Output the code for the beginning of a new section@>;
//  save_position;
  @<Translate the \TEX/ part of the current section@>; /* outputs nothing, but must be present */
  @<Translate the definition part of the current section@>; /* same */
  @<Translate the \CEE/ part of the current section@>;
  finish_line();
}
@z

@x
  out_str("\\end");
@.\\end@>
  finish_line();
@y
@z
