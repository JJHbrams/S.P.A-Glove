
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
	.DB  0xFF,0xFF,0xFF,0xFF
_0x5:
	.DB  0x17,0xB7,0xD1,0x38
_0x6:
	.DB  0xA
_0x99:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x3F,0x0,0x0,0x80,0x3F
_0xBB:
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
	.DB  0x53,0x0,0x31,0x2E,0x50,0x72,0x65,0x73
	.DB  0x73,0x75,0x72,0x65,0x20,0x54,0x45,0x53
	.DB  0x54,0x0,0x32,0x2E,0x50,0x72,0x65,0x73
	.DB  0x73,0x75,0x72,0x65,0x20,0x54,0x75,0x6E
	.DB  0x6E,0x69,0x6E,0x67,0x0,0x33,0x2E,0x46
	.DB  0x6C,0x65,0x78,0x20,0x54,0x45,0x53,0x54
	.DB  0x0,0x34,0x2E,0x46,0x6C,0x65,0x78,0x20
	.DB  0x54,0x75,0x6E,0x6E,0x69,0x6E,0x67,0x0
	.DB  0x35,0x2E,0x50,0x57,0x4D,0x20,0x54,0x45
	.DB  0x53,0x54,0x0,0x36,0x2E,0x50,0x55,0x4D
	.DB  0x50,0x20,0x54,0x45,0x53,0x54,0x0,0x37
	.DB  0x2E,0x4F,0x72,0x64,0x65,0x72,0x20,0x54
	.DB  0x45,0x53,0x54,0x0,0x38,0x2E,0x56,0x61
	.DB  0x6C,0x76,0x65,0x20,0x4F,0x72,0x64,0x65
	.DB  0x72,0x0,0x39,0x2E,0x54,0x68,0x72,0x65
	.DB  0x73,0x68,0x6F,0x6C,0x64,0x3F,0x0,0x31
	.DB  0x30,0x2E,0x50,0x55,0x4D,0x50,0x20,0x56
	.DB  0x41,0x4C,0x56,0x45,0x0,0x2A,0x2A,0x42
	.DB  0x52,0x45,0x41,0x4B,0x21,0x2A,0x2A,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _flex_min
	.DW  _0x3*2

	.DW  0x04
	.DW  _pressure_min
	.DW  _0x4*2

	.DW  0x04
	.DW  _kp
	.DW  _0x5*2

	.DW  0x01
	.DW  _delta_ang
	.DW  _0x6*2

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
;Version : 2.1.0
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
;// Alphanumeric LCD Module functions
;#include <lcd.h>
;#asm
 .equ __lcd_port = 0x12 //PORTD 8
; 0000 001C #endasm
;// About ADC
;#define ADC_VREF_TYPE 0x60
;#define NUM_SAMP  50  //MUST be Under 255
;//About Switch
;#define Left_switch_on    (!PINE.3)
;#define Middle_switch_on  (!PINE.2)
;#define Right_switch_on   (!PINE.1)
;#define Left_switch_off   (PINE.3)
;#define Middle_switch_off (PINE.2)
;#define Right_switch_off  (PINE.1)
;//About order
;#define Up_thumb          (!PINE.5)
;#define Down_thumb        (!PINA.1)
;#define Up_index          (!PINA.2)
;#define Down_index        (!PINA.3)
;#define Up_middle         (!PINA.4)
;#define Down_middle       (!PINA.5)
;#define Up_rest           (!PINA.6)
;#define Down_rest         (!PINA.7)
;
;#define NO_SIGNAL_tu      (PINE.5)
;#define NO_SIGNAL_td      (PINA.1)
;#define NO_SIGNAL_iu      (PINA.2)
;#define NO_SIGNAL_id      (PINA.3)
;#define NO_SIGNAL_mu      (PINA.4)
;#define NO_SIGNAL_md      (PINA.5)
;#define NO_SIGNAL_ru      (PINA.6)
;#define NO_SIGNAL_rd      (PINA.7)
;
;//About u saturation
;#define UPPER   3790
;#define LOWER   1250
;//About RUN
;#define NORMAL_SPEED  500 //Only relates to reaction speed...
;#define INITIATE  TIMSK = 0x14, ETIMSK = 0x14   //TIM1_COMPA interrupt on, TIM1_OVF interrupt on (Inlet Valve control)
;                                                //TIM3_COMPA interrupt on, TIM3_OVF interrupt on (Outlet Valve control)
;
;#define TERMINATE TIMSK = 0x00, ETIMSK = 0x00   //TIM1_COMPA interrupt off, TIM1_OVF interrupt off (Inlet Valve control)
;                                                //TIM3_COMPA interrupt off, TIM3_OVF interrupt off (Outlet Valve control)
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
;unsigned char flex_max[4] = {0};
;unsigned char flex_min[4] = {255, 255, 255, 255};

	.DSEG
;unsigned char pressure_max[4] = {0};
;unsigned char pressure_min[4] = {255, 255, 255, 255};
;
;// Moving
;unsigned char E_flag[4]={0}; //EXTENSION : 1
;unsigned char F_flag[4]={0}; //FLEXTION : 1
;unsigned char Global_Sequence=0;
;
;// PID
;double kp=0.0001;
;double ki=0.0000;
;double kd=0.0000;
;double error_old[4]={0};
;double error_sum[4]={0};
;unsigned char ang_desired=0;
;unsigned char ang_old[4]={0};//Initial angle : 0 degrees
;unsigned char delta_ang=10;//10 degrees per each sequence(EXPERIMENT NEED!)
;unsigned const char Ts=60; //Control sequence term in [ms]
;//*****************************************************************************************************************
;// Timer 1 Controls INLET!!
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0075 {

	.CSEG
_timer1_compa_isr:
	CALL SUBOPT_0x0
; 0000 0076   PORTC |= 0x01<<Global_Sequence;//INLET Valve on
	LDI  R26,LOW(1)
	RJMP _0xE7
; 0000 0077 }
;// Timer1 overflow A interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 007A {
_timer1_ovf_isr:
	RJMP _0xE6
; 0000 007B   PORTC=0x00;//INLET Valve off
; 0000 007C }
;// Timer 3 Controls OUTLET!!
;// Timer3 comparematch A interrupt service routine
;interrupt [TIM3_COMPA] void timer3_compa_isr(void)
; 0000 0080 {
_timer3_compa_isr:
	CALL SUBOPT_0x0
; 0000 0081   PORTC |= 0x10<<Global_Sequence;//OUTLET Valve on
	LDI  R26,LOW(16)
_0xE7:
	CALL __LSLB12
	OR   R30,R1
	OUT  0x15,R30
; 0000 0082 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;// Timer1 output compare A interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 0085 {
_timer3_ovf_isr:
_0xE6:
	ST   -Y,R30
; 0000 0086   PORTC=0x00;//OUTLET Valve off
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0087 }
	LD   R30,Y+
	RETI
;// ********************************* ADC interrupt service routine ************************************************
;interrupt [ADC_INT] void adc_isr(void)
; 0000 008A {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008B     // Read the AD conversion result
; 0000 008C     //for (h = 0; h<=6; h++);
; 0000 008D     if(mux>4)           flex_data[mux-4][sam_num] = ADCH;   // 4, 5, 6, 7
	LDS  R26,_mux
	CPI  R26,LOW(0x5)
	BRLO _0x7
	LDS  R30,_mux
	LDI  R31,0
	SBIW R30,4
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	CALL __MULW12U
	SUBI R30,LOW(-_flex_data)
	SBCI R31,HIGH(-_flex_data)
	RJMP _0xE3
; 0000 008E     else                pressure_data[mux][sam_num] = ADCH;     // 0, 1, 2, 3
_0x7:
	LDS  R30,_mux
	LDI  R26,LOW(50)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_pressure_data)
	SBCI R31,HIGH(-_pressure_data)
_0xE3:
	MOVW R26,R30
	LDS  R30,_sam_num
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x5
	ST   X,R30
; 0000 008F     //ADC sampling
; 0000 0090     if(sam_num == NUM_SAMP)
	LDS  R26,_sam_num
	CPI  R26,LOW(0x32)
	BRNE _0x9
; 0000 0091     {
; 0000 0092         mux++;
	LDS  R30,_mux
	SUBI R30,-LOW(1)
	STS  _mux,R30
; 0000 0093         sam_num=0;
	LDI  R30,LOW(0)
	STS  _sam_num,R30
; 0000 0094         d_flag=1;
	LDI  R30,LOW(1)
	STS  _d_flag,R30
; 0000 0095     }
; 0000 0096 
; 0000 0097     mux &= 0x07;  //mux : 0~7
_0x9:
	LDS  R30,_mux
	ANDI R30,LOW(0x7)
	STS  _mux,R30
; 0000 0098     ADMUX = mux | 0x60;
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0099     ADCSRA |= 0x40;
	SBI  0x6,6
; 0000 009A     sam_num++;
	LDS  R30,_sam_num
	SUBI R30,-LOW(1)
	STS  _sam_num,R30
