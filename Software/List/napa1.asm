
;CodeVisionAVR C Compiler V2.03.9 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _i=R6
	.DEF _ir=R8
	.DEF _napstev=R10
	.DEF _Uizh=R12
	.DEF _scf=R4

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x25,0x32,0x64,0x2E,0x0,0x25,0x31,0x64
	.DB  0x0,0x25,0x31,0x64,0x2E,0x0,0x25,0x30
	.DB  0x32,0x64,0x0,0x2A,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x0,0x3E,0x55,0x3D,0x25,0x35,0x64
	.DB  0x0,0x3E,0x4D,0x3D,0x25,0x35,0x64,0x0
	.DB  0x3E,0x49,0x3D,0x25,0x35,0x64,0x0,0x3E
	.DB  0x54,0x25,0x35,0x64,0x0,0x2D,0x3E,0x0
	.DB  0x20,0x20,0x0,0x55,0x0,0x5B,0x0,0x5D
	.DB  0x20,0x0,0x20,0x56,0x0,0x49,0x0,0x20
	.DB  0x41,0x0,0x52,0x62,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x50,0x6F,0x20,0x0
	.DB  0x57,0x0,0x3E,0x4E,0x3D,0x25,0x35,0x64
	.DB  0x0,0x3E,0x4B,0x3D,0x25,0x35,0x64,0x0
	.DB  0x3E,0x52,0x3D,0x25,0x35,0x64,0x0,0x3E
	.DB  0x50,0x3D,0x25,0x35,0x64,0x0,0x3E,0x75
	.DB  0x3D,0x25,0x35,0x64,0x0,0x3E,0x69,0x3D
	.DB  0x25,0x35,0x64,0x0
_0x200005F:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G100
	.DW  _0x200005F*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : Napajalnik
;Version :1.1
;Date    : 16.7.2009
;Author  : Volk Darko
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
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
;#include <stdlib.h>
;#include <delay.h>
;#include <string.h>
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 25
;char rx_buffer[RX_BUFFER_SIZE];
;unsigned char rx_wr_index;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 002A #endasm
;#include <lcd.h>
;#include <stdio.h>         // Standard Input/Output functions
;#include <delay.h>
;#define RE1 PIND.2        // Rotary encoder
;#define RE2 PIND.3        // Rotary encoder
;#define T1 PIND.4          // Tipka 1
;#define T2 PIND.5          // Tipka 2
;#define Ux2 PORTA.7     // Prižge tyristor in da dvojno napetost
;#define ADC_VREF_TYPE 0xC0
;#define ADC_VREF_TYPE1 0x40
;#define LEDUx2 PORTB.3
;#define LEDena PORTA.6
;#define LEDdis  PORTA.5
;
;// Declare your global variables here
;unsigned int i,ir;            // števec AD pretvornika
;char str[12];
;unsigned napstev;
;unsigned int Uizh,Uinp,Iizh,Uzel,Rbre,Pout,uizh0,iizh0;
;unsigned int Imax;
;unsigned int Umax;
;unsigned int nrread;
;char scf;
;char rxd[RX_BUFFER_SIZE];
;char enable;                 // output enble
;char ADport;
;char ui;                        // index meritve izhodne napetosti
;char ii,in;                         // index meritve toka
;long int cl,wr;
;unsigned int un[10];
;unsigned int ip[10];
;unsigned int r;
;unsigned int up,up1,up2,up3;
;unsigned int wrk;
;char menu;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0051 {

	.CSEG
_usart_rx_isr:
	CALL SUBOPT_0x0
; 0000 0052 char status,data;
; 0000 0053  status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0054  data=UDR;
	IN   R16,12
; 0000 0055  if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+3
	JMP _0x3
; 0000 0056   {
; 0000 0057      if (data=='*') {rx_wr_index=0;}
	CPI  R16,42
	BRNE _0x4
	CLR  R5
; 0000 0058      rx_buffer[rx_wr_index]=data;
_0x4:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0059 
; 0000 005A      if (rx_wr_index==6) {
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x5
; 0000 005B          strcpy(rxd,rx_buffer+2);
	CALL SUBOPT_0x1
	__POINTW1MN _rx_buffer,2
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpy
; 0000 005C          rx_wr_index=0;
	CLR  R5
; 0000 005D          if (rx_buffer[1]=='U') {
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x55)
	BRNE _0x6
; 0000 005E             ir=atoi(rxd);
	CALL SUBOPT_0x1
	CALL _atoi
	MOVW R8,R30
; 0000 005F             i=ir;
	MOVW R6,R8
; 0000 0060             Uzel=ir;
	__PUTWMRN _Uzel,0,8,9
; 0000 0061          }
; 0000 0062          if (rx_buffer[1]=='I') {
_0x6:
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x49)
	BRNE _0x7
; 0000 0063             Imax=atoi(rxd);
	CALL SUBOPT_0x1
	CALL _atoi
	CALL SUBOPT_0x2
; 0000 0064          }
; 0000 0065          if (rx_buffer[1]=='M') {
_0x7:
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x4D)
	BRNE _0x8
; 0000 0066             Umax=atoi(rxd);
	CALL SUBOPT_0x1
	CALL _atoi
	CALL SUBOPT_0x3
; 0000 0067          }
; 0000 0068          if (rx_buffer[1]=='S') {
_0x8:
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x53)
	BRNE _0x9
; 0000 0069             scf=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 006A          }
; 0000 006B       }
_0x9:
; 0000 006C 
; 0000 006D      if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
_0x5:
	INC  R5
	LDI  R30,LOW(25)
	CP   R30,R5
	BRNE _0xA
	CLR  R5
