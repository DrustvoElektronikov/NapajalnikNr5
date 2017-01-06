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
******************************************************
V1.2

-dodan x10 za nastavitev toka
-dodan zagon na 5V
-dodan menu 4 (std. vrednosti napetosti)
******************************************************
V1.3

-enkder izklopljen pri menu=4 in aktivnem izhodu
-dodan wellcome ekran
-dodane nastavitve (zagonski U,I, tokovna limita, parametri za enkoder)
-dodane hitrosti za enkoder, 3 koraki
-dodana tokovna limita (izhod->0)
-shranjevanje nastavitev v eeprom
******************************************************
V1.4

** ZAHTEVA SPREMEMBO HW !! **

-spremenjen vhod za RE2 in izhod za LED_Ux2 (zaradi sprostitve INT1 in OC0 pinov)
-dodana regulacija osvetlitve (PWM na timer 0)
-dodana detekcija izpada napajanja (INT1)
-dodane nastavitve za osvetlitev in shranjevanje zadnje napetosti in toka
******************************************************
V1.4a

-dodan init LCD-ja ob pritisku na tipko
******************************************************
V1.5

-dodan CRC pri komunikaciji
-dodan E blok pri komunikaciji
-optimizacija RX interupta
-dodana spodnja meja za tokovno limito IMAX_MIN (10mA)
******************************************************
V1.5a

-komunikacija predelana na binarne pakete v obe smeri
-par optimizacij glede lcd_puts()
-upoèasnitev izpisa upornosti in moèi (da je berljivo), dodan znak za ohm
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

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
#include <stdio.h>         // Standard Input/Output functions
#include <delay.h>
#define RE1 PIND.2        // Rotary encoder
//#define RE2 PIND.3        // Rotary encoder
#define RE2 PINA.3        // Rotary encoder
#define T1 PIND.4          // Tipka 1
#define T2 PIND.5          // Tipka 2
#define Ux2 PORTA.7     // Prižge tyristor in da dvojno napetost
#define ADC_VREF_TYPE 0xC0
#define ADC_VREF_TYPE1 0x40
//#define LEDUx2 PORTB.3
#define LEDUx2 PORTA.4
#define LEDena PORTA.6
#define LEDdis  PORTA.5

#define IMAX_MIN 10

// Declare your global variables here
unsigned int i,ir;            // števec AD pretvornika
char str[16];
unsigned napstev;
unsigned int Uizh,Uinp,Iizh,Uzel,Rbre,Pout,uizh0,iizh0;
unsigned int Imax;
unsigned int Umax;
unsigned int nrread;
char scf;
char enable;                 // output enble
char ADport;
char ui;                        // index meritve izhodne napetosti
char ii,in;                         // index meritve toka
long int cl,wr;
unsigned int un[10];
unsigned int ip[10];
unsigned int r;
unsigned int up,up1,up2,up3;
volatile unsigned int wrk;
volatile static signed int wrk2=0;
volatile char menu;

unsigned int enc_s1,enc_s2,enc_t1,enc_t2,enc_t3,enc_is1,enc_is2,osv;

volatile unsigned int tick=0;
volatile bit gor=0,dol=0,limit=0,pwrfail=1;

volatile unsigned int istart,ustart;
eeprom unsigned int ee_istart,ee_ustart;
eeprom unsigned char ee_limit,ee_pwrfail;
eeprom unsigned int ee_enc_s1,ee_enc_s2,ee_enc_t1,ee_enc_t2,ee_enc_t3,ee_osv;
#define EE_LOGIC_ONE    0x39
#define MENU_LAST       110

typedef struct
{
    unsigned int Umax; // max U, ki jo napajalnik zmore
    unsigned int Ulim; // max U, soft omejitev
    unsigned int Uset; // nastavljena U
    unsigned int Uizh; // dejanska U
    unsigned int Imax; // max I, ki ga napajalnik zmore
    unsigned int Ilim; // nastavljena limita I
    unsigned int Iizh; // dejanski I
    char enable;       // izhod on/off    
    char limit;        // limit on/off
} com_tx;

typedef struct
{
    unsigned int Ulim; // max U, soft omejitev
    unsigned int Uset; // nastavljena U
    unsigned int Ilim; // nastavljena limita I
    char enable;       // izhod on/off    
    char limit;        // limit on/off
} com_rx;

inline void sei(void)
{
#asm("sei")
}

