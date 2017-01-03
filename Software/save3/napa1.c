/*****************************************************
Project : Napajalnik
Version :1.1 
Date    : 16.7.2009
Author  : Volk Darko


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <string.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
// USART Receiver buffer
#define RX_BUFFER_SIZE 25
char rx_buffer[RX_BUFFER_SIZE];
unsigned char rx_wr_index;

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
#include <stdio.h>         // Standard Input/Output functions
#include <delay.h>
#define RE1 PIND.2        // Rotary encoder
#define RE2 PIND.3        // Rotary encoder
#define T1 PIND.4          // Tipka 1
#define T2 PIND.5          // Tipka 2
#define Ux2 PORTA.7     // Pri�ge tyristor in da dvojno napetost
#define ADC_VREF_TYPE 0xC0
#define ADC_VREF_TYPE1 0x40
#define LEDUx2 PORTB.3 
#define LEDena PORTA.6
#define LEDdis  PORTA.5

// Declare your global variables here
unsigned int i,ir;            // �tevec AD pretvornika
char str[12];
unsigned napstev;
unsigned int Uizh,Uinp,Iizh,Uzel,Rbre,Pout,uizh0,iizh0;
unsigned int Imax;
unsigned int Umax;
unsigned int nrread;
char scf;
char rxd[RX_BUFFER_SIZE];
char enable;                 // output enble  
char ADport;
char ui;                        // index meritve izhodne napetosti
char ii,in;                         // index meritve toka
long int cl,wr;
unsigned int un[10];
unsigned int ip[10];
unsigned int r;
unsigned int up,up1,up2,up3;
unsigned int wrk;
char menu;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
 status=UCSRA;
 data=UDR;
 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) 
  {  
     if (data=='*') {rx_wr_index=0;}
     rx_buffer[rx_wr_index]=data;  
    
     if (rx_wr_index==6) {
         strcpy(rxd,rx_buffer+2);
         rx_wr_index=0; 
         if (rx_buffer[1]=='U') {
            ir=atoi(rxd);
            i=ir;
            Uzel=ir;
         }
         if (rx_buffer[1]=='I') {
            Imax=atoi(rxd);
         }
         if (rx_buffer[1]=='M') {
            Umax=atoi(rxd);
         }
         if (rx_buffer[1]=='S') {
            scf=1;
         }
      }   

     if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;

  };

}

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif
#include <stdio.h>

void SendUsb(char* s) {
char i;
   i=0;
   while (s[++i]!=0x0) {putchar(s[i]);}        
}

void SetU(){   
unsigned char u1;                    // delovno polje
   if (napstev>1025) {napstev=0;}
   if (napstev>1023) {napstev=1023;}   
   u1=napstev % 256;
   PORTC=u1;         
   u1= napstev / 256;
   switch (u1) {
      case 0: { PORTD.6=0; PORTD.7=0;break;} 
      case 1: { PORTD.6=0; PORTD.7=1;break;} 
      case 2: { PORTD.6=1; PORTD.7=0;break;} 
      case 3: { PORTD.6=1; PORTD.7=1;break;} 
   };      
   if ( Ux2 & (napstev<450)) {Ux2=0;}
   if (!Ux2 & (napstev>512)) {
      Ux2=1;      
      #asm("cli")      
      delay_ms(100);
      #asm("sei")
   }
   LEDUx2=Ux2;        
}

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE1 & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}


// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
unsigned int u,s;
// Read the AD conversion result
switch(ADport) {
  case 0:{Uizh=ADCW; 
               uizh0=Uizh;  
               if (cl==0) { 
                  if (Uizh>((i*2.55)+20)) {napstev=2*i+i/2; SetU();delay_us(200);}
                  if ((Uizh+20)<(i*2.55)) {napstev=2*i+i/2; SetU();delay_us(200);}
                  r=0;
               }
               un[ui]=Uizh;
               ui++;
               if (ui>=3){ui=0;}
               u=0;
               for (s=0;s<3;s++) { u=u+un[s];}

               u=u/3;
               Uizh=u*10;    
               u=u/10;
               Uizh=Uizh/16;
               Uizh=Uizh*10;   
               Uizh=Uizh/16;
               if (Uizh>(i+0)) {napstev--; SetU();delay_us(50);cl=0;}
               if ((Uizh+0)<i) {napstev++; SetU();delay_us(50);}
               if ((Uizh+2)<i) {napstev++; SetU();delay_us(50);}
                
               ADport=1;
               nrread=0;            
               break;}       
  case 1:{ii++;
               if (ii>=5){ii=0;}
               ip[ii]=ADCW;
               iizh0=ADCW;
               Iizh=0;
               for (s=0;s<5;s++) {Iizh=Iizh+ip[s];}

               if (Iizh>Imax) {      
                  cl=1;

                  if (Iizh>(Imax*3)) {    
                     if (r==0) {
                        r=(Uizh*5000)/ip[ii];
                        up=Imax*r/100;   
                        up1=up;
                        
                        up=(Uizh*100)/up;
                        up2=up;              
                        up3=Iizh;
                        napstev=up;
                     }
                     else {napstev--;}
                  }
                  else { napstev--;}
//                  napstev--;
                  SetU();
                  LEDdis=1;
                  delay_ms(1);
                  nrread=950;
                  if (LEDena) {LEDdis=0;};
               }
               else {        
                  if (cl!=0) {cl++;}
                  if (cl==100000) {cl=0;}
               }      
               nrread++;
               if (nrread==1000) { ADport=2;} 
               break;}
  case 2:{Uinp=ADCW*47;Uinp=Uinp/60; ADport=0; break;} 
  default:ADport=0;
}
ADMUX=ADport | ADC_VREF_TYPE ;  // doloci adc vhod
if (scf==0) {ADCSRA|=0x40;}

}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
   if ((menu==1)|(menu==3)) { if (enable) {wrk=i;} else {wrk=ir;}}
   if (menu==2) {wrk=Imax;}
   if (RE1==RE2) {
      wrk--; 
      if ((menu==1)|(menu==3)) {if (wrk>410){wrk=0;}}
      if (menu==2) {if (wrk>5010){wrk=0;}}
   }
   else {
      wrk++;
      if ((menu==1)|(menu==3)) {if (wrk>400){wrk=400;}}
      if (menu==2) {if (wrk>5000){wrk=5000;}}
   }
   if ((menu==1)|(menu==3)) { Uzel=wrk; if (enable) {i=wrk;} else {ir=wrk;}}
   if (menu==2) {Imax=wrk;}
   delay_ms(1);                                  
}

void IzpUizh(unsigned int U){
    sprintf(str,"%2d.",U/10);
    lcd_puts(str);       
    sprintf(str,"%1d",U%10);
    lcd_puts(str);   
}

void IzpIizh(unsigned int I){
    sprintf(str,"%1d.",I/100);
    lcd_puts(str);   
    sprintf(str,"%02d",I%100);
    lcd_puts(str);   
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0xE0;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x08;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xC0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Any change
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x01;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x08;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: Int., cap. on AREF
// ADC Auto Trigger Source: None
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x8C;


// LCD module initialization
lcd_init(20);
// Global enable interrupts
#asm("sei")

PORTC=0;                                         // init D/A pretvornika
PORTD.6=0;
PORTD.7=0;
napstev=0;                                       // init �tevca napetosti
SetU();
for (ui=0;ui<10;ui++){un[ui]=0;}
ui=0;
ii=0;
cl=0;
scf=0;
Umax=400;
Imax=130;
enable=0;
LEDdis=1;
r=0;
menu=1;
Uzel=0;

Umax=0040;

i=0;
ADport=2;
ADCSRA|=0x40;

while (1)
   {       
      in=0;   
      while (scf) {  
         ADMUX=ADC_VREF_TYPE1 & 0xff;
         ADCSRA=0x84;
         i=0;
         sprintf(str,"******"); 
         SendUsb(str);
         delay_ms(10);
         while ((Umax>uizh0) & (iizh0<Imax)) {
            napstev=i;
            SetU();
            delay_ms(20);
            uizh0=read_adc(0);      
            delay_ms(20);
            uizh0=read_adc(0);      
            delay_ms(20);
            uizh0=read_adc(0);      
            uizh0=uizh0*5;    
            uizh0=uizh0/8;
            uizh0=uizh0*5;   
            uizh0=uizh0/4;
            
            delay_ms(2);
            iizh0=read_adc(1);      
            iizh0=iizh0*5;       
            
            lcd_gotoxy(10,0);       
            IzpUizh(uizh0);                                                
            
            sprintf(str,">U=%5d",uizh0);             // U izhodna
            SendUsb(str);
            delay_ms(10);
            sprintf(str,">M=%5d",Umax);             // U max 
            SendUsb(str);
            delay_ms(10);
            sprintf(str,">I=%5d",iizh0);              // I izhodni
            SendUsb(str);
            delay_ms(10);
            sprintf(str,">T%5d",Imax);              
            SendUsb(str);
            delay_ms(10);
            i++;
          }     
          i=0;
          napstev=i;
          delay_ms(10);
          scf=0;
          ADMUX=ADC_VREF_TYPE & 0xff;
          ADCSRA=0x8C;
          ADCSRA|=0x40;      
          
    
      }
   
      if (enable) {ir=i;}  
      if (T1==0) {
         while (T1==0) {delay_ms(10);}
         menu++;
         if (menu>3) {menu=1;}
      }
      if (T2==0){
         enable=!enable;  
         if (enable) {LEDena=1;LEDdis=0;}
         else {LEDena=0;LEDdis=1;} 
         if (!enable) {i=0;}
         else {i=ir;} 
         while (T2==0){};        
      }
              


    switch(menu) {
       case 1:{
               lcd_gotoxy(1,0);
               sprintf(str,"->") ;
               lcd_puts(str);               
               lcd_gotoxy(1,1);
               sprintf(str,"  ") ;
               lcd_puts(str);
               break;               
       }
       case 2:{
               lcd_gotoxy(1,0);
               sprintf(str,"  ") ;
               lcd_puts(str);               
               lcd_gotoxy(1,1);
               sprintf(str,"->") ;
               lcd_puts(str);               
               break;               
       }
       case 3:{
               lcd_gotoxy(1,0);
               sprintf(str,"->") ;
               lcd_puts(str);               
               break;               
       }
        
         
    }     


      lcd_gotoxy(0,0);
      sprintf(str,"U") ;
      lcd_puts(str);
      lcd_gotoxy(3,0);
      sprintf(str,"[") ;
      lcd_puts(str);
      IzpUizh(Uzel);
      sprintf(str,"] ") ;
      lcd_puts(str);
      IzpUizh(Uizh);
      sprintf(str," V") ;
      lcd_puts(str);
      if ((menu==1)|(menu==2)) {
         lcd_gotoxy(0,1);
         sprintf(str,"I") ;
         lcd_puts(str);
         lcd_gotoxy(3,1);
         sprintf(str,"[") ;
         lcd_puts(str);
         IzpIizh(Imax/10);
         sprintf(str,"] ") ;
         lcd_puts(str);
         IzpIizh(Iizh/10);
         sprintf(str," A") ;
         lcd_puts(str);
      }
      if (menu==3) {
         lcd_gotoxy(0,1);           
         sprintf(str,"Rb ") ;
         lcd_puts(str);
         if (Iizh!=0) {      
            wr=Uizh; 
            wr=wr*1000;
            wr=wr/Iizh;
            r=wr;
            Rbre=r;       
            IzpUizh(r);       
            }
         else {
            sprintf(str,"    ") ;
            lcd_puts(str);
         }
         sprintf(str," Po ");
         lcd_puts(str); 
         wr=Uizh;
         wr=wr*Iizh;
         wr=wr/1000;    
         r=wr;     
         Pout=r;
         IzpUizh(r);
         sprintf(str,"W");
         lcd_puts(str);

//            lcd_puts(rx_buffer);         
      }
      if (Iizh!=0) {      
         wr=Uizh; 
         wr=wr*1000;
         wr=wr/Iizh;
         Rbre=wr;       
      }
      wr=Uizh;
      wr=wr*Iizh;
      wr=wr/1000;    
      Pout=wr;

      sprintf(str,">U=%5d",Uizh);             // U izhodna
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">N=%5d",ir);                 // U nastavljena
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">I=%5d",Iizh);              // I izhodni
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">M=%5d",Imax);           // I maximalni
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">K=%5d",Uinp);            // U vhodna
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">R=%5d",Rbre);            // R bremena
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">P=%5d",Pout);            // P out
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">u=%5d",uizh0);            // U izh brez konverzije
      SendUsb(str);
      delay_ms(3);
      sprintf(str,">i=%5d",iizh0);              // I izh brez konverzije
      SendUsb(str);
      delay_ms(3);

   };
}
