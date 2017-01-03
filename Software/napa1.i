
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

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

char rx_buffer[25];
unsigned char rx_wr_index;

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
char str[12];
unsigned napstev;
unsigned int Uizh,Uinp,Iizh,Uzel,Rbre,Pout,uizh0,iizh0;
unsigned int Imax;
unsigned int Umax;
unsigned int nrread;
char scf;
char rxd[25];
char enable;                 
char ADport;
char ui;                        
char ii,in;                         
long int cl,wr;
unsigned int un[10];
unsigned int ip[10];
unsigned int r;
unsigned int up,up1,up2,up3;
unsigned int wrk;
char menu;

interrupt [12] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0) 
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

if (++rx_wr_index == 25) rx_wr_index=0;

};

}

char tx_buffer[8];

unsigned char tx_wr_index,tx_rd_index,tx_counter;

interrupt [14] void usart_tx_isr(void)
{
if (tx_counter)
{
--tx_counter;
UDR=tx_buffer[tx_rd_index];
if (++tx_rd_index == 8) tx_rd_index=0;
};
}

#pragma used+
void putchar(char c)
{
while (tx_counter == 8);
#asm("cli")
if (tx_counter || ((UCSRA & (1<<5))==0))
{
tx_buffer[tx_wr_index]=c;
if (++tx_wr_index == 8) tx_wr_index=0;
++tx_counter;
}
else
UDR=c;
#asm("sei")
}
#pragma used-

void SendUsb(char* s) {
char i;
i=0;
while (s[++i]!=0x0) {putchar(s[i]);}        
}

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
if ( PORTA.7      & (napstev<450)) {PORTA.7     =0;}
if (!PORTA.7      & (napstev>512)) {
PORTA.7     =1;      
#asm("cli")      
delay_ms(100);
#asm("sei")
}
PORTB.3 =PORTA.7     ;        
}

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x40 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

interrupt [15] void adc_isr(void)
{
unsigned int u,s;

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

SetU();
PORTA.5=1;
delay_ms(1);
nrread=950;
if (PORTA.6) {PORTA.5=0;};
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
ADMUX=ADport | 0xC0 ;  
if (scf==0) {ADCSRA|=0x40;}

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
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x08;

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
scf=0;
Umax=400;
Imax=130;
enable=0;
PORTA.5=1;
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
ADMUX=0x40 & 0xff;
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

sprintf(str,">U=%5d",uizh0);             
SendUsb(str);
delay_ms(10);
sprintf(str,">M=%5d",Umax);             
SendUsb(str);
delay_ms(10);
sprintf(str,">I=%5d",iizh0);              
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
ADMUX=0xC0 & 0xff;
ADCSRA=0x8C;
ADCSRA|=0x40;      

}

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

sprintf(str,">U=%5d",Uizh);             
SendUsb(str);
delay_ms(3);
sprintf(str,">N=%5d",ir);                 
SendUsb(str);
delay_ms(3);
sprintf(str,">I=%5d",Iizh);              
SendUsb(str);
delay_ms(3);
sprintf(str,">M=%5d",Imax);           
SendUsb(str);
delay_ms(3);
sprintf(str,">K=%5d",Uinp);            
SendUsb(str);
delay_ms(3);
sprintf(str,">R=%5d",Rbre);            
SendUsb(str);
delay_ms(3);
sprintf(str,">P=%5d",Pout);            
SendUsb(str);
delay_ms(3);
sprintf(str,">u=%5d",uizh0);            
SendUsb(str);
delay_ms(3);
sprintf(str,">i=%5d",iizh0);              
SendUsb(str);
delay_ms(3);

};
}