inline void cli(void)
{
#asm("cli")
}

char _crc_ibutton_update(char icrc, char data)
{
    char i;

    icrc = icrc ^ data;
    for (i = 0; i < 8; i++)
    {
        if ((icrc & 0x01) != 0)
            icrc = (icrc >> 1) ^ 0x8C;
        else
            icrc >>= 1;
    }

    return icrc;
}

char CalcCRC(char *data, char len)
{
    char crc=0x42;
    while(len--)
        crc=_crc_ibutton_update(crc, *data++);
    return (crc);
}

void output_on(void)
{
    enable=1;
    LEDena=1;
    LEDdis=0;
    i=ir;
}

void output_off(void)
{
    enable=0;
    LEDena=0;
    LEDdis=1;
    i=0;
}

void Parse_RX(void)
{
    com_rx *rx;
    
    rx=(com_rx *)&rx_buffer;

    if(rx->Ulim>40000)
        rx->Ulim=40000;
    if(rx->Ulim==0)
        rx->Ulim=40000;
    Umax=rx->Ulim/100;
                  
    rx->Uset/=100;
    if(rx->Uset>Umax)
        rx->Uset=Umax;
    ir=rx->Uset;     
    Uzel=ir;

    if(rx->Ilim<IMAX_MIN)
        rx->Ilim=IMAX_MIN;
    if(rx->Ilim>5000)
        rx->Ilim=5000;
    Imax=rx->Ilim;

    if(rx->enable)
        output_on();
    else
        output_off();

    limit=!!rx->limit;
}

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
    char status,dat;
    char rcrc,ccrc;
    static char rxs=0;
    static char rxdc=0;   

    status=UCSRA;
    dat=UDR;   

    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {
        switch(rxs)
        {
            case 0:
            case 1:
            case 2:
                if (dat == 0xaa)
                    rxs++;
                else
                    rxs = 0;
                break;
            case 3:
                if (dat == 0xab)
                    rxs++;
                else if(dat!=0xaa)
                    rxs = 0;
                break;
            case 4:
                rx_buffer[rxdc++] = dat;
                if (rxdc == sizeof(com_rx))
                    rxs++;
                break;
            case 5:
                rcrc = dat;
                ccrc = CalcCRC(rx_buffer, sizeof(com_rx));
                if (rcrc == ccrc)
                    Parse_RX();
                rxs = 0;
                rxdc = 0;
                break;
            default:
                rxs = 0;
                rxdc = 0;
                break;
        }        
    }   
    else
        rxs=rxdc=0;
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
        if (++tx_rd_index == TX_BUFFER_SIZE)
            tx_rd_index=0;
    };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
    while (tx_counter == TX_BUFFER_SIZE)
        ;
    cli();
    if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
    {
        tx_buffer[tx_wr_index]=c;
        if (++tx_wr_index == TX_BUFFER_SIZE) 
            tx_wr_index=0;
        ++tx_counter;
    }
    else
        UDR=c;
    sei();
}
#pragma used-
#endif

void send_status(void)
{
    char i,crc;
    char *d;    
    com_tx txd;

    txd.Umax=40000;
    txd.Ulim=Umax*100;
    txd.Uset=ir*100;
    txd.Uizh=Uizh*100;
    txd.Imax=5000;
    txd.Ilim=Imax;
    txd.Iizh=Iizh;
    txd.enable=enable;
    txd.limit=limit;
    d=(char *)&txd;
    crc=CalcCRC(d,sizeof(txd));
    for(i=0;i<4;i++)
        putchar(0xaa);
    putchar(0xab);
    for(i=0;i<sizeof(txd);i++)
        putchar(*d++);
    putchar(crc);
}

void output_toggle(void)
{
    if(enable)
        output_off();
    else
        output_on();
}

