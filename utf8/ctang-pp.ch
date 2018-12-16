For testing use test-pp.w, compiled with clang (go step-by-step in gdb with and without "#if-endif"
block). After you finish this change-file, remove test-pp.w
(and check that test-pp2.w will work - "cat test" must not be empty after running "ctangle test-pp2" - and remove it too).

As the result of this change-file, this part from test-pp.c:
--------------------
#line 7 "test-pp.w"

int done= 0;
int main(void)
{
char c= '\x1a';
switch(c){
case'\x18':
#if 0
/*2:*/
#line 3 "test-pp.w"

(void)c;

/*:2*/
#line 15 "test-pp.w"

done= 1;
#endif
break;
case'\x12':
--------------------
must be this:
-----------------------
#line 7 "test-pp.w"

int done= 0;
int main(void)
{
char c= '\x1a';
switch(c){
case'\x18':
#if 0

done= 1;
#endif
break;
case'\x12':
-----------------------
