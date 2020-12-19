@x
char translit[128][translit_length];
@y
char translit[256][translit_length];
@z

@x
  for (i=0;i<128;i++) sprintf(translit[i],"X%02X",(unsigned)(128+i));
@y
sprintf(translit[0x80], "A");
sprintf(translit[0xa0], "a");
sprintf(translit[0x81], "B");
sprintf(translit[0xa1], "b");
sprintf(translit[0x82], "V");
sprintf(translit[0xa2], "v");
sprintf(translit[0x83], "G");
sprintf(translit[0xa3], "g");
sprintf(translit[0x84], "D");
sprintf(translit[0xa4], "d");
sprintf(translit[0x85], "E");
sprintf(translit[0xa5], "e");
sprintf(translit[0xf0], "IO");
sprintf(translit[0xf1], "io");
sprintf(translit[0x86], "ZH");
sprintf(translit[0xa6], "zh");
sprintf(translit[0x87], "Z");
sprintf(translit[0xa7], "z");
sprintf(translit[0x88], "I");
sprintf(translit[0xa8], "i");
sprintf(translit[0x89], "J");
sprintf(translit[0xa9], "j");
sprintf(translit[0x8a], "K");
sprintf(translit[0xaa], "k");
sprintf(translit[0x8b], "L");
sprintf(translit[0xab], "l");
sprintf(translit[0x8c], "M");
sprintf(translit[0xac], "m");
sprintf(translit[0x8d], "N");
sprintf(translit[0xad], "n");
sprintf(translit[0x8e], "O");
sprintf(translit[0xae], "o");
sprintf(translit[0x8f], "P");
sprintf(translit[0xaf], "p");
sprintf(translit[0x90], "R");
sprintf(translit[0xe0], "r");
sprintf(translit[0x91], "S");
sprintf(translit[0xe1], "s");
sprintf(translit[0x92], "T");
sprintf(translit[0xe2], "t");
sprintf(translit[0x93], "U");
sprintf(translit[0xe3], "u");
sprintf(translit[0x94], "F");
sprintf(translit[0xe4], "f");
sprintf(translit[0x95], "KH");
sprintf(translit[0xe5], "kh");
sprintf(translit[0x96], "CZ");
sprintf(translit[0xe6], "cz");
sprintf(translit[0x97], "CH");
sprintf(translit[0xe7], "ch");
sprintf(translit[0x98], "SH");
sprintf(translit[0xe8], "sh");
sprintf(translit[0x99], "SCH");
sprintf(translit[0xe9], "sch");
sprintf(translit[0x9a], "X");
sprintf(translit[0xea], "x");
sprintf(translit[0x9b], "Y");
sprintf(translit[0xeb], "y");
sprintf(translit[0x9c], "$");
sprintf(translit[0xec], "$");
sprintf(translit[0x9d], "EH");
sprintf(translit[0xed], "eh");
sprintf(translit[0x9e], "YU");
sprintf(translit[0xee], "yu");
sprintf(translit[0x9f], "YA");
sprintf(translit[0xef], "ya");
sprintf(translit[0xfc], "No");
@z

@x
      C_printf("%s",translit[z-0200]);
@y
      C_printf("%s",translit[z]);
@z
