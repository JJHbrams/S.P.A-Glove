
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : Off

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  _timer1_ovf_isr
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
	JMP  _timer3_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0xFF,0xFF,0xFF,0xFF
_0x4:
	.DB  0x50,0x52,0x4B,0x41
_0x5:
	.DB  0x0,0x0,0x8C,0x42
_0x6:
	.DB  0x0,0x0,0xF0,0x41
_0x7:
	.DB  0x0,0x0,0xA0,0x41
_0x99:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0xB5:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0xD7:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0xEC:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x54,0x65,0x73,0x74,0x69,0x6E,0x67,0x0
	.DB  0x25,0x64,0x0,0x54,0x75,0x6E,0x6E,0x69
	.DB  0x6E,0x67,0x0,0x44,0x75,0x74,0x79,0x0
	.DB  0x25,0x64,0x20,0x25,0x0,0x45,0x0,0x46
	.DB  0x0,0x2D,0x0,0x54,0x0,0x49,0x0,0x4D
	.DB  0x0,0x52,0x0,0x56,0x61,0x6C,0x76,0x65
	.DB  0x21,0x0,0x44,0x75,0x74,0x79,0x20,0x3A
	.DB  0x20,0x0,0x25,0x32,0x64,0x20,0x25,0x0
	.DB  0x46,0x4C,0x45,0x58,0x0,0x50,0x52,0x45
	.DB  0x53,0x0,0x44,0x61,0x69,0x6C,0x79,0x0
	.DB  0x52,0x65,0x68,0x61,0x62,0x69,0x6C,0x69
	.DB  0x74,0x61,0x74,0x69,0x6F,0x6E,0x0,0x49
	.DB  0x6E,0x6C,0x65,0x74,0x21,0x0,0x4F,0x75
	.DB  0x74,0x6C,0x65,0x74,0x21,0x0,0x25,0x34
	.DB  0x64,0x20,0x25,0x0,0x31,0x2E,0x50,0x72
	.DB  0x65,0x73,0x73,0x75,0x72,0x65,0x20,0x54
	.DB  0x45,0x53,0x54,0x0,0x32,0x2E,0x50,0x72
	.DB  0x65,0x73,0x73,0x75,0x72,0x65,0x20,0x54
	.DB  0x75,0x6E,0x6E,0x69,0x6E,0x67,0x0,0x33
	.DB  0x2E,0x46,0x6C,0x65,0x78,0x20,0x54,0x45
	.DB  0x53,0x54,0x0,0x34,0x2E,0x46,0x6C,0x65
	.DB  0x78,0x20,0x54,0x75,0x6E,0x6E,0x69,0x6E
	.DB  0x67,0x0,0x35,0x2E,0x50,0x57,0x4D,0x20
	.DB  0x54,0x45,0x53,0x54,0x0,0x36,0x2E,0x50
	.DB  0x55,0x4D,0x50,0x20,0x54,0x45,0x53,0x54
	.DB  0x0,0x37,0x2E,0x4F,0x72,0x64,0x65,0x72
	.DB  0x20,0x54,0x45,0x53,0x54,0x0,0x38,0x2E
	.DB  0x56,0x61,0x6C,0x76,0x65,0x20,0x4F,0x72
	.DB  0x64,0x65,0x72,0x0,0x39,0x2E,0x54,0x68
	.DB  0x72,0x65,0x73,0x68,0x6F,0x6C,0x64,0x3F
	.DB  0x0,0x31,0x30,0x2E,0x50,0x55,0x4D,0x50
	.DB  0x20,0x56,0x41,0x4C,0x56,0x45,0x0,0x31
	.DB  0x31,0x2E,0x44,0x61,0x69,0x6C,0x79,0x20
	.DB  0x74,0x65,0x73,0x74,0x0,0x31,0x32,0x2E
	.DB  0x52,0x65,0x68,0x61,0x62,0x20,0x74,0x65
	.DB  0x73,0x74,0x0,0x31,0x33,0x2E,0x54,0x45
	.DB  0x53,0x54,0x0,0x31,0x34,0x2E,0x54,0x45
	.DB  0x53,0x54,0x32,0x0,0x31,0x35,0x2E,0x54
	.DB  0x45,0x53,0x54,0x33,0x0,0x2A,0x2A,0x42
	.DB  0x52,0x45,0x41,0x4B,0x21,0x2A,0x2A,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _flex_min
	.DW  _0x3*2

	.DW  0x04
	.DW  _pressure_max
	.DW  _0x4*2

	.DW  0x04
	.DW  _kp
	.DW  _0x5*2

	.DW  0x04
	.DW  _ki
	.DW  _0x6*2

	.DW  0x04
	.DW  _kd
	.DW  _0x7*2

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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the JJH, KYY and Johnadan
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;占� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 2018 占쏙옙占쏙옙占쏙옙품 12占쏙옙 - S.P.A glove
;Version : 2.2.0
;Date    : 2018-05-03
;Author  : JJH
;Company : Chungnam National University
;Comments: Holy Fucking Shit...
;
;
;Chip type               : Atmega128
;AVR Core Clock frequency: 16.000000 MHz
;*****************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;
;/* Alphanumeric LCD Module functions */
;#include <lcd.h>
;#asm
 .equ __lcd_port = 0x12 //PORTD 8
; 0000 001C #endasm
;
;/* About ADC */
;#define ADC_VREF_TYPE 0x60
;#define NUM_SAMP  50  //MUST be Under 255
;
;/*About Switch*/
;#define Left_switch_on    (!PINE.1)
;#define Middle_switch_on  (!PINE.2)
;#define Right_switch_on   (!PINE.3)
;#define Left_switch_off   (PINE.1)
;#define Middle_switch_off (PINE.2)
;#define Right_switch_off  (PINE.3)
;
;/*About order*/
;// Actual signal
;#define Up_thumb          (!PINE.5)
;#define Down_thumb        (!PINA.1)
;#define Up_index          (!PINA.2)
;#define Down_index        (!PINA.3)
;#define Up_middle         (!PINA.4)
;#define Down_middle       (!PINA.5)
;#define Up_rest           (!PINA.6)
;#define Down_rest         (!PINA.7)
;// No signal
;#define NO_SIGNAL_tu      (PINE.5)
;#define NO_SIGNAL_td      (PINA.1)
;#define NO_SIGNAL_iu      (PINA.2)
;#define NO_SIGNAL_id      (PINA.3)
;#define NO_SIGNAL_mu      (PINA.4)
;#define NO_SIGNAL_md      (PINA.5)
;#define NO_SIGNAL_ru      (PINA.6)
;#define NO_SIGNAL_rd      (PINA.7)
;
;/*About u saturation*/
;#define UPPER   3500 //90%  duty
;#define LOWER   800 //10% duty
;
;/*About RUN*/
;#define NORMAL_SPEED  500 //Only relates to reaction speed...
;#define ANG_th 1
;#define MAX_ANG 60
;//Timer on/off
;#define INITIATE  TIMSK = 0x14, ETIMSK = 0x14   //TIM1_COMPA interrupt on, TIM1_OVF interrupt on (Inlet Valve control)
;                                                //TIM3_COMPA interrupt on, TIM3_OVF interrupt on (Outlet Valve control)
;
;#define TERMINATE TIMSK = 0x00, ETIMSK = 0x00   //TIM1_COMPA interrupt off, TIM1_OVF interrupt off (Inlet Valve control)
;                                                //TIM3_COMPA interrupt off, TIM3_OVF interrupt off (Outlet Valve control)
;/* Rehabilitation */
;//Flextion or Extension
;#define FLEX   1
;#define EXTD   0
;//Finger type
;#define THUMB  0
;#define INDEX  1
;#define MIDDLE 2
;#define REST   3
;// Flextion/Extension speed
;// Top : 4999에 대한 duty ratio = (duty)*(4999/100) => (duty)*50
;#define REHAB_SPEED 3000
;
;//*****************************************************************************************************************
;// ****** Declare your global variables here  ******
;unsigned char sam_num = 0; // counting variable for ADC interrupt
;int i,j,k;
;//*****************************************************************************************************************
;// LCD
;unsigned char lcd_data[40];
;//*****************************************************************************************************************
;// ADC
;//unsigned char adc_data[4][100] = {0};
;unsigned char mux = 0;
;//unsigned char NUM_SAMP = 50;
;unsigned char d_flag = 0;
;
;// * Pressure
;unsigned char pressure_data[4][NUM_SAMP] = {0};
;unsigned int  pressure_sum[4] = {0};
;unsigned char pressure_mean[4] = {0};
;
;// * Flex
;unsigned char flex_data[4][NUM_SAMP] = {0};
;unsigned int  flex_sum[4] = {0};
;unsigned char flex_mean[4] = {0};
;
;//tuning
;//unsigned char flex_max[4] = {90, 130, 105, 135};
;//unsigned char flex_min[4] = {65, 100, 79, 107};
;unsigned char flex_max[4] = {0, 0, 0, 0};
;unsigned char flex_min[4] = {255, 255, 255, 255};

	.DSEG
;unsigned char pressure_max[4] = {80, 82, 75, 65};
;unsigned char pressure_min[4] = {0};
;
;// Moving
;unsigned char E_flag[4]={0}; //EXTENSION : 1
;unsigned char F_flag[4]={0}; //FLEXTION : 1
;unsigned char Global_Sequence=0;
;int arrived[4] = {0};    // 아직 목표값에 도달하지 못한 경우(목표값보다 큼) : -1
;                    // 목표값에도달한 경우 : 0
;                    // 아직 목표값에 도달하지 못한 경우(목표값보다 작음) : 1
;
;// PID
;float kp=70.0000;
;float ki=30.0000;
;float kd=20.0000;
;double error_old[4]={0};
;double error_sum[4]={0};
;unsigned char ang_old[4]={0};//Initial angle : 0 degrees
;unsigned const char delta_ang=2;//5 degrees per each sequence(EXPERIMENT NEED!)
;unsigned const char Ts=60; //Control sequence term in [ms]
;//*****************************************************************************************************************
;// Timer 1 Controls INLET!!
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 008E {

	.CSEG
_timer1_compa_isr:
	CALL SUBOPT_0x0
; 0000 008F     if(arrived[Global_Sequence] == 1)   PORTC |= 0x01<<Global_Sequence;//INLET Valve on
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8
	IN   R1,21
	LDS  R30,_Global_Sequence
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	RJMP _0x135
; 0000 0090     else                                PORTC &= 0x00;
_0x8:
	IN   R30,0x15
	ANDI R30,LOW(0x0)
_0x135:
	OUT  0x15,R30
; 0000 0091 }
	RJMP _0x13C
;// Timer1 overflow A interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0094 {
_timer1_ovf_isr:
	RJMP _0x13D
; 0000 0095     PORTC=0x00;//INLET Valve off
; 0000 0096 }
;// Timer 3 Controls OUTLET!!
;// Timer3 comparematch A interrupt service routine
;interrupt [TIM3_COMPA] void timer3_compa_isr(void)
; 0000 009A {
_timer3_compa_isr:
	CALL SUBOPT_0x0
; 0000 009B     if(arrived[Global_Sequence] == -1)  PORTC |= 0x10<<Global_Sequence;//OUTLET Valve on
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0xA
	IN   R1,21
	LDS  R30,_Global_Sequence
	LDI  R26,LOW(16)
	CALL __LSLB12
	OR   R30,R1
	RJMP _0x136
; 0000 009C     else                                PORTC &= 0x00;
_0xA:
	IN   R30,0x15
	ANDI R30,LOW(0x0)
_0x136:
	OUT  0x15,R30
; 0000 009D }
	RJMP _0x13C
;// Timer1 output compare A interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 00A0 {
_timer3_ovf_isr:
_0x13D:
	ST   -Y,R30
; 0000 00A1     PORTC=0x00;//OUTLET Valve off
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00A2 }
	LD   R30,Y+
	RETI
;// ********************************* ADC interrupt service routine ************************************************
;interrupt [ADC_INT] void adc_isr(void)
; 0000 00A5 {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A6     // Read the AD conversion result
; 0000 00A7     //for (h = 0; h<=6; h++);
; 0000 00A8     if(mux>4)           flex_data[mux-4][sam_num] = ADCH;   // 4, 5, 6, 7
	LDS  R26,_mux
	CPI  R26,LOW(0x5)
	BRLO _0xC
	LDS  R30,_mux
	LDI  R31,0
	SBIW R30,4
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	CALL __MULW12U
	SUBI R30,LOW(-_flex_data)
	SBCI R31,HIGH(-_flex_data)
	RJMP _0x137
; 0000 00A9     else                pressure_data[mux][sam_num] = ADCH;     // 0, 1, 2, 3
_0xC:
	LDS  R30,_mux
	LDI  R26,LOW(50)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_pressure_data)
	SBCI R31,HIGH(-_pressure_data)
_0x137:
	MOVW R26,R30
	LDS  R30,_sam_num
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x5
	ST   X,R30
; 0000 00AA     //ADC sampling
; 0000 00AB     if(sam_num == NUM_SAMP)
	LDS  R26,_sam_num
	CPI  R26,LOW(0x32)
	BRNE _0xE
; 0000 00AC     {
; 0000 00AD         mux++;
	LDS  R30,_mux
	SUBI R30,-LOW(1)
	STS  _mux,R30
; 0000 00AE         sam_num=0;
	LDI  R30,LOW(0)
	STS  _sam_num,R30
; 0000 00AF         d_flag=1;
	LDI  R30,LOW(1)
	STS  _d_flag,R30
; 0000 00B0     }
; 0000 00B1 
; 0000 00B2     mux &= 0x07;  //mux : 0~7
_0xE:
	LDS  R30,_mux
	ANDI R30,LOW(0x7)
	STS  _mux,R30
; 0000 00B3     ADMUX = mux | 0x60;
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 00B4     ADCSRA |= 0x40;
	SBI  0x6,6
; 0000 00B5     sam_num++;
	LDS  R30,_sam_num
	SUBI R30,-LOW(1)
	STS  _sam_num,R30
; 0000 00B6 }
_0x13C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// ******************************** About Pressure Sensor *******************************************************
;void mean_pressure(unsigned char sequence, unsigned char tunned)
; 0000 00BA {
_mean_pressure:
; 0000 00BB     unsigned char num = 0; // counting variable for function
; 0000 00BC     while(!d_flag);
	ST   -Y,R17
;	sequence -> Y+2
;	tunned -> Y+1
;	num -> R17
	LDI  R17,0
_0xF:
	LDS  R30,_d_flag
	CPI  R30,0
	BREQ _0xF
; 0000 00BD     for(num = 0; num < NUM_SAMP; num++)
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,50
	BRSH _0x14
; 0000 00BE         pressure_sum[sequence] += pressure_data[sequence][num];
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_pressure_data)
	SBCI R31,HIGH(-_pressure_data)
	CALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 00BF pressure_mean[sequence] = pressure_sum[sequence]/50  ;
	CALL SUBOPT_0x4
	MOVW R22,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x5
; 0000 00C0     pressure_sum[sequence] = 0;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x6
; 0000 00C1     d_flag=0;
; 0000 00C2 
; 0000 00C3     if(pressure_mean[sequence]>190)  pressure_mean[sequence]=0;
	CALL SUBOPT_0x4
	LD   R26,Z
	CPI  R26,LOW(0xBF)
	BRLO _0x15
	CALL SUBOPT_0x4
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00C4 
; 0000 00C5     if(tunned)
_0x15:
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x16
; 0000 00C6     {
; 0000 00C7       if(pressure_mean[sequence]>pressure_max[sequence])  pressure_mean[sequence]=pressure_max[sequence];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x17
	CALL SUBOPT_0x9
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	ST   X,R30
; 0000 00C8       if(pressure_mean[sequence]<pressure_min[sequence])  pressure_mean[sequence]=pressure_min[sequence];
_0x17:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x18
	CALL SUBOPT_0x9
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	ST   X,R30
; 0000 00C9     }
_0x18:
; 0000 00CA }
_0x16:
	RJMP _0x2080008
