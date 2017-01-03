
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

void lcd_control (unsigned char control);

#pragma used-
#pragma library lcd.lib

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

unsigned int i,ir;            
char str[8];
unsigned napstev;
unsigned int Uizh,Uinp,Iizh,Uzel;
unsigned int Imax;
unsigned int nrread;
char enable;                 
char ADport;
char ui;                        
char ii;                         
long int cl,wr;
unsigned int un[10];
unsigned int ip[10];
unsigned int r;
unsigned int up,up1,up2,up3;
unsigned int wrk;
char menu;

void SetU(){   
unsigned char u1;                    
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
if ( PORTA.7      & (napstev<470)) {PORTA.7     =0;}
if (!PORTA.7      & (napstev>512)) {PORTA.7     =1;}
PORTB.3 =PORTA.7     ;          
}

interrupt [15] void adc_isr(void)
{
unsigned int u,s;

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

SetU();
PORTA.5=1;
delay_ms(1);
nrread=900;
if (PORTA.6) {PORTA.5=0;};
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
ADMUX=ADport | 0xC0 ;  
ADCSRA|=0x40;

}

interrupt [2] void ext_int0_isr(void)
{
if ((menu==1)|(menu==3)) { if (enable) {wrk=i;} else {wrk=ir;}}
if (menu==2) {wrk=Imax;}
if (PIND.2        ==PIND.3        ) {
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

PORTA=0x00;
DDRA=0xE0;

PORTB=0x00;
DDRB=0x08;

PORTC=0x00;
DDRC=0xFF;

PORTD=0x00;
DDRD=0xC0;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

GICR|=0x40;
MCUCR=0x01;
MCUCSR=0x00;
GIFR=0x40;

TIMSK=0x00;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0xC0 & 0xff;
ADCSRA=0x8C;

lcd_init(20);

#asm("sei")

PORTC=0;                                         
PORTD.6=0;
PORTD.7=0;
napstev=0;                                       
SetU();
for (ui=0;ui<10;ui++){un[ui]=0;}
ui=0;
ii=0;
cl=0;
Imax=130;
enable=0;
PORTA.5=1;
r=0;
menu=1;
Uzel=0;

i=0;
ADport=2;
ADCSRA|=0x40;

while (1)
{          

if (enable) {ir=i;}  
if (PIND.4          ==0) {
while (PIND.4          ==0) {delay_ms(10);}
menu++;
if (menu>3) {menu=1;}
}
if (PIND.5          ==0){
enable=!enable;  
if (enable) {PORTA.6=1;PORTA.5=0;}
else {PORTA.6=0;PORTA.5=1;} 
if (!enable) {i=0;}
else {i=ir;} 
while (PIND.5          ==0){};        
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

};
}