; 0000 009B }
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
; 0000 009F {
_mean_pressure:
; 0000 00A0     unsigned char num = 0; // counting variable for function
; 0000 00A1     while(!d_flag);
	ST   -Y,R17
;	sequence -> Y+2
;	tunned -> Y+1
;	num -> R17
	LDI  R17,0
_0xA:
	LDS  R30,_d_flag
	CPI  R30,0
	BREQ _0xA
; 0000 00A2     for(num = 0; num < NUM_SAMP; num++)
	LDI  R17,LOW(0)
_0xE:
	CPI  R17,50
	BRSH _0xF
; 0000 00A3         pressure_sum[sequence] += pressure_data[sequence][num];
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_pressure_data)
	SBCI R31,HIGH(-_pressure_data)
	CALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0xE
_0xF:
; 0000 00A4 pressure_mean[sequence] = pressure_sum[sequence]/50  ;
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	MOVW R22,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x5
; 0000 00A5     pressure_sum[sequence] = 0;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x6
; 0000 00A6     d_flag=0;
; 0000 00A7 
; 0000 00A8     if(tunned)
	BREQ _0x10
; 0000 00A9     {
; 0000 00AA       if(pressure_mean[sequence]>pressure_max[sequence])  pressure_mean[sequence]=pressure_max[sequence];
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x11
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	ST   X,R30
; 0000 00AB       if(pressure_mean[sequence]<pressure_min[sequence])  pressure_mean[sequence]=pressure_min[sequence];
_0x11:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x12
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	ST   X,R30
; 0000 00AC     }
_0x12:
; 0000 00AD }
_0x10:
	RJMP _0x2080008
;//Pressure test
;void pressure_test(void)
; 0000 00B0 {
_pressure_test:
; 0000 00B1     unsigned char num = 0;
; 0000 00B2     delay_ms(50);
	CALL SUBOPT_0x9
;	num -> R17
; 0000 00B3 
; 0000 00B4     while(Middle_switch_off)
_0x13:
	SBIS 0x1,2
	RJMP _0x15
; 0000 00B5     {
; 0000 00B6         lcd_clear();
	CALL SUBOPT_0xA
; 0000 00B7         lcd_gotoxy(0, 0);
; 0000 00B8         lcd_putsf("Testing");
	CALL SUBOPT_0xB
; 0000 00B9 
; 0000 00BA         if(Left_switch_on)  num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 00BB         if(Right_switch_on) num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 00BC         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x18
	LDI  R17,LOW(3)
; 0000 00BD         mean_pressure((unsigned char)num,0);
_0x18:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 00BE 
; 0000 00BF         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xC
; 0000 00C0         sprintf(lcd_data, "%d", num);
	CALL SUBOPT_0xD
; 0000 00C1         lcd_puts(lcd_data);
; 0000 00C2         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xE
; 0000 00C3         sprintf(lcd_data, "%d", pressure_mean[num]);
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	CALL SUBOPT_0xD
; 0000 00C4         lcd_puts(lcd_data);
; 0000 00C5 
; 0000 00C6         delay_ms(200);
	CALL SUBOPT_0xF
; 0000 00C7     }
	RJMP _0x13
_0x15:
; 0000 00C8 }
	RJMP _0x2080006
;
;// Pressure tuning
;void pressure_tuning(void)
; 0000 00CC {
_pressure_tuning:
; 0000 00CD     unsigned char num = 0;
; 0000 00CE     delay_ms(50);
	CALL SUBOPT_0x9
;	num -> R17
; 0000 00CF 
; 0000 00D0     while(Middle_switch_off)
_0x19:
	SBIS 0x1,2
	RJMP _0x1B
; 0000 00D1     {
; 0000 00D2         lcd_clear();
	CALL SUBOPT_0xA
; 0000 00D3         lcd_gotoxy(0, 0);
; 0000 00D4         lcd_putsf("Tunning");
	CALL SUBOPT_0x10
; 0000 00D5 
; 0000 00D6         if(Left_switch_on)  num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 00D7         if(Right_switch_on) num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 00D8         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x1E
	LDI  R17,LOW(3)
; 0000 00D9 
; 0000 00DA         mean_pressure((unsigned char)num,0);
_0x1E:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 00DB 
; 0000 00DC         if(pressure_mean[num]>pressure_max[num])  pressure_max[num]=pressure_mean[num];
	CALL SUBOPT_0x11
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x1F
	CALL SUBOPT_0x12
	SUBI R26,LOW(-_pressure_max)
	SBCI R27,HIGH(-_pressure_max)
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	ST   X,R30
; 0000 00DD         if(pressure_mean[num]<pressure_min[num])  pressure_min[num]=pressure_mean[num];
_0x1F:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x20
	CALL SUBOPT_0x12
	SUBI R26,LOW(-_pressure_min)
	SBCI R27,HIGH(-_pressure_min)
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	ST   X,R30
; 0000 00DE 
; 0000 00DF         lcd_gotoxy(7, 0);
_0x20:
	CALL SUBOPT_0x13
; 0000 00E0         sprintf(lcd_data, "%d", num);
; 0000 00E1         lcd_puts(lcd_data);
; 0000 00E2         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xC
; 0000 00E3         sprintf(lcd_data, "%d", pressure_min[num]);
	LDI  R31,0
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CALL SUBOPT_0xD
; 0000 00E4         lcd_puts(lcd_data);
; 0000 00E5         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xE
; 0000 00E6         sprintf(lcd_data, "%d", pressure_max[num]);
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CALL SUBOPT_0xD
; 0000 00E7         lcd_puts(lcd_data);
; 0000 00E8         delay_ms(100);
	CALL SUBOPT_0x14
; 0000 00E9     }
	RJMP _0x19
_0x1B:
; 0000 00EA }
	RJMP _0x2080006
;
;// ******************************** About Flex Sensor *******************************************************
;void mean_flex(unsigned char sequence, unsigned char tunned)
; 0000 00EE {
_mean_flex:
; 0000 00EF     unsigned char num = 0; // counting variable for function
; 0000 00F0     while(!d_flag);
	ST   -Y,R17
;	sequence -> Y+2
;	tunned -> Y+1
;	num -> R17
	LDI  R17,0
_0x21:
	LDS  R30,_d_flag
	CPI  R30,0
	BREQ _0x21
; 0000 00F1     for(num = 0; num < NUM_SAMP; num++)
	LDI  R17,LOW(0)
_0x25:
	CPI  R17,50
	BRSH _0x26
; 0000 00F2         flex_sum[sequence] += flex_data[sequence][num];
	CALL SUBOPT_0x15
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_flex_data)
	SBCI R31,HIGH(-_flex_data)
	CALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0x25
_0x26:
; 0000 00F3 flex_mean[sequence] = flex_sum[sequence]/50  ;
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	MOVW R22,R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x5
; 0000 00F4     flex_sum[sequence] = 0;
	CALL SUBOPT_0x15
	CALL SUBOPT_0x6
; 0000 00F5     d_flag=0;
; 0000 00F6     if(tunned)
	BREQ _0x27
; 0000 00F7     {
; 0000 00F8       if(flex_mean[sequence]>flex_max[sequence])  flex_mean[sequence]=flex_max[sequence];
	CALL SUBOPT_0x4
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x28
	CALL SUBOPT_0x17
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	ST   X,R30
; 0000 00F9       if(flex_mean[sequence]<flex_min[sequence])  flex_mean[sequence]=flex_min[sequence];
_0x28:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x29
	CALL SUBOPT_0x17
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	ST   X,R30
; 0000 00FA     }
_0x29:
; 0000 00FB }
_0x27:
_0x2080008:
	LDD  R17,Y+0
	ADIW R28,3
	RET
;//Pressure test
;void flex_test(void)
; 0000 00FE {
_flex_test:
; 0000 00FF     unsigned char num = 0;
; 0000 0100     delay_ms(50);
	CALL SUBOPT_0x9
;	num -> R17
; 0000 0101 
; 0000 0102     while(Middle_switch_off)
_0x2A:
	SBIS 0x1,2
	RJMP _0x2C
; 0000 0103     {
; 0000 0104         lcd_clear();
	CALL SUBOPT_0xA
; 0000 0105         lcd_gotoxy(0, 0);
; 0000 0106         lcd_putsf("Testing");
	CALL SUBOPT_0xB
; 0000 0107 
; 0000 0108         if(Left_switch_on)  num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 0109         if(Right_switch_on) num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 010A         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x2F
	LDI  R17,LOW(3)
; 0000 010B         mean_flex((unsigned char)num,0);
_0x2F:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_flex
; 0000 010C 
; 0000 010D         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xC
; 0000 010E         sprintf(lcd_data, "%d", num);
	CALL SUBOPT_0xD
; 0000 010F         lcd_puts(lcd_data);
; 0000 0110         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xE
; 0000 0111         sprintf(lcd_data, "%d", flex_mean[num]);
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	CALL SUBOPT_0xD
; 0000 0112         lcd_puts(lcd_data);
; 0000 0113 
; 0000 0114         delay_ms(200);
	CALL SUBOPT_0xF
; 0000 0115     }
	RJMP _0x2A
_0x2C:
; 0000 0116 }
	RJMP _0x2080006