;//Pressure test
;void pressure_test(void)
; 0000 00CD {
_pressure_test:
; 0000 00CE     unsigned char num = 0;
; 0000 00CF     delay_ms(50);
	CALL SUBOPT_0xA
;	num -> R17
; 0000 00D0 
; 0000 00D1     while(Middle_switch_off)
_0x19:
	SBIS 0x1,2
	RJMP _0x1B
; 0000 00D2     {
; 0000 00D3         lcd_clear();
	CALL SUBOPT_0xB
; 0000 00D4         lcd_gotoxy(0, 0);
; 0000 00D5         lcd_putsf("Testing");
	CALL SUBOPT_0xC
; 0000 00D6 
; 0000 00D7         if(Left_switch_on)  num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 00D8         if(Right_switch_on) num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 00D9         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x1E
	LDI  R17,LOW(3)
; 0000 00DA         mean_pressure((unsigned char)num,0);
_0x1E:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 00DB 
; 0000 00DC         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xD
; 0000 00DD         sprintf(lcd_data, "%d", num);
	CALL SUBOPT_0xE
; 0000 00DE         lcd_puts(lcd_data);
; 0000 00DF         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xF
; 0000 00E0         sprintf(lcd_data, "%d", pressure_mean[num]);
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 00E1         lcd_puts(lcd_data);
; 0000 00E2 
; 0000 00E3         delay_ms(200);
	CALL SUBOPT_0x10
; 0000 00E4     }
	RJMP _0x19
_0x1B:
; 0000 00E5 }
	RJMP _0x2080007
;
;// Pressure tuning
;void pressure_tuning(void)
; 0000 00E9 {
_pressure_tuning:
; 0000 00EA     unsigned char num = 0;
; 0000 00EB     delay_ms(50);
	CALL SUBOPT_0xA
;	num -> R17
; 0000 00EC 
; 0000 00ED     while(Middle_switch_off)
_0x1F:
	SBIS 0x1,2
	RJMP _0x21
; 0000 00EE     {
; 0000 00EF         lcd_clear();
	CALL SUBOPT_0xB
; 0000 00F0         lcd_gotoxy(0, 0);
; 0000 00F1         lcd_putsf("Tunning");
	CALL SUBOPT_0x11
; 0000 00F2 
; 0000 00F3         if(Left_switch_on)  num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 00F4         if(Right_switch_on) num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 00F5         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x24
	LDI  R17,LOW(3)
; 0000 00F6 
; 0000 00F7         mean_pressure((unsigned char)num,0);
_0x24:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 00F8 
; 0000 00F9         if(pressure_mean[num]>pressure_max[num])  pressure_max[num]=pressure_mean[num];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x25
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_pressure_max)
	SBCI R27,HIGH(-_pressure_max)
	CALL SUBOPT_0x12
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	ST   X,R30
; 0000 00FA         if(pressure_mean[num]<pressure_min[num])  pressure_min[num]=pressure_mean[num];
_0x25:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x26
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_pressure_min)
	SBCI R27,HIGH(-_pressure_min)
	CALL SUBOPT_0x12
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	ST   X,R30
; 0000 00FB 
; 0000 00FC         lcd_gotoxy(7, 0);
_0x26:
	CALL SUBOPT_0x14
; 0000 00FD         sprintf(lcd_data, "%d", num);
; 0000 00FE         lcd_puts(lcd_data);
; 0000 00FF         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xD
; 0000 0100         sprintf(lcd_data, "%d", pressure_min[num]);
	LDI  R31,0
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 0101         lcd_puts(lcd_data);
; 0000 0102         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xF
; 0000 0103         sprintf(lcd_data, "%d", pressure_max[num]);
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 0104         lcd_puts(lcd_data);
; 0000 0105         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 0106     }
	RJMP _0x1F
_0x21:
; 0000 0107 }
	RJMP _0x2080007
;
;// ******************************** About Flex Sensor *******************************************************
;void mean_flex(unsigned char sequence, unsigned char tunned)
; 0000 010B {
_mean_flex:
; 0000 010C     unsigned char num = 0; // counting variable for function
; 0000 010D     while(!d_flag);
	ST   -Y,R17
;	sequence -> Y+2
;	tunned -> Y+1
;	num -> R17
	LDI  R17,0
_0x27:
	LDS  R30,_d_flag
	CPI  R30,0
	BREQ _0x27
; 0000 010E     for(num = 0; num < NUM_SAMP; num++)
	LDI  R17,LOW(0)
_0x2B:
	CPI  R17,50
	BRSH _0x2C
; 0000 010F         flex_sum[sequence] += flex_data[sequence][num];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_flex_data)
	SBCI R31,HIGH(-_flex_data)
	CALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0x2B
_0x2C:
; 0000 0110 flex_mean[sequence] = flex_sum[sequence]/50  ;
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	MOVW R22,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x5
; 0000 0111     flex_sum[sequence] = 0;
	CALL SUBOPT_0x16
	CALL SUBOPT_0x6
; 0000 0112     d_flag=0;
; 0000 0113     if(tunned)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2D
; 0000 0114     {
; 0000 0115       if(flex_mean[sequence]>flex_max[sequence])  flex_mean[sequence]=flex_max[sequence];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x17
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x2E
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	ST   X,R30
; 0000 0116       if(flex_mean[sequence]<flex_min[sequence])  flex_mean[sequence]=flex_min[sequence];
_0x2E:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x17
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x2F
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	ST   X,R30
; 0000 0117     }
_0x2F:
; 0000 0118 }
_0x2D:
_0x2080008:
	LDD  R17,Y+0
	ADIW R28,3
	RET
;//Pressure test
;void flex_test(void)
; 0000 011B {
_flex_test:
; 0000 011C     unsigned char num = 0;
; 0000 011D     delay_ms(50);
	CALL SUBOPT_0xA
;	num -> R17
; 0000 011E 
; 0000 011F     while(Middle_switch_off)
_0x30:
	SBIS 0x1,2
	RJMP _0x32
; 0000 0120     {
; 0000 0121         lcd_clear();
	CALL SUBOPT_0xB
; 0000 0122         lcd_gotoxy(0, 0);
; 0000 0123         lcd_putsf("Testing");
	CALL SUBOPT_0xC
; 0000 0124 
; 0000 0125         if(Left_switch_on)  num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 0126         if(Right_switch_on) num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 0127         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x35
	LDI  R17,LOW(3)
; 0000 0128         mean_flex((unsigned char)num,0);
_0x35:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_flex
; 0000 0129 
; 0000 012A         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xD
; 0000 012B         sprintf(lcd_data, "%d", num);
	CALL SUBOPT_0xE
; 0000 012C         lcd_puts(lcd_data);
; 0000 012D         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xF
; 0000 012E         sprintf(lcd_data, "%d", flex_mean[num]);
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 012F         lcd_puts(lcd_data);
; 0000 0130 
; 0000 0131         delay_ms(200);
	CALL SUBOPT_0x10
; 0000 0132     }
	RJMP _0x30
_0x32:
; 0000 0133 }
	RJMP _0x2080007
;
;// flex tuning
;void flex_tuning(void)
; 0000 0137 {
_flex_tuning:
; 0000 0138     unsigned char num = 0;
; 0000 0139     delay_ms(50);
	CALL SUBOPT_0xA
;	num -> R17
; 0000 013A 
; 0000 013B     while(Middle_switch_off)
_0x36:
	SBIS 0x1,2
	RJMP _0x38
; 0000 013C     {
; 0000 013D         lcd_clear();
	CALL SUBOPT_0xB
; 0000 013E         lcd_gotoxy(0, 0);
; 0000 013F         lcd_putsf("Tunning");
	CALL SUBOPT_0x11
; 0000 0140 
; 0000 0141         if(Left_switch_on)  num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 0142         if(Right_switch_on) num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 0143         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x3B
	LDI  R17,LOW(3)
; 0000 0144         mean_flex((unsigned char)num,0);
_0x3B:
	ST   -Y,R17
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 0000 0145 
; 0000 0146         if(flex_mean[num]>flex_max[num])  flex_max[num]=flex_mean[num];
	CALL SUBOPT_0x17
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x3C
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_flex_max)
	SBCI R27,HIGH(-_flex_max)
	CALL SUBOPT_0x12
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	ST   X,R30
; 0000 0147         if(flex_mean[num]<flex_min[num])  flex_min[num]=flex_mean[num];
_0x3C:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x17
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x3D
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_flex_min)
	SBCI R27,HIGH(-_flex_min)
	CALL SUBOPT_0x12
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	ST   X,R30
; 0000 0148 
; 0000 0149         lcd_gotoxy(7, 0);
_0x3D:
	CALL SUBOPT_0x14
; 0000 014A         sprintf(lcd_data, "%d", num);
; 0000 014B         lcd_puts(lcd_data);
; 0000 014C         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xD
; 0000 014D         sprintf(lcd_data, "%d", flex_min[num]);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xE
; 0000 014E         lcd_puts(lcd_data);
; 0000 014F         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xF
; 0000 0150         sprintf(lcd_data, "%d", flex_max[num]);
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 0151         lcd_puts(lcd_data);
; 0000 0152 
; 0000 0153         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 0154     }
	RJMP _0x36
_0x38:
; 0000 0155 }
	RJMP _0x2080007
;
;// ******************************** About PWM control *******************************************************
;void check_pwm(void)
; 0000 0159 {
_check_pwm:
; 0000 015A     char temp = 50;//PWM interrupt control, 50% duty
; 0000 015B     delay_ms(50);
	ST   -Y,R17
;	temp -> R17
	LDI  R17,50
	CALL SUBOPT_0x1B
; 0000 015C 
; 0000 015D     INITIATE; //Timer interrupts on
	CALL SUBOPT_0x1C
; 0000 015E     while(Middle_switch_off)
_0x3E:
	SBIS 0x1,2
	RJMP _0x40
; 0000 015F     {
; 0000 0160         if(Left_switch_on)  temp--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 0161         if(Right_switch_on)  temp++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 0162         if(temp<1) temp=1;
	CPI  R17,1
	BRSH _0x43
	LDI  R17,LOW(1)
; 0000 0163         if(temp>99)  temp=99;
_0x43:
	CPI  R17,100
	BRLO _0x44
	LDI  R17,LOW(99)
; 0000 0164         // TEST by LED berfore Valve delivered...
; 0000 0165         OCR1AH = temp*50>>8;
_0x44:
	LDI  R30,LOW(50)
	MUL  R30,R17
	MOVW R30,R0
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 0166         OCR1AL = temp*50;   //duty ratio클수록 세기가 약해짐(Compare Match Interrupt에서 ON)
	LDI  R26,LOW(50)
	MULS R17,R26
	MOVW R30,R0
	OUT  0x2A,R30
; 0000 0167 
; 0000 0168         lcd_clear();
	CALL SUBOPT_0xB
; 0000 0169         lcd_gotoxy(0, 0);
; 0000 016A         lcd_putsf("Duty");
	CALL SUBOPT_0x1D
; 0000 016B         lcd_gotoxy(0, 1);
; 0000 016C         sprintf(lcd_data, "%d %", temp);
	MOV  R30,R17
	CALL SUBOPT_0xE
; 0000 016D         lcd_puts(lcd_data);
; 0000 016E 
; 0000 016F         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 0170     }
	RJMP _0x3E
_0x40:
; 0000 0171     TERMINATE; //Timer interrupts off
	CALL SUBOPT_0x1E
; 0000 0172     PORTC=0x00;
	OUT  0x15,R30
; 0000 0173     OCR1AH = 0;
	CALL SUBOPT_0x1F
; 0000 0174     OCR1AL = 0;//0% duty
; 0000 0175 }
	RJMP _0x2080007
;
;// ******************************** About PWM control *******************************************************
;void PUMP_test()
; 0000 0179 {
_PUMP_test:
; 0000 017A     int temp = 50;//50% duty
; 0000 017B     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	__GETWRN 16,17,50
	CALL SUBOPT_0x1B
; 0000 017C 
; 0000 017D     while(Middle_switch_off)
_0x45:
	SBIS 0x1,2
	RJMP _0x47
; 0000 017E     {
; 0000 017F         if(Left_switch_on)  temp--;
	SBIC 0x1,1
	RJMP _0x48
	__SUBWRN 16,17,1
; 0000 0180         if(Right_switch_on)  temp++;
_0x48:
	SBIC 0x1,3
	RJMP _0x49
	__ADDWRN 16,17,1
; 0000 0181         if(temp<1) temp=1;
_0x49:
	__CPWRN 16,17,1
	BRGE _0x4A
	__GETWRN 16,17,1
; 0000 0182         if(temp>99)  temp=99;
_0x4A:
	__CPWRN 16,17,100
	BRLT _0x4B
	__GETWRN 16,17,99
; 0000 0183         // TEST by LED berfore Valve delivered...
; 0000 0184         OCR1BH = temp*50 >>8;
_0x4B:
	MOVW R30,R16
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	CALL __MULW12
	CALL SUBOPT_0x20
; 0000 0185         OCR1BL = temp*50;
; 0000 0186 
; 0000 0187         lcd_clear();
	CALL SUBOPT_0xB
; 0000 0188         lcd_gotoxy(0, 0);
; 0000 0189         lcd_putsf("Duty");
	CALL SUBOPT_0x1D
; 0000 018A         lcd_gotoxy(0, 1);
; 0000 018B         sprintf(lcd_data, "%d %", temp);
	MOVW R30,R16
	CALL SUBOPT_0x21
; 0000 018C         lcd_puts(lcd_data);
; 0000 018D 
; 0000 018E         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 018F     }
	RJMP _0x45
_0x47:
; 0000 0190     OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 0191     OCR1BL=0x00; //0% duty
; 0000 0192     PORTB=0x00;
	OUT  0x18,R30
; 0000 0193 }
	RJMP _0x2080006