; 0000 006E 
; 0000 006F   };
_0xA:
_0x3:
; 0000 0070 
; 0000 0071 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xAA
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 007F {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0080 if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xB
; 0000 0081    {
; 0000 0082    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 0083    UDR=tx_buffer[tx_rd_index];
	LDS  R30,_tx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0084    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	SUBI R26,-LOW(1)
	STS  _tx_rd_index,R26
	CPI  R26,LOW(0x8)
	BRNE _0xC
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 0085    };
_0xC:
_0xB:
; 0000 0086 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 008D {
_putchar:
; 0000 008E while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0xD:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0xD
; 0000 008F #asm("cli")
	cli
; 0000 0090 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x11
	SBIC 0xB,5
	RJMP _0x10
_0x11:
; 0000 0091    {
; 0000 0092    tx_buffer[tx_wr_index]=c;
	LDS  R30,_tx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0093    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	SUBI R26,-LOW(1)
	STS  _tx_wr_index,R26
	CPI  R26,LOW(0x8)
	BRNE _0x13
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 0094    ++tx_counter;
_0x13:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 0095    }
; 0000 0096 else
	RJMP _0x14
_0x10:
; 0000 0097    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0098 #asm("sei")
_0x14:
	sei
; 0000 0099 }
	RJMP _0x20C0003
;#pragma used-
;#endif
;#include <stdio.h>
;
;void SendUsb(char* s) {
; 0000 009E void SendUsb(char* s) {
_SendUsb:
; 0000 009F char i;
; 0000 00A0    i=0;
	ST   -Y,R17
;	*s -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
; 0000 00A1    while (s[++i]!=0x0) {putchar(s[i]);}
_0x15:
	SUBI R17,-LOW(1)
	CALL SUBOPT_0x4
	CPI  R30,0
	BREQ _0x17
	CALL SUBOPT_0x4
	ST   -Y,R30
	RCALL _putchar
	RJMP _0x15
_0x17:
; 0000 00A2 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;void SetU(){
; 0000 00A4 void SetU(){
_SetU:
; 0000 00A5 unsigned char u1;                    // delovno polje
; 0000 00A6    if (napstev>1025) {napstev=0;}
	ST   -Y,R17
;	u1 -> R17
	LDI  R30,LOW(1025)
	LDI  R31,HIGH(1025)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x18
	CLR  R10
	CLR  R11
; 0000 00A7    if (napstev>1023) {napstev=1023;}
_0x18:
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x19
	MOVW R10,R30
; 0000 00A8    u1=napstev % 256;
_0x19:
	MOVW R30,R10
	MOV  R17,R30
; 0000 00A9    PORTC=u1;
	OUT  0x15,R17
; 0000 00AA    u1= napstev / 256;
	MOV  R17,R11
; 0000 00AB    switch (u1) {
	MOV  R30,R17
	CALL SUBOPT_0x5
; 0000 00AC       case 0: { PORTD.6=0; PORTD.7=0;break;}
	BRNE _0x1D
	CBI  0x12,6
	CBI  0x12,7
	RJMP _0x1C
; 0000 00AD       case 1: { PORTD.6=0; PORTD.7=1;break;}
_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x22
	CBI  0x12,6
	RJMP _0xA6
; 0000 00AE       case 2: { PORTD.6=1; PORTD.7=0;break;}
_0x22:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x27
	SBI  0x12,6
	CBI  0x12,7
	RJMP _0x1C
; 0000 00AF       case 3: { PORTD.6=1; PORTD.7=1;break;}
_0x27:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1C
	SBI  0x12,6
_0xA6:
	SBI  0x12,7
; 0000 00B0    };
_0x1C:
; 0000 00B1    if ( Ux2 & (napstev<450)) {Ux2=0;}
	LDI  R30,0
	SBIC 0x1B,7
	LDI  R30,1
	MOV  R0,R30
	MOVW R26,R10
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0x31
	CBI  0x1B,7
; 0000 00B2    if (!Ux2 & (napstev>512)) {
_0x31:
	LDI  R30,0
	SBIS 0x1B,7
	LDI  R30,1
	MOV  R0,R30
	MOVW R26,R10
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __GTW12U
	AND  R30,R0
	BREQ _0x34
; 0000 00B3       Ux2=1;
	SBI  0x1B,7
; 0000 00B4       #asm("cli")
	cli
; 0000 00B5       delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x6
; 0000 00B6       #asm("sei")
	sei
; 0000 00B7    }
; 0000 00B8    LEDUx2=Ux2;
_0x34:
	SBIC 0x1B,7
	RJMP _0x37
	CBI  0x18,3
	RJMP _0x38
_0x37:
	SBI  0x18,3
_0x38:
; 0000 00B9 }
	LD   R17,Y+
	RET
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00BD {
_read_adc:
; 0000 00BE ADMUX=adc_input | (ADC_VREF_TYPE1 & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 00BF // Delay needed for the stabilization of the ADC input voltage
; 0000 00C0 delay_us(10);
	__DELAY_USB 53
; 0000 00C1 // Start the AD conversion
; 0000 00C2 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00C3 // Wait for the AD conversion to complete
; 0000 00C4 while ((ADCSRA & 0x10)==0);
_0x39:
	SBIS 0x6,4
	RJMP _0x39
; 0000 00C5 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00C6 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20C0003:
	ADIW R28,1
	RET
; 0000 00C7 }
;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 00CC {
_adc_isr:
	CALL SUBOPT_0x0
; 0000 00CD unsigned int u,s;
; 0000 00CE // Read the AD conversion result
; 0000 00CF switch(ADport) {
	CALL __SAVELOCR4
;	u -> R16,R17
;	s -> R18,R19
	LDS  R30,_ADport
	CALL SUBOPT_0x5
; 0000 00D0   case 0:{Uizh=ADCW;
	BREQ PC+3
	JMP _0x3F
	__INWR 12,13,4
; 0000 00D1                uizh0=Uizh;
	__PUTWMRN _uizh0,0,12,13
; 0000 00D2                if (cl==0) {
	CALL SUBOPT_0x7
	BRNE _0x40
; 0000 00D3                   if (Uizh>((i*2.55)+20)) {napstev=2*i+i/2; SetU();delay_us(200);}
	CALL SUBOPT_0x8
	__GETD2N 0x41A00000
	CALL __ADDF12
	MOVW R26,R12
	CALL SUBOPT_0x9
	BREQ PC+2
	BRCC PC+3
	JMP  _0x41
	CALL SUBOPT_0xA
; 0000 00D4                   if ((Uizh+20)<(i*2.55)) {napstev=2*i+i/2; SetU();delay_us(200);}
_0x41:
	MOVW R30,R12
	ADIW R30,20
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	CALL SUBOPT_0x9
	BRSH _0x42
	CALL SUBOPT_0xA
; 0000 00D5                   r=0;
_0x42:
	LDI  R30,LOW(0)
	STS  _r,R30
	STS  _r+1,R30
; 0000 00D6                }
; 0000 00D7                un[ui]=Uizh;
_0x40:
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R12
	STD  Z+1,R13
; 0000 00D8                ui++;
	LDS  R30,_ui
	SUBI R30,-LOW(1)
	STS  _ui,R30
; 0000 00D9                if (ui>=3){ui=0;}
	LDS  R26,_ui
	CPI  R26,LOW(0x3)
	BRLO _0x43
	LDI  R30,LOW(0)
	STS  _ui,R30
; 0000 00DA                u=0;
_0x43:
	__GETWRN 16,17,0
; 0000 00DB                for (s=0;s<3;s++) { u=u+un[s];}
	__GETWRN 18,19,0
_0x45:
	__CPWRN 18,19,3
	BRSH _0x46
	MOVW R30,R18
	LDI  R26,LOW(_un)
	LDI  R27,HIGH(_un)
	CALL SUBOPT_0xC
	__ADDWRR 16,17,30,31
	__ADDWRN 18,19,1
	RJMP _0x45
_0x46:
; 0000 00DC 
; 0000 00DD                u=u/3;
	MOVW R26,R16
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21U
	MOVW R16,R30
; 0000 00DE                Uizh=u*10;
	__MULBNWRU 16,17,10
	MOVW R12,R30
; 0000 00DF                u=u/10;
	MOVW R26,R16
	CALL SUBOPT_0xD
	MOVW R16,R30
; 0000 00E0                Uizh=Uizh/16;
	MOVW R30,R12
	CALL __LSRW4
	MOVW R12,R30
; 0000 00E1                Uizh=Uizh*10;
	MOVW R26,R12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MULW12U
	MOVW R12,R30
; 0000 00E2                Uizh=Uizh/16;
	MOVW R30,R12
	CALL __LSRW4
	MOVW R12,R30
; 0000 00E3                if (Uizh>(i+0)) {napstev--; SetU();delay_us(50);cl=0;}
	MOVW R30,R6
	ADIW R30,0
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x47
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
	ADIW R30,1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 00E4                if ((Uizh+0)<i) {napstev++; SetU();delay_us(50);}
_0x47:
	MOVW R26,R12
	ADIW R26,0
	CP   R26,R6
	CPC  R27,R7
	BRSH _0x48
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	CALL SUBOPT_0xE
; 0000 00E5                if ((Uizh+2)<i) {napstev++; SetU();delay_us(50);}
_0x48:
	MOVW R26,R12
	ADIW R26,2
	CP   R26,R6
	CPC  R27,R7
	BRSH _0x49
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	CALL SUBOPT_0xE
; 0000 00E6 
; 0000 00E7                ADport=1;
_0x49:
	LDI  R30,LOW(1)
	STS  _ADport,R30
; 0000 00E8                nrread=0;
	LDI  R30,LOW(0)
	STS  _nrread,R30
	STS  _nrread+1,R30
; 0000 00E9                break;}
	RJMP _0x3E
; 0000 00EA   case 1:{ii++;
_0x3F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4A
	LDS  R30,_ii
	SUBI R30,-LOW(1)
	STS  _ii,R30
; 0000 00EB                if (ii>=5){ii=0;}
	LDS  R26,_ii
	CPI  R26,LOW(0x5)
	BRLO _0x4B
	LDI  R30,LOW(0)
	STS  _ii,R30
; 0000 00EC                ip[ii]=ADCW;
_0x4B:
	CALL SUBOPT_0x10
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x4
	IN   R31,0x4+1
	ST   X+,R30
	ST   X,R31
; 0000 00ED                iizh0=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	CALL SUBOPT_0x11
; 0000 00EE                Iizh=0;
	LDI  R30,LOW(0)
	STS  _Iizh,R30
	STS  _Iizh+1,R30
; 0000 00EF                for (s=0;s<5;s++) {Iizh=Iizh+ip[s];}
	__GETWRN 18,19,0
_0x4D:
	__CPWRN 18,19,5
	BRSH _0x4E
	MOVW R30,R18
	LDI  R26,LOW(_ip)
	LDI  R27,HIGH(_ip)
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	ADD  R30,R26
	ADC  R31,R27
	STS  _Iizh,R30
	STS  _Iizh+1,R31
	__ADDWRN 18,19,1
	RJMP _0x4D
_0x4E:
; 0000 00F0 
; 0000 00F1                if (Iizh>Imax) {
	CALL SUBOPT_0x13
	CALL SUBOPT_0x12
	CP   R30,R26
	CPC  R31,R27
	BRLO PC+3
	JMP _0x4F
; 0000 00F2                   cl=1;
	__GETD1N 0x1
	STS  _cl,R30
	STS  _cl+1,R31
	STS  _cl+2,R22
	STS  _cl+3,R23
; 0000 00F3 
; 0000 00F4                   if (Iizh>(Imax*3)) {
	CALL SUBOPT_0x14
	LDI  R30,LOW(3)
	CALL __MULB1W2U
	CALL SUBOPT_0x12
	CP   R30,R26
	CPC  R31,R27
	BRLO PC+3
	JMP _0x50
; 0000 00F5                      if (r==0) {
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x51
; 0000 00F6                         r=(Uizh*5000)/ip[ii];
	MOVW R26,R12
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL __MULW12U
	MOVW R0,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0xC
	MOVW R26,R0
	CALL __DIVW21U
	CALL SUBOPT_0x16
; 0000 00F7                         up=Imax*r/100;
	CALL SUBOPT_0x14
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x17
; 0000 00F8                         up1=up;
	STS  _up1,R30
	STS  _up1+1,R31
; 0000 00F9 
; 0000 00FA                         up=(Uizh*100)/up;
	MOVW R26,R12
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MULW12U
	MOVW R26,R30
	LDS  R30,_up
	LDS  R31,_up+1
	CALL SUBOPT_0x17
; 0000 00FB                         up2=up;
	STS  _up2,R30
	STS  _up2+1,R31
; 0000 00FC                         up3=Iizh;
	CALL SUBOPT_0x18
	STS  _up3,R30
	STS  _up3+1,R31
; 0000 00FD                         napstev=up;
	__GETWRMN 10,11,0,_up
; 0000 00FE                      }
; 0000 00FF                      else {napstev--;}
	RJMP _0x52
_0x51:
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
_0x52:
; 0000 0100                   }
; 0000 0101                   else { napstev--;}
	RJMP _0x53
_0x50:
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
_0x53:
; 0000 0102 //                  napstev--;
; 0000 0103                   SetU();
	RCALL _SetU
; 0000 0104                   LEDdis=1;
	SBI  0x1B,5
; 0000 0105                   delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x6
; 0000 0106                   nrread=950;
	LDI  R30,LOW(950)
	LDI  R31,HIGH(950)
	STS  _nrread,R30
	STS  _nrread+1,R31
; 0000 0107                   if (LEDena) {LEDdis=0;};
	SBIC 0x1B,6
	CBI  0x1B,5
; 0000 0108                }
; 0000 0109                else {
	RJMP _0x59
_0x4F:
; 0000 010A                   if (cl!=0) {cl++;}
	CALL SUBOPT_0x7
	BREQ _0x5A
	LDI  R26,LOW(_cl)
	LDI  R27,HIGH(_cl)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 010B                   if (cl==100000) {cl=0;}
_0x5A:
	LDS  R26,_cl
	LDS  R27,_cl+1
	LDS  R24,_cl+2
	LDS  R25,_cl+3
	__CPD2N 0x186A0
	BRNE _0x5B
	CALL SUBOPT_0xF
; 0000 010C                }
_0x5B:
_0x59:
; 0000 010D                nrread++;
	LDI  R26,LOW(_nrread)
	LDI  R27,HIGH(_nrread)
	CALL SUBOPT_0x19
; 0000 010E                if (nrread==1000) { ADport=2;}
	LDS  R26,_nrread
	LDS  R27,_nrread+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRNE _0x5C
	LDI  R30,LOW(2)
	STS  _ADport,R30
; 0000 010F                break;}
_0x5C:
	RJMP _0x3E
; 0000 0110   case 2:{Uinp=ADCW*47;Uinp=Uinp/60; ADport=0; break;}
_0x4A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5E
	IN   R30,0x4
	IN   R31,0x4+1
	LDI  R26,LOW(47)
	LDI  R27,HIGH(47)
	CALL __MULW12U
	STS  _Uinp,R30
	STS  _Uinp+1,R31
	LDS  R26,_Uinp
	LDS  R27,_Uinp+1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21U
	STS  _Uinp,R30
	STS  _Uinp+1,R31
; 0000 0111   default:ADport=0;
_0x5E:
_0xA7:
	LDI  R30,LOW(0)
	STS  _ADport,R30
; 0000 0112 }
_0x3E:
; 0000 0113 ADMUX=ADport | ADC_VREF_TYPE ;  // doloci adc vhod
	LDS  R30,_ADport
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 0114 if (scf==0) {ADCSRA|=0x40;}
	TST  R4
	BRNE _0x5F
	SBI  0x6,6
; 0000 0115 
; 0000 0116 }
_0x5F:
	CALL __LOADLOCR4
	ADIW R28,4
	RJMP _0xAA
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 011A {
_ext_int0_isr:
	CALL SUBOPT_0x0
; 0000 011B    if ((menu==1)|(menu==3)) { if (enable) {wrk=i;} else {wrk=ir;}}
	CALL SUBOPT_0x1A
	BREQ _0x60
	LDS  R30,_enable
	CPI  R30,0
	BREQ _0x61
	__PUTWMRN _wrk,0,6,7
	RJMP _0x62
_0x61:
	__PUTWMRN _wrk,0,8,9
_0x62:
; 0000 011C    if (menu==2) {wrk=Imax;}
_0x60:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x63
	CALL SUBOPT_0x13
	CALL SUBOPT_0x1B
; 0000 011D    if (RE1==RE2) {
_0x63:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
	CP   R30,R26
	BRNE _0x64
; 0000 011E       wrk--;
	LDI  R26,LOW(_wrk)
	LDI  R27,HIGH(_wrk)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
; 0000 011F       if ((menu==1)|(menu==3)) {if (wrk>410){wrk=0;}}
	CALL SUBOPT_0x1A
	BREQ _0x65
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x19B)
	LDI  R30,HIGH(0x19B)
	CPC  R27,R30
	BRLO _0x66
	LDI  R30,LOW(0)
	STS  _wrk,R30
	STS  _wrk+1,R30
_0x66:
; 0000 0120       if (menu==2) {if (wrk>5010){wrk=0;}}
_0x65:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x67
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x1393)
	LDI  R30,HIGH(0x1393)
	CPC  R27,R30
	BRLO _0x68
	LDI  R30,LOW(0)
	STS  _wrk,R30
	STS  _wrk+1,R30
_0x68:
; 0000 0121    }
_0x67:
; 0000 0122    else {
	RJMP _0x69
_0x64:
; 0000 0123       wrk++;
	LDI  R26,LOW(_wrk)
	LDI  R27,HIGH(_wrk)
	CALL SUBOPT_0x19
; 0000 0124       if ((menu==1)|(menu==3)) {if (wrk>400){wrk=400;}}
	CALL SUBOPT_0x1A
	BREQ _0x6A
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLO _0x6B
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x1B
_0x6B:
; 0000 0125       if (menu==2) {if (wrk>5000){wrk=5000;}}
_0x6A:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x6C
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x1389)
	LDI  R30,HIGH(0x1389)
	CPC  R27,R30
	BRLO _0x6D
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x1B
_0x6D:
; 0000 0126    }
_0x6C:
_0x69:
; 0000 0127    if ((menu==1)|(menu==3)) { Uzel=wrk; if (enable) {i=wrk;} else {ir=wrk;}}
	CALL SUBOPT_0x1A
	BREQ _0x6E
	LDS  R30,_wrk
	LDS  R31,_wrk+1
	STS  _Uzel,R30
	STS  _Uzel+1,R31
	LDS  R30,_enable
	CPI  R30,0
	BREQ _0x6F
	__GETWRMN 6,7,0,_wrk
	RJMP _0x70
_0x6F:
	__GETWRMN 8,9,0,_wrk
_0x70:
; 0000 0128    if (menu==2) {Imax=wrk;}
_0x6E:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x71
	LDS  R30,_wrk
	LDS  R31,_wrk+1
	CALL SUBOPT_0x2
; 0000 0129    delay_ms(1);
_0x71:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x6
; 0000 012A }
_0xAA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void IzpUizh(unsigned int U){
; 0000 012C void IzpUizh(unsigned int U){
_IzpUizh:
; 0000 012D     sprintf(str,"%2d.",U/10);
;	U -> Y+0
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1E
	CALL SUBOPT_0xD
	CALL SUBOPT_0x1F
; 0000 012E     lcd_puts(str);
	CALL _lcd_puts
; 0000 012F     sprintf(str,"%1d",U%10);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,5
	CALL SUBOPT_0x1E
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	CALL SUBOPT_0x1F
; 0000 0130     lcd_puts(str);
	CALL _lcd_puts
; 0000 0131 }
	JMP  _0x20C0002
;
;void IzpIizh(unsigned int I){
; 0000 0133 void IzpIizh(unsigned int I){
_IzpIizh:
; 0000 0134     sprintf(str,"%1d.",I/100);
;	I -> Y+0
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,9
	CALL SUBOPT_0x1E
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	CALL SUBOPT_0x1F
; 0000 0135     lcd_puts(str);
	CALL _lcd_puts
; 0000 0136     sprintf(str,"%02d",I%100);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,14
	CALL SUBOPT_0x1E
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	CALL SUBOPT_0x1F
; 0000 0137     lcd_puts(str);
	CALL _lcd_puts
; 0000 0138 }
	JMP  _0x20C0002
;
;void main(void)
; 0000 013B {
_main:
; 0000 013C // Declare your local variables here
; 0000 013D 
; 0000 013E // Input/Output Ports initialization
; 0000 013F // Port A initialization
; 0000 0140 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0141 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0142 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0143 DDRA=0xE0;
	LDI  R30,LOW(224)
	OUT  0x1A,R30
; 0000 0144 
; 0000 0145 // Port B initialization
; 0000 0146 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0147 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0148 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0149 DDRB=0x08;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 014A 
; 0000 014B // Port C initialization
; 0000 014C // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 014D // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 014E PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 014F DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0150 
; 0000 0151 // Port D initialization
; 0000 0152 // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0153 // State7=0 State6=0 State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0154 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0155 DDRD=0xC0;
	LDI  R30,LOW(192)
	OUT  0x11,R30
; 0000 0156 
; 0000 0157 // Timer/Counter 0 initialization
; 0000 0158 // Clock source: System Clock
; 0000 0159 // Clock value: Timer 0 Stopped
; 0000 015A // Mode: Normal top=FFh
; 0000 015B // OC0 output: Disconnected
; 0000 015C TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 015D TCNT0=0x00;
	OUT  0x32,R30
; 0000 015E OCR0=0x00;
	OUT  0x3C,R30
; 0000 015F 
; 0000 0160 // Timer/Counter 1 initialization
; 0000 0161 // Clock source: System Clock
; 0000 0162 // Clock value: Timer 1 Stopped
; 0000 0163 // Mode: Normal top=FFFFh
; 0000 0164 // OC1A output: Discon.
; 0000 0165 // OC1B output: Discon.
; 0000 0166 // Noise Canceler: Off
; 0000 0167 // Input Capture on Falling Edge
; 0000 0168 // Timer 1 Overflow Interrupt: Off
; 0000 0169 // Input Capture Interrupt: Off
; 0000 016A // Compare A Match Interrupt: Off
; 0000 016B // Compare B Match Interrupt: Off
; 0000 016C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 016D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 016E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 016F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0170 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0171 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0172 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0173 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0174 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0175 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0176 
; 0000 0177 // Timer/Counter 2 initialization
; 0000 0178 // Clock source: System Clock
; 0000 0179 // Clock value: Timer 2 Stopped
; 0000 017A // Mode: Normal top=FFh
; 0000 017B // OC2 output: Disconnected
; 0000 017C ASSR=0x00;
	OUT  0x22,R30
; 0000 017D TCCR2=0x00;
	OUT  0x25,R30
; 0000 017E TCNT2=0x00;
	OUT  0x24,R30
; 0000 017F OCR2=0x00;
	OUT  0x23,R30
; 0000 0180 
; 0000 0181 // External Interrupt(s) initialization
; 0000 0182 // INT0: On
; 0000 0183 // INT0 Mode: Any change
; 0000 0184 // INT1: Off
; 0000 0185 // INT2: Off
; 0000 0186 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0187 MCUCR=0x01;
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0000 0188 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0189 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 018A 
; 0000 018B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 018C TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 018D 
; 0000 018E // USART initialization
; 0000 018F // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0190 // USART Receiver: On
; 0000 0191 // USART Transmitter: On
; 0000 0192 // USART Mode: Asynchronous
; 0000 0193 // USART Baud Rate: 115200
; 0000 0194 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0195 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0196 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0197 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0198 UBRRL=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 0199 
; 0000 019A // Analog Comparator initialization
; 0000 019B // Analog Comparator: Off
; 0000 019C // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 019D ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 019E SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 019F 
; 0000 01A0 // ADC initialization
; 0000 01A1 // ADC Clock frequency: 1000,000 kHz
; 0000 01A2 // ADC Voltage Reference: Int., cap. on AREF
; 0000 01A3 // ADC Auto Trigger Source: None
; 0000 01A4 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 01A5 ADCSRA=0x8C;
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 01A6 
; 0000 01A7 
; 0000 01A8 // LCD module initialization
; 0000 01A9 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01AA // Global enable interrupts
; 0000 01AB #asm("sei")
	sei
; 0000 01AC 
; 0000 01AD PORTC=0;                                         // init D/A pretvornika
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01AE PORTD.6=0;
	CBI  0x12,6
; 0000 01AF PORTD.7=0;
	CBI  0x12,7
; 0000 01B0 napstev=0;                                       // init števca napetosti
	CLR  R10
	CLR  R11
; 0000 01B1 SetU();
	RCALL _SetU
; 0000 01B2 for (ui=0;ui<10;ui++){un[ui]=0;}
	LDI  R30,LOW(0)
	STS  _ui,R30
_0x77:
	LDS  R26,_ui
	CPI  R26,LOW(0xA)
	BRSH _0x78
	CALL SUBOPT_0xB
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDS  R30,_ui
	SUBI R30,-LOW(1)
	STS  _ui,R30
	RJMP _0x77
_0x78:
; 0000 01B3 ui=0;
	LDI  R30,LOW(0)
	STS  _ui,R30
; 0000 01B4 ii=0;
	STS  _ii,R30
; 0000 01B5 cl=0;
	CALL SUBOPT_0xF
; 0000 01B6 scf=0;
	CLR  R4
; 0000 01B7 Umax=400;
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x3
; 0000 01B8 Imax=130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x2
; 0000 01B9 enable=0;
	LDI  R30,LOW(0)
	STS  _enable,R30
; 0000 01BA LEDdis=1;
	SBI  0x1B,5
; 0000 01BB r=0;
	STS  _r,R30
	STS  _r+1,R30
; 0000 01BC menu=1;
	LDI  R30,LOW(1)
	STS  _menu,R30
; 0000 01BD Uzel=0;
	LDI  R30,LOW(0)
	STS  _Uzel,R30
	STS  _Uzel+1,R30
; 0000 01BE 
; 0000 01BF Umax=0040;
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x3
; 0000 01C0 
; 0000 01C1 i=0;
	CLR  R6
	CLR  R7
; 0000 01C2  ADport=2;
	LDI  R30,LOW(2)
	STS  _ADport,R30
; 0000 01C3  ADCSRA|=0x40;
	SBI  0x6,6
; 0000 01C4 
; 0000 01C5 while (1)
_0x7B:
; 0000 01C6    {
; 0000 01C7       in=0;
	LDI  R30,LOW(0)
	STS  _in,R30
; 0000 01C8       while (scf) {
_0x7E:
	TST  R4
	BRNE PC+3
	JMP _0x80
; 0000 01C9          ADMUX=ADC_VREF_TYPE1 & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 01CA          ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 01CB          i=0;
	CLR  R6
	CLR  R7
; 0000 01CC          sprintf(str,"******");
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,19
	CALL SUBOPT_0x20
; 0000 01CD          SendUsb(str);
	CALL SUBOPT_0x21
; 0000 01CE          delay_ms(10);
; 0000 01CF          while ((Umax>uizh0) & (iizh0<Imax)) {
_0x81:
	CALL SUBOPT_0x22
	LDS  R26,_Umax
	LDS  R27,_Umax+1
	CALL __GTW12U
	MOV  R0,R30
	CALL SUBOPT_0x13
	LDS  R26,_iizh0
	LDS  R27,_iizh0+1
	CALL __LTW12U
	AND  R30,R0
	BRNE PC+3
	JMP _0x83
; 0000 01D0             napstev=i;
	MOVW R10,R6
; 0000 01D1             SetU();
	RCALL _SetU
; 0000 01D2             delay_ms(20);
	CALL SUBOPT_0x23
; 0000 01D3             uizh0=read_adc(0);
	CALL SUBOPT_0x24
; 0000 01D4             delay_ms(20);
; 0000 01D5             uizh0=read_adc(0);
	CALL SUBOPT_0x24
; 0000 01D6             delay_ms(20);
; 0000 01D7             uizh0=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x25
; 0000 01D8             uizh0=uizh0*5;
	CALL SUBOPT_0x26
; 0000 01D9             uizh0=uizh0/8;
	CALL __LSRW3
	CALL SUBOPT_0x25
; 0000 01DA             uizh0=uizh0*5;
	CALL SUBOPT_0x26
; 0000 01DB             uizh0=uizh0/4;
	CALL __LSRW2
	CALL SUBOPT_0x25
; 0000 01DC 
; 0000 01DD             delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x6
; 0000 01DE             iizh0=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x11
; 0000 01DF             iizh0=iizh0*5;
	LDS  R26,_iizh0
	LDS  R27,_iizh0+1
	LDI  R30,LOW(5)
	CALL __MULB1W2U
	CALL SUBOPT_0x11
; 0000 01E0 
; 0000 01E1             lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x27
; 0000 01E2             IzpUizh(uizh0);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x28
; 0000 01E3 
; 0000 01E4             sprintf(str,">U=%5d",uizh0);             // U izhodna
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x29
; 0000 01E5             SendUsb(str);
	CALL SUBOPT_0x21
; 0000 01E6             delay_ms(10);
; 0000 01E7             sprintf(str,">M=%5d",Umax);             // U max
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Umax
	LDS  R31,_Umax+1
	CALL SUBOPT_0x1F
; 0000 01E8             SendUsb(str);
	CALL SUBOPT_0x21
; 0000 01E9             delay_ms(10);
; 0000 01EA             sprintf(str,">I=%5d",iizh0);              // I izhodni
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,40
	CALL SUBOPT_0x2A
; 0000 01EB             SendUsb(str);
	CALL SUBOPT_0x21
; 0000 01EC             delay_ms(10);
; 0000 01ED             sprintf(str,">T%5d",Imax);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,47
	CALL SUBOPT_0x2B
; 0000 01EE             SendUsb(str);
	CALL SUBOPT_0x21
; 0000 01EF             delay_ms(10);
; 0000 01F0             i++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 01F1           }
	RJMP _0x81
_0x83:
; 0000 01F2           i=0;
	CLR  R6
	CLR  R7
; 0000 01F3           napstev=i;
	MOVW R10,R6
; 0000 01F4           delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x6
; 0000 01F5           scf=0;
	CLR  R4
; 0000 01F6           ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 01F7           ADCSRA=0x8C;
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 01F8           ADCSRA|=0x40;
	SBI  0x6,6
; 0000 01F9 
; 0000 01FA 
; 0000 01FB       }
	RJMP _0x7E
_0x80:
; 0000 01FC 
; 0000 01FD       if (enable) {ir=i;}
	LDS  R30,_enable
	CPI  R30,0
	BREQ _0x84
	MOVW R8,R6
; 0000 01FE       if (T1==0) {
_0x84:
	SBIC 0x10,4
	RJMP _0x85
; 0000 01FF          while (T1==0) {delay_ms(10);}
_0x86:
	SBIC 0x10,4
	RJMP _0x88
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x6
	RJMP _0x86
_0x88:
; 0000 0200          menu++;
	LDS  R30,_menu
	SUBI R30,-LOW(1)
	STS  _menu,R30
; 0000 0201          if (menu>3) {menu=1;}
	LDS  R26,_menu
	CPI  R26,LOW(0x4)
	BRLO _0x89
	LDI  R30,LOW(1)
	STS  _menu,R30
; 0000 0202       }
_0x89:
; 0000 0203       if (T2==0){
_0x85:
	SBIC 0x10,5
	RJMP _0x8A
; 0000 0204          enable=!enable;
	LDS  R30,_enable
	CALL __LNEGB1
	STS  _enable,R30
; 0000 0205          if (enable) {LEDena=1;LEDdis=0;}
	CPI  R30,0
	BREQ _0x8B
	SBI  0x1B,6
	CBI  0x1B,5
; 0000 0206          else {LEDena=0;LEDdis=1;}
	RJMP _0x90
_0x8B:
	CBI  0x1B,6
	SBI  0x1B,5
_0x90:
; 0000 0207          if (!enable) {i=0;}
	LDS  R30,_enable
	CPI  R30,0
	BRNE _0x95
	CLR  R6
	CLR  R7
; 0000 0208          else {i=ir;}
	RJMP _0x96
_0x95:
	MOVW R6,R8
_0x96:
; 0000 0209          while (T2==0){};
_0x97:
	SBIS 0x10,5
	RJMP _0x97
; 0000 020A       }
; 0000 020B 
; 0000 020C 
; 0000 020D 
; 0000 020E     switch(menu) {
_0x8A:
	LDS  R30,_menu
	LDI  R31,0
; 0000 020F        case 1:{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9D
; 0000 0210                lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 0211                sprintf(str,"->") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,53
	CALL SUBOPT_0x20
; 0000 0212                lcd_puts(str);
	CALL _lcd_puts
; 0000 0213                lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2C
; 0000 0214                sprintf(str,"  ") ;
	__POINTW1FN _0x0,56
	RJMP _0xA8
; 0000 0215                lcd_puts(str);
; 0000 0216                break;
; 0000 0217        }
; 0000 0218        case 2:{
_0x9D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x9E
; 0000 0219                lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 021A                sprintf(str,"  ") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,56
	CALL SUBOPT_0x20
; 0000 021B                lcd_puts(str);
	CALL _lcd_puts
; 0000 021C                lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _0xA9
; 0000 021D                sprintf(str,"->") ;
; 0000 021E                lcd_puts(str);
; 0000 021F                break;
; 0000 0220        }
; 0000 0221        case 3:{
_0x9E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9C
; 0000 0222                lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
_0xA9:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0223                sprintf(str,"->") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,53
_0xA8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 0224                lcd_puts(str);
	CALL SUBOPT_0x1D
	CALL _lcd_puts
; 0000 0225                break;
; 0000 0226        }
; 0000 0227 
; 0000 0228 
; 0000 0229     }
_0x9C:
; 0000 022A 
; 0000 022B 
; 0000 022C       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
; 0000 022D       sprintf(str,"U") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,59
	CALL SUBOPT_0x20
; 0000 022E       lcd_puts(str);
	CALL _lcd_puts
; 0000 022F       lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x27
; 0000 0230       sprintf(str,"[") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,61
	CALL SUBOPT_0x20
; 0000 0231       lcd_puts(str);
	CALL _lcd_puts
; 0000 0232       IzpUizh(Uzel);
	LDS  R30,_Uzel
	LDS  R31,_Uzel+1
	CALL SUBOPT_0x28
; 0000 0233       sprintf(str,"] ") ;
	__POINTW1FN _0x0,63
	CALL SUBOPT_0x20
; 0000 0234       lcd_puts(str);
	CALL _lcd_puts
; 0000 0235       IzpUizh(Uizh);
	ST   -Y,R13
	ST   -Y,R12
	RCALL _IzpUizh
; 0000 0236       sprintf(str," V") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,66
	CALL SUBOPT_0x20
; 0000 0237       lcd_puts(str);
	CALL _lcd_puts
; 0000 0238       if ((menu==1)|(menu==2)) {
	LDS  R26,_menu
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(2)
	CALL __EQB12
	OR   R30,R0
	BREQ _0xA0
; 0000 0239          lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
; 0000 023A          sprintf(str,"I") ;
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x20
; 0000 023B          lcd_puts(str);
	CALL _lcd_puts
; 0000 023C          lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2C
; 0000 023D          sprintf(str,"[") ;
	__POINTW1FN _0x0,61
	CALL SUBOPT_0x20
; 0000 023E          lcd_puts(str);
	CALL _lcd_puts
; 0000 023F          IzpIizh(Imax/10);
	CALL SUBOPT_0x14
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2D
; 0000 0240          sprintf(str,"] ") ;
	__POINTW1FN _0x0,63
	CALL SUBOPT_0x20
; 0000 0241          lcd_puts(str);
	CALL _lcd_puts
; 0000 0242          IzpIizh(Iizh/10);
	CALL SUBOPT_0x12
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2D
; 0000 0243          sprintf(str," A") ;
	__POINTW1FN _0x0,71
	CALL SUBOPT_0x20
; 0000 0244          lcd_puts(str);
	CALL _lcd_puts
; 0000 0245       }
; 0000 0246       if (menu==3) {
_0xA0:
	LDS  R26,_menu
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0xA1
; 0000 0247          lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
; 0000 0248          sprintf(str,"Rb ") ;
	__POINTW1FN _0x0,74
	CALL SUBOPT_0x20
; 0000 0249          lcd_puts(str);
	CALL _lcd_puts
; 0000 024A          if (Iizh!=0) {
	CALL SUBOPT_0x18
	SBIW R30,0
	BREQ _0xA2
; 0000 024B             wr=Uizh;
	CALL SUBOPT_0x2E
; 0000 024C             wr=wr*1000;
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 024D             wr=wr/Iizh;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 024E             r=wr;
; 0000 024F             Rbre=r;
	STS  _Rbre,R30
	STS  _Rbre+1,R31
; 0000 0250             IzpUizh(r);
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	RCALL _IzpUizh
; 0000 0251             }
; 0000 0252          else {
	RJMP _0xA3
_0xA2:
; 0000 0253             sprintf(str,"    ") ;
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,78
	CALL SUBOPT_0x20
; 0000 0254             lcd_puts(str);
	CALL _lcd_puts
; 0000 0255          }
_0xA3:
; 0000 0256          sprintf(str," Po ");
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,83
	CALL SUBOPT_0x20
; 0000 0257          lcd_puts(str);
	CALL _lcd_puts
; 0000 0258          wr=Uizh;
	CALL SUBOPT_0x2E
; 0000 0259          wr=wr*Iizh;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
; 0000 025A          wr=wr/1000;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x33
; 0000 025B          r=wr;
; 0000 025C          Pout=r;
	STS  _Pout,R30
	STS  _Pout+1,R31
; 0000 025D          IzpUizh(r);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x28
; 0000 025E          sprintf(str,"W");
	__POINTW1FN _0x0,88
	CALL SUBOPT_0x20
; 0000 025F          lcd_puts(str);
	CALL _lcd_puts
; 0000 0260 
; 0000 0261 //            lcd_puts(rx_buffer);
; 0000 0262       }
; 0000 0263       if (Iizh!=0) {
_0xA1:
	CALL SUBOPT_0x18
	SBIW R30,0
	BREQ _0xA4
; 0000 0264          wr=Uizh;
	CALL SUBOPT_0x2E
; 0000 0265          wr=wr*1000;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
; 0000 0266          wr=wr/Iizh;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
; 0000 0267          Rbre=wr;
	STS  _Rbre,R30
	STS  _Rbre+1,R31
; 0000 0268       }
; 0000 0269       wr=Uizh;
_0xA4:
	CALL SUBOPT_0x2E
; 0000 026A       wr=wr*Iizh;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
; 0000 026B       wr=wr/1000;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 026C       Pout=wr;
	STS  _Pout,R30
	STS  _Pout+1,R31
; 0000 026D 
; 0000 026E       sprintf(str,">U=%5d",Uizh);             // U izhodna
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,26
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL SUBOPT_0x1F
; 0000 026F       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0270       delay_ms(3);
; 0000 0271       sprintf(str,">N=%5d",ir);                 // U nastavljena
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,90
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0x1F
; 0000 0272       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0273       delay_ms(3);
; 0000 0274       sprintf(str,">I=%5d",Iizh);              // I izhodni
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,40
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
; 0000 0275       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0276       delay_ms(3);
; 0000 0277       sprintf(str,">M=%5d",Imax);           // I maximalni
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,33
	CALL SUBOPT_0x2B
; 0000 0278       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0279       delay_ms(3);
; 0000 027A       sprintf(str,">K=%5d",Uinp);            // U vhodna
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,97
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Uinp
	LDS  R31,_Uinp+1
	CALL SUBOPT_0x1F
; 0000 027B       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 027C       delay_ms(3);
; 0000 027D       sprintf(str,">R=%5d",Rbre);            // R bremena
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,104
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Rbre
	LDS  R31,_Rbre+1
	CALL SUBOPT_0x1F
; 0000 027E       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 027F       delay_ms(3);
; 0000 0280       sprintf(str,">P=%5d",Pout);            // P out
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,111
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Pout
	LDS  R31,_Pout+1
	CALL SUBOPT_0x1F
; 0000 0281       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0282       delay_ms(3);
; 0000 0283       sprintf(str,">u=%5d",uizh0);            // U izh brez konverzije
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,118
	CALL SUBOPT_0x29
; 0000 0284       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0285       delay_ms(3);
; 0000 0286       sprintf(str,">i=%5d",iizh0);              // I izh brez konverzije
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,125
	CALL SUBOPT_0x2A
; 0000 0287       SendUsb(str);
	CALL SUBOPT_0x36
; 0000 0288       delay_ms(3);
; 0000 0289 
; 0000 028A    };
	RJMP _0x7B
; 0000 028B }
_0xA5:
	RJMP _0xA5

	.CSEG
_atoi:
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
	ST   -Y,R30
	CALL _isspace
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
	ST   -Y,R30
	CALL _isdigit
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret

	.DSEG

	.CSEG

	.CSEG
_strcpy:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G102:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G102:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G102
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G102
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
__lcd_read_nibble_G102:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G102
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G102
    andi  r30,0xf0
	RET
_lcd_read_byte0_G102:
	CALL __lcd_delay_G102
	RCALL __lcd_read_nibble_G102
    mov   r26,r30
	RCALL __lcd_read_nibble_G102
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x37
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2040004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2040005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040005
_0x2040007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G102:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G102:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x37
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G102,2
	CALL SUBOPT_0x37
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G102,3
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	RCALL __long_delay_G102
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	LDI  R30,LOW(40)
	CALL SUBOPT_0x39
	LDI  R30,LOW(4)
	CALL SUBOPT_0x39
	LDI  R30,LOW(133)
	CALL SUBOPT_0x39
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G102
	CPI  R30,LOW(0x5)
	BREQ _0x204000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x204000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET
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

	.CSEG
__put_G103:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2060012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x19
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2060013:
	RJMP _0x2060014
_0x2060010:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x2060014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x2060015:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2060017
	MOV  R30,R17
	CALL SUBOPT_0x5
	BRNE _0x206001B
	CPI  R18,37
	BRNE _0x206001C
	LDI  R17,LOW(1)
	RJMP _0x206001D
_0x206001C:
	CALL SUBOPT_0x3A
_0x206001D:
	RJMP _0x206001A
_0x206001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x206001E
	CPI  R18,37
	BRNE _0x206001F
	CALL SUBOPT_0x3A
	RJMP _0x20600BC
_0x206001F:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060020
	LDI  R16,LOW(1)
	RJMP _0x206001A
_0x2060020:
	CPI  R18,43
	BRNE _0x2060021
	LDI  R20,LOW(43)
	RJMP _0x206001A
_0x2060021:
	CPI  R18,32
	BRNE _0x2060022
	LDI  R20,LOW(32)
	RJMP _0x206001A
_0x2060022:
	RJMP _0x2060023
_0x206001E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2060024
_0x2060023:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060025
	ORI  R16,LOW(128)
	RJMP _0x206001A
_0x2060025:
	RJMP _0x2060026
_0x2060024:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x206001A
_0x2060026:
	CPI  R18,48
	BRLO _0x2060029
	CPI  R18,58
	BRLO _0x206002A
_0x2060029:
	RJMP _0x2060028
_0x206002A:
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R22,R21
	CLR  R23
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R30,R26
	MOV  R21,R30
	RJMP _0x206001A
_0x2060028:
	CALL SUBOPT_0x3B
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x206002E
	CALL SUBOPT_0x3C
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3D
	RJMP _0x206002F
_0x206002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2060031
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3E
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060032
_0x2060031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2060034
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3E
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060032:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060035
_0x2060034:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x2060038
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2060039
_0x2060038:
	ORI  R16,LOW(4)
	RJMP _0x206003A
_0x2060039:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x206003B
_0x206003A:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003C
_0x206003B:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x206003E
	ORI  R16,LOW(8)
	RJMP _0x206003F
_0x206003E:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2060070
_0x206003F:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003C:
	SBRS R16,2
	RJMP _0x2060041
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060042
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060042:
	CPI  R20,0
	BREQ _0x2060043
	SUBI R17,-LOW(1)
	RJMP _0x2060044
_0x2060043:
	ANDI R16,LOW(251)
_0x2060044:
	RJMP _0x2060045
_0x2060041:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
_0x2060045:
_0x2060035:
	SBRC R16,0
	RJMP _0x2060046
_0x2060047:
	CP   R17,R21
	BRSH _0x2060049
	SBRS R16,7
	RJMP _0x206004A
	SBRS R16,2
	RJMP _0x206004B
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004C
_0x206004B:
	LDI  R18,LOW(48)
_0x206004C:
	RJMP _0x206004D
_0x206004A:
	LDI  R18,LOW(32)
_0x206004D:
	CALL SUBOPT_0x3A
	SUBI R21,LOW(1)
	RJMP _0x2060047
_0x2060049:
_0x2060046:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004E
_0x206004F:
	CPI  R19,0
	BREQ _0x2060051
	SBRS R16,3
	RJMP _0x2060052
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x20600BD
_0x2060052:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20600BD:
	ST   -Y,R30
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x2060054
	SUBI R21,LOW(1)
_0x2060054:
	SUBI R19,LOW(1)
	RJMP _0x206004F
_0x2060051:
	RJMP _0x2060055
_0x206004E:
_0x2060057:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2060059:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005B
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2060059
_0x206005B:
	CPI  R18,58
	BRLO _0x206005C
	SBRS R16,3
	RJMP _0x206005D
	CALL SUBOPT_0x3B
	ADIW R30,7
	RJMP _0x20600BE
_0x206005D:
	CALL SUBOPT_0x3B
	ADIW R30,39
_0x20600BE:
	MOV  R18,R30
_0x206005C:
	SBRC R16,4
	RJMP _0x2060060
	CPI  R18,49
	BRSH _0x2060062
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060061
_0x2060062:
	RJMP _0x20600BF
_0x2060061:
	CP   R21,R19
	BRLO _0x2060066
	SBRS R16,0
	RJMP _0x2060067
_0x2060066:
	RJMP _0x2060065
_0x2060067:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060068
	LDI  R18,LOW(48)
_0x20600BF:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2060069
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x206006A
	SUBI R21,LOW(1)
_0x206006A:
_0x2060069:
_0x2060068:
_0x2060060:
	CALL SUBOPT_0x3A
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x2060065:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060058
	RJMP _0x2060057
_0x2060058:
_0x2060055:
	SBRS R16,0
	RJMP _0x206006C
_0x206006D:
	CPI  R21,0
	BREQ _0x206006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3D
	RJMP _0x206006D
_0x206006F:
_0x206006C:
_0x2060070:
_0x206002F:
_0x20600BC:
	LDI  R17,LOW(0)
_0x206001A:
	RJMP _0x2060015
_0x2060017:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G103
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET

	.CSEG
_isdigit:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x19
_str:
	.BYTE 0xC
_Uinp:
	.BYTE 0x2
_Iizh:
	.BYTE 0x2
_Uzel:
	.BYTE 0x2
_Rbre:
	.BYTE 0x2
_Pout:
	.BYTE 0x2
_uizh0:
	.BYTE 0x2
_iizh0:
	.BYTE 0x2
_Imax:
	.BYTE 0x2
_Umax:
	.BYTE 0x2
_nrread:
	.BYTE 0x2
_rxd:
	.BYTE 0x19
_enable:
	.BYTE 0x1
_ADport:
	.BYTE 0x1
_ui:
	.BYTE 0x1
_ii:
	.BYTE 0x1
_in:
	.BYTE 0x1
_cl:
	.BYTE 0x4
_wr:
	.BYTE 0x4
_un:
	.BYTE 0x14
_ip:
	.BYTE 0x14
_r:
	.BYTE 0x2
_up:
	.BYTE 0x2
_up1:
	.BYTE 0x2
_up2:
	.BYTE 0x2
_up3:
	.BYTE 0x2
_wrk:
	.BYTE 0x2
_menu:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
_p_S1010024:
	.BYTE 0x2
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_rxd)
	LDI  R31,HIGH(_rxd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	STS  _Imax,R30
	STS  _Imax+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	STS  _Umax,R30
	STS  _Umax+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDS  R30,_cl
	LDS  R31,_cl+1
	LDS  R22,_cl+2
	LDS  R23,_cl+3
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40233333
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	MOVW R30,R6
	LSL  R30
	ROL  R31
	MOVW R26,R30
	MOVW R30,R6
	LSR  R31
	ROR  R30
	ADD  R30,R26
	ADC  R31,R27
	MOVW R10,R30
	CALL _SetU
	__DELAY_USW 800
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDS  R30,_ui
	LDI  R26,LOW(_un)
	LDI  R27,HIGH(_un)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	CALL _SetU
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _cl,R30
	STS  _cl+1,R30
	STS  _cl+2,R30
	STS  _cl+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDS  R30,_ii
	LDI  R26,LOW(_ip)
	LDI  R27,HIGH(_ip)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	STS  _iizh0,R30
	STS  _iizh0+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDS  R26,_Iizh
	LDS  R27,_Iizh+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDS  R30,_Imax
	LDS  R31,_Imax+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDS  R26,_Imax
	LDS  R27,_Imax+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LDS  R30,_r
	LDS  R31,_r+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	STS  _r,R30
	STS  _r+1,R31
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	CALL __DIVW21U
	STS  _up,R30
	STS  _up+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	LDS  R30,_Iizh
	LDS  R31,_Iizh+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1A:
	LDS  R26,_menu
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(3)
	CALL __EQB12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	STS  _wrk,R30
	STS  _wrk+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDS  R26,_wrk
	LDS  R27,_wrk+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 67 TIMES, CODE SIZE REDUCTION:129 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:125 WORDS
SUBOPT_0x1F:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x20:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x21:
	CALL _SendUsb
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	LDS  R30,_uizh0
	LDS  R31,_uizh0+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	STS  _uizh0,R30
	STS  _uizh0+1,R31
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	STS  _uizh0,R30
	STS  _uizh0+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	LDS  R26,_uizh0
	LDS  R27,_uizh0+1
	LDI  R30,LOW(5)
	CALL __MULB1W2U
	RCALL SUBOPT_0x25
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	CALL _IzpUizh
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x22
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_iizh0
	LDS  R31,_iizh0+1
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x13
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2C:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _IzpIizh
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2E:
	MOVW R30,R12
	CLR  R22
	CLR  R23
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2F:
	LDS  R26,_wr
	LDS  R27,_wr+1
	LDS  R24,_wr+2
	LDS  R25,_wr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	__GETD1N 0x3E8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x31:
	CALL __MULD12
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x2F
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x33:
	CALL __DIVD21
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	LDS  R30,_wr
	LDS  R31,_wr+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0x2F
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	CALL __DIVD21
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	LDS  R30,_wr
	LDS  R31,_wr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x36:
	CALL _SendUsb
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	CALL __long_delay_G102
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3A:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__GTW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLO __GTW12UT
	CLR  R30
__GTW12UT:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