;
;// flex tuning
;void flex_tuning(void)
; 0000 011A {
_flex_tuning:
; 0000 011B     unsigned char num = 0;
; 0000 011C     delay_ms(50);
	CALL SUBOPT_0x9
;	num -> R17
; 0000 011D 
; 0000 011E     while(Middle_switch_off)
_0x30:
	SBIS 0x1,2
	RJMP _0x32
; 0000 011F     {
; 0000 0120         lcd_clear();
	CALL SUBOPT_0xA
; 0000 0121         lcd_gotoxy(0, 0);
; 0000 0122         lcd_putsf("Tunning");
	CALL SUBOPT_0x10
; 0000 0123 
; 0000 0124         if(Left_switch_on)  num++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 0125         if(Right_switch_on) num--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 0126         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x35
	LDI  R17,LOW(3)
; 0000 0127         mean_flex((unsigned char)num,0);
_0x35:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _mean_flex
; 0000 0128 
; 0000 0129         if(flex_mean[num]>flex_max[num])  flex_max[num]=flex_mean[num];
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x36
	CALL SUBOPT_0x12
	SUBI R26,LOW(-_flex_max)
	SBCI R27,HIGH(-_flex_max)
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	ST   X,R30
; 0000 012A         if(flex_mean[num]<flex_min[num])  flex_min[num]=flex_mean[num];
_0x36:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x37
	CALL SUBOPT_0x12
	SUBI R26,LOW(-_flex_min)
	SBCI R27,HIGH(-_flex_min)
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	ST   X,R30
; 0000 012B 
; 0000 012C         lcd_gotoxy(7, 0);
_0x37:
	CALL SUBOPT_0x13
; 0000 012D         sprintf(lcd_data, "%d", num);
; 0000 012E         lcd_puts(lcd_data);
; 0000 012F         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xC
; 0000 0130         sprintf(lcd_data, "%d", flex_min[num]);
	LDI  R31,0
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	CALL SUBOPT_0xD
; 0000 0131         lcd_puts(lcd_data);
; 0000 0132         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xE
; 0000 0133         sprintf(lcd_data, "%d", flex_max[num]);
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CALL SUBOPT_0xD
; 0000 0134         lcd_puts(lcd_data);
; 0000 0135 
; 0000 0136         delay_ms(100);
	CALL SUBOPT_0x14
; 0000 0137     }
	RJMP _0x30
_0x32:
; 0000 0138 }
	RJMP _0x2080006
;
;// ******************************** About PWM control *******************************************************
;void check_pwm(void)
; 0000 013C {
_check_pwm:
; 0000 013D     long temp = 50;//PWM interrupt control, 50% duty
; 0000 013E     delay_ms(50);
	SBIW R28,4
	LDI  R30,LOW(50)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	temp -> Y+0
	CALL SUBOPT_0x18
; 0000 013F 
; 0000 0140     INITIATE; //Timer interrupts on
	CALL SUBOPT_0x19
; 0000 0141     ICR1H=0x13;
	CALL SUBOPT_0x1A
; 0000 0142     ICR1L=0x87;
; 0000 0143     while(Middle_switch_off)
_0x38:
	SBIS 0x1,2
	RJMP _0x3A
; 0000 0144     {
; 0000 0145         if(Left_switch_on)  temp++;
	SBIC 0x1,3
	RJMP _0x3B
	CALL SUBOPT_0x1B
	__SUBD1N -1
	CALL SUBOPT_0x1C
; 0000 0146         if(Right_switch_on)  temp--;
_0x3B:
	SBIC 0x1,1
	RJMP _0x3C
	CALL SUBOPT_0x1B
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL SUBOPT_0x1C
; 0000 0147         if(temp<1) temp=1;
_0x3C:
	CALL __GETD2S0
	__CPD2N 0x1
	BRGE _0x3D
	__GETD1N 0x1
	CALL SUBOPT_0x1C
; 0000 0148         if(temp>99)  temp=99;
_0x3D:
	CALL __GETD2S0
	__CPD2N 0x64
	BRLT _0x3E
	__GETD1N 0x63
	CALL SUBOPT_0x1C
; 0000 0149         // TEST by LED berfore Valve delivered...
; 0000 014A         OCR1AH = temp*50>>8;
_0x3E:
	CALL SUBOPT_0x1B
	__GETD2N 0x32
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __ASRD12
	OUT  0x2B,R30
; 0000 014B         OCR1AL = temp*50;
	LD   R30,Y
	LDI  R26,LOW(50)
	MULS R30,R26
	MOVW R30,R0
	OUT  0x2A,R30
; 0000 014C 
; 0000 014D         lcd_clear();
	CALL SUBOPT_0xA
; 0000 014E         lcd_gotoxy(0, 0);
; 0000 014F         lcd_putsf("Duty");
	CALL SUBOPT_0x1D
; 0000 0150         lcd_gotoxy(0, 1);
; 0000 0151         sprintf(lcd_data, "%d %", temp);
	__GETD1S 4
	CALL SUBOPT_0x1E
; 0000 0152         lcd_puts(lcd_data);
; 0000 0153 
; 0000 0154         delay_ms(100);
; 0000 0155     }
	RJMP _0x38
_0x3A:
; 0000 0156     TERMINATE; //Timer interrupts off
	CALL SUBOPT_0x1F
; 0000 0157     PORTC=0x00;
	OUT  0x15,R30
; 0000 0158     OCR1AH = 0;
	CALL SUBOPT_0x20
; 0000 0159     OCR1AL = 0;//0% duty
; 0000 015A     ICR1H=0x13;
	CALL SUBOPT_0x1A
; 0000 015B     ICR1L=0x87;
; 0000 015C }
	RJMP _0x2080007
;
;// ******************************** About PWM control *******************************************************
;void PUMP_test()
; 0000 0160 {
_PUMP_test:
; 0000 0161     int temp = 50;//50% duty
; 0000 0162     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	__GETWRN 16,17,50
	CALL SUBOPT_0x18
; 0000 0163 
; 0000 0164     while(Middle_switch_off)
_0x3F:
	SBIS 0x1,2
	RJMP _0x41
; 0000 0165     {
; 0000 0166         if(Left_switch_on)  temp++;
	SBIC 0x1,3
	RJMP _0x42
	__ADDWRN 16,17,1
; 0000 0167         if(Right_switch_on)  temp--;
_0x42:
	SBIC 0x1,1
	RJMP _0x43
	__SUBWRN 16,17,1
; 0000 0168         if(temp<1) temp=1;
_0x43:
	__CPWRN 16,17,1
	BRGE _0x44
	__GETWRN 16,17,1
; 0000 0169         if(temp>99)  temp=99;
_0x44:
	__CPWRN 16,17,100
	BRLT _0x45
	__GETWRN 16,17,99
; 0000 016A         // TEST by LED berfore Valve delivered...
; 0000 016B         OCR1BH = temp*50 >>8;
_0x45:
	MOVW R30,R16
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	CALL __MULW12
	CALL SUBOPT_0x21
; 0000 016C         OCR1BL = temp*50;
; 0000 016D 
; 0000 016E         lcd_clear();
	CALL SUBOPT_0xA
; 0000 016F         lcd_gotoxy(0, 0);
; 0000 0170         lcd_putsf("Duty");
	CALL SUBOPT_0x1D
; 0000 0171         lcd_gotoxy(0, 1);
; 0000 0172         sprintf(lcd_data, "%d %", temp);
	MOVW R30,R16
	CALL __CWD1
	CALL SUBOPT_0x1E
; 0000 0173         lcd_puts(lcd_data);
; 0000 0174 
; 0000 0175         delay_ms(100);
; 0000 0176     }
	RJMP _0x3F
_0x41:
; 0000 0177     OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 0178     OCR1BL=0x00; //0% duty
; 0000 0179     PORTB=0x00;
	OUT  0x18,R30
; 0000 017A }
	RJMP _0x2080005