;
;// ******************************** About Order *******************************************************
;void order(unsigned char * sequence)
; 0000 0197 {
_order:
; 0000 0198     unsigned char seq=*sequence;
; 0000 0199     unsigned char Order=0x00;
; 0000 019A 
; 0000 019B     if(Up_thumb)    Order|=0x01;
	ST   -Y,R17
	ST   -Y,R16
;	*sequence -> Y+2
;	seq -> R17
;	Order -> R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	MOV  R17,R30
	LDI  R16,0
	SBIS 0x1,5
	ORI  R16,LOW(1)
; 0000 019C     if(Up_index)    Order|=0x02;
	SBIS 0x19,2
	ORI  R16,LOW(2)
; 0000 019D     if(Up_middle)   Order|=0x04;
	SBIS 0x19,4
	ORI  R16,LOW(4)
; 0000 019E     if(Up_rest)     Order|=0x08;
	SBIS 0x19,6
	ORI  R16,LOW(8)
; 0000 019F     if(Down_thumb)  Order|=0x10;
	SBIS 0x19,1
	ORI  R16,LOW(16)
; 0000 01A0     if(Down_index)  Order|=0x20;
	SBIS 0x19,3
	ORI  R16,LOW(32)
; 0000 01A1     if(Down_middle) Order|=0x40;
	SBIS 0x19,5
	ORI  R16,LOW(64)
; 0000 01A2     if(Down_rest)   Order|=0x80;
	SBIS 0x19,7
	ORI  R16,LOW(128)
; 0000 01A3     if(NO_SIGNAL_tu&&NO_SIGNAL_td) Order&=0xEE;
	SBIS 0x1,5
	RJMP _0x55
	SBIC 0x19,1
	RJMP _0x56
_0x55:
	RJMP _0x54
_0x56:
	ANDI R16,LOW(238)
; 0000 01A4     if(NO_SIGNAL_iu&&NO_SIGNAL_id) Order&=0xDD;
_0x54:
	SBIS 0x19,2
	RJMP _0x58
	SBIC 0x19,3
	RJMP _0x59
_0x58:
	RJMP _0x57
_0x59:
	ANDI R16,LOW(221)
; 0000 01A5     if(NO_SIGNAL_mu&&NO_SIGNAL_md) Order&=0xBB;
_0x57:
	SBIS 0x19,4
	RJMP _0x5B
	SBIC 0x19,5
	RJMP _0x5C
_0x5B:
	RJMP _0x5A
_0x5C:
	ANDI R16,LOW(187)
; 0000 01A6     if(NO_SIGNAL_ru&&NO_SIGNAL_rd) Order&=0x77;
_0x5A:
	SBIS 0x19,6
	RJMP _0x5E
	SBIC 0x19,7
	RJMP _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
	ANDI R16,LOW(119)
; 0000 01A7     /*
; 0000 01A8     lcd_clear();
; 0000 01A9     lcd_gotoxy(0, 0);
; 0000 01AA     sprintf(lcd_data, "%2x", Order);
; 0000 01AB     lcd_puts(lcd_data);
; 0000 01AC     */
; 0000 01AD 
; 0000 01AE     if(Order&(0x01<<seq))
_0x5D:
	CALL SUBOPT_0x23
	BREQ _0x60
; 0000 01AF     {
; 0000 01B0         E_flag[seq]=1;
	CALL SUBOPT_0x12
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 01B1         F_flag[seq]=0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x24
; 0000 01B2     }
; 0000 01B3     if(Order&(0x10<<seq))
_0x60:
	CALL SUBOPT_0x25
	BREQ _0x61
; 0000 01B4     {
; 0000 01B5         E_flag[seq]=0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x26
; 0000 01B6         F_flag[seq]=1;
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 01B7     }
; 0000 01B8     if(!(Order&(0x01<<seq))&&!(Order&(0x10<<seq)))
_0x61:
	CALL SUBOPT_0x23
	BRNE _0x63
	CALL SUBOPT_0x25
	BREQ _0x64
_0x63:
	RJMP _0x62
_0x64:
; 0000 01B9     {
; 0000 01BA         E_flag[seq]=0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x26
; 0000 01BB         F_flag[seq]=0;
	CALL SUBOPT_0x24
; 0000 01BC     }
; 0000 01BD 
; 0000 01BE     // sequence 0 : Thumb   PC0, PC4 on, PORTC = 0x11
; 0000 01BF     // sequence 1 : Index   PC1, PC5 on, PORTC = 0x22
; 0000 01C0     // sequence 2 : Middle  PC2, PC6 on, PORTC = 0x44
; 0000 01C1     // sequence 3 : Rest    PC3, PC7 on, PORTC = 0x88
; 0000 01C2     //PORTC = 0x11<<sequence;
; 0000 01C3     seq++;
_0x62:
	SUBI R17,-1
; 0000 01C4     if(seq>3) seq=0;
	CPI  R17,4
	BRLO _0x65
	LDI  R17,LOW(0)
; 0000 01C5     *sequence=seq;
_0x65:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R17
; 0000 01C6 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;void disp(unsigned char x, unsigned char seq)
; 0000 01C9 {
_disp:
; 0000 01CA     lcd_gotoxy(x, 1);
;	x -> Y+1
;	seq -> Y+0
	LDD  R30,Y+1
	CALL SUBOPT_0x27
; 0000 01CB     if(E_flag[seq])                     lcd_putsf("E");
	CALL SUBOPT_0x28
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x66
	CALL SUBOPT_0x29
; 0000 01CC     if(F_flag[seq])                     lcd_putsf("F");
_0x66:
	CALL SUBOPT_0x28
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x67
	CALL SUBOPT_0x2A
; 0000 01CD     if((E_flag[seq]==0)&&(F_flag[seq]==0))  lcd_putsf("-");
_0x67:
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2B
	BRNE _0x69
	CALL SUBOPT_0x2C
	BREQ _0x6A
_0x69:
	RJMP _0x68
_0x6A:
	CALL SUBOPT_0x2D
; 0000 01CE }
_0x68:
	ADIW R28,2
	RET
;
;void test_order()
; 0000 01D1 {
_test_order:
; 0000 01D2     unsigned char sequence=0;
; 0000 01D3 
; 0000 01D4     delay_ms(50);
	CALL SUBOPT_0xA
;	sequence -> R17
; 0000 01D5     while(Middle_switch_off)
_0x6B:
	SBIS 0x1,2
	RJMP _0x6D
; 0000 01D6     {
; 0000 01D7         order(&sequence);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 01D8 
; 0000 01D9         lcd_clear();
	CALL SUBOPT_0xB
; 0000 01DA 
; 0000 01DB         lcd_gotoxy(0, 0);lcd_putsf("T");
	__POINTW1FN _0x0,35
	CALL SUBOPT_0x2E
; 0000 01DC         lcd_gotoxy(2, 0);lcd_putsf("I");
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,37
	CALL SUBOPT_0x2E
; 0000 01DD         lcd_gotoxy(4, 0);lcd_putsf("M");
	CALL SUBOPT_0x30
	__POINTW1FN _0x0,39
	CALL SUBOPT_0x2E
; 0000 01DE         lcd_gotoxy(6, 0);lcd_putsf("R");
	CALL SUBOPT_0x31
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x2E
; 0000 01DF 
; 0000 01E0         disp(0,0);
	CALL SUBOPT_0x32
	RCALL _disp
; 0000 01E1         disp(2,1);
	CALL SUBOPT_0x33
	RCALL _disp
; 0000 01E2         disp(4,2);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _disp
; 0000 01E3         disp(6,3);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _disp
; 0000 01E4 
; 0000 01E5 
; 0000 01E6         /*
; 0000 01E7         lcd_gotoxy(0, 1);
; 0000 01E8         sprintf(lcd_data, "%d", sequence);
; 0000 01E9         lcd_puts(lcd_data);
; 0000 01EA         */
; 0000 01EB         delay_ms(100);//Sequence term
	CALL SUBOPT_0x15
; 0000 01EC     }
	RJMP _0x6B
_0x6D:
; 0000 01ED }
	RJMP _0x2080007
;
;void valve_order()
; 0000 01F0 {
_valve_order:
; 0000 01F1     unsigned char seq=0;
; 0000 01F2 
; 0000 01F3     delay_ms(50);
	CALL SUBOPT_0xA
;	seq -> R17
; 0000 01F4     INITIATE;
	CALL SUBOPT_0x1C
; 0000 01F5     while(Middle_switch_off)
_0x6E:
	SBIS 0x1,2
	RJMP _0x70
; 0000 01F6     {
; 0000 01F7         order(&seq);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 01F8         //Global_Sequence=seq;
; 0000 01F9 
; 0000 01FA         lcd_clear();
	CALL SUBOPT_0xB
; 0000 01FB         lcd_gotoxy(0, 0);lcd_putsf("Valve!");
	__POINTW1FN _0x0,43
	CALL SUBOPT_0x2E
; 0000 01FC 
; 0000 01FD         if(Left_switch_on)  Global_Sequence--;
	SBIC 0x1,1
	RJMP _0x71
	LDS  R30,_Global_Sequence
	SUBI R30,LOW(1)
	STS  _Global_Sequence,R30
; 0000 01FE         if(Right_switch_on)  Global_Sequence++;
_0x71:
	SBIC 0x1,3
	RJMP _0x72
	LDS  R30,_Global_Sequence
	SUBI R30,-LOW(1)
	STS  _Global_Sequence,R30
; 0000 01FF         if(Global_Sequence>3)   Global_Sequence=0;
_0x72:
	LDS  R26,_Global_Sequence
	CPI  R26,LOW(0x4)
	BRLO _0x73
	LDI  R30,LOW(0)
	STS  _Global_Sequence,R30
; 0000 0200         if(Global_Sequence==0 && Right_switch_on)   Global_Sequence=3;
_0x73:
	LDS  R26,_Global_Sequence
	CPI  R26,LOW(0x0)
	BRNE _0x75
	SBIS 0x1,3
	RJMP _0x76
_0x75:
	RJMP _0x74
_0x76:
	LDI  R30,LOW(3)
	STS  _Global_Sequence,R30
; 0000 0201 
; 0000 0202         lcd_gotoxy(7, 0);
_0x74:
	LDI  R30,LOW(7)
	CALL SUBOPT_0x34
; 0000 0203         sprintf(lcd_data, "%d", Global_Sequence);
	LDS  R30,_Global_Sequence
	CALL SUBOPT_0xE
; 0000 0204         lcd_puts(lcd_data);
; 0000 0205 
; 0000 0206         disp(0,Global_Sequence);
	CALL SUBOPT_0x35
; 0000 0207 
; 0000 0208         lcd_gotoxy(5, 1);
; 0000 0209         sprintf(lcd_data, "%d", E_flag[Global_Sequence]);
	CALL SUBOPT_0x36
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 020A         lcd_puts(lcd_data);
; 0000 020B         lcd_gotoxy(7, 1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x27
; 0000 020C         sprintf(lcd_data, "%d", F_flag[Global_Sequence]);
	CALL SUBOPT_0x36
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 020D         lcd_puts(lcd_data);
; 0000 020E 
; 0000 020F 
; 0000 0210         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==0))
	CALL SUBOPT_0x37
	CALL SUBOPT_0x2B
	BRNE _0x78
	CALL SUBOPT_0x2C
	BREQ _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 0211         {
; 0000 0212             OCR1AH=500>>8;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 0213             OCR1AL=500;
	LDI  R30,LOW(244)
	OUT  0x2A,R30
; 0000 0214             OCR3AH=500>>8;
	LDI  R30,LOW(1)
	STS  135,R30
; 0000 0215             OCR3AL=500;
	LDI  R30,LOW(244)
	STS  134,R30
; 0000 0216         }
; 0000 0217         if((E_flag[Global_Sequence]==1)&&(F_flag[Global_Sequence]==0))
_0x77:
	CALL SUBOPT_0x37
	MOVW R0,R30
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x7B
	CALL SUBOPT_0x2C
	BREQ _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
; 0000 0218         {
; 0000 0219             OCR1AH=800>>8;
	CALL SUBOPT_0x38
; 0000 021A             OCR1AL=800;
; 0000 021B             OCR3AH=200>>8;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 021C             OCR3AL=200;
	LDI  R30,LOW(200)
	STS  134,R30
; 0000 021D         }
; 0000 021E         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==1))
_0x7A:
	CALL SUBOPT_0x37
	CALL SUBOPT_0x2B
	BRNE _0x7E
	MOVW R30,R0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ _0x7F
_0x7E:
	RJMP _0x7D
_0x7F:
; 0000 021F         {
; 0000 0220             OCR1AH=200>>8;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0221             OCR1AL=200;
	LDI  R30,LOW(200)
	OUT  0x2A,R30
; 0000 0222             OCR3AH=800>>8;
	LDI  R30,LOW(3)
	STS  135,R30
; 0000 0223             OCR3AL=800;
	LDI  R30,LOW(32)
	STS  134,R30
; 0000 0224         }
; 0000 0225         delay_ms(100);
_0x7D:
	CALL SUBOPT_0x15
; 0000 0226     }
	RJMP _0x6E
_0x70:
; 0000 0227     TERMINATE;
	CALL SUBOPT_0x1E
; 0000 0228     Global_Sequence=0;
	STS  _Global_Sequence,R30
; 0000 0229     OCR1A =0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 022A     OCR3BH=0x00;
	CALL SUBOPT_0x39
; 0000 022B     OCR3BL=0x00;
; 0000 022C     for(i=0;i<4;i++)
	CALL SUBOPT_0x3A
_0x81:
	CALL SUBOPT_0x3B
	BRGE _0x82
; 0000 022D     {
; 0000 022E         E_flag[i]=0;
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0000 022F         F_flag[i]=0;
; 0000 0230     }
	CALL SUBOPT_0x3E
	RJMP _0x81
_0x82:
; 0000 0231     PORTB=0x00;
	CALL SUBOPT_0x3F
; 0000 0232     PORTC=0x00;
; 0000 0233 }
_0x2080007:
	LD   R17,Y+
	RET
;
;void pump_valve()
; 0000 0236 {
_pump_valve:
; 0000 0237     unsigned char seq=0;
; 0000 0238     unsigned char temp=50;
; 0000 0239 
; 0000 023A     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	seq -> R17
;	temp -> R16
	LDI  R17,0
	LDI  R16,50
	CALL SUBOPT_0x1B
; 0000 023B     INITIATE;
	CALL SUBOPT_0x1C
; 0000 023C     while(Middle_switch_off)
_0x83:
	SBIS 0x1,2
	RJMP _0x85
; 0000 023D     {
; 0000 023E         order(&seq);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 023F         Global_Sequence=seq;
	STS  _Global_Sequence,R17
; 0000 0240 
; 0000 0241         lcd_clear();
	CALL SUBOPT_0xB
; 0000 0242         lcd_gotoxy(0, 0);lcd_putsf("Duty : ");
	__POINTW1FN _0x0,50
	CALL SUBOPT_0x2E
; 0000 0243         lcd_gotoxy(6, 0);sprintf(lcd_data, "%2d %", temp);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
; 0000 0244         lcd_puts(lcd_data);
; 0000 0245 
; 0000 0246         disp(0,Global_Sequence);
	CALL SUBOPT_0x35
; 0000 0247 
; 0000 0248         lcd_gotoxy(5, 1);
; 0000 0249         sprintf(lcd_data, "%d", E_flag[Global_Sequence]);
	CALL SUBOPT_0x36
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 024A         lcd_puts(lcd_data);
; 0000 024B         lcd_gotoxy(7, 1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x27
; 0000 024C         sprintf(lcd_data, "%d", F_flag[Global_Sequence]);
	CALL SUBOPT_0x36
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R30,Z
	CALL SUBOPT_0xE
; 0000 024D         lcd_puts(lcd_data);
; 0000 024E 
; 0000 024F 
; 0000 0250         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==0))
	CALL SUBOPT_0x37
	CALL SUBOPT_0x2B
	BRNE _0x87
	CALL SUBOPT_0x2C
	BREQ _0x88
_0x87:
	RJMP _0x86
_0x88:
; 0000 0251         {
; 0000 0252             OCR1AH=50*50>>8;
	LDI  R30,LOW(9)
	OUT  0x2B,R30
; 0000 0253             OCR1AL=50*50;
	LDI  R30,LOW(196)
	OUT  0x2A,R30
; 0000 0254             OCR3AH=50*50>>8;
	LDI  R30,LOW(9)
	STS  135,R30
; 0000 0255             OCR3AL=50*50;
	LDI  R30,LOW(196)
	STS  134,R30
; 0000 0256         }
; 0000 0257         if((E_flag[Global_Sequence]==1)&&(F_flag[Global_Sequence]==0))
_0x86:
	CALL SUBOPT_0x37
	MOVW R0,R30
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x8A
	CALL SUBOPT_0x2C
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 0258         {
; 0000 0259             OCR1AH=70*50>>8;
	LDI  R30,LOW(13)
	OUT  0x2B,R30
; 0000 025A             OCR1AL=70*50;
	LDI  R30,LOW(172)
	OUT  0x2A,R30
; 0000 025B             OCR3AH=30*50>>8;
	LDI  R30,LOW(5)
	STS  135,R30
; 0000 025C             OCR3AL=30*50;
	LDI  R30,LOW(220)
	STS  134,R30
; 0000 025D         }
; 0000 025E         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==1))
_0x89:
	CALL SUBOPT_0x37
	CALL SUBOPT_0x2B
	BRNE _0x8D
	MOVW R30,R0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
; 0000 025F         {
; 0000 0260             OCR1AH=30*50>>8;
	LDI  R30,LOW(5)
	OUT  0x2B,R30
; 0000 0261             OCR1AL=30*50;
	LDI  R30,LOW(220)
	OUT  0x2A,R30
; 0000 0262             OCR3AH=70*50>>8;
	LDI  R30,LOW(13)
	STS  135,R30
; 0000 0263             OCR3AL=70*50;
	LDI  R30,LOW(172)
	STS  134,R30
; 0000 0264         }
; 0000 0265 
; 0000 0266         if(Left_switch_on)  temp--;
_0x8C:
	SBIS 0x1,1
	SUBI R16,1
