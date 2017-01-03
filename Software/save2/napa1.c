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
#define Ux2 PORTA.7     // Prižge tyristor in da dvojno napetost
#define ADC_VREF_TYPE 0xC0
#define LEDUx2 PORTB.3 
#define LEDena PORTA.6
#define LEDdis  PORTA.5

// Declare your global variables here
unsigned int i,ir;            // števec AD pretvornika
char str[8];
unsigned napstev;
unsigned int Uizh,Uinp,Iizh,Uzel;
unsigned int Imax;
unsigned int nrread;
char enable;                 // output enble  
char ADport;
char ui;                        // index meritve izhodne napetosti
char ii;                         // index meritve toka
long int cl,wr;
unsigned int un[10];
unsigned int ip[10];
unsigned int r;
unsigned int up,up1,up2,up3;
unsigned int wrk;
char menu;


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
   if ( Ux2 & (napstev<470)) {Ux2=0;}
   if (!Ux2 & (napstev>512)) {Ux2=1;}
   LEDUx2=Ux2;          
}

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
unsigned int u,s;



// Read the AD conversion result
switch(ADport) {
  case 0:{Uizh=ADCW;   
               if (cl==0) { 
                  if (Uizh>((i*2.55)+25)) {napstev=2*i+i/2; SetU();delay_us(400);}
                  if ((Uizh+25)<(i*2.55)) {napstev=2*i+i/2; SetU();delay_us(400);}
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
               if (Uizh>(i+1)) {napstev--; SetU();delay_us(200);cl=0;}
               if ((Uizh+1)<i) {napstev++; SetU();delay_us(200);}
                
               ADport=1;
               nrread=0;            
               break;}       
  case 1:{ii++;
               if (ii>=5){ii=0;}
               ip[ii]=ADCW;
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
                  nrread=900;
                  if (LEDena) {LEDdis=0;};
               }
               else {        
                  if (cl!=0) {cl++;}
                  if (cl==100000) {cl=0;}
               }      
               nrread++;
               if (nrread==1000) { ADport=2;} 
               break;}
  case 2:{Uinp=ADCW; ADport=0; break;} 
  default:ADport=0;
}
ADMUX=ADport | ADC_VREF_TYPE ;  // doloci adc vhod
ADCSRA|=0x40;

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
// USART Baud Rate: 19200
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

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
napstev=0;                                       // init števca napetosti
SetU();
for (ui=0;ui<10;ui++){un[ui]=0;}
ui=0;
ii=0;
cl=0;
Imax=130;
enable=0;
LEDdis=1;
r=0;
menu=1;
Uzel=0;

i=0;
ADport=2;
ADCSRA|=0x40;

while (1)
   {          

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
         IzpUizh(r);
         sprintf(str,"W");
         lcd_puts(str);         
      
      
      }
      sprintf(str,"%d",menu) ;
      lcd_puts(str);               

               
//      sprintf(str,"%4d ",napstev);
//      lcd_puts(str);
//      sprintf(str,"%3d ",i);
//      lcd_puts(str);

//      IzpUizh(Uizh);
//      IzpIizh();
//      lcd_gotoxy(0,1);
//      sprintf(str,"%4d ",Iizh);
//      lcd_puts(str);      
//      sprintf(str,"%5d",up1);
//      lcd_puts(str);      
//      sprintf(str,"%5d",up2);
//      lcd_puts(str);      
//      sprintf(str,"%5d",up3);
//      lcd_puts(str);      
   };
}