;
;// ******************************** About Order *******************************************************
;void order(unsigned char * sequence)
; 0000 017E {
_order:
; 0000 017F     unsigned char seq=*sequence;
; 0000 0180     unsigned char Order=0x00;
; 0000 0181 
; 0000 0182     if(Up_thumb)    Order|=0x01;
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
; 0000 0183     if(Up_index)    Order|=0x02;
	SBIS 0x19,2
	ORI  R16,LOW(2)
; 0000 0184     if(Up_middle)   Order|=0x04;
	SBIS 0x19,4
	ORI  R16,LOW(4)
; 0000 0185     if(Up_rest)     Order|=0x08;
	SBIS 0x19,6
	ORI  R16,LOW(8)
; 0000 0186     if(Down_thumb)  Order|=0x10;
	SBIS 0x19,1
	ORI  R16,LOW(16)
; 0000 0187     if(Down_index)  Order|=0x20;
	SBIS 0x19,3
	ORI  R16,LOW(32)
; 0000 0188     if(Down_middle) Order|=0x40;
	SBIS 0x19,5
	ORI  R16,LOW(64)
; 0000 0189     if(Down_rest)   Order|=0x80;
	SBIS 0x19,7
	ORI  R16,LOW(128)
; 0000 018A     if(NO_SIGNAL_tu&&NO_SIGNAL_td) Order&=0xEE;
	SBIS 0x1,5
	RJMP _0x4F
	SBIC 0x19,1
	RJMP _0x50
_0x4F:
	RJMP _0x4E
_0x50:
	ANDI R16,LOW(238)
; 0000 018B     if(NO_SIGNAL_iu&&NO_SIGNAL_id) Order&=0xDD;
_0x4E:
	SBIS 0x19,2
	RJMP _0x52
	SBIC 0x19,3
	RJMP _0x53
_0x52:
	RJMP _0x51
_0x53:
	ANDI R16,LOW(221)
; 0000 018C     if(NO_SIGNAL_mu&&NO_SIGNAL_md) Order&=0xBB;
_0x51:
	SBIS 0x19,4
	RJMP _0x55
	SBIC 0x19,5
	RJMP _0x56
_0x55:
	RJMP _0x54
_0x56:
	ANDI R16,LOW(187)
; 0000 018D     if(NO_SIGNAL_ru&&NO_SIGNAL_rd) Order&=0x77;
_0x54:
	SBIS 0x19,6
	RJMP _0x58
	SBIC 0x19,7
	RJMP _0x59
_0x58:
	RJMP _0x57
_0x59:
	ANDI R16,LOW(119)
; 0000 018E     /*
; 0000 018F     lcd_clear();
; 0000 0190     lcd_gotoxy(0, 0);
; 0000 0191     sprintf(lcd_data, "%2x", Order);
; 0000 0192     lcd_puts(lcd_data);
; 0000 0193     */
; 0000 0194 
; 0000 0195     if(Order&(0x01<<seq))
_0x57:
	CALL SUBOPT_0x23
	BREQ _0x5A
; 0000 0196     {
; 0000 0197         E_flag[seq]=1;
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 0198         F_flag[seq]=0;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x24
; 0000 0199     }
; 0000 019A     if(Order&(0x10<<seq))
_0x5A:
	CALL SUBOPT_0x25
	BREQ _0x5B
; 0000 019B     {
; 0000 019C         E_flag[seq]=0;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x26
; 0000 019D         F_flag[seq]=1;
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 019E     }
; 0000 019F     if(!(Order&(0x01<<seq))&&!(Order&(0x10<<seq)))
_0x5B:
	CALL SUBOPT_0x23
	BRNE _0x5D
	CALL SUBOPT_0x25
	BREQ _0x5E
_0x5D:
	RJMP _0x5C
_0x5E:
; 0000 01A0     {
; 0000 01A1         E_flag[seq]=0;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x26
; 0000 01A2         F_flag[seq]=0;
	CALL SUBOPT_0x24
; 0000 01A3     }
; 0000 01A4 
; 0000 01A5     // sequence 0 : Thumb   PC0, PC4 on, PORTC = 0x11
; 0000 01A6     // sequence 1 : Index   PC1, PC5 on, PORTC = 0x22
; 0000 01A7     // sequence 2 : Middle  PC2, PC6 on, PORTC = 0x44
; 0000 01A8     // sequence 3 : Rest    PC3, PC7 on, PORTC = 0x88
; 0000 01A9     //PORTC = 0x11<<sequence;
; 0000 01AA     seq++;
_0x5C:
	SUBI R17,-1
; 0000 01AB     if(seq>3) seq=0;
	CPI  R17,4
	BRLO _0x5F
	LDI  R17,LOW(0)
; 0000 01AC     *sequence=seq;
_0x5F:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R17
; 0000 01AD }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2080007:
	ADIW R28,4
	RET
;
;void disp(unsigned char x, unsigned char seq)
; 0000 01B0 {
_disp:
; 0000 01B1     lcd_gotoxy(x, 1);
;	x -> Y+1
;	seq -> Y+0
	LDD  R30,Y+1
	CALL SUBOPT_0x27
; 0000 01B2     if(E_flag[seq])                     lcd_putsf("E");
	CALL SUBOPT_0x28
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x60
	__POINTW1FN _0x0,29
	CALL SUBOPT_0x29
; 0000 01B3     if(F_flag[seq])                     lcd_putsf("F");
_0x60:
	CALL SUBOPT_0x28
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x61
	__POINTW1FN _0x0,31
	CALL SUBOPT_0x29
; 0000 01B4     if((E_flag[seq]==0)&&(F_flag[seq]==0))  lcd_putsf("-");
_0x61:
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2A
	BRNE _0x63
	CALL SUBOPT_0x2B
	BREQ _0x64
_0x63:
	RJMP _0x62
_0x64:
	__POINTW1FN _0x0,33
	CALL SUBOPT_0x29
; 0000 01B5 }
_0x62:
	JMP  _0x2080003