; 0000 0267         if(Right_switch_on)  temp++;
	SBIS 0x1,3
	SUBI R16,-1
; 0000 0268         if(temp<1) temp=1;
	CPI  R16,1
	BRSH _0x91
	LDI  R16,LOW(1)
; 0000 0269         if(temp>99)  temp=99;
_0x91:
	CPI  R16,100
	BRLO _0x92
	LDI  R16,LOW(99)
; 0000 026A         // TEST by LED berfore Valve delivered...
; 0000 026B         OCR1BH = temp*50 >>8;
_0x92:
	LDI  R30,LOW(50)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x20
; 0000 026C         OCR1BL = temp*50;
; 0000 026D 
; 0000 026E         delay_ms(Ts);
	CALL SUBOPT_0x42
; 0000 026F     }
	RJMP _0x83
_0x85:
; 0000 0270     TERMINATE;
	CALL SUBOPT_0x1E
; 0000 0271     Global_Sequence=0;
	CALL SUBOPT_0x43
; 0000 0272     OCR1AH=0x00;
; 0000 0273     OCR1AL=0x00;
; 0000 0274     OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 0275     OCR1BL=0x00;
; 0000 0276     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0277     OCR1BL=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 0278     for(i=0;i<4;i++)
	CALL SUBOPT_0x3A
_0x94:
	CALL SUBOPT_0x3B
	BRGE _0x95
; 0000 0279     {
; 0000 027A         E_flag[i]=0;
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0000 027B         F_flag[i]=0;
; 0000 027C     }
	CALL SUBOPT_0x3E
	RJMP _0x94
_0x95:
; 0000 027D     PORTB=0x00;
	CALL SUBOPT_0x3F
; 0000 027E     PORTC=0x00;
; 0000 027F }
	RJMP _0x2080006
