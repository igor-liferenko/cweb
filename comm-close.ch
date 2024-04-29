see explanation in tex/close.ch

@x
  @<Initialize pointers@>;
@y
  atexit(list_close);
  @<Initialize pointers@>;
@z

@x
web_file_open=1;
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal("! Cannot open change file ", change_file_name);
@y
list_add(web_file);
web_file_open=1;
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal("! Cannot open change file ", change_file_name);
list_add(change_file);
@z

@x
  if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
@y
  if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
    list_add(cur_file);
@z

@x
    if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
@y
    if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
      list_add(cur_file);
@z

@x
      fclose(cur_file); include_depth--;
@y
      list_delete(cur_file);
      fclose(cur_file); include_depth--;
@z

@x
@** Index.
@y
@ @<Predecl...@>=
struct node {
   void *f;
   struct node *n;
};
typedef struct node * node;
node list_head = NULL;

void list_add(void *f)
{
   if (f == NULL) return;
   node e = (node) malloc(sizeof (struct node));
   e->f = f, e->n = list_head, list_head = e;
}

void list_delete(void *f)
{
  node c = list_head;
  node p = NULL;
  if (list_head == NULL) return;
  while (c->f != f)
    if (c->n == NULL) return;
    else p = c, c = c->n;
  if (c == list_head) list_head = list_head->n;
  else p->n = c->n;
  free(c);
}

void list_close(void)
{
  for (node c = list_head; c != NULL; c = c->n) fclose(c->f);
}

@** Index.
@z