;
;void test_order()
; 0000 01B8 {
_test_order:
; 0000 01B9     unsigned char sequence=0;
; 0000 01BA 
; 0000 01BB     delay_ms(50);
	CALL SUBOPT_0x9
;	sequence -> R17
; 0000 01BC     while(Middle_switch_off)
_0x65:
	SBIS 0x1,2
	RJMP _0x67
; 0000 01BD     {
; 0000 01BE         order(&sequence);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 01BF 
; 0000 01C0         lcd_clear();
	CALL SUBOPT_0xA
; 0000 01C1 
; 0000 01C2         lcd_gotoxy(0, 0);lcd_putsf("T");
	__POINTW1FN _0x0,35
	CALL SUBOPT_0x29
; 0000 01C3         lcd_gotoxy(2, 0);lcd_putsf("I");
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2C
	__POINTW1FN _0x0,37
	CALL SUBOPT_0x29
; 0000 01C4         lcd_gotoxy(4, 0);lcd_putsf("M");
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2C
	__POINTW1FN _0x0,39
	CALL SUBOPT_0x29
; 0000 01C5         lcd_gotoxy(6, 0);lcd_putsf("R");
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2C
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x29
; 0000 01C6 
; 0000 01C7         disp(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _disp
; 0000 01C8         disp(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _disp
; 0000 01C9         disp(4,2);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _disp
; 0000 01CA         disp(6,3);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _disp
; 0000 01CB 
; 0000 01CC 
; 0000 01CD         /*
; 0000 01CE         lcd_gotoxy(0, 1);
; 0000 01CF         sprintf(lcd_data, "%d", sequence);
; 0000 01D0         lcd_puts(lcd_data);
; 0000 01D1         */
; 0000 01D2         delay_ms(100);//Sequence term
	CALL SUBOPT_0x14
; 0000 01D3     }
	RJMP _0x65
_0x67:
; 0000 01D4 }
_0x2080006:
	LD   R17,Y+
	RET
;
;void valve_order()
; 0000 01D7 {
_valve_order:
; 0000 01D8     unsigned char seq=0;
; 0000 01D9     unsigned char temp=0;
; 0000 01DA 
; 0000 01DB     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	seq -> R17
;	temp -> R16
	LDI  R17,0
	LDI  R16,0
	CALL SUBOPT_0x18
; 0000 01DC     INITIATE;
	CALL SUBOPT_0x19
; 0000 01DD     while(Middle_switch_off)
_0x68:
	SBIS 0x1,2
	RJMP _0x6A
; 0000 01DE     {
; 0000 01DF         order(&seq);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 01E0         //Global_Sequence=seq;
; 0000 01E1 
; 0000 01E2         lcd_clear();
	CALL SUBOPT_0xA
; 0000 01E3         lcd_gotoxy(0, 0);lcd_putsf("Valve!");
	__POINTW1FN _0x0,43
	CALL SUBOPT_0x29
; 0000 01E4 
; 0000 01E5         if(Left_switch_on)  Global_Sequence++;
	SBIC 0x1,3
	RJMP _0x6B
	LDS  R30,_Global_Sequence
	SUBI R30,-LOW(1)
	STS  _Global_Sequence,R30
; 0000 01E6         if(Right_switch_on)  Global_Sequence--;
_0x6B:
	SBIC 0x1,1
	RJMP _0x6C
	LDS  R30,_Global_Sequence
	SUBI R30,LOW(1)
	STS  _Global_Sequence,R30
; 0000 01E7         if(Global_Sequence>3)   Global_Sequence=0;
_0x6C:
	LDS  R26,_Global_Sequence
	CPI  R26,LOW(0x4)
	BRLO _0x6D
	LDI  R30,LOW(0)
	STS  _Global_Sequence,R30
; 0000 01E8         if(Global_Sequence==0 && Right_switch_on)   Global_Sequence=3;
_0x6D:
	LDS  R26,_Global_Sequence
	CPI  R26,LOW(0x0)
	BRNE _0x6F
	SBIS 0x1,1
	RJMP _0x70
_0x6F:
	RJMP _0x6E
_0x70:
	LDI  R30,LOW(3)
	STS  _Global_Sequence,R30
; 0000 01E9 
; 0000 01EA         lcd_gotoxy(7, 0);
_0x6E:
	LDI  R30,LOW(7)
	CALL SUBOPT_0x2C
; 0000 01EB         sprintf(lcd_data, "%d", Global_Sequence);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0xD
; 0000 01EC         lcd_puts(lcd_data);
; 0000 01ED 
; 0000 01EE         disp(0,Global_Sequence);
	CALL SUBOPT_0x2E
; 0000 01EF 
; 0000 01F0         lcd_gotoxy(5, 1);
; 0000 01F1         sprintf(lcd_data, "%d", E_flag[Global_Sequence]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
; 0000 01F2         lcd_puts(lcd_data);
; 0000 01F3         lcd_gotoxy(7, 1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x27
; 0000 01F4         sprintf(lcd_data, "%d", F_flag[Global_Sequence]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
; 0000 01F5         lcd_puts(lcd_data);
; 0000 01F6 
; 0000 01F7 
; 0000 01F8         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==0))
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2A
	BRNE _0x72
	CALL SUBOPT_0x2B
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 01F9         {
; 0000 01FA             OCR1AH=500>>8;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 01FB             OCR1AL=500;
	LDI  R30,LOW(244)
	OUT  0x2A,R30
; 0000 01FC             OCR3AH=500>>8;
	LDI  R30,LOW(1)
	STS  135,R30
; 0000 01FD             OCR3AL=500;
	LDI  R30,LOW(244)
	STS  134,R30
; 0000 01FE         }
; 0000 01FF         if((E_flag[Global_Sequence]==1)&&(F_flag[Global_Sequence]==0))
_0x71:
	CALL SUBOPT_0x31
	MOVW R0,R30
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x75
	CALL SUBOPT_0x2B
	BREQ _0x76
_0x75:
	RJMP _0x74
_0x76:
; 0000 0200         {
; 0000 0201             OCR1AH=800>>8;
	LDI  R30,LOW(3)
	OUT  0x2B,R30
; 0000 0202             OCR1AL=800;
	LDI  R30,LOW(32)
	OUT  0x2A,R30
; 0000 0203             OCR3AH=200>>8;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0204             OCR3AL=200;
	LDI  R30,LOW(200)
	STS  134,R30
; 0000 0205         }
; 0000 0206         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==1))
_0x74:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2A
	BRNE _0x78
	MOVW R30,R0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 0207         {
; 0000 0208             OCR1AH=200>>8;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0209             OCR1AL=200;
	LDI  R30,LOW(200)
	OUT  0x2A,R30
; 0000 020A             OCR3AH=800>>8;
	LDI  R30,LOW(3)
	STS  135,R30
; 0000 020B             OCR3AL=800;
	LDI  R30,LOW(32)
	STS  134,R30
; 0000 020C         }
; 0000 020D         delay_ms(100);
_0x77:
	CALL SUBOPT_0x14
; 0000 020E     }
	RJMP _0x68
_0x6A:
; 0000 020F     TERMINATE;
	CALL SUBOPT_0x1F
; 0000 0210     Global_Sequence=0;
	STS  _Global_Sequence,R30
; 0000 0211     OCR1A =0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0212     OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 0213     OCR1BL=0x00;
; 0000 0214     for(i=0;i<4;i++)
	STS  _i,R30
	STS  _i+1,R30
_0x7B:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,4
	BRGE _0x7C
; 0000 0215     {
; 0000 0216         E_flag[i]=0;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 0217         F_flag[i]=0;
; 0000 0218     }
	CALL SUBOPT_0x34
	RJMP _0x7B
_0x7C:
; 0000 0219     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 021A     PORTC=0x00;
	OUT  0x15,R30
; 0000 021B }
	RJMP _0x2080005
;
;void pump_valve()
; 0000 021E {
_pump_valve:
; 0000 021F     unsigned char seq=0;
; 0000 0220     unsigned char temp=50;
; 0000 0221 
; 0000 0222     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	seq -> R17
;	temp -> R16
	LDI  R17,0
	LDI  R16,50
	CALL SUBOPT_0x18
; 0000 0223     INITIATE;
	CALL SUBOPT_0x19
; 0000 0224     while(Middle_switch_off)
_0x7D:
	SBIS 0x1,2
	RJMP _0x7F
; 0000 0225     {
; 0000 0226         order(&seq);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _order
	POP  R17
; 0000 0227         Global_Sequence=seq;
	STS  _Global_Sequence,R17
; 0000 0228 
; 0000 0229         lcd_clear();
	CALL SUBOPT_0xA
; 0000 022A         lcd_gotoxy(0, 0);lcd_putsf("Duty : ");
	__POINTW1FN _0x0,50
	CALL SUBOPT_0x29
; 0000 022B         lcd_gotoxy(6, 0);sprintf(lcd_data, "%2d %", temp);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x35
	__POINTW1FN _0x0,58
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CALL SUBOPT_0xD
; 0000 022C         lcd_puts(lcd_data);
; 0000 022D 
; 0000 022E         disp(0,Global_Sequence);
	CALL SUBOPT_0x2E
; 0000 022F 
; 0000 0230         lcd_gotoxy(5, 1);
; 0000 0231         sprintf(lcd_data, "%d", E_flag[Global_Sequence]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
; 0000 0232         lcd_puts(lcd_data);
; 0000 0233         lcd_gotoxy(7, 1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x27
; 0000 0234         sprintf(lcd_data, "%d", F_flag[Global_Sequence]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
; 0000 0235         lcd_puts(lcd_data);
; 0000 0236 
; 0000 0237 
; 0000 0238         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==0))
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2A
	BRNE _0x81
	CALL SUBOPT_0x2B
	BREQ _0x82
_0x81:
	RJMP _0x80
_0x82:
; 0000 0239         {
; 0000 023A             OCR1AH=50*50>>8;
	LDI  R30,LOW(9)
	OUT  0x2B,R30
; 0000 023B             OCR1AL=50*50;
	LDI  R30,LOW(196)
	OUT  0x2A,R30
; 0000 023C             OCR3AH=50*50>>8;
	LDI  R30,LOW(9)
	STS  135,R30
; 0000 023D             OCR3AL=50*50;
	LDI  R30,LOW(196)
	STS  134,R30
; 0000 023E         }
; 0000 023F         if((E_flag[Global_Sequence]==1)&&(F_flag[Global_Sequence]==0))
_0x80:
	CALL SUBOPT_0x31
	MOVW R0,R30
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x84
	CALL SUBOPT_0x2B
	BREQ _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 0240         {
; 0000 0241             OCR1AH=70*50>>8;
	LDI  R30,LOW(13)
	OUT  0x2B,R30
; 0000 0242             OCR1AL=70*50;
	LDI  R30,LOW(172)
	OUT  0x2A,R30
; 0000 0243             OCR3AH=30*50>>8;
	LDI  R30,LOW(5)
	STS  135,R30
; 0000 0244             OCR3AL=30*50;
	LDI  R30,LOW(220)
	STS  134,R30
; 0000 0245         }
; 0000 0246         if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==1))
_0x83:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2A
	BRNE _0x87
	MOVW R30,R0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ _0x88
_0x87:
	RJMP _0x86
_0x88:
; 0000 0247         {
; 0000 0248             OCR1AH=30*50>>8;
	LDI  R30,LOW(5)
	OUT  0x2B,R30
; 0000 0249             OCR1AL=30*50;
	LDI  R30,LOW(220)
	OUT  0x2A,R30
; 0000 024A             OCR3AH=70*50>>8;
	LDI  R30,LOW(13)
	STS  135,R30
; 0000 024B             OCR3AL=70*50;
	LDI  R30,LOW(172)
	STS  134,R30
; 0000 024C         }
; 0000 024D 
; 0000 024E         if(Left_switch_on)  temp++;
_0x86:
	SBIS 0x1,3
	SUBI R16,-1
; 0000 024F         if(Right_switch_on)  temp--;
	SBIS 0x1,1
	SUBI R16,1
; 0000 0250         if(temp<1) temp=1;
	CPI  R16,1
	BRSH _0x8B
	LDI  R16,LOW(1)
; 0000 0251         if(temp>99)  temp=99;
_0x8B:
	CPI  R16,100
	BRLO _0x8C
	LDI  R16,LOW(99)
; 0000 0252         // TEST by LED berfore Valve delivered...
; 0000 0253         OCR1BH = temp*50 >>8;
_0x8C:
	LDI  R30,LOW(50)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x21
; 0000 0254         OCR1BL = temp*50;
; 0000 0255 
; 0000 0256         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0257     }
	RJMP _0x7D
_0x7F:
; 0000 0258     TERMINATE;
	CALL SUBOPT_0x1F
; 0000 0259     Global_Sequence=0;
	STS  _Global_Sequence,R30
; 0000 025A     OCR1AH=0x00;
	CALL SUBOPT_0x20
; 0000 025B     OCR1AL=0x00;
; 0000 025C     OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 025D     OCR1BL=0x00;
; 0000 025E     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 025F     OCR1BL=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 0260     for(i=0;i<4;i++)
	STS  _i,R30
	STS  _i+1,R30
_0x8E:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,4
	BRGE _0x8F
; 0000 0261     {
; 0000 0262         E_flag[i]=0;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 0263         F_flag[i]=0;
; 0000 0264     }
	CALL SUBOPT_0x34
	RJMP _0x8E
_0x8F:
; 0000 0265     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0266     PORTC=0x00;
	OUT  0x15,R30
; 0000 0267 }
	RJMP _0x2080005
