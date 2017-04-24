This change-file is applied both to utf8-enabled and original (8-bit) cweave in build.sh

This change-file was created for using ccw, because the order of resulting index entries
depends on hash sum, and as utf8 and 8-bit strings consist of different bytes, the hash sum
may be different, and they may be added to the hash in different order, and thus get to the
index in different order, which makes ccw raise a false alert.

This curious effect can be seen if we change hash_size from 353 to 367 and compare
cweave.idx before and after:
    --- /tmp/cweave-353.idx
    +++ /tmp/cweave-367.idx
    @@ -541,8 +541,8 @@
     \I\\{reswitch}, \[195], 198, \[214].
     \I\\{rhs}, \[68], 70, 71.
     \I\\{right\_preproc}, \[41], 45, 176.
    -\I\\{Rlink}, \[9].
     \I\\{rlink}, \[9], 16, 75, 247.
    +\I\\{Rlink}, \[9].
     \I\\{roman}, \[16], 62, 242.
     \I\\{root}, \[9], 76, 248.
     \I\\{rpar}, \[97], 98, 101, 102, 117, 118, 120, 127, 153, 162, 176.

This effect happens only to words that are equal in lowercase form.

@x
@ @<Output index...@>= {
@y
@ @<Global...@>=
char *byte_cur, *byte_nxt;
wchar_t wc1, wc2;

@ If there is more than one element in the current list, then all strings of
bytes signified by the elements of the list are equal in lowercase form and thus have
equal length. We sort such list in ascending order (uppercase letter has lesser
code value than corresponding lowercase letter).

@<Output index...@>= {
if (blink[sort_ptr->head-name_dir]!=NULL)
  @<Sort the list at |sort_ptr| before output@>@;
@z

@x
@ @<Output the name...@>=
@y
@ @<Sort the list...@>= {
loop:
  next_name=sort_ptr->head;
  do {
    cur_name=next_name;
    next_name=blink[cur_name-name_dir];
#ifdef _WCHAR_H
    byte_cur=cur_name->byte_start;
    byte_nxt=next_name->byte_start;
    while (byte_cur != (cur_name+1)->byte_start) {
      mbtowc(&wc1,byte_cur,MB_CUR_MAX);
      mbtowc(&wc2,byte_nxt,MB_CUR_MAX);
      if (wc1 > wc2) {
#else
      if (strncmp(cur_name->byte_start,next_name->byte_start,length(cur_name)) > 0) {
#endif
	      @<Swap neighbour elements@>@;
	      goto loop;
      }
#ifdef _WCHAR_H
      byte_cur+=mblen(byte_cur,MB_CUR_MAX);
      byte_nxt+=mblen(byte_nxt,MB_CUR_MAX);
    }
#endif
  } while (blink[next_name-name_dir]!=NULL);
}

@ @<Swap...@>=
if (cur_name==sort_ptr->head)
  sort_ptr->head=next_name;
else {
  @<Find link to |cur_name|@>@;
  blink[cur_link-name_dir]=next_name;
}
blink[cur_name-name_dir]=blink[next_name-name_dir];
blink[next_name-name_dir]=cur_name;

@ @<Find link...@>=
name_pointer cur_link=sort_ptr->head;
while (blink[cur_link-name_dir]!=cur_name) cur_link=blink[cur_link-name_dir];

@ @<Output the name...@>=
@z
