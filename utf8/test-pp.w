@* Program.

@ @<Remove lock and save cursor@>=
(void) c;

@ @c
@<Header...@>@;
int done = 0;
int main(void)
{
  char c = '\x1a';
  switch (c) {
	case '\x18': /* C-x */
#if 1==0
		@<Remove lock and save cursor@>@;
		done = 1; /* quit without saving */
#endif
		break;
	case '\x12': /* C-r */
		break;
	case '\x13': /* C-s */
		break;
	case '\x10': /* C-p */
		break;
	case '\x0e': /* C-n */
		break;
	case '\x02': /* C-b */
		break;
	case '\x06': /* C-f */
		break;
	case '\x05': /* C-e */
		break;
	case '\x01': /* C-a */
		break;
	case '\x04': /* C-d */
		break;
	case '\x08': /* C-h */
		break;
	case '\x1d': /* C-] */
		break;
	case '\x16': /* C-v */
		break;
	case '\x1a': /* C-z */
		break;
	case '\x0d': /* C-m */
		break;
	default:
		(void) c;
  }
  return 0;
}

@ @<Header files@>=
/* TODO: sort alphabetically */
@^TODO@>
#include <stdlib.h> /* |malloc|, |mkstemp|, |exit|, |EXIT_FAILURE|, |free|, |realloc|, |getenv| */
#include <stdarg.h> /* |va_end|, |va_start| */
#include <assert.h> /* |assert| */
#include <ncursesw/curses.h> /* |add_wch|, |addwstr|, |chars|, |clrtoeol|, |COLS|, |endwin|,
  |ERR|, |FALSE|, |get_wch|, |initscr|, |keypad|, |KEY_BACKSPACE|, |KEY_RESIZE|,
  |KEY_BACKSPACE|, |KEY_RESIZE|, |KEY_LEFT|, |KEY_RIGHT|, |KEY_UP|, |KEY_DOWN|, |KEY_HOME|,
  |KEY_END|, |KEY_NPAGE|, |KEY_PPAGE|, |KEY_DC|, |KEY_BACKSPACE|, |LINES|, |move|, |noecho|,
  |nonl|, |noraw|, |OK|, |raw|, |refresh|, |standend|, |standout|, |stdscr|, |TRUE|, |wunctrl|,
  |KEY_CODE_YES|, |cchar_t| */
#include <pwd.h> /* |struct passwd|, |pw_uid|, |pw_gid|, |getpwnam| */
#include <stdio.h> /* |fclose|, |fgets|, |fileno|, |snprintf|, |fopen|, |fprintf|, |sscanf| */
#include <locale.h> /* |LC_CTYPE|, |setlocale| */
#include <wchar.h> /* |fgetwc|, |fputwc|, |vswprintf|, |vwprintf|, |wcslen|, |WEOF| */
#include <wctype.h> /* |iswprint| */
#include <string.h> /* |strncmp|, |memset|, |strlen|, |strstr| */
#include <sys/wait.h> /* |wait| */
#include <errno.h> /* |errno| */
#include <limits.h> /* |PATH_MAX| */
#include <unistd.h> /* |unlink|, |readlink|, |fchown|, |getuid| */

@* Index.