;
;//**************************************%%%&&&&&&&&&&&&&&&&&&&&&&&%%%********************************************
;//**************************************%%% About Actual Movement %%%********************************************
;//**************************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%********************************************
;//Measuring Grab threshold
;void measure_threshold()
; 0000 026E {
_measure_threshold:
; 0000 026F     int seq = 0;//50% duty
; 0000 0270     delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	seq -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x18
; 0000 0271 
; 0000 0272     while(Middle_switch_off)
_0x90:
	SBIS 0x1,2
	RJMP _0x92
; 0000 0273     {
; 0000 0274         if(Left_switch_on)  seq++;
	SBIC 0x1,3
	RJMP _0x93
	__ADDWRN 16,17,1
; 0000 0275         if(Right_switch_on)  seq--;
_0x93:
	SBIC 0x1,1
	RJMP _0x94
	__SUBWRN 16,17,1
; 0000 0276         if(seq>3)  seq=0;
_0x94:
	__CPWRN 16,17,4
	BRLT _0x95
	__GETWRN 16,17,0
; 0000 0277         if(seq==0 && Right_switch_on)  seq=3;
_0x95:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x97
	SBIS 0x1,1
	RJMP _0x98
_0x97:
	RJMP _0x96
_0x98:
	__GETWRN 16,17,3
; 0000 0278 
; 0000 0279         mean_flex(seq,1);
_0x96:
	ST   -Y,R16
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mean_flex
; 0000 027A         mean_pressure(seq,1);
	ST   -Y,R16
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mean_pressure
; 0000 027B 
; 0000 027C         lcd_clear();
	CALL SUBOPT_0xA
; 0000 027D         lcd_gotoxy(0, 0);
; 0000 027E         lcd_putsf("FLEX");
	__POINTW1FN _0x0,64
	CALL SUBOPT_0x29
; 0000 027F         lcd_gotoxy(5, 0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2C
; 0000 0280         sprintf(lcd_data, "%d %", flex_mean[seq]);
	CALL SUBOPT_0x35
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_flex_mean)
	LDI  R27,HIGH(_flex_mean)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CALL SUBOPT_0xD
; 0000 0281         lcd_puts(lcd_data);
; 0000 0282 
; 0000 0283         lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
; 0000 0284         lcd_putsf("PRES");
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x29
; 0000 0285         lcd_gotoxy(5, 1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x27
; 0000 0286         sprintf(lcd_data, "%d %", pressure_mean[seq]);
	CALL SUBOPT_0x35
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pressure_mean)
	LDI  R27,HIGH(_pressure_mean)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CALL SUBOPT_0xD
; 0000 0287         lcd_puts(lcd_data);
; 0000 0288 
; 0000 0289         delay_ms(100);
	CALL SUBOPT_0x14
; 0000 028A     }
	RJMP _0x90
_0x92:
; 0000 028B }
_0x2080005:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;// Moving fingers
;void Move_finger(unsigned char seq, unsigned char P, unsigned char Bend)
; 0000 028F {
; 0000 0290   unsigned char threshold;//Actively changing by Bend
; 0000 0291   unsigned char Grab=0;//if 1, no more Grab (NO FLEXTION)
; 0000 0292   unsigned char E_OR_F;
; 0000 0293   unsigned int OCR_in;
; 0000 0294   unsigned int OCR_out;
; 0000 0295   //double r=0;//r=OCR_out/OCR_in
; 0000 0296   double r_in=1;//inlet speed ratio
; 0000 0297   double r_out=1;//outlet speed ratio
; 0000 0298   double u=0;
; 0000 0299   double error=0;
; 0000 029A 
; 0000 029B   /***INSERT TERM OF 'threshold' IN TERMS OF 'Bend'!!!***/
; 0000 029C   threshold = 70;//일단모르니까 상수로 둠
;	seq -> Y+26
;	P -> Y+25
;	Bend -> Y+24
;	threshold -> R17
;	Grab -> R16
;	E_OR_F -> R19
;	OCR_in -> R20,R21
;	OCR_out -> Y+22
;	r_in -> Y+18
;	r_out -> Y+14
;	u -> Y+10
;	error -> Y+6
; 0000 029D   // Grab or not?
; 0000 029E   if(P>=threshold)  Grab=1;//Over the threshold : no more grab
; 0000 029F   else Grab=0;//Under the threshold : Keep moving
; 0000 02A0 
; 0000 02A1 
; 0000 02A2   //Update angle (PID)
; 0000 02A3   E_OR_F = ((E_flag[seq]?-1:1)+(F_flag[seq]?1:-1))/2;//Extension:1, Flextion:-1, Do noting:0
; 0000 02A4   ang_desired = Bend+E_OR_F*delta_ang;//Ext:Bend+delta_ang, Flex:Bend-delta_ang, Stay:Bend
; 0000 02A5   error = ang_desired-ang_old[seq];
; 0000 02A6   error_sum[seq] += error;
; 0000 02A7   u = kp*error + ki*error_sum[seq]*(Ts/1000.) + kd*(error-error_old[seq])/(Ts/1000.);//Control value for OCR1A,OCR3A
; 0000 02A8   error_old[seq]=error;
; 0000 02A9 
; 0000 02AA   //Saturation condition...
; 0000 02AB   if(u>UPPER)       u=UPPER;
; 0000 02AC   else if(u<LOWER)  u=LOWER;
; 0000 02AD 
; 0000 02AE 
; 0000 02AF   // Input update
; 0000 02B0   /*구버전... (Input-Output ratio calcultate)
; 0000 02B1   //Grab&Flextion:r=1, !Grab&Flextion:r=1.4, !Grab&E_flag:r=0.6, !Grab&stay:r=1, Grab&!F_flag:Extension(r=0.6) or stay(r=1)
; 0000 02B2   r = (Grab&&F_flag[seq])?1:(((E_flag[seq]?0.2:1)+(F_flag[seq]?1.8:1))/2);
; 0000 02B3 
; 0000 02B4 
; 0000 02B5   //without PID
; 0000 02B6   OCR_in = IN_SPEED;  //Inlet
; 0000 02B7   OCR_out = r*OCR_in; //Outlet
; 0000 02B8 
; 0000 02B9   //with PID
; 0000 02BA   OCR_in = u;           //Inlet
; 0000 02BB   OCR_out = r*OCR_in;   //Outlet
; 0000 02BC   */
; 0000 02BD 
; 0000 02BE   /*신버전...
; 0000 02BF   기준 속도를 PID로 구한 후
; 0000 02C0   1. Grab 판정이 나지 않은 경우 Felxtion이면 inlet을 높은 비율로 outlet울 낮은 비율로 할당
; 0000 02C1   2. Grab 판정이 나지 않은 경우 Extension이면 inlet을 낮은 비율로 outlet울 높은 비율로 할당
; 0000 02C2   3. Grab 판정이 난 경우 Flextion이면 inlet/outlet 모두 기준속도사용
; 0000 02C3   4. Grab 판정이 난 경우 Extension이면 inlet을 낮은 비율로 outlet울 높은 비율로 할당
; 0000 02C4   5. 아무런 입력이 없는 경우 동적평형상태를 유지
; 0000 02C5   */
; 0000 02C6   //Grab&Flextion:r=1, !Grab&Flextion:r=1.4, !Grab&E_flag:r=0.6, !Grab&stay:r=1, Grab&!F_flag:Extension(r=0.6) or stay(r=1)
; 0000 02C7   r_in = (Grab&&F_flag[seq])?1:(((E_flag[seq]?0.2:1)+(F_flag[seq]?1.8:1))/2);
; 0000 02C8   //Grab&Flextion:r=1, !Grab&Flextion:r=0.6, !Grab&E_flag:r=1.4, !Grab&stay:r=1, Grab&!F_flag:Extension(r=1.4) or stay(r=1)
; 0000 02C9   r_out = (Grab&&F_flag[seq])?1:(((E_flag[seq]?1.8:1)+(F_flag[seq]?0.2:1))/2);
; 0000 02CA 
; 0000 02CB   //with PID
; 0000 02CC   OCR_in = r_in*u;          //Inlet
; 0000 02CD   OCR_out = r_out*u;        //Outlet
; 0000 02CE 
; 0000 02CF   //Define action
; 0000 02D0   OCR1AH = OCR_in>>8;
; 0000 02D1   OCR1AL = OCR_in;
; 0000 02D2   OCR3AH = OCR_out>>8;
; 0000 02D3   OCR3AL = OCR_out;
; 0000 02D4 }
;
;// About Daily mode
;void RUN_daily()
; 0000 02D8 {
; 0000 02D9   unsigned char seq=0;
; 0000 02DA   float ANG[4]={0};
; 0000 02DB 
; 0000 02DC   delay_ms(100);
;	seq -> R17
;	ANG -> Y+1
; 0000 02DD   INITIATE; //Initialization, Turn interrupts on
; 0000 02DE   while(Middle_switch_on)
; 0000 02DF   {
; 0000 02E0     order(&seq); //Control signal of each sequence
; 0000 02E1     Global_Sequence = seq;
; 0000 02E2 
; 0000 02E3     mean_pressure(seq,1);
; 0000 02E4     mean_flex(seq,1);
; 0000 02E5     ANG[seq] = (flex_max[seq]-flex_mean[seq])/(flex_max[seq]-flex_min[seq])*90.;//Angle : 0~90degrees, 굽어진 각도가 클수록 센서값이 작아짐
; 0000 02E6 
; 0000 02E7     Move_finger(seq,pressure_mean[seq], ANG[seq]);
; 0000 02E8     //mean_flex(seq,1);
; 0000 02E9     ang_old[seq]=ANG[seq];
; 0000 02EA     delay_ms(Ts);//sequence gab,100times PWM pulse per each sequence
; 0000 02EB   }
; 0000 02EC   for(i=0;i<4;i++)
; 0000 02ED   {
; 0000 02EE     E_flag[i]=0;
; 0000 02EF     F_flag[i]=0;
; 0000 02F0   }
; 0000 02F1   Global_Sequence=0;
; 0000 02F2   OCR1AH=0x00;
; 0000 02F3   OCR1AL=0x00;
; 0000 02F4   OCR1BH=0x00;
; 0000 02F5   OCR1BL=0x00;
; 0000 02F6   OCR1BH=0x00;
; 0000 02F7   OCR1BL=0x00;
; 0000 02F8   PORTC=0x00;
; 0000 02F9   TERMINATE; // Turn interrupts off
; 0000 02FA }
;/*
;// About Rhabilitation
;void Rehab()
;{
;    unsigned char seq=0;
;
;    delay_ms(100);
;    INITIATE; //Initialization, Turn interrupts on
;    while(Middle_switch_on)
;    {
;        order(&seq); //Control signal of each sequence
;        Global_Sequence = seq;
;
;        mean_flex(seq,1);
;        ANG[seq] = (flex_max[seq]-flex_mean[seq])/(flex_max[seq]-flex_min[seq])*90.;//Angle : 0~90degrees, 굽어진 각도가 클수록 센서값이 작아짐
;
;        mean_flex(seq,1);
;        ang_old[seq]=ANG[seq];
;        delay_ms(Ts);//sequence gab,100times PWM pulse per each sequence
;    }
;    TERMINATE; // Turn interrupts off
;    Global_Sequence=0;
;}
;*/
;
;// ********************************************* main ******************************************************************
;void main(void)
; 0000 0316 {
_main:
; 0000 0317 // Declare your local variables here
; 0000 0318 // menu
; 0000 0319 unsigned char menu = 0;
; 0000 031A unsigned char menu_Max = 9;
; 0000 031B 
; 0000 031C // PA1~7 : Control switch (PA0안됨)
; 0000 031D PORTA=0x00;
;	menu -> R17
;	menu_Max -> R16
	LDI  R17,0
	LDI  R16,9
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 031E DDRA=0x01;
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 031F // PB6 : Pump
; 0000 0320 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0321 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0322 // PC0~3 : Inlet Valve
; 0000 0323 // PC4~7 : Outlet Valve
; 0000 0324 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0325 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0326 // PD0~7 : LCD
; 0000 0327 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0328 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0329 // PE0 : EMERGENCY switch
; 0000 032A // PE1 : Interface switch - LEFT
; 0000 032B // PE2 : Interface switch - MIDDLE
; 0000 032C // PE3 : Interface switch - RIGHT
; 0000 032D // PE4 : Mode change switch (Toggle)
; 0000 032E // * PE5 : Thumb up....
; 0000 032F PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0330 DDRE=0xC0;
	LDI  R30,LOW(192)
	OUT  0x2,R30
; 0000 0331 // PF0~3 : Pressure Sensor
; 0000 0332 // PF4~7 : Flex Sensor
; 0000 0333 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0334 DDRF=0x00;
	STS  97,R30
; 0000 0335 PORTG=0x00;
	STS  101,R30
; 0000 0336 DDRG=0x00;
	STS  100,R30
; 0000 0337 
; 0000 0338 // Compare match interrupt  : Valve on
; 0000 0339 // Overflow interrupt       : Valve off
; 0000 033A // Timer 1 B : PUMP pwm control by using OCR1B
; 0000 033B // Timer 1   : Inlet Valve control
; 0000 033C // Timer 3   : Outlet Valve on
; 0000 033D 
; 0000 033E // Timer/Counter 1 initialization
; 0000 033F TCCR1A=0x22;//Only OC1B can make PWM signal(whenever TIM1_COMPB is LOW), Else : GPIO
	LDI  R30,LOW(34)
	OUT  0x2F,R30
; 0000 0340 //TCCR1A=0x02;
; 0000 0341 TCCR1B=0x1C;//Timer 1 : Fast PWM mode, prescale=256, TOP=ICR1 (PWM period:80ms)
	LDI  R30,LOW(28)
	OUT  0x2E,R30
; 0000 0342 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0343 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0344 ICR1H=0x13;
	CALL SUBOPT_0x1A
; 0000 0345 ICR1L=0x87;
; 0000 0346 OCR1AH=0x00;
	CALL SUBOPT_0x20
; 0000 0347 OCR1AL=0x00;
; 0000 0348 OCR1BH=0x00;
	CALL SUBOPT_0x22
; 0000 0349 OCR1BL=0x00;
; 0000 034A OCR1CH=0x00;
	STS  121,R30
; 0000 034B OCR1CL=0x00;
	LDI  R30,LOW(0)
	STS  120,R30
; 0000 034C // Timer/Counter 3 initialization
; 0000 034D TCCR3A=0x02;//All port related with Timer3 : GPIO
	LDI  R30,LOW(2)
	STS  139,R30
; 0000 034E TCCR3B=0x1C;//Timer 3 : Fast PWM mode, prescale=256, TOP=ICR3, f=clk/((TOP+1)*prescale)=80ms
	LDI  R30,LOW(28)
	STS  138,R30
; 0000 034F TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0350 TCNT3L=0x00;
	STS  136,R30
; 0000 0351 ICR3H=0x13;
	LDI  R30,LOW(19)
	STS  129,R30
; 0000 0352 ICR3L=0x87;
	LDI  R30,LOW(135)
	STS  128,R30
; 0000 0353 OCR3AH=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0354 OCR3AL=0x00;
	STS  134,R30
; 0000 0355 OCR3BH=0x00;
	STS  133,R30
; 0000 0356 OCR3BL=0x00;
	STS  132,R30
; 0000 0357 OCR3CH=0x00;
	STS  131,R30
; 0000 0358 OCR3CL=0x00;
	STS  130,R30
; 0000 0359 //Timer/counter interrupt
; 0000 035A TIMSK = 0x00;
	OUT  0x37,R30
; 0000 035B ETIMSK = 0x00;
	STS  125,R30
; 0000 035C 
; 0000 035D //ADC setting
; 0000 035E ADMUX=0x21;
	LDI  R30,LOW(33)
	OUT  0x7,R30
; 0000 035F ADCSRA=0xCF;  //ADC enable, ADC start, ADC interrupt on, prescale:128(62.5kHz)
	LDI  R30,LOW(207)
	OUT  0x6,R30
; 0000 0360 SFIOR=0x01;
	LDI  R30,LOW(1)
	OUT  0x20,R30
; 0000 0361 
; 0000 0362 lcd_init(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0363 // Global enable interrupts
; 0000 0364 #asm("sei")
	sei
; 0000 0365 //SREG = 0x80;
; 0000 0366 while (1)
_0xC2:
; 0000 0367       {
; 0000 0368         if(Left_switch_on) menu++;
	SBIS 0x1,3
	SUBI R17,-1
; 0000 0369         if(Right_switch_on) menu--;
	SBIS 0x1,1
	SUBI R17,1
; 0000 036A         if(menu > menu_Max)    menu = 0;
	CP   R16,R17
	BRSH _0xC7
	LDI  R17,LOW(0)
; 0000 036B         if(menu == 0)
_0xC7:
	CPI  R17,0
	BRNE _0xC8
; 0000 036C             if(Right_switch_on) menu = menu_Max;
	SBIS 0x1,1
	MOV  R17,R16
; 0000 036D 
; 0000 036E         switch(menu)
_0xC8:
	CALL SUBOPT_0x11
; 0000 036F         {
; 0000 0370             case 0:
	SBIW R30,0
	BRNE _0xCD
; 0000 0371                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 0372                     lcd_gotoxy(0, 0);
; 0000 0373                     lcd_putsf("1.Pressure TEST");
	__POINTW1FN _0x0,74
	CALL SUBOPT_0x29
; 0000 0374                     if(Middle_switch_on) pressure_test();
	SBIS 0x1,2
	RCALL _pressure_test
; 0000 0375                     delay_ms(100);
	RJMP _0xE5
; 0000 0376                     break;
; 0000 0377 
; 0000 0378             case 1:
_0xCD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xCF
; 0000 0379                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 037A                     lcd_gotoxy(0, 0);
; 0000 037B                     lcd_putsf("2.Pressure Tunning");
	__POINTW1FN _0x0,90
	CALL SUBOPT_0x29
; 0000 037C                     if(Middle_switch_on)    pressure_tuning();
	SBIS 0x1,2
	RCALL _pressure_tuning
; 0000 037D                     delay_ms(100);
	RJMP _0xE5
; 0000 037E                     break;
; 0000 037F 
; 0000 0380             case 2:
_0xCF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0381                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 0382                     lcd_gotoxy(0, 0);
; 0000 0383                     lcd_putsf("3.Flex TEST");
	__POINTW1FN _0x0,109
	CALL SUBOPT_0x29
; 0000 0384                     if(Middle_switch_on)    flex_test();
	SBIS 0x1,2
	RCALL _flex_test
; 0000 0385                     delay_ms(100);
	RJMP _0xE5
; 0000 0386                     break;
; 0000 0387             case 3:
_0xD1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0388                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 0389                     lcd_gotoxy(0, 0);
; 0000 038A                     lcd_putsf("4.Flex Tunning");
	__POINTW1FN _0x0,121
	CALL SUBOPT_0x29
; 0000 038B                     if(Middle_switch_on)    flex_tuning();
	SBIS 0x1,2
	RCALL _flex_tuning
; 0000 038C                     delay_ms(100);
	RJMP _0xE5
; 0000 038D                     break;
; 0000 038E 
; 0000 038F             case 4:
_0xD3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0390                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 0391                     lcd_gotoxy(0, 0);
; 0000 0392                     lcd_putsf("5.PWM TEST");
	__POINTW1FN _0x0,136
	CALL SUBOPT_0x29
; 0000 0393                     if(Middle_switch_on)    check_pwm();
	SBIS 0x1,2
	RCALL _check_pwm
; 0000 0394                     delay_ms(100);
	RJMP _0xE5
; 0000 0395                     break;
; 0000 0396 
; 0000 0397             case 5:
_0xD5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xD7
; 0000 0398                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 0399                     lcd_gotoxy(0, 0);
; 0000 039A                     lcd_putsf("6.PUMP TEST");
	__POINTW1FN _0x0,147
	CALL SUBOPT_0x29
; 0000 039B                     if(Middle_switch_on)    PUMP_test();
	SBIS 0x1,2
	RCALL _PUMP_test
; 0000 039C                     delay_ms(100);
	RJMP _0xE5
; 0000 039D                     break;
; 0000 039E 
; 0000 039F             case 6:
_0xD7:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xD9
; 0000 03A0                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 03A1                     lcd_gotoxy(0, 0);
; 0000 03A2                     lcd_putsf("7.Order TEST");
	__POINTW1FN _0x0,159
	CALL SUBOPT_0x29
; 0000 03A3                     if(Middle_switch_on)    test_order();
	SBIS 0x1,2
	RCALL _test_order
; 0000 03A4                     delay_ms(100);
	RJMP _0xE5
; 0000 03A5                     break;
; 0000 03A6 
; 0000 03A7             case 7:
_0xD9:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xDB
; 0000 03A8                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 03A9                     lcd_gotoxy(0, 0);
; 0000 03AA                     lcd_putsf("8.Valve Order");
	__POINTW1FN _0x0,172
	CALL SUBOPT_0x29
; 0000 03AB                     if(Middle_switch_on)    valve_order();
	SBIS 0x1,2
	RCALL _valve_order
; 0000 03AC                     delay_ms(100);
	RJMP _0xE5
; 0000 03AD                     break;
; 0000 03AE 
; 0000 03AF             case 8:
_0xDB:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xDD
; 0000 03B0                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 03B1                     lcd_gotoxy(0, 0);
; 0000 03B2                     lcd_putsf("9.Threshold?");
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x29
; 0000 03B3                     if(Middle_switch_on)    measure_threshold();
	SBIS 0x1,2
	RCALL _measure_threshold
; 0000 03B4                     delay_ms(100);
	RJMP _0xE5
; 0000 03B5                     break;
; 0000 03B6 
; 0000 03B7             case 9:
_0xDD:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xE1
; 0000 03B8                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 03B9                     lcd_gotoxy(0, 0);
; 0000 03BA                     lcd_putsf("10.PUMP VALVE");
	__POINTW1FN _0x0,199
	CALL SUBOPT_0x29
; 0000 03BB                     if(Middle_switch_on)    pump_valve();
	SBIS 0x1,2
	RCALL _pump_valve
; 0000 03BC                     delay_ms(100);
	RJMP _0xE5
; 0000 03BD                     break;
; 0000 03BE 
; 0000 03BF              default :
_0xE1:
; 0000 03C0                     lcd_clear();
	CALL SUBOPT_0xA
; 0000 03C1                     lcd_gotoxy(0, 0);
; 0000 03C2                     lcd_putsf("**BREAK!**");
	__POINTW1FN _0x0,213
	CALL SUBOPT_0x29
; 0000 03C3                     delay_ms(100);
_0xE5:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 03C4                     break;
; 0000 03C5 
; 0000 03C6          }
; 0000 03C7       }
	RJMP _0xC2
; 0000 03C8 
; 0000 03C9 }
_0xE2:
	RJMP _0xE2
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
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
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
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
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
	CALL SUBOPT_0x36
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x37
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x38
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
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
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x38
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x38
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
	CALL SUBOPT_0x3B
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x3B
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
_0x2080004:
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
_0x2080003:
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
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x3D
	LDI  R30,LOW(4)
	CALL SUBOPT_0x3D
	LDI  R30,LOW(133)
	CALL SUBOPT_0x3D
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
_ang_desired:
	.BYTE 0x1
_ang_old:
	.BYTE 0x4
_delta_ang:
	.BYTE 0x1
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	IN   R1,21
	LDS  R30,_Global_Sequence
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	LDD  R30,Y+2
	LDI  R31,0
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	STS  _d_flag,R30
	LDD  R30,Y+1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	MOVW R0,R30
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R26,Z
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDD  R26,Y+2
	LDI  R27,0
	SUBI R26,LOW(-_pressure_mean)
	SBCI R27,HIGH(-_pressure_mean)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9:
	ST   -Y,R17
	LDI  R17,0
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0xA:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xC:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:218 WORDS
SUBOPT_0xD:
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
SUBOPT_0xE:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__POINTW1FN _0x0,11
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x11:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13:
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
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDD  R30,Y+2
	LDI  R26,LOW(_flex_sum)
	LDI  R27,HIGH(_flex_sum)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	MOVW R0,R30
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R26,Z
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDD  R26,Y+2
	LDI  R27,0
	SUBI R26,LOW(-_flex_mean)
	SBCI R27,HIGH(-_flex_mean)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(20)
	OUT  0x37,R30
	STS  125,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(19)
	OUT  0x27,R30
	LDI  R30,LOW(135)
	OUT  0x26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CALL __PUTD1S0
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	OUT  0x37,R30
	STS  125,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(0)
	OUT  0x2B,R30
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	CALL __ASRW8
	OUT  0x29,R30
	LDI  R26,LOW(50)
	MULS R16,R26
	MOVW R30,R0
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
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
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	MOVW R0,R30
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	MOVW R30,R0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2C:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Global_Sequence
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,_Global_Sequence
	ST   -Y,R30
	CALL _disp
	LDI  R30,LOW(5)
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDI  R31,0
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LD   R30,Z
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDI  R31,0
	SUBI R30,LOW(-_F_flag)
	SBCI R31,HIGH(-_F_flag)
	LD   R30,Z
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x31:
	LDS  R30,_Global_Sequence
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	SUBI R30,LOW(-_E_flag)
	SBCI R31,HIGH(-_E_flag)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RCALL SUBOPT_0x32
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x36:
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
SUBOPT_0x37:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x38:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
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
SUBOPT_0x3A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
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

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
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

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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
