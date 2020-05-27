@x
  phase_one(); /* read all the user's text and compress it into |tok_mem| */
  phase_two(); /* output the contents of the compressed tables */
@y
  phase_one(); /* read all the user's text and compress it into |tok_mem| */
  if ((C_file=fopen(C_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", C_file_name);
@.Cannot open output file@>
  phase_two(); /* output the contents of the compressed tables */
@z