void SetU()
{
    unsigned char u1;                    // delovno polje
    if(napstev>1025)
        napstev=0;
    if(napstev>1023)
        napstev=1023;
    u1=napstev%256;
    PORTC=u1;
    u1=napstev/256;
    switch(u1)
    {
        case 0:
            PORTD.6=0;
            PORTD.7=0;
            break;
        case 1:
            PORTD.6=0;
            PORTD.7=1;
            break;
        case 2:
            PORTD.6=1;
            PORTD.7=0;
            break;
        case 3:
            PORTD.6=1;
            PORTD.7=1;
            break;
    }
    if(Ux2 && napstev<450)
        Ux2=0;
    if(!Ux2 && napstev>512)
    {
        Ux2=1;
        cli();
        delay_ms(100);
        sei();
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
    while ((ADCSRA & 0x10)==0)
        ;
    ADCSRA|=0x10;
    return ADCW;
}

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
    unsigned int u,s;
    // Read the AD conversion result
    switch(ADport)
    {
        case 0:
            Uizh=ADCW;
            uizh0=Uizh;
            if (cl==0)
            {
                if (Uizh>((i*2.55)+20))
                {
                    napstev=2*i+i/2;
                    SetU();
                    delay_us(200);
                }
                if ((Uizh+20)<(i*2.55))
                {
                    napstev=2*i+i/2;
                    SetU();
                    delay_us(200);
                }
                r=0;
            }
            un[ui]=Uizh;
            ui++;
            if (ui>=3)
                ui=0;
            u=0;
            for (s=0;s<3;s++)
                u=u+un[s];
            u=u/3;
            Uizh=u*10;
            u=u/10;
            Uizh=Uizh/16;
            Uizh=Uizh*10;
            Uizh=Uizh/16;
            if (Uizh>(i+0))
            {
                napstev--;
                SetU();
                delay_us(50);
                cl=0;
            }
            if ((Uizh+0)<i)
            {
                napstev++;
                SetU();
                delay_us(50);
            }
            if ((Uizh+2)<i)
            {
                napstev++;
                SetU();
                delay_us(50);
            }

            ADport=1;
            nrread=0;
            break;
        case 1:
            ii++;
            if (ii>=5)
                ii=0;
            ip[ii]=ADCW;
            iizh0=ADCW;
            Iizh=0;
            for (s=0;s<5;s++)
                Iizh=Iizh+ip[s];
            if (Iizh>Imax)
            {
                if(limit)
                    output_off();
                cl=1;
                if (Iizh>(Imax*3))
                {
                    if (r==0)
                    {
                        r=(Uizh*5000)/ip[ii];
                        up=Imax*r/100;
                        up1=up;
                        up=(Uizh*100)/up;
                        up2=up;
                        up3=Iizh;
                        napstev=up;
                    }
                    else
                        napstev--;
                }
                else
                    napstev--;
                SetU();
                LEDdis=1;
                delay_ms(1);
                nrread=950;
                if (LEDena)
                    LEDdis=0;
            }
            else
            {
                if (cl!=0)
                    cl++;
                if (cl==100000)
                    cl=0;
            }
            nrread++;
            if (nrread==1000)
                ADport=2;
            break;
        case 2:
            Uinp=ADCW*47;
            Uinp=Uinp/60;
            ADport=0;
            break;
        default:
            ADport=0;
    }
    ADMUX=ADport | ADC_VREF_TYPE ;  // doloci adc vhod
    if (scf==0)
        ADCSRA|=0x40;
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    cli();
    OCR0=0;
    if(pwrfail==1)
    {
        PORTD.7=0;
        PORTD.6=0;
        PORTC=0;
        ee_ustart=ir;
        ee_istart=Imax;
        lcd_gotoxy(0,0);
        lcd_puts("      bye        ");
        for(;;)
        {
        }
    }
    OCR0=osv;
    sei();
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    unsigned int tmr;
    tmr=TCNT1;
    switch(menu)
    {
        case 1:
        case 3:
        case 4:
            if(enable)
                wrk=i;
            else
                wrk=ir;
            break;
        case 2:
            wrk=Imax;
            break;
        case 101:
        case 102:
        case 103:
        case 104:
        case 105:
        case 106:
        case 107:
        case 108:
        case 109:
        case 110:
            wrk=menu;
            break;
        case 151:
            wrk=ustart;
            break;
        case 152:
            wrk=istart;
            break;
        case 153:
            wrk=limit;
            break;
        case 154:
            wrk=enc_t1;
            break;
        case 155:
            wrk=enc_t2;
            break;
        case 156:
            wrk=enc_t3;
            break;
        case 157:
            wrk=enc_s1;
            break;
        case 158:
            wrk=enc_s2;
            break;
        case 159:
            wrk=osv;
            break;
        case 160:
            wrk=pwrfail;
            break;
    }

    if (RE1==RE2)       //dol
    {
        switch(menu)
        {
            case 1:
            case 3:
            case 151:
            case 154:
            case 155:
            case 156:
            case 157:
            case 158:
            case 159:
                if(!gor)
                {
                    if(tmr>enc_t1)
                        wrk-=1;
                    else if(dol && tmr>enc_t2)
                        wrk-=enc_s1;
                    else if(dol && tmr>enc_t3)
                        wrk-=enc_s2;
                    dol=1;
                }
                break;
            case 2:
            case 152:
                if(!gor)
                {
                    if(tmr>enc_t1)
                        wrk-=10;
                    else if(dol && tmr>enc_t2)
                        wrk-=enc_is1;
                    else if(dol && tmr>enc_t3)
                        wrk-=enc_is2;
                    dol=1;
                }
                break;
            case 4:
                if(!enable)
                {
                    if (wrk2<-2)
                    {
                        wrk2=0;
                        if(wrk<=18)
                            wrk=0;
                        else if(wrk<=25)
                            wrk=18;
                        else if(wrk<=33)
                            wrk=25;
                        else if(wrk<=50)
                            wrk=33;
                        else if(wrk<=90)
                            wrk=50;
                        else if(wrk<=120)
                            wrk=90;
                        else if(wrk<=150)
                            wrk=120;
                        else if(wrk<=240)
                            wrk=150;
                        else
                            wrk=240;
                    }
                    else
                        wrk2--;
                }
                break;
            case 101:
            case 102:
            case 103:
            case 104:
            case 105:
            case 106:
            case 107:
            case 108:
            case 109:
            case 110:
            case 153:
            case 160:
                if (wrk2<-2)
                {
                    wrk2=0;
                    wrk--;
                }
                else
                    wrk2--;
                break;
        }
    }
    else        //gor
    {
        switch(menu)
        {
            case 1:
            case 3:
            case 151:
            case 154:
            case 155:
            case 156:
            case 157:
            case 158:
            case 159:
                if(!dol)
                {
                    if(tmr>enc_t1)
                        wrk+=1;
                    else if(gor && tmr>enc_t2)
                        wrk+=enc_s1;
                    else if(gor && tmr>enc_t3)
                        wrk+=enc_s2;
                    gor=1;
                }
                break;
            case 2:
            case 152:
                if(!dol)
                {
                    if(tmr>enc_t1)
                        wrk+=10;
                    else if(gor && tmr>enc_t2)
                        wrk+=enc_is1;
                    else if(gor && tmr>enc_t3)
                        wrk+=enc_is2;
                    gor=1;
                }
                break;
            case 4:
                if(!enable)
                {
                    if(wrk2>2)
                    {
                        wrk2=0;
                        if(wrk>=150)
                            wrk=240;
                        else if(wrk>=120)
                            wrk=150;
                        else if(wrk>=90)
                            wrk=120;
                        else if(wrk>=50)
                            wrk=90;
                        else if(wrk>=33)
                            wrk=50;
                        else if(wrk>=25)
                            wrk=33;
                        else if(wrk>=18)
                            wrk=25;
                        else
                            wrk=18;
                    }
                    else
                        wrk2++;
                }
                break;
            case 101:
            case 102:
            case 103:
            case 104:
            case 105:
            case 106:
            case 107:
            case 108:
            case 109:
            case 110:
            case 153:
            case 160:
                if(wrk2>2)
                {
                    wrk2=0;
                    wrk++;
                }
                else
                    wrk2++;
                break;
        }
    }

    if(wrk>50000)
        wrk=0;
    switch(menu)
    {
        case 1:
        case 3:
        case 4:
            Uzel=wrk;
            if(Uzel>500)
                Uzel=0;
            if(Uzel>400)
                Uzel=400;
            if(enable)
                i=Uzel;
            else
                ir=Uzel;
            break;
        case 2:
            Imax=wrk;
            if(Imax>6000)
                Imax=0;
            if(Imax>5000)
                Imax=5000;  
            if(Imax<IMAX_MIN)
                Imax=IMAX_MIN;
            break;
        case 101:
        case 102:
        case 103:
        case 104:
        case 105:
        case 106:
        case 107:
        case 108:
        case 109:
        case 110:
            menu=wrk;
            if(menu>MENU_LAST)
                menu=101;
            if(menu<101)
                menu=MENU_LAST;
            break;
        case 151:
            ustart=wrk;
            if(ustart>500)
                ustart=0;
            if(ustart>400)
                ustart=400;
            break;
        case 152:
            istart=wrk;
            if(istart>6000||istart<10)
                istart=10;
            if(istart>5000)
                istart=5000;
            break;
        case 153:
            limit=wrk&1;
            break;
        case 154:
            enc_t1=wrk;
            break;
        case 155:
            enc_t2=wrk;
            break;
        case 156:
            enc_t3=wrk;
            break;
        case 157:
            enc_s1=wrk;
            enc_is1=wrk*10;
            break;
        case 158:
            enc_s2=wrk;
            enc_is2=wrk*10;
            break;
        case 159:
            if(wrk>255)
                wrk=255;
            osv=wrk;
            OCR0=osv;
            break;
        case 160:
            pwrfail=wrk&1;
            break;
    }
    TCNT1=0;
    delay_ms(2);
}

