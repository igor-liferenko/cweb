Close any open input files before exiting.
Otherwise they will be closed automatically,
which may result to "Segmentation fault" on
old systems (due to the glibc bug in handling
wide-character streams).

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

void list_close(void)
{
  for (node c = list_head; c != NULL; c = c->n) fclose(c->f);
}

@** Index.
@z