;
;//**************************************%%%&&&&&&&&&&&&&&&&&&&&&&&%%%********************************************
;//**************************************%%% About Actual Movement %%%********************************************
;//**************************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%********************************************
;//Measuring Grab threshold
;void measure_threshold()
; 0000 0286 {
_measure_threshold:
; 0000 0287     int seq = 0;//50% duty
; 0000 0288     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	seq -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x1B
; 0000 0289 
; 0000 028A     while(Middle_switch_off)
_0x96:
	SBIS 0x1,2
	RJMP _0x98
; 0000 028B     {
; 0000 028C         float ANG[4]={0};
; 0000 028D 
; 0000 028E         if(Left_switch_on)  seq--;
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x99*2)
	LDI  R31,HIGH(_0x99*2)
	CALL __INITLOCB
;	ANG -> Y+0
	SBIC 0x1,1
	RJMP _0x9A
	__SUBWRN 16,17,1
; 0000 028F         if(Right_switch_on)  seq++;
_0x9A:
	SBIC 0x1,3
	RJMP _0x9B
	__ADDWRN 16,17,1
; 0000 0290         if(seq>3)  seq=0;
_0x9B:
	__CPWRN 16,17,4
	BRLT _0x9C
	__GETWRN 16,17,0
; 0000 0291         if(seq==0 && Right_switch_on)  seq=3;
_0x9C:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x9E
	SBIS 0x1,3
	RJMP _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
	__GETWRN 16,17,3
; 0000 0292 
; 0000 0293         mean_flex(seq,1);
_0x9D:
	ST   -Y,R16
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mean_flex
; 0000 0294         mean_pressure(seq,1);
	ST   -Y,R16
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 0295 
; 0000 0296         ANG[seq] = (float)(flex_max[seq]-flex_mean[seq])/((float)(flex_max[seq]-flex_min[seq]))*MAX_ANG;
	MOVW R30,R16
	MOVW R26,R28
	CALL SUBOPT_0x44
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x45
	LDI  R26,LOW(_flex_mean)
	LDI  R27,HIGH(_flex_mean)
	CALL SUBOPT_0x46
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x45
	LDI  R26,LOW(_flex_min)
	LDI  R27,HIGH(_flex_min)
	CALL SUBOPT_0x46
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x47
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0297 
; 0000 0298         lcd_clear();
	CALL SUBOPT_0xB
; 0000 0299         lcd_gotoxy(0, 0);
; 0000 029A         lcd_putsf("FLEX");
	__POINTW1FN _0x0,64
	CALL SUBOPT_0x2E
; 0000 029B         lcd_gotoxy(5, 0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x34
; 0000 029C         sprintf(lcd_data, "%d", (int)ANG[seq]);
	MOVW R30,R16
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
; 0000 029D         lcd_puts(lcd_data);
; 0000 029E 
; 0000 029F         lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
; 0000 02A0         lcd_putsf("PRES");
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x2E
; 0000 02A1         lcd_gotoxy(5, 1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x27
; 0000 02A2         sprintf(lcd_data, "%d %", pressure_mean[seq]);
	CALL SUBOPT_0x40
	CALL SUBOPT_0x4A
	LDI  R26,LOW(_pressure_mean)
	LDI  R27,HIGH(_pressure_mean)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CALL SUBOPT_0xE
; 0000 02A3         lcd_puts(lcd_data);
; 0000 02A4 
; 0000 02A5         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 02A6     }
	ADIW R28,16
	RJMP _0x96
_0x98:
; 0000 02A7 }
_0x2080006:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;// Moving fingers
;void Move_finger(unsigned char seq, unsigned char P, float Bend)
; 0000 02AB {
_Move_finger:
; 0000 02AC     unsigned char threshold;  //Actively changing by Bend
; 0000 02AD     unsigned char Grab=0;     //if 1, no more Grab (NO FLEXTION)
; 0000 02AE     int ang_desired=0;
; 0000 02AF     int E_OR_F;
; 0000 02B0     float u=0;
; 0000 02B1     float error=0;
; 0000 02B2 
; 0000 02B3     /*** INSERT TERM OF 'threshold' IN TERMS OF 'Bend'!!! ***/
; 0000 02B4     threshold = 100;
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	CALL __SAVELOCR6
;	seq -> Y+19
;	P -> Y+18
;	Bend -> Y+14
;	threshold -> R17
;	Grab -> R16
;	ang_desired -> R18,R19
;	E_OR_F -> R20,R21
;	u -> Y+10
;	error -> Y+6
	LDI  R16,0
	__GETWRN 18,19,0
	LDI  R17,LOW(100)
; 0000 02B5     // Grab or not?
; 0000 02B6     /*
; 0000 02B7     if(P>=threshold)  Grab=1;//Over the threshold : no more grab
; 0000 02B8     else Grab=0;//Under the threshold : Keep moving
; 0000 02B9     */
; 0000 02BA 
; 0000 02BB     //Update angle (PID)
; 0000 02BC     E_OR_F = (Grab&&F_flag[seq])?0:(((E_flag[seq]?-1:1)+(F_flag[seq]?1:-1))/2);//Extension:-1, Flextion:1, Do noting:0
	CALL SUBOPT_0x4B
	SBIW R30,0
	BREQ _0xA0
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
	BRNE _0xA1
_0xA0:
	RJMP _0xA2
_0xA1:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xA3
_0xA2:
	CALL SUBOPT_0x4C
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	CALL SUBOPT_0x4E
	SBIW R30,0
	BREQ _0xA5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0xA6
_0xA5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0xA6:
	MOVW R26,R30
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
	BREQ _0xA8
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xA9
_0xA8:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0xA9:
	CALL SUBOPT_0x4F
_0xA3:
	MOVW R20,R30
; 0000 02BD     ang_desired = Bend+(E_OR_F*delta_ang);//Ext:Bend-delta_ang, Flex:Bend+delta_ang, Stay:Bend
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x50
	CALL __ADDF12
	CALL __CFD1
	MOVW R18,R30
; 0000 02BE     //if(ang_desired<0)   ang_desired = 0;
; 0000 02BF     error = ang_desired-ang_old[seq];     //error : 0~60
	CALL SUBOPT_0x4C
	SUBI R30,LOW(-_ang_old)
	SBCI R31,HIGH(-_ang_old)
	CALL SUBOPT_0x51
	MOVW R30,R18
	CALL SUBOPT_0x52
	__PUTD1S 6
; 0000 02C0     error_sum[seq] += error;
	CALL SUBOPT_0x53
	CALL SUBOPT_0x44
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL SUBOPT_0x54
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 02C1     u = kp*error + ki*error_sum[seq]*((float)(Ts/1000.)) + kd*(error-error_old[seq])/((float)(Ts/1000.));//Control value for OCR1A,OCR3A
	CALL SUBOPT_0x55
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x53
	CALL SUBOPT_0x56
	CALL __GETD1P
	CALL SUBOPT_0x57
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x58
	CALL SUBOPT_0x56
	CALL SUBOPT_0x54
	CALL SUBOPT_0x59
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x5A
; 0000 02C2     error_old[seq]=error;
	CALL SUBOPT_0x58
	CALL SUBOPT_0x44
	CALL SUBOPT_0x5B
	CALL __PUTDZ20
; 0000 02C3 
; 0000 02C4     //Saturation condition...
; 0000 02C5     if(u>UPPER)       u=UPPER;
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xAB
	CALL SUBOPT_0x5D
	RJMP _0x138
; 0000 02C6     else if(u<LOWER)  u=LOWER;
_0xAB:
	CALL SUBOPT_0x5E
	BRSH _0xAD
	CALL SUBOPT_0x5F
_0x138:
	__PUTD1S 10
; 0000 02C7 
; 0000 02C8 
; 0000 02C9     //Extension
; 0000 02CA     if(Bend>(ang_desired+ANG_th))
_0xAD:
	MOVW R30,R18
	ADIW R30,1
	CALL SUBOPT_0x50
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xAE
; 0000 02CB     {
; 0000 02CC         arrived[seq] = -1;
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
; 0000 02CD         OCR3AH=(int)u>>8;
	CALL SUBOPT_0x62
	CALL SUBOPT_0x63
	STS  135,R30
; 0000 02CE         OCR3AL=u;
	CALL SUBOPT_0x62
	LDI  R26,LOW(134)
	LDI  R27,HIGH(134)
	CALL __CFD1U
	ST   X,R30
; 0000 02CF     }
; 0000 02D0     //Flextion
; 0000 02D1     else if(Bend<(ang_desired-ANG_th))
	RJMP _0xAF
_0xAE:
	MOVW R30,R18
	SBIW R30,1
	CALL SUBOPT_0x50
	CALL __CMPF12
	BRSH _0xB0
; 0000 02D2     {
; 0000 02D3         arrived[seq] = 1;
	CALL SUBOPT_0x60
	CALL SUBOPT_0x64
; 0000 02D4         OCR1AH=(int)u>>8;
	CALL SUBOPT_0x65
	OUT  0x2B,R30
; 0000 02D5         OCR1AL=u;
	CALL SUBOPT_0x62
	CALL __CFD1U
	OUT  0x2A,R30
; 0000 02D6     }
; 0000 02D7     //Hold
; 0000 02D8     else if((Bend>=(ang_desired-ANG_th)) && (Bend<=(ang_desired+ANG_th)))
	RJMP _0xB1
_0xB0:
	MOVW R30,R18
	SBIW R30,1
	CALL SUBOPT_0x50
	CALL __CMPF12
	BRLO _0xB3
	MOVW R30,R18
	ADIW R30,1
	CALL SUBOPT_0x50
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xB3
	RJMP _0xB4
_0xB3:
	RJMP _0xB2
_0xB4:
; 0000 02D9     {
; 0000 02DA         //OCR3AH=(int)u>>8;
; 0000 02DB         //OCR3AL=u;
; 0000 02DC         arrived[seq] = 0;
	CALL SUBOPT_0x60
	CALL SUBOPT_0x66
; 0000 02DD     }
; 0000 02DE }
_0xB2:
_0xB1:
_0xAF:
	CALL __LOADLOCR6
	RJMP _0x2080005
;
;// About Daily mode
;void RUN_daily()
; 0000 02E2 {
_RUN_daily:
; 0000 02E3   unsigned char seq=0;
; 0000 02E4   int finger=1;
; 0000 02E5   float ANG[4]={0};
; 0000 02E6 
; 0000 02E7   lcd_clear();
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xB5*2)
	LDI  R31,HIGH(_0xB5*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	seq -> R17
;	finger -> R18,R19
;	ANG -> Y+4
	LDI  R17,0
	__GETWRN 18,19,1
	CALL SUBOPT_0xB
; 0000 02E8   lcd_gotoxy(0, 0);lcd_putsf("Daily");
	__POINTW1FN _0x0,74
	CALL SUBOPT_0x2E
; 0000 02E9   delay_ms(100);
	CALL SUBOPT_0x15
; 0000 02EA 
; 0000 02EB   OCR1BH=(99*50)>>8;
	CALL SUBOPT_0x67
; 0000 02EC   OCR1BL=99*50;
; 0000 02ED 
; 0000 02EE   INITIATE; //Initialization, Turn interrupts on
	CALL SUBOPT_0x1C
; 0000 02EF   while(Middle_switch_off)
_0xB6:
	SBIS 0x1,2
	RJMP _0xB8
; 0000 02F0   {
; 0000 02F1     order(&seq); //Control signal of each sequence
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 02F2     Global_Sequence = seq;
	STS  _Global_Sequence,R17
; 0000 02F3 
; 0000 02F4     for(i=0;i<4;i++)    disp(i*2,i);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3A
_0xBA:
	CALL SUBOPT_0x3B
	BRGE _0xBB
	CALL SUBOPT_0x68
	CALL SUBOPT_0x3E
	RJMP _0xBA
_0xBB:
; 0000 02F6 mean_pressure(seq,1);
	ST   -Y,R17
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 02F7     mean_flex(seq,1);
	CALL SUBOPT_0x69
; 0000 02F8     ANG[seq] = (float)(flex_max[seq]-flex_mean[seq])/((float)(flex_max[seq]-flex_min[seq]))*MAX_ANG;
	MOVW R24,R30
	MOVW R22,R30
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,4
	CALL SUBOPT_0x44
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x12
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x47
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 02F9 
; 0000 02FA     Move_finger(seq,pressure_mean[seq], ANG[seq]);
	ST   -Y,R17
	CALL SUBOPT_0x12
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	ST   -Y,R30
	CALL SUBOPT_0x12
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x56
	CALL __GETD1P
	CALL __PUTPARD1
	RCALL _Move_finger
; 0000 02FB 
; 0000 02FC     if(Left_switch_on)  finger--;
	SBIC 0x1,1
	RJMP _0xBC
	__SUBWRN 18,19,1
; 0000 02FD     if(Right_switch_on)  finger++;
_0xBC:
	SBIC 0x1,3
	RJMP _0xBD
	__ADDWRN 18,19,1
; 0000 02FE     if(finger<0) finger=0;
_0xBD:
	TST  R19
	BRPL _0xBE
	__GETWRN 18,19,0
; 0000 02FF     if(finger>3)  finger=3;
_0xBE:
	__CPWRN 18,19,4
	BRLT _0xBF
	__GETWRN 18,19,3
; 0000 0300     lcd_gotoxy(6, 0);sprintf(lcd_data, "%d %", arrived[finger]);lcd_puts(lcd_data);
_0xBF:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	CALL SUBOPT_0x4A
	MOVW R30,R18
	CALL SUBOPT_0x6F
	CALL __GETW1P
	CALL SUBOPT_0x21
; 0000 0301 
; 0000 0302     ang_old[seq]=ANG[seq];
	CALL SUBOPT_0x12
	MOVW R26,R30
	SUBI R30,LOW(-_ang_old)
	SBCI R31,HIGH(-_ang_old)
	MOVW R0,R30
	MOVW R30,R26
	CALL SUBOPT_0x48
	MOVW R26,R0
	CALL __CFD1U
	ST   X,R30
; 0000 0303     delay_ms(200);//sequence gab
	CALL SUBOPT_0x10
; 0000 0304   }
	RJMP _0xB6
_0xB8:
; 0000 0305   TERMINATE; // Turn interrupts off
	CALL SUBOPT_0x1E
; 0000 0306   PORTC=0x00;
	OUT  0x15,R30
; 0000 0307   for(i=0;i<4;i++)
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3A
_0xC1:
	CALL SUBOPT_0x3B
	BRGE _0xC2
; 0000 0308   {
; 0000 0309     E_flag[i]=0;
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0000 030A     F_flag[i]=0;
; 0000 030B     arrived[i]=0;
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x66
; 0000 030C   }
	CALL SUBOPT_0x3E
	RJMP _0xC1
_0xC2:
; 0000 030D   Global_Sequence=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x43
; 0000 030E   OCR1AH=0x00;
; 0000 030F   OCR1AL=0x00;
; 0000 0310   OCR3AH=0x00;
	CALL SUBOPT_0x70
; 0000 0311   OCR3AL=0x00;
; 0000 0312   OCR1BH=0x00;
; 0000 0313   OCR1BL=0x00;
; 0000 0314 }
	CALL __LOADLOCR4
_0x2080005:
	ADIW R28,20
	RET
;
;void rehab_move(unsigned char finger, unsigned char mod, unsigned char ANG_d)
; 0000 0317 {
_rehab_move:
; 0000 0318     // mod : 접는지 펴는지 지시, Bend : 현재 손가락 각도
; 0000 0319     //(mod = 1:접음, 0:폄)    (Bend=In degrees, 0~90)
; 0000 031A     float Bend=-1;
; 0000 031B 
; 0000 031C     Global_Sequence=finger;
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(191)
	STD  Y+3,R30
;	finger -> Y+6
;	mod -> Y+5
;	ANG_d -> Y+4
;	Bend -> Y+0
	LDD  R30,Y+6
	STS  _Global_Sequence,R30
; 0000 031D 
; 0000 031E     while(1)
_0xC3:
; 0000 031F     {
; 0000 0320         mean_flex(finger,1);
	LDD  R30,Y+6
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mean_flex
; 0000 0321         Bend = (float)(flex_max[finger]-flex_mean[finger])/((float)(flex_max[finger]-flex_min[finger]))*MAX_ANG;
	LDD  R30,Y+6
	LDI  R31,0
	MOVW R24,R30
	MOVW R0,R30
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	CALL SUBOPT_0x51
	MOVW R30,R0
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x6C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	LDD  R30,Y+6
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x71
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x47
	CALL __PUTD1S0
; 0000 0322 
; 0000 0323         if((mod==1)&&(Bend<ANG_d))
	LDD  R26,Y+5
	CPI  R26,LOW(0x1)
	BRNE _0xC7
	CALL SUBOPT_0x72
	BRLO _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
; 0000 0324         {
; 0000 0325             //Define action
; 0000 0326             arrived[finger] = 1;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x64
; 0000 0327 
; 0000 0328         }
; 0000 0329         else if((mod!=1)&&(Bend>ANG_d))
	RJMP _0xC9
_0xC6:
	LDD  R26,Y+5
	CPI  R26,LOW(0x1)
	BREQ _0xCB
	CALL SUBOPT_0x72
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCB
	RJMP _0xCC
_0xCB:
	RJMP _0xCA
_0xCC:
; 0000 032A         {
; 0000 032B             //Define action
; 0000 032C             arrived[finger] = -1;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x61
; 0000 032D 
; 0000 032E         }
; 0000 032F         else    break;
	RJMP _0xCD
_0xCA:
	RJMP _0xC5
; 0000 0330 
; 0000 0331         if(Middle_switch_on)   return;
_0xCD:
_0xC9:
	SBIS 0x1,2
	RJMP _0x2080004
; 0000 0332     }
	RJMP _0xC3
_0xC5:
; 0000 0333     arrived[finger] = 0;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x66
; 0000 0334     delay_ms(1000);
	CALL SUBOPT_0x74
; 0000 0335 }
_0x2080004:
	ADIW R28,7
	RET
;
;// About Rhabilitation
;void RUN_rehab()
; 0000 0339 {
_RUN_rehab:
; 0000 033A     lcd_clear();
	CALL SUBOPT_0xB
; 0000 033B     lcd_gotoxy(0, 0);lcd_putsf("Rehabilitation");
	__POINTW1FN _0x0,80
	CALL SUBOPT_0x2E
; 0000 033C 
; 0000 033D     delay_ms(100);
	CALL SUBOPT_0x15
; 0000 033E 
; 0000 033F     OCR1BH=(99*50)>>8;
	CALL SUBOPT_0x67
; 0000 0340     OCR1BL=99*50;
; 0000 0341 
; 0000 0342     OCR1AH = 800>>8;
	CALL SUBOPT_0x38
; 0000 0343     OCR1AL = 800;     //Many Inlet
; 0000 0344     OCR3AH = REHAB_SPEED>>8;
	CALL SUBOPT_0x75
; 0000 0345     OCR3AL = REHAB_SPEED;     //Many Outlet
; 0000 0346 
; 0000 0347     INITIATE; //Initialization, Turn interrupts on
	CALL SUBOPT_0x1C
; 0000 0348     //mode1 (하나씩 접었다 폄)
; 0000 0349     rehab_move(THUMB,FLEX,40);
	CALL SUBOPT_0x76
; 0000 034A     rehab_move(THUMB,EXTD,10);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x77
; 0000 034B     rehab_move(INDEX,FLEX,60);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 034C     rehab_move(INDEX,EXTD,10);
	CALL SUBOPT_0x7A
; 0000 034D     rehab_move(MIDDLE,FLEX,40);
	CALL SUBOPT_0x33
	CALL SUBOPT_0x7B
; 0000 034E     rehab_move(MIDDLE,EXTD,10);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x77
; 0000 034F     rehab_move(REST,FLEX,60);
	CALL SUBOPT_0x7C
; 0000 0350     rehab_move(REST,EXTD,10);
	CALL SUBOPT_0x7D
; 0000 0351     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0352 
; 0000 0353     delay_ms(1000);
	CALL SUBOPT_0x74
; 0000 0354 
; 0000 0355     //mode2 (하나씩 접고 하나씩 폄)
; 0000 0356     rehab_move(THUMB,FLEX,40);
	CALL SUBOPT_0x76
; 0000 0357     rehab_move(INDEX,FLEX,50);
	CALL SUBOPT_0x78
	LDI  R30,LOW(50)
	ST   -Y,R30
	RCALL _rehab_move
; 0000 0358     rehab_move(MIDDLE,FLEX,40);
	CALL SUBOPT_0x33
	CALL SUBOPT_0x7B
; 0000 0359     rehab_move(REST,FLEX,60);
	CALL SUBOPT_0x7C
; 0000 035A     rehab_move(REST,EXTD,10);
	CALL SUBOPT_0x7D
; 0000 035B     rehab_move(MIDDLE,EXTD,10);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x77
; 0000 035C     rehab_move(INDEX,EXTD,10);
	CALL SUBOPT_0x7A
; 0000 035D     rehab_move(THUMB,EXTD,10);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x77
; 0000 035E     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 035F 
; 0000 0360     delay_ms(1000);
	CALL SUBOPT_0x74
; 0000 0361 
; 0000 0362     //mode3 (하나씩 엄지랑 맞붙였다 뗌)
; 0000 0363     rehab_move(THUMB,FLEX,25);
	CALL SUBOPT_0x7E
	LDI  R30,LOW(25)
	ST   -Y,R30
	RCALL _rehab_move
; 0000 0364     rehab_move(INDEX,FLEX,45);
	CALL SUBOPT_0x78
	LDI  R30,LOW(45)
	ST   -Y,R30
	RCALL _rehab_move
; 0000 0365     rehab_move(INDEX,EXTD,10);
	CALL SUBOPT_0x7A
; 0000 0366     rehab_move(THUMB,EXTD,10);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x77
; 0000 0367     rehab_move(THUMB,FLEX,30);
	CALL SUBOPT_0x7E
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _rehab_move
; 0000 0368     rehab_move(MIDDLE,FLEX,35);
	CALL SUBOPT_0x33
	LDI  R30,LOW(35)
	ST   -Y,R30
	RCALL _rehab_move
; 0000 0369     rehab_move(MIDDLE,EXTD,10);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x77
; 0000 036A     rehab_move(THUMB,EXTD,10);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x77
; 0000 036B     rehab_move(THUMB,FLEX,55);
	CALL SUBOPT_0x7E
	LDI  R30,LOW(55)
	ST   -Y,R30
	RCALL _rehab_move
; 0000 036C     rehab_move(REST,FLEX,40);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x7B
; 0000 036D     rehab_move(REST,EXTD,10);
	CALL SUBOPT_0x7D
; 0000 036E     rehab_move(THUMB,EXTD,10);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x77
; 0000 036F     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0370     TERMINATE; // Turn interrupts off
	CALL SUBOPT_0x1E
; 0000 0371     Global_Sequence=0;
	STS  _Global_Sequence,R30
; 0000 0372     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0373     PORTB=0x00;
	OUT  0x18,R30
; 0000 0374     OCR1AH=0x00;
	CALL SUBOPT_0x1F
; 0000 0375     OCR1AL=0x00;
; 0000 0376     OCR3AH=0x00;
	CALL SUBOPT_0x70
; 0000 0377     OCR3AL=0x00;
; 0000 0378     OCR1BH=0x00;
; 0000 0379     OCR1BL=0x00;
; 0000 037A }
	RET
;
;//
;void test()
; 0000 037E {
_test:
; 0000 037F     unsigned char seq=0;
; 0000 0380     int temp = 3000;
; 0000 0381 
; 0000 0382     delay_ms(50);
	CALL __SAVELOCR4
;	seq -> R17
;	temp -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,3000
	CALL SUBOPT_0x1B
; 0000 0383     INITIATE;
	CALL SUBOPT_0x1C
; 0000 0384 
; 0000 0385     //ICR1H=0x4F;
; 0000 0386     //ICR1L=0xFF;
; 0000 0387     //ICR3H=0x4F;
; 0000 0388     //ICR3L=0xFF;
; 0000 0389 
; 0000 038A     OCR1BH=(50*50)>>8;
	LDI  R30,LOW(9)
	OUT  0x29,R30
; 0000 038B     OCR1BL=50*50;
	LDI  R30,LOW(196)
	OUT  0x28,R30
; 0000 038C 
; 0000 038D     lcd_clear();
	CALL SUBOPT_0xB
; 0000 038E     lcd_gotoxy(0, 0);lcd_putsf("Valve!");
	__POINTW1FN _0x0,43
	CALL SUBOPT_0x2E
; 0000 038F 
; 0000 0390     while(Middle_switch_off)
_0xCF:
	SBIS 0x1,2
	RJMP _0xD1
; 0000 0391     {
; 0000 0392         order(&seq); //Control signal of each sequence
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 0393         Global_Sequence = seq;
	STS  _Global_Sequence,R17
; 0000 0394 
; 0000 0395         OCR1AH=800>>8;
	CALL SUBOPT_0x38
; 0000 0396         OCR1AL=800;
; 0000 0397         OCR3AH=3000>>8;
	CALL SUBOPT_0x75
; 0000 0398         OCR3AL=3000;
; 0000 0399 
; 0000 039A         lcd_gotoxy(0, 1);lcd_putsf("Inlet!");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
	__POINTW1FN _0x0,95
	CALL SUBOPT_0x2E
; 0000 039B         arrived[seq]=1;
	CALL SUBOPT_0x7F
; 0000 039C 
; 0000 039D         /*
; 0000 039E         if(Left_switch_on)  temp-=10;
; 0000 039F         if(Right_switch_on)  temp+=10;
; 0000 03A0         if(temp<0) temp=0;
; 0000 03A1         if(temp>3500)  temp=3500;
; 0000 03A2 
; 0000 03A3         lcd_gotoxy(0, 1);
; 0000 03A4         sprintf(lcd_data, "%d %", temp);
; 0000 03A5         lcd_puts(lcd_data);
; 0000 03A6         */
; 0000 03A7 
; 0000 03A8         if(Left_switch_on)
	SBIC 0x1,1
	RJMP _0xD2
; 0000 03A9         {
; 0000 03AA             lcd_gotoxy(0, 1);lcd_putsf("Inlet!");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
	__POINTW1FN _0x0,95
	CALL SUBOPT_0x2E
; 0000 03AB             arrived[seq]=1;
	CALL SUBOPT_0x7F
; 0000 03AC 
; 0000 03AD         }
; 0000 03AE 
; 0000 03AF         if(Right_switch_on)
_0xD2:
	SBIC 0x1,3
	RJMP _0xD3
; 0000 03B0         {
; 0000 03B1             lcd_gotoxy(0, 1);lcd_putsf("Outlet!");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x2E
; 0000 03B2             arrived[seq]=-1;
	MOV  R30,R17
	LDI  R26,LOW(_arrived)
	LDI  R27,HIGH(_arrived)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x61
; 0000 03B3 
; 0000 03B4         }
; 0000 03B5 
; 0000 03B6 
; 0000 03B7         /*
; 0000 03B8         if(Left_switch_on)
; 0000 03B9         {
; 0000 03BA             if((E_flag[0]==1)&&(F_flag[0]==0))
; 0000 03BB             {
; 0000 03BC                 E_flag[0]=0;
; 0000 03BD                 F_flag[0]=0;
; 0000 03BE             }
; 0000 03BF             else
; 0000 03C0             {
; 0000 03C1                 E_flag[0]=1;
; 0000 03C2                 F_flag[0]=0;
; 0000 03C3             }
; 0000 03C4         }
; 0000 03C5         if(Right_switch_on)
; 0000 03C6         {
; 0000 03C7             if((E_flag[0]==0)&&(F_flag[0]==1))
; 0000 03C8             {
; 0000 03C9                 E_flag[0]=0;
; 0000 03CA                 F_flag[0]=0;
; 0000 03CB             }
; 0000 03CC             else
; 0000 03CD             {
; 0000 03CE                 E_flag[0]=0;
; 0000 03CF                 F_flag[0]=1;
; 0000 03D0             }
; 0000 03D1         }
; 0000 03D2 
; 0000 03D3         disp(0,0);
; 0000 03D4 
; 0000 03D5         lcd_gotoxy(5, 1);
; 0000 03D6         sprintf(lcd_data, "%d", E_flag[0]);
; 0000 03D7         lcd_puts(lcd_data);
; 0000 03D8         lcd_gotoxy(7, 1);
; 0000 03D9         sprintf(lcd_data, "%d", F_flag[0]);
; 0000 03DA         lcd_puts(lcd_data);
; 0000 03DB 
; 0000 03DC         if((E_flag[0]==0)&&(F_flag[0]==0))
; 0000 03DD         {
; 0000 03DE             OCR1AH=500>>8;
; 0000 03DF             OCR1AL=500;
; 0000 03E0             OCR3AH=500>>8;
; 0000 03E1             OCR3AL=500;
; 0000 03E2         }
; 0000 03E3         if((E_flag[0]==1)&&(F_flag[0]==0))
; 0000 03E4         {
; 0000 03E5             OCR1AH=800>>8;
; 0000 03E6             OCR1AL=800;
; 0000 03E7             OCR3AH=200>>8;
; 0000 03E8             OCR3AL=200;
; 0000 03E9         }
; 0000 03EA         if((E_flag[0]==0)&&(F_flag[0]==1))
; 0000 03EB         {
; 0000 03EC             OCR1AH=200>>8;
; 0000 03ED             OCR1AL=200;
; 0000 03EE             OCR3AH=800>>8;
; 0000 03EF             OCR3AL=800;
; 0000 03F0         }
; 0000 03F1         */
; 0000 03F2 
; 0000 03F3         delay_ms(Ts);
_0xD3:
	CALL SUBOPT_0x42
; 0000 03F4     }
	RJMP _0xCF
_0xD1:
; 0000 03F5     TERMINATE;
	CALL SUBOPT_0x1E
; 0000 03F6     for(i=0;i<4;i++)    arrived[i]=0;
	CALL SUBOPT_0x3A
_0xD5:
	CALL SUBOPT_0x3B
	BRGE _0xD6
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x66
	CALL SUBOPT_0x3E
	RJMP _0xD5
_0xD6:
; 0000 03F7 ICR1H=0x13;
	CALL SUBOPT_0x80
; 0000 03F8     ICR1L=0x87;
; 0000 03F9     ICR3H=0x13;
; 0000 03FA     ICR3L=0x87;
; 0000 03FB     Global_Sequence=0;
; 0000 03FC     OCR1AH=0x00;
; 0000 03FD     OCR1AL=0x00;
; 0000 03FE     OCR3AH=0x00;
	CALL SUBOPT_0x81
; 0000 03FF     OCR3AL=0x00;
; 0000 0400     OCR1BH=0x00;
; 0000 0401     OCR1BL=0x00;
; 0000 0402     E_flag[0]=0;
	CALL SUBOPT_0x82
; 0000 0403     F_flag[0]=0;
; 0000 0404     PORTB=0x00;
; 0000 0405     PORTC=0x00;
; 0000 0406 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void test2()
; 0000 0409 {
_test2:
; 0000 040A     unsigned char seq=0;
; 0000 040B     float ANG[4]={0};
; 0000 040C     char ang_desired=15;
; 0000 040D     int temp = 3500;
; 0000 040E     float u=0;
; 0000 040F     float error=0;
; 0000 0410 
; 0000 0411     delay_ms(50);
	SBIW R28,24
	LDI  R24,24
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xD7*2)
	LDI  R31,HIGH(_0xD7*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	seq -> R17
;	ANG -> Y+12
;	ang_desired -> R16
;	temp -> R18,R19
;	u -> Y+8
;	error -> Y+4
	CALL SUBOPT_0x83
; 0000 0412     INITIATE;
	CALL SUBOPT_0x1C
; 0000 0413 
; 0000 0414     OCR1BH=(99*50)>>8;
	CALL SUBOPT_0x67
; 0000 0415     OCR1BL=99*50;
; 0000 0416 
; 0000 0417     OCR1AH=temp>>8;
	CALL SUBOPT_0x84
; 0000 0418     OCR1AL=temp;
; 0000 0419 
; 0000 041A     lcd_clear();
; 0000 041B 
; 0000 041C     while(Middle_switch_off)
_0xD8:
	SBIS 0x1,2
	RJMP _0xDA
; 0000 041D     {
; 0000 041E         order(&seq); //Control signal of each sequence
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 041F         Global_Sequence = seq;
	STS  _Global_Sequence,R17
; 0000 0420         //Global_Sequence=0;
; 0000 0421         mean_flex(seq,1);
	CALL SUBOPT_0x69
; 0000 0422         ANG[seq] = (float)(flex_max[seq]-flex_mean[seq])/((float)(flex_max[seq]-flex_min[seq]))*MAX_ANG;
	MOVW R24,R30
	MOVW R22,R30
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,12
	CALL SUBOPT_0x44
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x12
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x47
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0423 
; 0000 0424         if(Left_switch_on)      ang_desired--;
	SBIS 0x1,1
	SUBI R16,1
; 0000 0425         if(Right_switch_on)     ang_desired++;
	SBIS 0x1,3
	SUBI R16,-1
; 0000 0426 
; 0000 0427         if(ang_desired<0)       ang_desired=0;
; 0000 0428         if(ang_desired>40)      ang_desired=40;
	CPI  R16,41
	BRLO _0xDE
	LDI  R16,LOW(40)
; 0000 0429 
; 0000 042A         error = ang_desired-ang_old[2];   //error : 0~90
_0xDE:
	CALL SUBOPT_0x85
	__PUTD1S 4
; 0000 042B         error_sum[2] += error;
	CALL SUBOPT_0x86
	__GETD2S 4
	CALL SUBOPT_0x87
; 0000 042C         u = kp*error + ki*error_sum[2]*((float)(Ts/1000.)) + kd*(error-error_old[2])/((float)(Ts/1000.));//Control value for OCR1A,OCR3A
	__GETD1S 4
	LDS  R26,_kp
	LDS  R27,_kp+1
	LDS  R24,_kp+2
	LDS  R25,_kp+3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x86
	CALL SUBOPT_0x57
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x88
	__GETD2S 4
	CALL SUBOPT_0x59
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__PUTD1S 8
; 0000 042D         //u=4999-u;
; 0000 042E         error_old[2]=error;
	__GETD1S 4
	CALL SUBOPT_0x89
; 0000 042F         ang_old[2]= ANG[2];
	__GETD1S 20
	CALL __CFD1U
	ST   X,R30
; 0000 0430 
; 0000 0431         //Saturation condition...
; 0000 0432         if(u>UPPER)       u=UPPER;
	__GETD2S 8
	CALL SUBOPT_0x5D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDF
	CALL SUBOPT_0x5D
	RJMP _0x139
; 0000 0433         else if(u<LOWER)  u=LOWER;
_0xDF:
	__GETD2S 8
	CALL SUBOPT_0x5F
	CALL __CMPF12
	BRSH _0xE1
	CALL SUBOPT_0x5F
_0x139:
	__PUTD1S 8
; 0000 0434 
; 0000 0435         lcd_gotoxy(0, 0);
_0xE1:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x8A
; 0000 0436         sprintf(lcd_data, "%2d %", ang_desired);
	CALL SUBOPT_0x41
; 0000 0437         lcd_puts(lcd_data);
; 0000 0438 
; 0000 0439         lcd_gotoxy(2, 0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x8A
; 0000 043A         sprintf(lcd_data, "%2d %", (int)ANG[2]);
	__POINTW1FN _0x0,58
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 24
	CALL SUBOPT_0x49
; 0000 043B         lcd_puts(lcd_data);
; 0000 043C 
; 0000 043D         lcd_gotoxy(4, 0);
	CALL SUBOPT_0x30
; 0000 043E         sprintf(lcd_data, "%4d %", (int)u);
	CALL SUBOPT_0x40
	__POINTW1FN _0x0,110
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 12
	CALL SUBOPT_0x49
; 0000 043F         lcd_puts(lcd_data);
; 0000 0440 
; 0000 0441         for(i=0;i<4;i++)    disp(i*2,i);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3A
_0xE3:
	CALL SUBOPT_0x3B
	BRGE _0xE4
	CALL SUBOPT_0x68
	CALL SUBOPT_0x3E
	RJMP _0xE3
_0xE4:
; 0000 0443 if(ANG[2]>(ang_desired+2))
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x8B
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE5
; 0000 0444         {
; 0000 0445             //Extension
; 0000 0446             TIMSK=0x14;
	CALL SUBOPT_0x1C
; 0000 0447             ETIMSK=0x14;
; 0000 0448             OCR3AH=(int)u>>8;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x63
	STS  135,R30
; 0000 0449             OCR3AL=(int)u;
	CALL SUBOPT_0x8C
	CALL __CFD1
	STS  134,R30
; 0000 044A         }
; 0000 044B         else if(ANG[2]<(ang_desired-2))
	RJMP _0xE6
_0xE5:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x8D
	BRSH _0xE7
; 0000 044C         {
; 0000 044D             //Flextion
; 0000 044E             TIMSK=0x14;
	LDI  R30,LOW(20)
	CALL SUBOPT_0x8E
; 0000 044F             ETIMSK = 0x00;
; 0000 0450             OCR1AH=(int)u>>8;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x63
	OUT  0x2B,R30
; 0000 0451             OCR1AL=(int)u;
	CALL SUBOPT_0x8C
	CALL __CFD1
	OUT  0x2A,R30
; 0000 0452         }
; 0000 0453         else if(ANG[2]>=(ang_desired-2) && ANG[2]<=(ang_desired+2))
	RJMP _0xE8
_0xE7:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x8D
	BRLO _0xEA
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x8B
	BREQ PC+4
	BRCS PC+3
	JMP  _0xEA
	RJMP _0xEB
_0xEA:
	RJMP _0xE9
_0xEB:
; 0000 0454         {
; 0000 0455             //Hold
; 0000 0456             TIMSK=0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8E
; 0000 0457             ETIMSK = 0x00;
; 0000 0458         }
; 0000 0459 
; 0000 045A         /*
; 0000 045B         if(Left_switch_on)
; 0000 045C         {
; 0000 045D             if((E_flag[0]==1)&&(F_flag[0]==0))
; 0000 045E             {
; 0000 045F                 E_flag[0]=0;
; 0000 0460                 F_flag[0]=0;
; 0000 0461             }
; 0000 0462             else
; 0000 0463             {
; 0000 0464                 E_flag[0]=1;
; 0000 0465                 F_flag[0]=0;
; 0000 0466             }
; 0000 0467         }
; 0000 0468         if(Right_switch_on)
; 0000 0469         {
; 0000 046A             if((E_flag[0]==0)&&(F_flag[0]==1))
; 0000 046B             {
; 0000 046C                 E_flag[0]=0;
; 0000 046D                 F_flag[0]=0;
; 0000 046E             }
; 0000 046F             else
; 0000 0470             {
; 0000 0471                 E_flag[0]=0;
; 0000 0472                 F_flag[0]=1;
; 0000 0473             }
; 0000 0474         }
; 0000 0475 
; 0000 0476         disp(0,0);
; 0000 0477 
; 0000 0478         lcd_gotoxy(5, 1);
; 0000 0479         sprintf(lcd_data, "%d", E_flag[0]);
; 0000 047A         lcd_puts(lcd_data);
; 0000 047B         lcd_gotoxy(7, 1);
; 0000 047C         sprintf(lcd_data, "%d", F_flag[0]);
; 0000 047D         lcd_puts(lcd_data);
; 0000 047E 
; 0000 047F         if((E_flag[0]==0)&&(F_flag[0]==0))
; 0000 0480         {
; 0000 0481             OCR1AH=500>>8;
; 0000 0482             OCR1AL=500;
; 0000 0483             OCR3AH=500>>8;
; 0000 0484             OCR3AL=500;
; 0000 0485         }
; 0000 0486         if((E_flag[0]==1)&&(F_flag[0]==0))
; 0000 0487         {
; 0000 0488             OCR1AH=800>>8;
; 0000 0489             OCR1AL=800;
; 0000 048A             OCR3AH=200>>8;
; 0000 048B             OCR3AL=200;
; 0000 048C         }
; 0000 048D         if((E_flag[0]==0)&&(F_flag[0]==1))
; 0000 048E         {
; 0000 048F             OCR1AH=200>>8;
; 0000 0490             OCR1AL=200;
; 0000 0491             OCR3AH=800>>8;
; 0000 0492             OCR3AL=800;
; 0000 0493         }
; 0000 0494         */
; 0000 0495 
; 0000 0496         delay_ms(100);
_0xE9:
_0xE8:
_0xE6:
	CALL SUBOPT_0x15
; 0000 0497     }
	RJMP _0xD8
_0xDA:
; 0000 0498     TERMINATE;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8E
; 0000 0499     ICR1H=0x13;
	CALL SUBOPT_0x80
; 0000 049A     ICR1L=0x87;
; 0000 049B     ICR3H=0x13;
; 0000 049C     ICR3L=0x87;
; 0000 049D     Global_Sequence=0;
; 0000 049E     OCR1AH=0x00;
; 0000 049F     OCR1AL=0x00;
; 0000 04A0     OCR3AH=0x00;
	CALL SUBOPT_0x81
; 0000 04A1     OCR3AL=0x00;
; 0000 04A2     OCR1BH=0x00;
; 0000 04A3     OCR1BL=0x00;
; 0000 04A4     E_flag[0]=0;
	CALL SUBOPT_0x82
; 0000 04A5     F_flag[0]=0;
; 0000 04A6     PORTB=0x00;
; 0000 04A7     PORTC=0x00;
; 0000 04A8 }
	CALL __LOADLOCR4
	ADIW R28,28
	RET
;
;void test3()
; 0000 04AB {
_test3:
; 0000 04AC     unsigned char seq=0;
; 0000 04AD     float ANG[4]={0};
; 0000 04AE     char ang_desired=15;
; 0000 04AF     int temp = 3500;
; 0000 04B0     int E_OR_F;
; 0000 04B1     float u=0;
; 0000 04B2     float error=0;
; 0000 04B3 
; 0000 04B4     delay_ms(50);
	SBIW R28,24
	LDI  R24,24
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xEC*2)
	LDI  R31,HIGH(_0xEC*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	seq -> R17
;	ANG -> Y+14
;	ang_desired -> R16
;	temp -> R18,R19
;	E_OR_F -> R20,R21
;	u -> Y+10
;	error -> Y+6
	CALL SUBOPT_0x83
; 0000 04B5     INITIATE;
	CALL SUBOPT_0x1C
; 0000 04B6 
; 0000 04B7     OCR1BH=(99*50)>>8;
	CALL SUBOPT_0x67
; 0000 04B8     OCR1BL=99*50;
; 0000 04B9 
; 0000 04BA     OCR1AH=temp>>8;
	CALL SUBOPT_0x84
; 0000 04BB     OCR1AL=temp;
; 0000 04BC 
; 0000 04BD     lcd_clear();
; 0000 04BE 
; 0000 04BF     while(Middle_switch_off)
_0xED:
	SBIS 0x1,2
	RJMP _0xEF
; 0000 04C0     {
; 0000 04C1         order(&seq); //Control signal of each sequence
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 04C2         Global_Sequence = seq;
	STS  _Global_Sequence,R17
; 0000 04C3         //Global_Sequence=2;
; 0000 04C4         mean_flex(seq,1);
	CALL SUBOPT_0x69
; 0000 04C5         ANG[seq] = (float)(flex_max[seq]-flex_mean[seq])/((float)(flex_max[seq]-flex_min[seq]))*MAX_ANG;
	MOVW R24,R30
	MOVW R22,R30
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,14
	CALL SUBOPT_0x44
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x12
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x47
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 04C6 
; 0000 04C7         if(Left_switch_on)      ang_desired--;
	SBIS 0x1,1
	SUBI R16,1
; 0000 04C8         if(Right_switch_on)     ang_desired++;
	SBIS 0x1,3
	SUBI R16,-1
; 0000 04C9 
; 0000 04CA         if(ang_desired<0)       ang_desired=0;
; 0000 04CB         if(ang_desired>MAX_ANG)      ang_desired=MAX_ANG;
	CPI  R16,61
	BRLO _0xF3
	LDI  R16,LOW(60)
; 0000 04CC 
; 0000 04CD         E_OR_F = ((E_flag[2]?-1:1)+(F_flag[2]?1:-1))/2;//Extension:-1, Flextion:1, Do noting:0
_0xF3:
	__GETB1MN _E_flag,2
	LDI  R31,0
	SBIW R30,0
	BREQ _0xF4
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0xF5
_0xF4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0xF5:
	MOVW R26,R30
	__GETB1MN _F_flag,2
	LDI  R31,0
	SBIW R30,0
	BREQ _0xF7
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xF8
_0xF7:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0xF8:
	CALL SUBOPT_0x4F
	MOVW R20,R30
; 0000 04CE         ang_desired = ANG[2]+(E_OR_F*delta_ang);//Ext:Bend-delta_ang, Flex:Bend+delta_ang, Stay:Bend
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x8F
	CALL __ADDF12
	CALL __CFD1U
	MOV  R16,R30
; 0000 04CF         error = ang_desired-ang_old[2];   //error : 0~90
	CALL SUBOPT_0x85
	__PUTD1S 6
; 0000 04D0         error_sum[2] += error;
	CALL SUBOPT_0x86
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x87
; 0000 04D1         u = kp*error + ki*error_sum[2]*((float)(Ts/1000.)) + kd*(error-error_old[2])/((float)(Ts/1000.));//Control value for OCR1A,OCR3A
	CALL SUBOPT_0x55
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x86
	CALL SUBOPT_0x57
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x88
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x59
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x5A
; 0000 04D2         //u=4999-u;
; 0000 04D3         error_old[2]=error;
	__GETD1S 6
	CALL SUBOPT_0x89
; 0000 04D4         ang_old[2]= ANG[2];
	__GETD1S 22
	CALL __CFD1U
	ST   X,R30
; 0000 04D5 
; 0000 04D6         //Saturation condition...
; 0000 04D7         if(u>UPPER)       u=UPPER;
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFA
	CALL SUBOPT_0x5D
	RJMP _0x13A
; 0000 04D8         else if(u<LOWER)  u=LOWER;
_0xFA:
	CALL SUBOPT_0x5E
	BRSH _0xFC
	CALL SUBOPT_0x5F
_0x13A:
	__PUTD1S 10
; 0000 04D9 
; 0000 04DA         lcd_gotoxy(0, 0);
_0xFC:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x8A
; 0000 04DB         sprintf(lcd_data, "%d %", ang_desired);
	CALL SUBOPT_0x4A
	MOV  R30,R16
	CALL SUBOPT_0xE
; 0000 04DC         lcd_puts(lcd_data);
; 0000 04DD 
; 0000 04DE         lcd_gotoxy(6, 0);
	CALL SUBOPT_0x31
; 0000 04DF         sprintf(lcd_data, "%d %", (int)ANG[2]);
	CALL SUBOPT_0x40
	CALL SUBOPT_0x4A
	__GETD1S 26
	CALL SUBOPT_0x49
; 0000 04E0         lcd_puts(lcd_data);
; 0000 04E1 
; 0000 04E2         lcd_gotoxy(4, 0);
	CALL SUBOPT_0x30
; 0000 04E3         if(E_OR_F==-1)lcd_putsf("E");
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xFD
	CALL SUBOPT_0x29
; 0000 04E4         if(E_OR_F==0)lcd_putsf("-");
_0xFD:
	MOV  R0,R20
	OR   R0,R21
	BRNE _0xFE
	CALL SUBOPT_0x2D
; 0000 04E5         if(E_OR_F==1)lcd_putsf("F");
_0xFE:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xFF
	CALL SUBOPT_0x2A
; 0000 04E6 
; 0000 04E7 
; 0000 04E8         for(i=0;i<4;i++)    disp(i*2,i);
_0xFF:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3A
_0x101:
	CALL SUBOPT_0x3B
	BRGE _0x102
	CALL SUBOPT_0x68
	CALL SUBOPT_0x3E
	RJMP _0x101
_0x102:
; 0000 04EA if(ANG[2]>(ang_desired+1))
	CALL SUBOPT_0x4B
	ADIW R30,1
	CALL SUBOPT_0x8F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x103
; 0000 04EB         {
; 0000 04EC             //Extension
; 0000 04ED             TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 04EE             ETIMSK=0x14;
	LDI  R30,LOW(20)
	STS  125,R30
; 0000 04EF             OCR3AH=(int)u>>8;
	CALL SUBOPT_0x65
	STS  135,R30
; 0000 04F0             OCR3AL=(int)u;
	CALL SUBOPT_0x62
	CALL __CFD1
	STS  134,R30
; 0000 04F1         }
; 0000 04F2         else if(ANG[2]<(ang_desired-ANG_th))
	RJMP _0x104
_0x103:
	CALL SUBOPT_0x4B
	SBIW R30,1
	CALL SUBOPT_0x8F
	CALL __CMPF12
	BRSH _0x105
; 0000 04F3         {
; 0000 04F4             //Flextion
; 0000 04F5             TIMSK=0x14;
	LDI  R30,LOW(20)
	CALL SUBOPT_0x8E
; 0000 04F6             ETIMSK = 0x00;
; 0000 04F7             OCR1AH=(int)u>>8;
	CALL SUBOPT_0x65
	OUT  0x2B,R30
; 0000 04F8             OCR1AL=(int)u;
	CALL SUBOPT_0x62
	CALL __CFD1
	OUT  0x2A,R30
; 0000 04F9         }
; 0000 04FA         else if((ANG[2]>=(ang_desired-ANG_th)) && (ANG[2]<=(ang_desired+ANG_th)))
	RJMP _0x106
_0x105:
	CALL SUBOPT_0x4B
	SBIW R30,1
	CALL SUBOPT_0x8F
	CALL __CMPF12
	BRLO _0x108
	CALL SUBOPT_0x4B
	ADIW R30,1
	CALL SUBOPT_0x8F
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x108
	RJMP _0x109
_0x108:
	RJMP _0x107
_0x109:
; 0000 04FB         {
; 0000 04FC             //Hold
; 0000 04FD             TIMSK=0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8E
; 0000 04FE             ETIMSK = 0x00;
; 0000 04FF         }
; 0000 0500 
; 0000 0501         /*
; 0000 0502         if(Left_switch_on)
; 0000 0503         {
; 0000 0504             if((E_flag[0]==1)&&(F_flag[0]==0))
; 0000 0505             {
; 0000 0506                 E_flag[0]=0;
; 0000 0507                 F_flag[0]=0;
; 0000 0508             }
; 0000 0509             else
; 0000 050A             {
; 0000 050B                 E_flag[0]=1;
; 0000 050C                 F_flag[0]=0;
; 0000 050D             }
; 0000 050E         }
; 0000 050F         if(Right_switch_on)
; 0000 0510         {
; 0000 0511             if((E_flag[0]==0)&&(F_flag[0]==1))
; 0000 0512             {
; 0000 0513                 E_flag[0]=0;
; 0000 0514                 F_flag[0]=0;
; 0000 0515             }
; 0000 0516             else
; 0000 0517             {
; 0000 0518                 E_flag[0]=0;
; 0000 0519                 F_flag[0]=1;
; 0000 051A             }
; 0000 051B         }
; 0000 051C 
; 0000 051D         disp(0,0);
; 0000 051E 
; 0000 051F         lcd_gotoxy(5, 1);
; 0000 0520         sprintf(lcd_data, "%d", E_flag[0]);
; 0000 0521         lcd_puts(lcd_data);
; 0000 0522         lcd_gotoxy(7, 1);
; 0000 0523         sprintf(lcd_data, "%d", F_flag[0]);
; 0000 0524         lcd_puts(lcd_data);
; 0000 0525 
; 0000 0526         if((E_flag[0]==0)&&(F_flag[0]==0))
; 0000 0527         {
; 0000 0528             OCR1AH=500>>8;
; 0000 0529             OCR1AL=500;
; 0000 052A             OCR3AH=500>>8;
; 0000 052B             OCR3AL=500;
; 0000 052C         }
; 0000 052D         if((E_flag[0]==1)&&(F_flag[0]==0))
; 0000 052E         {
; 0000 052F             OCR1AH=800>>8;
; 0000 0530             OCR1AL=800;
; 0000 0531             OCR3AH=200>>8;
; 0000 0532             OCR3AL=200;
; 0000 0533         }
; 0000 0534         if((E_flag[0]==0)&&(F_flag[0]==1))
; 0000 0535         {
; 0000 0536             OCR1AH=200>>8;
; 0000 0537             OCR1AL=200;
; 0000 0538             OCR3AH=800>>8;
; 0000 0539             OCR3AL=800;
; 0000 053A         }
; 0000 053B         */
; 0000 053C 
; 0000 053D         delay_ms(500);
_0x107:
_0x106:
_0x104:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 053E     }
	RJMP _0xED
_0xEF:
; 0000 053F     TERMINATE;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8E
; 0000 0540     ICR1H=0x13;
	CALL SUBOPT_0x80
; 0000 0541     ICR1L=0x87;
; 0000 0542     ICR3H=0x13;
; 0000 0543     ICR3L=0x87;
; 0000 0544     Global_Sequence=0;
; 0000 0545     OCR1AH=0x00;
; 0000 0546     OCR1AL=0x00;
; 0000 0547     OCR3AH=0x00;
	CALL SUBOPT_0x81
; 0000 0548     OCR3AL=0x00;
; 0000 0549     OCR1BH=0x00;
; 0000 054A     OCR1BL=0x00;
; 0000 054B     E_flag[0]=0;
	CALL SUBOPT_0x82
; 0000 054C     F_flag[0]=0;
; 0000 054D     PORTB=0x00;
; 0000 054E     PORTC=0x00;
; 0000 054F }
	CALL __LOADLOCR6
	ADIW R28,30
	RET
;
;// ********************************************* main ******************************************************************
;void main(void)
; 0000 0553 {
_main:
; 0000 0554 // Declare your local variables here
; 0000 0555 // menu
; 0000 0556 unsigned char menu = 0;
; 0000 0557 unsigned char menu_Max = 14;
; 0000 0558 
; 0000 0559 // PA1~7 : Control switch (PA0안됨)
; 0000 055A PORTA=0x00;
;	menu -> R17
;	menu_Max -> R16
	LDI  R17,0
	LDI  R16,14
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 055B DDRA=0x01;
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 055C // PB6 : Pump
; 0000 055D PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 055E DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 055F // PC0~3 : Inlet Valve
; 0000 0560 // PC4~7 : Outlet Valve
; 0000 0561 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0562 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0563 // PD0~7 : LCD
; 0000 0564 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0565 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0566 // PE0 : EMERGENCY switch
; 0000 0567 // PE1 : Interface switch - LEFT
; 0000 0568 // PE2 : Interface switch - MIDDLE
; 0000 0569 // PE3 : Interface switch - RIGHT
; 0000 056A // PE4 : Mode change switch (Toggle)
; 0000 056B // * PE5 : Thumb up....
; 0000 056C PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 056D DDRE=0xC0;
	LDI  R30,LOW(192)
	OUT  0x2,R30
; 0000 056E // PF0~3 : Pressure Sensor
; 0000 056F // PF4~7 : Flex Sensor
; 0000 0570 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0571 DDRF=0x00;
	STS  97,R30
; 0000 0572 PORTG=0x00;
	STS  101,R30
; 0000 0573 DDRG=0x00;
	STS  100,R30
; 0000 0574 
; 0000 0575 // Compare match interrupt  : Valve on
; 0000 0576 // Overflow interrupt       : Valve off
; 0000 0577 // Timer 1 B : PUMP pwm control by using OCR1B
; 0000 0578 // Timer 1   : Inlet Valve control
; 0000 0579 // Timer 3   : Outlet Valve on
; 0000 057A 
; 0000 057B // Timer/Counter 1 initialization
; 0000 057C TCCR1A=0x22;//Only OC1B can make PWM signal(whenever TIM1_COMPB is LOW), Else : GPIO
	LDI  R30,LOW(34)
	OUT  0x2F,R30
; 0000 057D //TCCR1A=0x02;
; 0000 057E TCCR1B=0x1C;//Timer 1 : Fast PWM mode, prescale=256, TOP=ICR1 (PWM period:80ms)
	LDI  R30,LOW(28)
	OUT  0x2E,R30
; 0000 057F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0580 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0581 ICR1H=0x13;
	LDI  R30,LOW(19)
	OUT  0x27,R30
; 0000 0582 ICR1L=0x87;
	LDI  R30,LOW(135)
	OUT  0x26,R30
; 0000 0583 OCR1AH=0x00;
	CALL SUBOPT_0x1F
; 0000 0584 OCR1AL=0x00;
; 0000 0585 OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 0586 OCR1BL=0x00;
; 0000 0587 OCR1CH=0x00;
	STS  121,R30
; 0000 0588 OCR1CL=0x00;
	LDI  R30,LOW(0)
	STS  120,R30
; 0000 0589 // Timer/Counter 3 initialization
; 0000 058A TCCR3A=0x02;//All port related with Timer3 : GPIO
	LDI  R30,LOW(2)
	STS  139,R30
; 0000 058B TCCR3B=0x1C;//Timer 3 : Fast PWM mode, prescale=256, TOP=ICR3, f=clk/((TOP+1)*prescale)=80ms
	LDI  R30,LOW(28)
	STS  138,R30
; 0000 058C TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 058D TCNT3L=0x00;
	STS  136,R30
; 0000 058E ICR3H=0x13;
	LDI  R30,LOW(19)
	STS  129,R30
; 0000 058F ICR3L=0x87;
	LDI  R30,LOW(135)
	STS  128,R30
; 0000 0590 OCR3AH=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0591 OCR3AL=0x00;
	STS  134,R30
; 0000 0592 OCR3BH=0x00;
	CALL SUBOPT_0x39
; 0000 0593 OCR3BL=0x00;
; 0000 0594 OCR3CH=0x00;
	STS  131,R30
; 0000 0595 OCR3CL=0x00;
	LDI  R30,LOW(0)
	STS  130,R30
; 0000 0596 //Timer/counter interrupt
; 0000 0597 TIMSK = 0x00;
	CALL SUBOPT_0x8E
; 0000 0598 ETIMSK = 0x00;
; 0000 0599 
; 0000 059A //ADC setting
; 0000 059B ADMUX=0x21;
	LDI  R30,LOW(33)
	OUT  0x7,R30
; 0000 059C ADCSRA=0xCF;  //ADC enable, ADC start, ADC interrupt on, prescale:128(62.5kHz)
	LDI  R30,LOW(207)
	OUT  0x6,R30
; 0000 059D SFIOR=0x01;
	LDI  R30,LOW(1)
	OUT  0x20,R30
; 0000 059E 
; 0000 059F lcd_init(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _lcd_init
; 0000 05A0 // Global enable interrupts
; 0000 05A1 #asm("sei")
	sei
; 0000 05A2 SREG = 0x80;
	LDI  R30,LOW(128)
	OUT  0x3F,R30
; 0000 05A3 while (1)
_0x10A:
; 0000 05A4       {
; 0000 05A5         if(Left_switch_on){
	SBIC 0x1,1
	RJMP _0x10D
; 0000 05A6             if(menu == 0) menu = menu_Max;
	CPI  R17,0
	BRNE _0x10E
	MOV  R17,R16
; 0000 05A7             else    menu--;
	RJMP _0x10F
_0x10E:
	SUBI R17,1
; 0000 05A8         }
_0x10F:
; 0000 05A9 
; 0000 05AA         if(Right_switch_on) menu++;
_0x10D:
	SBIS 0x1,3
	SUBI R17,-1
; 0000 05AB         if(menu > menu_Max)    menu = 0;
	CP   R16,R17
	BRSH _0x111
	LDI  R17,LOW(0)
; 0000 05AC 
; 0000 05AD 
; 0000 05AE         switch(menu)
_0x111:
	CALL SUBOPT_0x12
; 0000 05AF         {
; 0000 05B0             case 0:
	SBIW R30,0
	BRNE _0x115
; 0000 05B1                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05B2                     lcd_gotoxy(0, 0);
; 0000 05B3                     lcd_putsf("1.Pressure TEST");
	__POINTW1FN _0x0,116
	CALL SUBOPT_0x2E
; 0000 05B4                     if(Middle_switch_on) pressure_test();
	SBIC 0x1,2
	RJMP _0x116
	CALL _pressure_test
; 0000 05B5                     delay_ms(100);
_0x116:
	RJMP _0x13B
; 0000 05B6                     break;
; 0000 05B7 
; 0000 05B8             case 1:
_0x115:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x117
; 0000 05B9                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05BA                     lcd_gotoxy(0, 0);
; 0000 05BB                     lcd_putsf("2.Pressure Tunning");
	__POINTW1FN _0x0,132
	CALL SUBOPT_0x2E
; 0000 05BC                     if(Middle_switch_on)    pressure_tuning();
	SBIC 0x1,2
	RJMP _0x118
	CALL _pressure_tuning
; 0000 05BD                     delay_ms(100);
_0x118:
	RJMP _0x13B
; 0000 05BE                     break;
; 0000 05BF 
; 0000 05C0             case 2:
_0x117:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x119
; 0000 05C1                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05C2                     lcd_gotoxy(0, 0);
; 0000 05C3                     lcd_putsf("3.Flex TEST");
	__POINTW1FN _0x0,151
	CALL SUBOPT_0x2E
; 0000 05C4                     if(Middle_switch_on)    flex_test();
	SBIC 0x1,2
	RJMP _0x11A
	CALL _flex_test
; 0000 05C5                     delay_ms(100);
_0x11A:
	RJMP _0x13B
; 0000 05C6                     break;
; 0000 05C7             case 3:
_0x119:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x11B
; 0000 05C8                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05C9                     lcd_gotoxy(0, 0);
; 0000 05CA                     lcd_putsf("4.Flex Tunning");
	__POINTW1FN _0x0,163
	CALL SUBOPT_0x2E
; 0000 05CB                     if(Middle_switch_on)    flex_tuning();
	SBIC 0x1,2
	RJMP _0x11C
	CALL _flex_tuning
; 0000 05CC                     delay_ms(100);
_0x11C:
	RJMP _0x13B
; 0000 05CD                     break;
; 0000 05CE 
; 0000 05CF             case 4:
_0x11B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11D
; 0000 05D0                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05D1                     lcd_gotoxy(0, 0);
; 0000 05D2                     lcd_putsf("5.PWM TEST");
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x2E
; 0000 05D3                     if(Middle_switch_on)    check_pwm();
	SBIC 0x1,2
	RJMP _0x11E
	CALL _check_pwm
; 0000 05D4                     delay_ms(100);
_0x11E:
	RJMP _0x13B
; 0000 05D5                     break;
; 0000 05D6 
; 0000 05D7             case 5:
_0x11D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x11F
; 0000 05D8                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05D9                     lcd_gotoxy(0, 0);
; 0000 05DA                     lcd_putsf("6.PUMP TEST");
	__POINTW1FN _0x0,189
	CALL SUBOPT_0x2E
; 0000 05DB                     if(Middle_switch_on)    PUMP_test();
	SBIC 0x1,2
	RJMP _0x120
	CALL _PUMP_test
; 0000 05DC                     delay_ms(100);
_0x120:
	RJMP _0x13B
; 0000 05DD                     break;
; 0000 05DE 
; 0000 05DF             case 6:
_0x11F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x121
; 0000 05E0                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05E1                     lcd_gotoxy(0, 0);
; 0000 05E2                     lcd_putsf("7.Order TEST");
	__POINTW1FN _0x0,201
	CALL SUBOPT_0x2E
; 0000 05E3                     if(Middle_switch_on)    test_order();
	SBIC 0x1,2
	RJMP _0x122
	CALL _test_order
; 0000 05E4                     delay_ms(100);
_0x122:
	RJMP _0x13B
; 0000 05E5                     break;
; 0000 05E6 
; 0000 05E7             case 7:
_0x121:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x123
; 0000 05E8                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05E9                     lcd_gotoxy(0, 0);
; 0000 05EA                     lcd_putsf("8.Valve Order");
	__POINTW1FN _0x0,214
	CALL SUBOPT_0x2E
; 0000 05EB                     if(Middle_switch_on)    valve_order();
	SBIC 0x1,2
	RJMP _0x124
	CALL _valve_order
; 0000 05EC                     delay_ms(100);
_0x124:
	RJMP _0x13B
; 0000 05ED                     break;
; 0000 05EE 
; 0000 05EF             case 8:
_0x123:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x125
; 0000 05F0                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05F1                     lcd_gotoxy(0, 0);
; 0000 05F2                     lcd_putsf("9.Threshold?");
	__POINTW1FN _0x0,228
	CALL SUBOPT_0x2E
; 0000 05F3                     if(Middle_switch_on)    measure_threshold();
	SBIS 0x1,2
	RCALL _measure_threshold
; 0000 05F4                     delay_ms(100);
	RJMP _0x13B
; 0000 05F5                     break;
; 0000 05F6 
; 0000 05F7             case 9:
_0x125:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x127
; 0000 05F8                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 05F9                     lcd_gotoxy(0, 0);
; 0000 05FA                     lcd_putsf("10.PUMP VALVE");
	__POINTW1FN _0x0,241
	CALL SUBOPT_0x2E
; 0000 05FB                     if(Middle_switch_on)    pump_valve();
	SBIS 0x1,2
	RCALL _pump_valve
; 0000 05FC                     delay_ms(100);
	RJMP _0x13B
; 0000 05FD                     break;
; 0000 05FE 
; 0000 05FF             case 10:
_0x127:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x129
; 0000 0600                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 0601                     lcd_gotoxy(0, 0);
; 0000 0602                     lcd_putsf("11.Daily test");
	__POINTW1FN _0x0,255
	CALL SUBOPT_0x2E
; 0000 0603                     if(Middle_switch_on)    RUN_daily();
	SBIS 0x1,2
	RCALL _RUN_daily
; 0000 0604                     delay_ms(100);
	RJMP _0x13B
; 0000 0605                     break;
; 0000 0606 
; 0000 0607             case 11:
_0x129:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0608                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 0609                     lcd_gotoxy(0, 0);
; 0000 060A                     lcd_putsf("12.Rehab test");
	__POINTW1FN _0x0,269
	CALL SUBOPT_0x2E
; 0000 060B                     if(Middle_switch_on)    RUN_rehab();
	SBIS 0x1,2
	RCALL _RUN_rehab
; 0000 060C                     delay_ms(100);
	RJMP _0x13B
; 0000 060D                     break;
; 0000 060E 
; 0000 060F             case 12:
_0x12B:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0610                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 0611                     lcd_gotoxy(0, 0);
; 0000 0612                     lcd_putsf("13.TEST");
	__POINTW1FN _0x0,283
	CALL SUBOPT_0x2E
; 0000 0613                     if(Middle_switch_on)    test();
	SBIS 0x1,2
	RCALL _test
; 0000 0614                     delay_ms(100);
	RJMP _0x13B
; 0000 0615                     break;
; 0000 0616 
; 0000 0617             case 13:
_0x12D:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0618                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 0619                     lcd_gotoxy(0, 0);
; 0000 061A                     lcd_putsf("14.TEST2");
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x2E
; 0000 061B                     if(Middle_switch_on)    test2();
	SBIS 0x1,2
	RCALL _test2
; 0000 061C                     delay_ms(100);
	RJMP _0x13B
; 0000 061D                     break;
; 0000 061E 
; 0000 061F             case 14:
_0x12F:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x133
; 0000 0620                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 0621                     lcd_gotoxy(0, 0);
; 0000 0622                     lcd_putsf("15.TEST3");
	__POINTW1FN _0x0,300
	CALL SUBOPT_0x2E
; 0000 0623                     if(Middle_switch_on)    test3();
	SBIS 0x1,2
	RCALL _test3
; 0000 0624                     delay_ms(100);
	RJMP _0x13B
; 0000 0625                     break;
; 0000 0626 
; 0000 0627              default :
_0x133:
; 0000 0628                     lcd_clear();
	CALL SUBOPT_0xB
; 0000 0629                     lcd_gotoxy(0, 0);
; 0000 062A                     lcd_putsf("**BREAK!**");
	__POINTW1FN _0x0,309
	CALL SUBOPT_0x2E
; 0000 062B                     delay_ms(100);
_0x13B:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 062C                     break;
; 0000 062D 
; 0000 062E          }
; 0000 062F       }
	RJMP _0x10A
; 0000 0630 
; 0000 0631 }
_0x134:
	RJMP _0x134
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x61
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x66
_0x2000016:
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
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x90
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x90
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x91
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x92
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x91
	CALL SUBOPT_0x93
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x91
	CALL SUBOPT_0x93
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x91
	CALL SUBOPT_0x94
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x91
	CALL SUBOPT_0x94
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x90
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x90
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
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
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x92
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x90
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x92
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x95
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x95
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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
	JMP  _0x2080001
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
	CALL SUBOPT_0x28
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
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
	JMP  _0x2080001
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
	RJMP _0x2080002
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x2080002:
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
	RJMP _0x2080001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x96
	CALL SUBOPT_0x96
	CALL SUBOPT_0x96
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x97
	LDI  R30,LOW(4)
	CALL SUBOPT_0x97
	LDI  R30,LOW(133)
	CALL SUBOPT_0x97
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET

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
_sam_num:
	.BYTE 0x1
_i:
	.BYTE 0x2
_lcd_data:
	.BYTE 0x28
_mux:
	.BYTE 0x1
_d_flag:
	.BYTE 0x1
_pressure_data:
	.BYTE 0xC8
_pressure_sum:
	.BYTE 0x8
_pressure_mean:
	.BYTE 0x4
_flex_data:
	.BYTE 0xC8
_flex_sum:
	.BYTE 0x8
_flex_mean:
	.BYTE 0x4
_flex_max:
	.BYTE 0x4
_flex_min:
	.BYTE 0x4
_pressure_max:
	.BYTE 0x4
_pressure_min:
	.BYTE 0x4
_E_flag:
	.BYTE 0x4
_F_flag:
	.BYTE 0x4
_Global_Sequence:
	.BYTE 0x1
_arrived:
	.BYTE 0x8
_kp:
	.BYTE 0x4
_ki:
	.BYTE 0x4
_kd:
	.BYTE 0x4
_error_old:
	.BYTE 0x10
_error_sum:
	.BYTE 0x10
_ang_old:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_Global_Sequence
	LDI  R26,LOW(_arrived)
	LDI  R27,HIGH(_arrived)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDD  R30,Y+2
	LDI  R26,LOW(_pressure_sum)
	LDI  R27,HIGH(_pressure_sum)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	LD   R22,Z
	LDD  R23,Z+1
	LDD  R30,Y+2
	LDI  R26,LOW(50)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3:
	MOVW R26,R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	LDI  R31,0
	ADD  R30,R22
	ADC  R31,R23
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	STS  _d_flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDD  R30,Y+2
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	MOVW R0,R30
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R26,Z
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDD  R26,Y+2
	LDI  R27,0
	SUBI R26,LOW(-_pressure_mean)
	SBCI R27,HIGH(-_pressure_mean)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xA:
	ST   -Y,R17
	LDI  R17,0
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:165 WORDS
SUBOPT_0xB:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:244 WORDS
SUBOPT_0xE:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__POINTW1FN _0x0,11
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x12:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	LDD  R30,Y+2
	LDI  R26,LOW(_flex_sum)
	LDI  R27,HIGH(_flex_sum)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	MOVW R0,R30
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R26,Z
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDD  R26,Y+2
	LDI  R27,0
	SUBI R26,LOW(-_flex_mean)
	SBCI R27,HIGH(-_flex_mean)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	CALL _mean_flex
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R31,0
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(20)
	OUT  0x37,R30
	STS  125,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1D:
	__POINTW1FN _0x0,19
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	OUT  0x37,R30
	STS  125,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	OUT  0x2B,R30
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	CALL __ASRW8
	OUT  0x29,R30
	LDI  R26,LOW(50)
	MULS R16,R26
	MOVW R30,R0
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x21:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R16
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	MOV  R30,R17
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	CALL __LSLW12
	MOV  R26,R16
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	__POINTW1FN _0x0,29
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	__POINTW1FN _0x0,31
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	MOVW R0,R30
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	MOVW R30,R0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x34:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,_Global_Sequence
	ST   -Y,R30
	CALL _disp
	LDI  R30,LOW(5)
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Global_Sequence
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x37:
	LDS  R30,_Global_Sequence
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(3)
	OUT  0x2B,R30
	LDI  R30,LOW(32)
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(0)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3B:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3C:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RCALL SUBOPT_0x3C
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(0)
	OUT  0x18,R30
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	__POINTW1FN _0x0,58
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x43:
	STS  _Global_Sequence,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(_flex_max)
	LDI  R27,HIGH(_flex_max)
	ADD  R26,R16
	ADC  R27,R17
	LD   R0,X
	CLR  R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x46:
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CLR  R27
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x47:
	CALL __DIVF21
	__GETD2N 0x42700000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	MOVW R26,R28
	ADIW R26,4
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	CALL __CFD1
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4B:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	LDD  R30,Y+19
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4D:
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R30,Z
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4E:
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x50:
	__GETD2S 14
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x51:
	LD   R26,Z
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x52:
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	LDD  R30,Y+19
	LDI  R26,LOW(_error_sum)
	LDI  R27,HIGH(_error_sum)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	CALL __GETD1P
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x55:
	__GETD1S 6
	LDS  R26,_kp
	LDS  R27,_kp+1
	LDS  R24,_kp+2
	LDS  R25,_kp+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x57:
	LDS  R26,_ki
	LDS  R27,_ki+1
	LDS  R24,_ki+2
	LDS  R25,_ki+3
	CALL __MULF12
	__GETD2N 0x3D75C28F
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	LDD  R30,Y+19
	LDI  R26,LOW(_error_old)
	LDI  R27,HIGH(_error_old)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x59:
	CALL __SWAPD12
	CALL __SUBF12
	LDS  R26,_kd
	LDS  R27,_kd+1
	LDS  R24,_kd+2
	LDS  R25,_kd+3
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3D75C28F
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	CALL __ADDF12
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5D:
	__GETD1N 0x455AC000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	RCALL SUBOPT_0x5C
	__GETD1N 0x44480000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	__GETD1N 0x44480000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x60:
	LDD  R30,Y+19
	LDI  R26,LOW(_arrived)
	LDI  R27,HIGH(_arrived)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x62:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x63:
	CALL __CFD1
	CALL __ASRW8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x62
	RJMP SUBOPT_0x63

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x66:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	LDI  R30,LOW(19)
	OUT  0x29,R30
	LDI  R30,LOW(86)
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x68:
	LDS  R30,_i
	LSL  R30
	ST   -Y,R30
	LDS  R30,_i
	ST   -Y,R30
	JMP  _disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	ST   -Y,R17
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	MOVW R30,R0
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	RJMP SUBOPT_0x51

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	MOVW R30,R22
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6C:
	CALL __SWAPW12
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6D:
	MOVW R30,R24
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	RJMP SUBOPT_0x51

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(_arrived)
	LDI  R27,HIGH(_arrived)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	LDI  R30,LOW(0)
	STS  135,R30
	STS  134,R30
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	LDI  R31,0
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x72:
	LDD  R30,Y+4
	CALL __GETD2S0
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x73:
	LDD  R30,Y+6
	LDI  R26,LOW(_arrived)
	LDI  R27,HIGH(_arrived)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(11)
	STS  135,R30
	LDI  R30,LOW(184)
	STS  134,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	JMP  _rehab_move

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(10)
	ST   -Y,R30
	JMP  _rehab_move

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	LDI  R30,LOW(60)
	ST   -Y,R30
	JMP  _rehab_move

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7B:
	LDI  R30,LOW(40)
	ST   -Y,R30
	JMP  _rehab_move

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x79

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7D:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7F:
	MOV  R30,R17
	LDI  R26,LOW(_arrived)
	LDI  R27,HIGH(_arrived)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x80:
	LDI  R30,LOW(19)
	OUT  0x27,R30
	LDI  R30,LOW(135)
	OUT  0x26,R30
	LDI  R30,LOW(19)
	STS  129,R30
	LDI  R30,LOW(135)
	STS  128,R30
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x81:
	LDI  R30,LOW(0)
	STS  135,R30
	STS  134,R30
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x82:
	STS  _E_flag,R30
	LDI  R30,LOW(0)
	STS  _F_flag,R30
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	LDI  R17,0
	LDI  R16,15
	__GETWRN 18,19,3500
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x84:
	MOVW R30,R18
	CALL __ASRW8
	OUT  0x2B,R30
	OUT  0x2A,R18
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x85:
	MOV  R26,R16
	CLR  R27
	__GETB1MN _ang_old,2
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x86:
	__GETD1MN _error_sum,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x87:
	CALL __ADDF12
	__PUTD1MN _error_sum,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	__GETD1MN _error_old,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x89:
	__PUTD1MN _error_old,8
	__POINTW2MN _ang_old,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8B:
	ADIW R30,2
	__GETD2S 20
	CALL __CWD1
	CALL __CDF1
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8C:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8D:
	SBIW R30,2
	__GETD2S 20
	CALL __CWD1
	CALL __CDF1
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8E:
	OUT  0x37,R30
	LDI  R30,LOW(0)
	STS  125,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8F:
	__GETD2S 22
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x90:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x91:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x92:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x93:
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
SUBOPT_0x94:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x95:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x96:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x97:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


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

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
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

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

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
	BRVS __ADDF1211
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
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
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

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
