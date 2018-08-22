@ In this test we show that CFGOK must not be called after configuring
non-control endpoint.

Result: `\.=' is not output.

@(test@>=
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#define USBRF 5

const uint8_t dev_desc[]
@t\hskip2.5pt@> @=PROGMEM@> = { @t\1@> @/
  0x12, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x20, 0xEB, 0x03, @/
@t\2@> 0x13, 0x20, 0x00, 0x10, 0x00, 0x00, 0x00, 1 @/
};

const uint8_t user_conf_desc[]
@t\hskip2.5pt@> @=PROGMEM@> = { @t\1@> @/
  0x09, 0x02, 0x22, 0x00, 0x01, 0x01, 0x00, 0x80, 0x32, 0x09, 0x04, @/
  0x00, 0x00, 0x01, 0x03, 0x00, 0x00, 0x00, 0x09, 0x21, 0x00, 0x01, @/
  0x00, 0x01, 0x22, 0x2b, 0x00, 0x07, 0x05, 0x81, 0x03, 0x08, 0x00, @/
@t\2@> 0x0f @/
};

const uint8_t rep_desc[]
@t\hskip2.5pt@> @=PROGMEM@> = { @t\1@> @/
  0x05, 0x01, 0x09, 0x06, 0xa1, 0x01, 0x05, 0x07, 0x75, 0x01, 0x95, @/
  0x08, 0x19, 0xe0, 0x29, 0xe7, 0x15, 0x00, 0x25, 0x01, 0x81, 0x02, @/
  0x75, 0x08, 0x95, 0x01, 0x81, 0x03, 0x75, 0x08, 0x95, 0x06, 0x19, @/
@t\2@> 0x00, 0x29, 0x65, 0x15, 0x00, 0x25, 0x65, 0x81, 0x00, 0xc0 @/
};

void send_descriptor(const void *buf, int size)
{
  int empty_packet = 0;
  if (size < wLength && size % 32 == 0)
    empty_packet = 1;
  if (size > wLength)
    size = wLength;
  while (size != 0) {
    while (!(UEINTX & 1 << TXINI)) ;
    int nb_byte = 0;
    while (size != 0) {
      if (nb_byte++ == 32)
        break;
      UEDATX = pgm_read_byte(buf++);
      size--;
    }
    UEINTX &= ~(1 << TXINI);
  }
  if (empty_packet) {
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
  }
  while (!(UEINTX & 1 << RXOUTI)) ;
  UEINTX &= ~(1 << RXOUTI);
}

volatile int connected = 0;
void main(void)
{
  UHWCON |= 1 << UVREGE;

  UBRR1 = 34;
  UCSR1A |= 1 << U2X1;
  UCSR1B = 1 << TXEN1;
  UDR1 = 'v';

  PLLCSR = 1 << PINDIV;
  PLLCSR |= 1 << PLLE;
  while (!(PLLCSR & (1<<PLOCK))) ;

  USBCON |= 1 << USBE;
  USBCON &= ~(1 << FRZCLK);

  USBCON |= 1 << OTGPADE;

  UDIEN |= 1 << EORSTE;
  sei();
  UDCON &= ~(1 << DETACH);

  uint16_t wLength;
  while (!connected)
    if (UEINTX & 1 << RXSTPI)
      switch (UEDATX | UEDATX << 8) {
      case 0x0500:
        UDADDR = UEDATX & 0x7F;
        UEINTX &= ~(1 << RXSTPI);
        UEINTX &= ~(1 << TXINI);
        while (!(UEINTX & (1 << TXINI))) ; /* wait until previous packet was sent */
        while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = 'A';
        UDADDR |= 1 << ADDEN;
        break;
      case 0x0680:
        switch (UEDATX | UEDATX << 8) {
        case 0x0100:
          (void) UEDATX; @+ (void) UEDATX;
          wLength = UEDATX | UEDATX << 8;
          UEINTX &= ~(1 << RXSTPI);
          while (!(UCSR1A & 1 << UDRE1)) ;
          if (wLength==8) UDR1 = 'd'; else UDR1 = 'D';
          send_descriptor(dev_desc, wLength < sizeof dev_desc ? 8 : sizeof dev_desc);
          break;
        case 0x0200:
          (void) UEDATX; @+ (void) UEDATX;
          wLength = UEDATX | UEDATX << 8;
          UEINTX &= ~(1 << RXSTPI);
          while (!(UCSR1A & 1 << UDRE1)) ;
          if (wLength==9) UDR1 = 'g'; else UDR1 = 'G';
          send_descriptor(&user_conf_desc, wLength);
          break;
        case 0x0600:
          UECONX |= 1 << STALLRQ;
          UEINTX &= ~(1 << RXSTPI);
          while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = 'Q';
          break;
        }
        break;
      case 0x0681:
        UEINTX &= ~(1 << RXSTPI);
        while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = 'R';
        send_descriptor(rep_desc, sizeof rep_desc);
        connected = 1;
        UENUM = 1;
        UECONX |= 1 << EPEN;
        UECFG0X = 1 << EPTYPE1 | 1 << EPTYPE0 | 1 << EPDIR;
        UECFG1X = 0;
        UECFG1X |= 1 << ALLOC;
        if (!(UESTA0X & 1 << CFGOK)) {
          while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = '=';
        }
        break;
      case 0x0900:
        UEINTX &= ~(1 << RXSTPI);
        UEINTX &= ~(1 << TXINI);
        while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = 'S';
        break;
      case 0x0a21:
        UEINTX &= ~(1 << RXSTPI);
        UEINTX &= ~(1 << TXINI);
        while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = 'I';
        break;
      }

  while (1) ;
}

ISR(USB_GEN_vect)
{
  UDINT &= ~(1 << EORSTI);
  if (!connected) {
    UECONX |= 1 << EPEN;
    UECFG1X = 1 << EPSIZE1;
    UECFG1X |= 1 << ALLOC;
    while (!(UCSR1A & 1 << UDRE1)) ; UDR1 = 'r';
  }
}
