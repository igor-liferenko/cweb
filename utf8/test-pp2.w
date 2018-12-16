@ @(test@>=
#include <avr/io.h>

#define configure @,@,@,@,@, UECONX |= 1 << EPEN;@+UECFG1X = 1 << EPSIZE1;@+UECFG1X |= 1 << ALLOC;
#define configured_en (UECONX & 1 << EPEN)
#define configured_sz (UECFG1X & 1 << EPSIZE1)
#define configured_al (UECFG1X & 1 << ALLOC)

void main(void)
{
  UHWCON |= 1 << UVREGE;

  UBRR1 = 34; // table 18-12 in datasheet
  UCSR1A |= 1 << U2X1;
  UCSR1B = 1 << TXEN1;

  PLLCSR = 1 << PINDIV;
  PLLCSR |= 1 << PLLE;
  while (!(PLLCSR & 1 << PLOCK)) ;

  USBCON |= 1 << USBE;
  USBCON &= ~(1 << FRZCLK);

  USBCON |= 1 << OTGPADE;

  UDCON &= ~(1 << DETACH);

  configure;

  while (!(UDINT & 1 << EORSTI)) ;
  if (!configured_en) { @+ while (!(UCSR1A & 1 << UDRE1)) ; @+ UDR1 = 'e'; @+ }
  if (!configured_sz) { @+ while (!(UCSR1A & 1 << UDRE1)) ; @+ UDR1 = 's'; @+ }
  if (!configured_al) { @+ while (!(UCSR1A & 1 << UDRE1)) ; @+ UDR1 = 'a'; @+ }
}