void IzpUizh(unsigned int U)
{
    sprintf(str,"%2d.",U/10);
    lcd_puts(str);
    sprintf(str,"%1d",U%10);
    lcd_puts(str);
}

void IzpIizh(unsigned int I)
{
    sprintf(str,"%1d.",I/100);
    lcd_puts(str);
    sprintf(str,"%02d",I%100);
    lcd_puts(str);
}

void cv_init(void)
{
    PORTA=0x00;
    DDRA=0b11110000;

    PORTB=0x00;
    DDRB=0x08;
    PORTC=0x00;
    DDRC=0xFF;

    PORTD=0x00;
    DDRD=0xC0;

    OCR0=0x00;
    TCCR0=0b11110011;   //64 prescale, PC-PWM
    TCNT0=0x00;

    TCCR1A=0x00;
    TCCR1B=0x05;    //1024 ps
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    ASSR=0x00;
    TCCR2=0x07;     //1024 prescale
    TCNT2=0x00;
    OCR2=0x00;

    GICR|=0x40;
    MCUCR=0b00001001;   //INT0:any  INT1:fall
    MCUCSR=0x00;
    GIFR=0xc0;

    TIMSK|=0x40;


    UCSRA=0x00;
    UCSRB=0xD8;
    UCSRC=0x86;
    UBRRH=0x00;
    //UBRRL=0x08; // 115200
    UBRRL=25; // 38400

    ACSR=0x80;
    SFIOR=0x00;

    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x8C;

    lcd_init(16);

    sei();
}

