
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
	.DEF _i=R4
	.DEF _ir=R6
	.DEF _napstev=R8
	.DEF _Uizh=R10
	.DEF _Uinp=R12

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x25,0x32,0x64,0x2E,0x0,0x25,0x31,0x64
	.DB  0x0,0x25,0x31,0x64,0x2E,0x0,0x25,0x30
	.DB  0x32,0x64,0x0,0x2D,0x3E,0x0,0x20,0x20
	.DB  0x0,0x55,0x0,0x5B,0x0,0x5D,0x20,0x0
	.DB  0x20,0x56,0x0,0x49,0x0,0x20,0x41,0x0
	.DB  0x52,0x62,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x50,0x6F,0x20,0x0,0x57,0x0
	.DB  0x25,0x64,0x0
_0x200005F:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G100
	.DW  _0x200005F*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 0018 #endasm
;#include <lcd.h>
;#include <stdio.h>         // Standard Input/Output functions
;#include <delay.h>
;#define RE1 PIND.2        // Rotary encoder
;#define RE2 PIND.3        // Rotary encoder
;#define T1 PIND.4          // Tipka 1
;#define T2 PIND.5          // Tipka 2
;#define Ux2 PORTA.7     // Prižge tyristor in da dvojno napetost
;#define ADC_VREF_TYPE 0xC0
;#define LEDUx2 PORTB.3
;#define LEDena PORTA.6
;#define LEDdis  PORTA.5
;
;// Declare your global variables here
;unsigned int i,ir;            // števec AD pretvornika
;char str[8];
;unsigned napstev;
;unsigned int Uizh,Uinp,Iizh,Uzel;
;unsigned int Imax;
;unsigned int nrread;
;char enable;                 // output enble
;char ADport;
;char ui;                        // index meritve izhodne napetosti
;char ii;                         // index meritve toka
;long int cl,wr;
;unsigned int un[10];
;unsigned int ip[10];
;unsigned int r;
;unsigned int up,up1,up2,up3;
;unsigned int wrk;
;char menu;
;
;
;void SetU(){
; 0000 003A void SetU(){

	.CSEG
_SetU:
; 0000 003B unsigned char u1;                    // delovno polje
; 0000 003C    if (napstev>1025) {napstev=0;}
	ST   -Y,R17
;	u1 -> R17
	LDI  R30,LOW(1025)
	LDI  R31,HIGH(1025)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x3
	CLR  R8
	CLR  R9
; 0000 003D    if (napstev>1023) {napstev=1023;}
_0x3:
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x4
	MOVW R8,R30
; 0000 003E    u1=napstev % 256;
_0x4:
	MOVW R30,R8
	MOV  R17,R30
; 0000 003F    PORTC=u1;
	OUT  0x15,R17
; 0000 0040    u1= napstev / 256;
	MOV  R17,R9
; 0000 0041    switch (u1) {
	MOV  R30,R17
	CALL SUBOPT_0x0
; 0000 0042       case 0: { PORTD.6=0; PORTD.7=0;break;}
	BRNE _0x8
	CBI  0x12,6
	CBI  0x12,7
	RJMP _0x7
; 0000 0043       case 1: { PORTD.6=0; PORTD.7=1;break;}
_0x8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD
	CBI  0x12,6
	RJMP _0x85
; 0000 0044       case 2: { PORTD.6=1; PORTD.7=0;break;}
_0xD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12
	SBI  0x12,6
	CBI  0x12,7
	RJMP _0x7
; 0000 0045       case 3: { PORTD.6=1; PORTD.7=1;break;}
_0x12:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7
	SBI  0x12,6
_0x85:
	SBI  0x12,7
; 0000 0046    };
_0x7:
; 0000 0047    if ( Ux2 & (napstev<470)) {Ux2=0;}
	LDI  R30,0
	SBIC 0x1B,7
	LDI  R30,1
	MOV  R0,R30
	MOVW R26,R8
	LDI  R30,LOW(470)
	LDI  R31,HIGH(470)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0x1C
	CBI  0x1B,7
; 0000 0048    if (!Ux2 & (napstev>512)) {Ux2=1;}
_0x1C:
	LDI  R30,0
	SBIS 0x1B,7
	LDI  R30,1
	MOV  R0,R30
	MOVW R26,R8
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __GTW12U
	AND  R30,R0
	BREQ _0x1F
	SBI  0x1B,7
; 0000 0049    LEDUx2=Ux2;
_0x1F:
	SBIC 0x1B,7
	RJMP _0x22
	CBI  0x18,3
	RJMP _0x23
_0x22:
	SBI  0x18,3
_0x23:
; 0000 004A }
	LD   R17,Y+
	RET
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 004E {
_adc_isr:
	CALL SUBOPT_0x1
; 0000 004F unsigned int u,s;
; 0000 0050 
; 0000 0051 
; 0000 0052 
; 0000 0053 // Read the AD conversion result
; 0000 0054 switch(ADport) {
	CALL __SAVELOCR4
;	u -> R16,R17
;	s -> R18,R19
	LDS  R30,_ADport
	CALL SUBOPT_0x0
; 0000 0055   case 0:{Uizh=ADCW;
	BREQ PC+3
	JMP _0x27
	__INWR 10,11,4
; 0000 0056                if (cl==0) {
	CALL SUBOPT_0x2
	BRNE _0x28
; 0000 0057                   if (Uizh>((i*2.55)+25)) {napstev=2*i+i/2; SetU();delay_us(400);}
	CALL SUBOPT_0x3
	__GETD2N 0x41C80000
	CALL __ADDF12
	MOVW R26,R10
	CALL SUBOPT_0x4
	BREQ PC+2
	BRCC PC+3
	JMP  _0x29
	CALL SUBOPT_0x5
; 0000 0058                   if ((Uizh+25)<(i*2.55)) {napstev=2*i+i/2; SetU();delay_us(400);}
_0x29:
	MOVW R30,R10
	ADIW R30,25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	CALL SUBOPT_0x4
	BRSH _0x2A
	CALL SUBOPT_0x5
; 0000 0059                   r=0;
_0x2A:
	LDI  R30,LOW(0)
	STS  _r,R30
	STS  _r+1,R30
; 0000 005A                }
; 0000 005B                un[ui]=Uizh;
_0x28:
	CALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R10
	STD  Z+1,R11
; 0000 005C                ui++;
	LDS  R30,_ui
	SUBI R30,-LOW(1)
	STS  _ui,R30
; 0000 005D                if (ui>=3){ui=0;}
	LDS  R26,_ui
	CPI  R26,LOW(0x3)
	BRLO _0x2B
	LDI  R30,LOW(0)
	STS  _ui,R30
; 0000 005E                u=0;
_0x2B:
	__GETWRN 16,17,0
; 0000 005F                for (s=0;s<3;s++) { u=u+un[s];}
	__GETWRN 18,19,0
_0x2D:
	__CPWRN 18,19,3
	BRSH _0x2E
	MOVW R30,R18
	LDI  R26,LOW(_un)
	LDI  R27,HIGH(_un)
	CALL SUBOPT_0x7
	__ADDWRR 16,17,30,31
	__ADDWRN 18,19,1
	RJMP _0x2D
_0x2E:
; 0000 0060 
; 0000 0061                u=u/3;
	MOVW R26,R16
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21U
	MOVW R16,R30
; 0000 0062                Uizh=u*10;
	__MULBNWRU 16,17,10
	MOVW R10,R30
; 0000 0063                u=u/10;
	MOVW R26,R16
	CALL SUBOPT_0x8
	MOVW R16,R30
; 0000 0064                Uizh=Uizh/16;
	MOVW R30,R10
	CALL __LSRW4
	MOVW R10,R30
; 0000 0065                Uizh=Uizh*10;
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MULW12U
	MOVW R10,R30
; 0000 0066                Uizh=Uizh/16;
	MOVW R30,R10
	CALL __LSRW4
	MOVW R10,R30
; 0000 0067                if (Uizh>(i+1)) {napstev--; SetU();delay_us(200);cl=0;}
	MOVW R30,R4
	ADIW R30,1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x2F
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
	ADIW R30,1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0068                if ((Uizh+1)<i) {napstev++; SetU();delay_us(200);}
_0x2F:
	MOVW R26,R10
	ADIW R26,1
	CP   R26,R4
	CPC  R27,R5
	BRSH _0x30
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	CALL SUBOPT_0x9
; 0000 0069 
; 0000 006A                ADport=1;
_0x30:
	LDI  R30,LOW(1)
	STS  _ADport,R30
; 0000 006B                nrread=0;
	LDI  R30,LOW(0)
	STS  _nrread,R30
	STS  _nrread+1,R30
; 0000 006C                break;}
	RJMP _0x26
; 0000 006D   case 1:{ii++;
_0x27:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x31
	LDS  R30,_ii
	SUBI R30,-LOW(1)
	STS  _ii,R30
; 0000 006E                if (ii>=5){ii=0;}
	LDS  R26,_ii
	CPI  R26,LOW(0x5)
	BRLO _0x32
	LDI  R30,LOW(0)
	STS  _ii,R30
; 0000 006F                ip[ii]=ADCW;
_0x32:
	CALL SUBOPT_0xB
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x4
	IN   R31,0x4+1
	ST   X+,R30
	ST   X,R31
; 0000 0070                Iizh=0;
	LDI  R30,LOW(0)
	STS  _Iizh,R30
	STS  _Iizh+1,R30
; 0000 0071                for (s=0;s<5;s++) {Iizh=Iizh+ip[s];}
	__GETWRN 18,19,0
_0x34:
	__CPWRN 18,19,5
	BRSH _0x35
	MOVW R30,R18
	LDI  R26,LOW(_ip)
	LDI  R27,HIGH(_ip)
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
	ADD  R30,R26
	ADC  R31,R27
	STS  _Iizh,R30
	STS  _Iizh+1,R31
	__ADDWRN 18,19,1
	RJMP _0x34
_0x35:
; 0000 0072 
; 0000 0073                if (Iizh>Imax) {
	LDS  R30,_Imax
	LDS  R31,_Imax+1
	CALL SUBOPT_0xC
	CP   R30,R26
	CPC  R31,R27
	BRLO PC+3
	JMP _0x36
; 0000 0074                   cl=1;
	__GETD1N 0x1
	STS  _cl,R30
	STS  _cl+1,R31
	STS  _cl+2,R22
	STS  _cl+3,R23
; 0000 0075 
; 0000 0076                   if (Iizh>(Imax*3)) {
	CALL SUBOPT_0xD
	LDI  R30,LOW(3)
	CALL __MULB1W2U
	CALL SUBOPT_0xC
	CP   R30,R26
	CPC  R31,R27
	BRLO PC+3
	JMP _0x37
; 0000 0077                      if (r==0) {
	CALL SUBOPT_0xE
	SBIW R30,0
	BRNE _0x38
; 0000 0078                         r=(Uizh*5000)/ip[ii];
	MOVW R26,R10
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL __MULW12U
	MOVW R0,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
	MOVW R26,R0
	CALL __DIVW21U
	CALL SUBOPT_0xF
; 0000 0079                         up=Imax*r/100;
	CALL SUBOPT_0xD
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x10
; 0000 007A                         up1=up;
	STS  _up1,R30
	STS  _up1+1,R31
; 0000 007B 
; 0000 007C                         up=(Uizh*100)/up;
	MOVW R26,R10
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MULW12U
	MOVW R26,R30
	LDS  R30,_up
	LDS  R31,_up+1
	CALL SUBOPT_0x10
; 0000 007D                         up2=up;
	STS  _up2,R30
	STS  _up2+1,R31
; 0000 007E                         up3=Iizh;
	CALL SUBOPT_0x11
	STS  _up3,R30
	STS  _up3+1,R31
; 0000 007F                         napstev=up;
	__GETWRMN 8,9,0,_up
; 0000 0080                      }
; 0000 0081                      else {napstev--;}
	RJMP _0x39
_0x38:
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
_0x39:
; 0000 0082                   }
; 0000 0083                   else { napstev--;}
	RJMP _0x3A
_0x37:
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
_0x3A:
; 0000 0084 //                  napstev--;
; 0000 0085                   SetU();
	RCALL _SetU
; 0000 0086                   LEDdis=1;
	SBI  0x1B,5
; 0000 0087                   delay_ms(1);
	CALL SUBOPT_0x12
; 0000 0088                   nrread=900;
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	STS  _nrread,R30
	STS  _nrread+1,R31
; 0000 0089                   if (LEDena) {LEDdis=0;};
	SBIC 0x1B,6
	CBI  0x1B,5
; 0000 008A                }
; 0000 008B                else {
	RJMP _0x40
_0x36:
; 0000 008C                   if (cl!=0) {cl++;}
	CALL SUBOPT_0x2
	BREQ _0x41
	LDI  R26,LOW(_cl)
	LDI  R27,HIGH(_cl)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 008D                   if (cl==100000) {cl=0;}
_0x41:
	LDS  R26,_cl
	LDS  R27,_cl+1
	LDS  R24,_cl+2
	LDS  R25,_cl+3
	__CPD2N 0x186A0
	BRNE _0x42
	CALL SUBOPT_0xA
; 0000 008E                }
_0x42:
_0x40:
; 0000 008F                nrread++;
	LDI  R26,LOW(_nrread)
	LDI  R27,HIGH(_nrread)
	CALL SUBOPT_0x13
; 0000 0090                if (nrread==1000) { ADport=2;}
	LDS  R26,_nrread
	LDS  R27,_nrread+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRNE _0x43
	LDI  R30,LOW(2)
	STS  _ADport,R30
; 0000 0091                break;}
_0x43:
	RJMP _0x26
; 0000 0092   case 2:{Uinp=ADCW; ADport=0; break;}
_0x31:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x45
	__INWR 12,13,4
; 0000 0093   default:ADport=0;
_0x45:
_0x86:
	LDI  R30,LOW(0)
	STS  _ADport,R30
; 0000 0094 }
_0x26:
; 0000 0095 ADMUX=ADport | ADC_VREF_TYPE ;  // doloci adc vhod
	LDS  R30,_ADport
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 0096 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0097 
; 0000 0098 }
	CALL __LOADLOCR4
	ADIW R28,4
	RJMP _0x89
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 009C {
_ext_int0_isr:
	CALL SUBOPT_0x1
; 0000 009D    if ((menu==1)|(menu==3)) { if (enable) {wrk=i;} else {wrk=ir;}}
	CALL SUBOPT_0x14
	BREQ _0x46
	LDS  R30,_enable
	CPI  R30,0
	BREQ _0x47
	__PUTWMRN _wrk,0,4,5
	RJMP _0x48
_0x47:
	__PUTWMRN _wrk,0,6,7
_0x48:
; 0000 009E    if (menu==2) {wrk=Imax;}
_0x46:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x49
	LDS  R30,_Imax
	LDS  R31,_Imax+1
	CALL SUBOPT_0x15
; 0000 009F    if (RE1==RE2) {
_0x49:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
	CP   R30,R26
	BRNE _0x4A
; 0000 00A0       wrk--;
	LDI  R26,LOW(_wrk)
	LDI  R27,HIGH(_wrk)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
; 0000 00A1       if ((menu==1)|(menu==3)) {if (wrk>410){wrk=0;}}
	CALL SUBOPT_0x14
	BREQ _0x4B
	CALL SUBOPT_0x16
	CPI  R26,LOW(0x19B)
	LDI  R30,HIGH(0x19B)
	CPC  R27,R30
	BRLO _0x4C
	LDI  R30,LOW(0)
	STS  _wrk,R30
	STS  _wrk+1,R30
_0x4C:
; 0000 00A2       if (menu==2) {if (wrk>5010){wrk=0;}}
_0x4B:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x4D
	CALL SUBOPT_0x16
	CPI  R26,LOW(0x1393)
	LDI  R30,HIGH(0x1393)
	CPC  R27,R30
	BRLO _0x4E
	LDI  R30,LOW(0)
	STS  _wrk,R30
	STS  _wrk+1,R30
_0x4E:
; 0000 00A3    }
_0x4D:
; 0000 00A4    else {
	RJMP _0x4F
_0x4A:
; 0000 00A5       wrk++;
	LDI  R26,LOW(_wrk)
	LDI  R27,HIGH(_wrk)
	CALL SUBOPT_0x13
; 0000 00A6       if ((menu==1)|(menu==3)) {if (wrk>400){wrk=400;}}
	CALL SUBOPT_0x14
	BREQ _0x50
	CALL SUBOPT_0x16
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLO _0x51
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x15
_0x51:
; 0000 00A7       if (menu==2) {if (wrk>5000){wrk=5000;}}
_0x50:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x52
	CALL SUBOPT_0x16
	CPI  R26,LOW(0x1389)
	LDI  R30,HIGH(0x1389)
	CPC  R27,R30
	BRLO _0x53
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x15
_0x53:
; 0000 00A8    }
_0x52:
_0x4F:
; 0000 00A9    if ((menu==1)|(menu==3)) { Uzel=wrk; if (enable) {i=wrk;} else {ir=wrk;}}
	CALL SUBOPT_0x14
	BREQ _0x54
	LDS  R30,_wrk
	LDS  R31,_wrk+1
	STS  _Uzel,R30
	STS  _Uzel+1,R31
	LDS  R30,_enable
	CPI  R30,0
	BREQ _0x55
	__GETWRMN 4,5,0,_wrk
	RJMP _0x56
_0x55:
	__GETWRMN 6,7,0,_wrk
_0x56:
; 0000 00AA    if (menu==2) {Imax=wrk;}
_0x54:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x57
	LDS  R30,_wrk
	LDS  R31,_wrk+1
	STS  _Imax,R30
	STS  _Imax+1,R31
; 0000 00AB    delay_ms(1);
_0x57:
	CALL SUBOPT_0x12
; 0000 00AC }
_0x89:
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
; 0000 00AE void IzpUizh(unsigned int U){
_IzpUizh:
; 0000 00AF     sprintf(str,"%2d.",U/10);
;	U -> Y+0
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x8
	CALL SUBOPT_0x19
; 0000 00B0     lcd_puts(str);
	CALL _lcd_puts
; 0000 00B1     sprintf(str,"%1d",U%10);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,5
	CALL SUBOPT_0x18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	CALL SUBOPT_0x19
; 0000 00B2     lcd_puts(str);
	CALL _lcd_puts
; 0000 00B3 }
	JMP  _0x20C0003
;
;void IzpIizh(unsigned int I){
; 0000 00B5 void IzpIizh(unsigned int I){
_IzpIizh:
; 0000 00B6     sprintf(str,"%1d.",I/100);
;	I -> Y+0
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,9
	CALL SUBOPT_0x18
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	CALL SUBOPT_0x19
; 0000 00B7     lcd_puts(str);
	CALL _lcd_puts
; 0000 00B8     sprintf(str,"%02d",I%100);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,14
	CALL SUBOPT_0x18
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	CALL SUBOPT_0x19
; 0000 00B9     lcd_puts(str);
	CALL _lcd_puts
; 0000 00BA }
	JMP  _0x20C0003
;
;void main(void)
; 0000 00BD {
_main:
; 0000 00BE // Declare your local variables here
; 0000 00BF 
; 0000 00C0 // Input/Output Ports initialization
; 0000 00C1 // Port A initialization
; 0000 00C2 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C3 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C4 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00C5 DDRA=0xE0;
	LDI  R30,LOW(224)
	OUT  0x1A,R30
; 0000 00C6 
; 0000 00C7 // Port B initialization
; 0000 00C8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00CA PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00CB DDRB=0x08;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 00CC 
; 0000 00CD // Port C initialization
; 0000 00CE // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00CF // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00D0 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00D1 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00D2 
; 0000 00D3 // Port D initialization
; 0000 00D4 // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00D5 // State7=0 State6=0 State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00D6 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00D7 DDRD=0xC0;
	LDI  R30,LOW(192)
	OUT  0x11,R30
; 0000 00D8 
; 0000 00D9 // Timer/Counter 0 initialization
; 0000 00DA // Clock source: System Clock
; 0000 00DB // Clock value: Timer 0 Stopped
; 0000 00DC // Mode: Normal top=FFh
; 0000 00DD // OC0 output: Disconnected
; 0000 00DE TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00DF TCNT0=0x00;
	OUT  0x32,R30
; 0000 00E0 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00E1 
; 0000 00E2 // Timer/Counter 1 initialization
; 0000 00E3 // Clock source: System Clock
; 0000 00E4 // Clock value: Timer 1 Stopped
; 0000 00E5 // Mode: Normal top=FFFFh
; 0000 00E6 // OC1A output: Discon.
; 0000 00E7 // OC1B output: Discon.
; 0000 00E8 // Noise Canceler: Off
; 0000 00E9 // Input Capture on Falling Edge
; 0000 00EA // Timer 1 Overflow Interrupt: Off
; 0000 00EB // Input Capture Interrupt: Off
; 0000 00EC // Compare A Match Interrupt: Off
; 0000 00ED // Compare B Match Interrupt: Off
; 0000 00EE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00EF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00F0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00F1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F8 
; 0000 00F9 // Timer/Counter 2 initialization
; 0000 00FA // Clock source: System Clock
; 0000 00FB // Clock value: Timer 2 Stopped
; 0000 00FC // Mode: Normal top=FFh
; 0000 00FD // OC2 output: Disconnected
; 0000 00FE ASSR=0x00;
	OUT  0x22,R30
; 0000 00FF TCCR2=0x00;
	OUT  0x25,R30
; 0000 0100 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0101 OCR2=0x00;
	OUT  0x23,R30
; 0000 0102 
; 0000 0103 // External Interrupt(s) initialization
; 0000 0104 // INT0: On
; 0000 0105 // INT0 Mode: Any change
; 0000 0106 // INT1: Off
; 0000 0107 // INT2: Off
; 0000 0108 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0109 MCUCR=0x01;
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0000 010A MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 010B GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 010C 
; 0000 010D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 010E TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 010F 
; 0000 0110 // USART initialization
; 0000 0111 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0112 // USART Receiver: On
; 0000 0113 // USART Transmitter: On
; 0000 0114 // USART Mode: Asynchronous
; 0000 0115 // USART Baud Rate: 19200
; 0000 0116 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0117 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0118 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0119 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 011A UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 011B 
; 0000 011C // Analog Comparator initialization
; 0000 011D // Analog Comparator: Off
; 0000 011E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 011F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0120 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0121 
; 0000 0122 // ADC initialization
; 0000 0123 // ADC Clock frequency: 1000,000 kHz
; 0000 0124 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0125 // ADC Auto Trigger Source: None
; 0000 0126 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 0127 ADCSRA=0x8C;
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 0128 
; 0000 0129 
; 0000 012A // LCD module initialization
; 0000 012B lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 012C // Global enable interrupts
; 0000 012D #asm("sei")
	sei
; 0000 012E 
; 0000 012F PORTC=0;                                         // init D/A pretvornika
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0130 PORTD.6=0;
	CBI  0x12,6
; 0000 0131 PORTD.7=0;
	CBI  0x12,7
; 0000 0132 napstev=0;                                       // init števca napetosti
	CLR  R8
	CLR  R9
; 0000 0133 SetU();
	RCALL _SetU
; 0000 0134 for (ui=0;ui<10;ui++){un[ui]=0;}
	LDI  R30,LOW(0)
	STS  _ui,R30
_0x5D:
	LDS  R26,_ui
	CPI  R26,LOW(0xA)
	BRSH _0x5E
	CALL SUBOPT_0x6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDS  R30,_ui
	SUBI R30,-LOW(1)
	STS  _ui,R30
	RJMP _0x5D
_0x5E:
; 0000 0135 ui=0;
	LDI  R30,LOW(0)
	STS  _ui,R30
; 0000 0136 ii=0;
	STS  _ii,R30
; 0000 0137 cl=0;
	CALL SUBOPT_0xA
; 0000 0138 Imax=130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _Imax,R30
	STS  _Imax+1,R31
; 0000 0139 enable=0;
	LDI  R30,LOW(0)
	STS  _enable,R30
; 0000 013A LEDdis=1;
	SBI  0x1B,5
; 0000 013B r=0;
	STS  _r,R30
	STS  _r+1,R30
; 0000 013C menu=1;
	LDI  R30,LOW(1)
	STS  _menu,R30
; 0000 013D Uzel=0;
	LDI  R30,LOW(0)
	STS  _Uzel,R30
	STS  _Uzel+1,R30
; 0000 013E 
; 0000 013F i=0;
	CLR  R4
	CLR  R5
; 0000 0140 ADport=2;
	LDI  R30,LOW(2)
	STS  _ADport,R30
; 0000 0141 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0142 
; 0000 0143 while (1)
_0x61:
; 0000 0144    {
; 0000 0145 
; 0000 0146       if (enable) {ir=i;}
	LDS  R30,_enable
	CPI  R30,0
	BREQ _0x64
	MOVW R6,R4
; 0000 0147       if (T1==0) {
_0x64:
	SBIC 0x10,4
	RJMP _0x65
; 0000 0148          while (T1==0) {delay_ms(10);}
_0x66:
	SBIC 0x10,4
	RJMP _0x68
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP _0x66
_0x68:
; 0000 0149          menu++;
	LDS  R30,_menu
	SUBI R30,-LOW(1)
	STS  _menu,R30
; 0000 014A          if (menu>3) {menu=1;}
	LDS  R26,_menu
	CPI  R26,LOW(0x4)
	BRLO _0x69
	LDI  R30,LOW(1)
	STS  _menu,R30
; 0000 014B       }
_0x69:
; 0000 014C       if (T2==0){
_0x65:
	SBIC 0x10,5
	RJMP _0x6A
; 0000 014D          enable=!enable;
	LDS  R30,_enable
	CALL __LNEGB1
	STS  _enable,R30
; 0000 014E          if (enable) {LEDena=1;LEDdis=0;}
	CPI  R30,0
	BREQ _0x6B
	SBI  0x1B,6
	CBI  0x1B,5
; 0000 014F          else {LEDena=0;LEDdis=1;}
	RJMP _0x70
_0x6B:
	CBI  0x1B,6
	SBI  0x1B,5
_0x70:
; 0000 0150          if (!enable) {i=0;}
	LDS  R30,_enable
	CPI  R30,0
	BRNE _0x75
	CLR  R4
	CLR  R5
; 0000 0151          else {i=ir;}
	RJMP _0x76
_0x75:
	MOVW R4,R6
_0x76:
; 0000 0152          while (T2==0){};
_0x77:
	SBIS 0x10,5
	RJMP _0x77
; 0000 0153       }
; 0000 0154 
; 0000 0155 
; 0000 0156 
; 0000 0157     switch(menu) {
_0x6A:
	LDS  R30,_menu
	LDI  R31,0
; 0000 0158        case 1:{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7D
; 0000 0159                lcd_gotoxy(1,0);
	CALL SUBOPT_0x1A
; 0000 015A                sprintf(str,"->") ;
	__POINTW1FN _0x0,19
	CALL SUBOPT_0x1B
; 0000 015B                lcd_puts(str);
	CALL _lcd_puts
; 0000 015C                lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1C
; 0000 015D                sprintf(str,"  ") ;
	__POINTW1FN _0x0,22
	RJMP _0x87
; 0000 015E                lcd_puts(str);
; 0000 015F                break;
; 0000 0160        }
; 0000 0161        case 2:{
_0x7D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7E
; 0000 0162                lcd_gotoxy(1,0);
	CALL SUBOPT_0x1A
; 0000 0163                sprintf(str,"  ") ;
	__POINTW1FN _0x0,22
	CALL SUBOPT_0x1B
; 0000 0164                lcd_puts(str);
	CALL _lcd_puts
; 0000 0165                lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _0x88
; 0000 0166                sprintf(str,"->") ;
; 0000 0167                lcd_puts(str);
; 0000 0168                break;
; 0000 0169        }
; 0000 016A        case 3:{
_0x7E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7C
; 0000 016B                lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x88:
	ST   -Y,R30
	CALL SUBOPT_0x1D
; 0000 016C                sprintf(str,"->") ;
	__POINTW1FN _0x0,19
_0x87:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 016D                lcd_puts(str);
	CALL SUBOPT_0x17
	CALL _lcd_puts
; 0000 016E                break;
; 0000 016F        }
; 0000 0170 
; 0000 0171 
; 0000 0172     }
_0x7C:
; 0000 0173 
; 0000 0174 
; 0000 0175       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL SUBOPT_0x1D
; 0000 0176       sprintf(str,"U") ;
	__POINTW1FN _0x0,25
	CALL SUBOPT_0x1B
; 0000 0177       lcd_puts(str);
	CALL _lcd_puts
; 0000 0178       lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x1D
; 0000 0179       sprintf(str,"[") ;
	__POINTW1FN _0x0,27
	CALL SUBOPT_0x1B
; 0000 017A       lcd_puts(str);
	CALL _lcd_puts
; 0000 017B       IzpUizh(Uzel);
	LDS  R30,_Uzel
	LDS  R31,_Uzel+1
	CALL SUBOPT_0x1E
; 0000 017C       sprintf(str,"] ") ;
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,29
	CALL SUBOPT_0x1B
; 0000 017D       lcd_puts(str);
	CALL _lcd_puts
; 0000 017E       IzpUizh(Uizh);
	ST   -Y,R11
	ST   -Y,R10
	RCALL _IzpUizh
; 0000 017F       sprintf(str," V") ;
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,32
	CALL SUBOPT_0x1B
; 0000 0180       lcd_puts(str);
	CALL _lcd_puts
; 0000 0181       if ((menu==1)|(menu==2)) {
	LDS  R26,_menu
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(2)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x80
; 0000 0182          lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1C
; 0000 0183          sprintf(str,"I") ;
	__POINTW1FN _0x0,35
	CALL SUBOPT_0x1B
; 0000 0184          lcd_puts(str);
	CALL _lcd_puts
; 0000 0185          lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1C
; 0000 0186          sprintf(str,"[") ;
	__POINTW1FN _0x0,27
	CALL SUBOPT_0x1B
; 0000 0187          lcd_puts(str);
	CALL _lcd_puts
; 0000 0188          IzpIizh(Imax/10);
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1F
; 0000 0189          sprintf(str,"] ") ;
	__POINTW1FN _0x0,29
	CALL SUBOPT_0x1B
; 0000 018A          lcd_puts(str);
	CALL _lcd_puts
; 0000 018B          IzpIizh(Iizh/10);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1F
; 0000 018C          sprintf(str," A") ;
	__POINTW1FN _0x0,37
	CALL SUBOPT_0x1B
; 0000 018D          lcd_puts(str);
	CALL _lcd_puts
; 0000 018E       }
; 0000 018F       if (menu==3) {
_0x80:
	LDS  R26,_menu
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x81
; 0000 0190          lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1C
; 0000 0191          sprintf(str,"Rb ") ;
	__POINTW1FN _0x0,40
	CALL SUBOPT_0x1B
; 0000 0192          lcd_puts(str);
	CALL _lcd_puts
; 0000 0193          if (Iizh!=0) {
	CALL SUBOPT_0x11
	SBIW R30,0
	BREQ _0x82
; 0000 0194             wr=Uizh;
	CALL SUBOPT_0x20
; 0000 0195             wr=wr*1000;
	CALL SUBOPT_0x21
	__GETD1N 0x3E8
	CALL SUBOPT_0x22
; 0000 0196             wr=wr/Iizh;
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 0197             r=wr;
; 0000 0198             IzpUizh(r);
	CALL SUBOPT_0x1E
; 0000 0199             }
; 0000 019A          else {
	RJMP _0x83
_0x82:
; 0000 019B             sprintf(str,"    ") ;
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,44
	CALL SUBOPT_0x1B
; 0000 019C             lcd_puts(str);
	CALL _lcd_puts
; 0000 019D          }
_0x83:
; 0000 019E          sprintf(str," Po ");
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x1B
; 0000 019F          lcd_puts(str);
	CALL _lcd_puts
; 0000 01A0          wr=Uizh;
	CALL SUBOPT_0x20
; 0000 01A1          wr=wr*Iizh;
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
; 0000 01A2          wr=wr/1000;
	CALL SUBOPT_0x21
	__GETD1N 0x3E8
	CALL SUBOPT_0x24
; 0000 01A3          r=wr;
; 0000 01A4          IzpUizh(r);
	CALL SUBOPT_0x1E
; 0000 01A5          sprintf(str,"W");
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,54
	CALL SUBOPT_0x1B
; 0000 01A6          lcd_puts(str);
	CALL _lcd_puts
; 0000 01A7 
; 0000 01A8 
; 0000 01A9       }
; 0000 01AA       sprintf(str,"%d",menu) ;
_0x81:
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,56
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_menu
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01AB       lcd_puts(str);
	CALL SUBOPT_0x17
	CALL _lcd_puts
; 0000 01AC 
; 0000 01AD 
; 0000 01AE //      sprintf(str,"%4d ",napstev);
; 0000 01AF //      lcd_puts(str);
; 0000 01B0 //      sprintf(str,"%3d ",i);
; 0000 01B1 //      lcd_puts(str);
; 0000 01B2 
; 0000 01B3 //      IzpUizh(Uizh);
; 0000 01B4 //      IzpIizh();
; 0000 01B5 //      lcd_gotoxy(0,1);
; 0000 01B6 //      sprintf(str,"%4d ",Iizh);
; 0000 01B7 //      lcd_puts(str);
; 0000 01B8 //      sprintf(str,"%5d",up1);
; 0000 01B9 //      lcd_puts(str);
; 0000 01BA //      sprintf(str,"%5d",up2);
; 0000 01BB //      lcd_puts(str);
; 0000 01BC //      sprintf(str,"%5d",up3);
; 0000 01BD //      lcd_puts(str);
; 0000 01BE    };
	RJMP _0x61
; 0000 01BF }
_0x84:
	RJMP _0x84

	.CSEG

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
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
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0002
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x25
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
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
_0x20C0003:
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
	BRLO _0x2020004
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
_0x2020004:
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
	JMP  _0x20C0002
_lcd_puts:
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0002
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x25
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G101,2
	CALL SUBOPT_0x25
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x27
	LDI  R30,LOW(4)
	CALL SUBOPT_0x27
	LDI  R30,LOW(133)
	CALL SUBOPT_0x27
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0001
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
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
_0x20C0002:
_0x20C0001:
	ADIW R28,1
	RET
__put_G102:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2040012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x13
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2040013:
	RJMP _0x2040014
_0x2040010:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x2040014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G102:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x2040015:
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
	JMP _0x2040017
	MOV  R30,R17
	CALL SUBOPT_0x0
	BRNE _0x204001B
	CPI  R18,37
	BRNE _0x204001C
	LDI  R17,LOW(1)
	RJMP _0x204001D
_0x204001C:
	CALL SUBOPT_0x28
_0x204001D:
	RJMP _0x204001A
_0x204001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x204001E
	CPI  R18,37
	BRNE _0x204001F
	CALL SUBOPT_0x28
	RJMP _0x20400BC
_0x204001F:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040020
	LDI  R16,LOW(1)
	RJMP _0x204001A
_0x2040020:
	CPI  R18,43
	BRNE _0x2040021
	LDI  R20,LOW(43)
	RJMP _0x204001A
_0x2040021:
	CPI  R18,32
	BRNE _0x2040022
	LDI  R20,LOW(32)
	RJMP _0x204001A
_0x2040022:
	RJMP _0x2040023
_0x204001E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2040024
_0x2040023:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040025
	ORI  R16,LOW(128)
	RJMP _0x204001A
_0x2040025:
	RJMP _0x2040026
_0x2040024:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x204001A
_0x2040026:
	CPI  R18,48
	BRLO _0x2040029
	CPI  R18,58
	BRLO _0x204002A
_0x2040029:
	RJMP _0x2040028
_0x204002A:
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
	RJMP _0x204001A
_0x2040028:
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x204002E
	CALL SUBOPT_0x2A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2B
	RJMP _0x204002F
_0x204002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2040031
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040032
_0x2040031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2040034
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040032:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040035
_0x2040034:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x2040038
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2040039
_0x2040038:
	ORI  R16,LOW(4)
	RJMP _0x204003A
_0x2040039:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x204003B
_0x204003A:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003C
_0x204003B:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x204003E
	ORI  R16,LOW(8)
	RJMP _0x204003F
_0x204003E:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2040070
_0x204003F:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003C:
	SBRS R16,2
	RJMP _0x2040041
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040042
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040042:
	CPI  R20,0
	BREQ _0x2040043
	SUBI R17,-LOW(1)
	RJMP _0x2040044
_0x2040043:
	ANDI R16,LOW(251)
_0x2040044:
	RJMP _0x2040045
_0x2040041:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
_0x2040045:
_0x2040035:
	SBRC R16,0
	RJMP _0x2040046
_0x2040047:
	CP   R17,R21
	BRSH _0x2040049
	SBRS R16,7
	RJMP _0x204004A
	SBRS R16,2
	RJMP _0x204004B
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004C
_0x204004B:
	LDI  R18,LOW(48)
_0x204004C:
	RJMP _0x204004D
_0x204004A:
	LDI  R18,LOW(32)
_0x204004D:
	CALL SUBOPT_0x28
	SUBI R21,LOW(1)
	RJMP _0x2040047
_0x2040049:
_0x2040046:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004E
_0x204004F:
	CPI  R19,0
	BREQ _0x2040051
	SBRS R16,3
	RJMP _0x2040052
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x20400BD
_0x2040052:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20400BD:
	ST   -Y,R30
	CALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x2040054
	SUBI R21,LOW(1)
_0x2040054:
	SUBI R19,LOW(1)
	RJMP _0x204004F
_0x2040051:
	RJMP _0x2040055
_0x204004E:
_0x2040057:
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
_0x2040059:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005B
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040059
_0x204005B:
	CPI  R18,58
	BRLO _0x204005C
	SBRS R16,3
	RJMP _0x204005D
	CALL SUBOPT_0x29
	ADIW R30,7
	RJMP _0x20400BE
_0x204005D:
	CALL SUBOPT_0x29
	ADIW R30,39
_0x20400BE:
	MOV  R18,R30
_0x204005C:
	SBRC R16,4
	RJMP _0x2040060
	CPI  R18,49
	BRSH _0x2040062
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040061
_0x2040062:
	RJMP _0x20400BF
_0x2040061:
	CP   R21,R19
	BRLO _0x2040066
	SBRS R16,0
	RJMP _0x2040067
_0x2040066:
	RJMP _0x2040065
_0x2040067:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040068
	LDI  R18,LOW(48)
_0x20400BF:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040069
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x204006A
	SUBI R21,LOW(1)
_0x204006A:
_0x2040069:
_0x2040068:
_0x2040060:
	CALL SUBOPT_0x28
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x2040065:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040058
	RJMP _0x2040057
_0x2040058:
_0x2040055:
	SBRS R16,0
	RJMP _0x204006C
_0x204006D:
	CPI  R21,0
	BREQ _0x204006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2B
	RJMP _0x204006D
_0x204006F:
_0x204006C:
_0x2040070:
_0x204002F:
_0x20400BC:
	LDI  R17,LOW(0)
_0x204001A:
	RJMP _0x2040015
_0x2040017:
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
	RCALL __print_G102
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

	.CSEG

	.CSEG
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

	.DSEG
_str:
	.BYTE 0x8
_Iizh:
	.BYTE 0x2
_Uzel:
	.BYTE 0x2
_Imax:
	.BYTE 0x2
_nrread:
	.BYTE 0x2
_enable:
	.BYTE 0x1
_ADport:
	.BYTE 0x1
_ui:
	.BYTE 0x1
_ii:
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
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1050024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDS  R30,_cl
	LDS  R31,_cl+1
	LDS  R22,_cl+2
	LDS  R23,_cl+3
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	MOVW R30,R4
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40233333
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	MOVW R30,R4
	LSL  R30
	ROL  R31
	MOVW R26,R30
	MOVW R30,R4
	LSR  R31
	ROR  R30
	ADD  R30,R26
	ADC  R31,R27
	MOVW R8,R30
	CALL _SetU
	__DELAY_USW 1600
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDS  R30,_ui
	LDI  R26,LOW(_un)
	LDI  R27,HIGH(_un)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL _SetU
	__DELAY_USW 800
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _cl,R30
	STS  _cl+1,R30
	STS  _cl+2,R30
	STS  _cl+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDS  R30,_ii
	LDI  R26,LOW(_ip)
	LDI  R27,HIGH(_ip)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R26,_Iizh
	LDS  R27,_Iizh+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDS  R26,_Imax
	LDS  R27,_Imax+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R30,_r
	LDS  R31,_r+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	STS  _r,R30
	STS  _r+1,R31
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	CALL __DIVW21U
	STS  _up,R30
	STS  _up+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R30,_Iizh
	LDS  R31,_Iizh+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDS  R26,_menu
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(3)
	CALL __EQB12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	STS  _wrk,R30
	STS  _wrk+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDS  R26,_wrk
	LDS  R27,_wrk+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _IzpUizh

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _IzpIizh
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	MOVW R30,R10
	CLR  R22
	CLR  R23
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x21:
	LDS  R26,_wr
	LDS  R27,_wr+1
	LDS  R24,_wr+2
	LDS  R25,_wr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	CALL __MULD12
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x21
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x24:
	CALL __DIVD21
	STS  _wr,R30
	STS  _wr+1,R31
	STS  _wr+2,R22
	STS  _wr+3,R23
	LDS  R30,_wr
	LDS  R31,_wr+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x28:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
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
SUBOPT_0x2D:
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