interrupt [TIM2_OVF] void tmr2_isr(void)
{
    tick++;
    if(tick>30)
        gor=dol=0;
}

void setup(void)
{
    unsigned char lastmenu;
    unsigned int i10;
    bit done=0;

    output_off();
    lastmenu=menu;
    menu=101;

    while(!done)
    {
        for(i10=0;i10<2;i10++)
        {
            lcd_gotoxy(0,(unsigned char)i10);
            lcd_puts("                ");
        }

        switch(menu)
        {
            case 101:
            case 151:
                lcd_gotoxy(2,0);
                lcd_puts("start U");
                lcd_gotoxy(2,1);
                sprintf(str,"%2u.%uV",ustart/10,ustart%10);
                lcd_puts(str);
                break;
            case 102:
            case 152:
                i10=istart/10;
                lcd_gotoxy(2,0);
                lcd_puts("start I");
                lcd_gotoxy(2,1);
                sprintf(str,"%u.%02uA",i10/100,i10%100);
                lcd_puts(str);
                break;
            case 103:
            case 153:
                lcd_gotoxy(2,0);
                lcd_puts("I limit");
                lcd_gotoxy(2,1);
                if(limit)
                    lcd_puts("ON");
                else
                    lcd_puts("OFF");
                break;
            case 104:
            case 154:
                lcd_gotoxy(2,0);
                lcd_puts("RE T1");
                lcd_gotoxy(2,1);
                sprintf(str,"%05u",enc_t1);
                lcd_puts(str);
                break;
            case 105:
            case 155:
                lcd_gotoxy(2,0);
                lcd_puts("RE T2");
                lcd_gotoxy(2,1);
                sprintf(str,"%05u",enc_t2);
                lcd_puts(str);
                break;
            case 106:
            case 156:
                lcd_gotoxy(2,0);
                lcd_puts("RE T3");
                lcd_gotoxy(2,1);
                sprintf(str,"%05u",enc_t3);
                lcd_puts(str);
                break;
            case 107:
            case 157:
                lcd_gotoxy(2,0);
                lcd_puts("RE S1");
                lcd_gotoxy(2,1);
                sprintf(str,"%05u",enc_s1);
                lcd_puts(str);
                break;
            case 108:
            case 158:
                lcd_gotoxy(2,0);
                lcd_puts("RE S2");
                lcd_gotoxy(2,1);
                sprintf(str,"%05u",enc_s2);
                lcd_puts(str);
                break;
            case 109:
            case 159:
                lcd_gotoxy(2,0);
                lcd_puts("Osvetlitev");
                lcd_gotoxy(2,1);
                sprintf(str,"%03u",osv);
                lcd_puts(str);
                break;
            case 110:
            case 160:
                lcd_gotoxy(2,0);
                lcd_puts("Zadnji U, I");
                lcd_gotoxy(2,1);
                if(pwrfail)
                    lcd_puts("ON ");
                else
                    lcd_puts("OFF ");
                break;
        }
        if(menu>150)
            lcd_gotoxy(0,1);
        else
            lcd_gotoxy(0,0);
        lcd_puts(">");
        if(T1==0)
        {
            bit save=0;

            tick=0;
            while(T1==0)
            {
                delay_ms(10);
                if(tick>200&&save==0)
                {
                    save=1;
                    lcd_clear();
                    lcd_gotoxy(7,0);
                    lcd_puts("OK");
                }
            }
            if(save)
            {
                ee_ustart=ustart;
                ee_istart=istart;
                if(limit)
                    ee_limit=EE_LOGIC_ONE;
                else
                    ee_limit=0;
                ee_enc_s1=enc_s1;
                ee_enc_s2=enc_s2;
                ee_enc_t1=enc_t1;
                ee_enc_t2=enc_t2;
                ee_enc_t3=enc_t3;
                ee_osv=osv;
                if(pwrfail)
                    ee_pwrfail=EE_LOGIC_ONE;
                else
                    ee_pwrfail=0;
                done=1;
            }
            else
            {
                if(menu>150)
                    menu-=50;
                else
                    menu+=50;
            }
        }
        delay_ms(10);
        if(T2==0)
        {
            done=1;
            while(T2==0)
                {};
        }
    }
    menu=lastmenu;
}

void welcome()
{
    unsigned int i,s;

    OCR0=0;
    s=osv>>5;

    lcd_gotoxy(2,0);
    lcd_puts("elektronik.si");
    lcd_gotoxy(2,1);
    lcd_puts("V1.5a 07/2012");

    for(i=0;i<32;i++)
    {
        OCR0+=s;
        delay_ms(50);
    }
}

void txtf_3(char *buf,unsigned int x)
{
    if(x<1000)
        sprintf(buf,"%5d",x);
    else if(x<10000)
        sprintf(buf,"%u.%02uk",x/1000,(x%1000)/10);
    else                                          
        sprintf(buf,"%2u.%01uk",x/1000,(x%1000)/100);
}

void txtf_3m(char *buf,unsigned int x)
{
    if(x<1000)
        sprintf(buf," %3dm",x);
    else if(x<10000)
        sprintf(buf," %u.%02u",x/1000,(x%1000)/10);
    else                                         
        sprintf(buf," %2u.%01u",x/1000,(x%1000)/100);
}

void main(void)
{
    static char usbsend=0;

    cv_init();
                 
    ustart=ee_ustart;
    if(ustart>400)
        ustart=50;
    istart=ee_istart;
    if(istart>5000)
        istart=130;
    limit=0;
    if(ee_limit==EE_LOGIC_ONE)
        limit=1;
    enc_s1=ee_enc_s1;
    enc_s2=ee_enc_s2;
    if(enc_s1>100)
        enc_s1=3;
    if(enc_s2>100)
        enc_s2=10;
    enc_is1=enc_s1*10;
    enc_is2=enc_s2*10;
    enc_t1=ee_enc_t1;
    enc_t2=ee_enc_t2;
    enc_t3=ee_enc_t3;
    if(enc_t1>2000)
        enc_t1=300;
    if(enc_t2>2000)
        enc_t2=100;
    if(enc_t3>2000)
        enc_t3=10;
    osv=ee_osv;
    if(osv>255)
        osv=0x80;
    pwrfail=0;
    if(ee_pwrfail==EE_LOGIC_ONE)
        pwrfail=1;

    welcome();

    OCR0=osv;

    GICR|=0x80; //INT1 enable

    i=0;
    PORTC=0;                                         // init D/A pretvornika
    PORTD.6=0;
    PORTD.7=0;
    napstev=0;                                       // init števca napetosti
    SetU();
    for (ui=0;ui<10;ui++){un[ui]=0;}
    ui=0;
    ii=0;
    cl=0;
    scf=0;
    Umax=400;
    Imax=istart;
    enable=0;
    LEDdis=1;
    r=0;
    menu=1;
    Uzel=ustart;
    ir=Uzel;

    ADport=2;
    ADCSRA|=0x40;


    while (1)
    {
        in=0;
        while(scf)
        {
            ADMUX=ADC_VREF_TYPE1 & 0xff;
            ADCSRA=0x84;
            i=0;
            delay_ms(10);
            while((Umax>uizh0) & (iizh0<Imax))
            {
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

                send_status();
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

        if(enable)
            ir=i;

        if(T1==0)
        {
            bit setup_go=0;

            tick=0;
            while(T1==0)
            {
                delay_ms(10);
                if(tick>200 && !setup_go)
                {
                    output_off();
                    lcd_clear();
                    lcd_gotoxy(3,0);
                    lcd_puts("nastavitve");
                    setup_go=1;
                }
            }
            if(setup_go)
                setup();
            else
            {
                menu++;
                if(menu>4)
                    menu=1;
            }
        }

        if(T2==0)
        {
            output_toggle();
            send_status();
            lcd_init(20);
            while(T2==0)
                {};
        }


        if(Iizh!=0)
        {
            wr=Uizh;
            wr=wr*1000;
            wr=wr/Iizh;
            Rbre=wr;
        }
        wr=Uizh;
        wr=wr*Iizh;
        wr=wr/1000;
        Pout=wr;

        switch(menu)
        {
            case 1:
                lcd_gotoxy(1,0);
                lcd_puts("->");
                lcd_gotoxy(1,1);
                lcd_puts("  ");
                break;
            case 2:
                lcd_gotoxy(1,0);
                lcd_puts("  ");
                lcd_gotoxy(1,1);
                lcd_puts("->");
                break;
            case 3:
                lcd_gotoxy(1,0);
                lcd_puts("->");
                break;
            case 4:
                lcd_gotoxy(1,0);
                lcd_puts("=>");
                lcd_gotoxy(1,1);
                lcd_puts("  ");
                break;
        }

        lcd_gotoxy(0,0);
        lcd_puts("U");
        lcd_gotoxy(3,0);
        lcd_puts("[");
        IzpUizh(Uzel);
        lcd_puts("] ");
        IzpUizh(Uizh);
        lcd_puts(" V");

        if ((menu==1)|(menu==2)|(menu==4))
        {
            lcd_gotoxy(0,1);
            lcd_puts("I");
            lcd_gotoxy(3,1);
            lcd_puts("[");
            IzpIizh(Imax/10);
            lcd_puts("] ");
            IzpIizh(Iizh/10);
            lcd_puts(" A");
        }
        else if(menu==3)
        {            
            static unsigned char rcount=0;
            
            if(!rcount)
            {
                lcd_gotoxy(0,1);
                if(Iizh>5)
                {   
                    char buf1[10],buf2[10];
                    if(Rbre<600)
                        txtf_3m(buf1,Rbre*100);
                    else                     
                        txtf_3(buf1,Rbre/10);
                    if(Pout<600)
                        txtf_3m(buf2,Pout*100);
                    else
                        txtf_3(buf2,Pout/10);
                    sprintf(str,"%s\336    %sW",buf1,buf2);
                }
                else
                    sprintf(str,"R >>>>>         ");
                lcd_puts(str);                
/*
                lcd_puts("R ");
                if(Iizh>5)
                {
                    if(Rbre<1000)
                        IzpUizh(Rbre);
                    else                        
                    {
                        sprintf(str,"%4d",Rbre/10);
                        lcd_puts(str);
                    }
                }
                else
                    lcd_puts("    ");   
                lcd_puts("\336  P "); 
                if(Pout<1000)
                    IzpUizh(Pout);
                else                        
                {
                    sprintf(str,"%4d",Pout/10);
                    lcd_puts(str);
                }
                lcd_puts("W ");
*/   
            }
            rcount++;
            if(rcount==25)
                rcount=0;
        }

        if(!usbsend)
            send_status();
        usbsend++;
        if(usbsend==12)
            usbsend=0;
    };
}
