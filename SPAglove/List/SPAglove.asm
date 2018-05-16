
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
	JMP  0x00
	JMP  _timer3_compa_isr
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
	.DB  0xFF,0xFF
_0x4:
	.DB  0xFF,0xFF,0xFF,0xFF
_0x5:
	.DB  0xFF,0xFF,0xFF,0xFF
_0x0:
	.DB  0x54,0x65,0x73,0x74,0x69,0x6E,0x67,0x0
	.DB  0x25,0x64,0x0,0x54,0x75,0x6E,0x6E,0x69
	.DB  0x6E,0x67,0x0,0x54,0x45,0x53,0x54,0x0
	.DB  0x31,0x2E,0x50,0x72,0x65,0x73,0x73,0x75
	.DB  0x72,0x65,0x20,0x54,0x45,0x53,0x54,0x0
	.DB  0x32,0x2E,0x50,0x72,0x65,0x73,0x73,0x75
	.DB  0x72,0x65,0x20,0x54,0x75,0x6E,0x6E,0x69
	.DB  0x6E,0x67,0x0,0x33,0x2E,0x46,0x6C,0x65
	.DB  0x78,0x20,0x54,0x45,0x53,0x54,0x0,0x34
	.DB  0x2E,0x46,0x6C,0x65,0x78,0x20,0x54,0x75
	.DB  0x6E,0x6E,0x69,0x6E,0x67,0x0,0x35,0x2E
	.DB  0x50,0x57,0x4D,0x20,0x54,0x45,0x53,0x54
	.DB  0x0,0x36,0x2E,0x50,0x55,0x4D,0x50,0x20
	.DB  0x54,0x45,0x53,0x54,0x0,0x37,0x2E,0x4F
	.DB  0x72,0x64,0x65,0x72,0x20,0x54,0x45,0x53
	.DB  0x54,0x0,0x2A,0x2A,0x42,0x52,0x45,0x41
	.DB  0x4B,0x21,0x2A,0x2A,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _pressure_min
	.DW  _0x4*2

	.DW  0x04
	.DW  _flex_min
	.DW  _0x5*2

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
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 2018 ������ǰ 12�� - S.P.A glove
;Version : 0.0.0
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
;#define NUM_SAMP  50
;//About Switch
;#define Left_switch_on    (!PINE.1)
;#define Middle_switch_on  (!PINE.2)
;#define Right_switch_on   (!PINE.3)
;#define Left_switch_off   (PINE.1)
;#define Middle_switch_off (PINE.2)
;#define Right_switch_off  (PINE.3)
;//About order
;#define Up_thumb    (!PINA.0)
;#define Down_thumb  (!PINA.1)
;#define Up_index    (!PINA.2)
;#define Down_index  (!PINA.3)
;#define Up_middle   (!PINA.4)
;#define Down_middle (!PINA.5)
;#define Up_rest     (!PINA.6)
;#define Down_rest   (!PINA.7)
;//About In/Out ratio
;#define FLEXTION   OCR1A=150, OCR3AH=50>>8, OCR3AL=50  //많이 들어오고 적게나감
;#define EXTENSION  OCR1A=50, OCR3AH=150>>8, OCR3AL=150  //적게 들어오고 많이 나감
;//*****************************************************************************************************************
;// ****** Declare your global variables here  ******
;unsigned char sam_num = 0; // counting variable for ADC interrupt
;int i,j,k;
;//*****************************************************************************************************************
;// LCD
;unsigned char lcd_data[40];
;//*****************************************************************************************************************
;// ADC
;//unsigned char adc_data[4][100] = {0}; //adc �� IR/�з¼���/cds���� ������
;unsigned char mux = 0;
;//unsigned char NUM_SAMP = 50;
;unsigned char d_flag = 0;
;
;// * PSD
;unsigned char dist_data[2][NUM_SAMP] = {0}; //adc��ȯ ���� PSD���� �����Ǵ� �迭
;unsigned int dist_sum[2]={0};
;unsigned char dist_mean[2]={0};
;unsigned char dist_max[2] = {0, 0}; //tuning���� �ִ밪 �� �ּҰ��� �ֱ� ���� �迭
;unsigned char dist_min[2] = {255, 255};

	.DSEG
;
;// * Pressure
;unsigned char pressure_data[4][NUM_SAMP] = {0}; //adc �� �з¼������� ������
;unsigned int pressure_sum[4] = {0};
;unsigned char pressure_mean[4] = {0};
;unsigned char pressure_max[4] = {0, 0, 0, 0}; //tuning���� �ִ밪 �� �ּҰ��� �ֱ� ���� �迭
;unsigned char pressure_min[4] = {255, 255, 255, 255};
;
;// * Flex
;unsigned char flex_data[4][NUM_SAMP] = {0}; //adc �� �з¼������� ������
;unsigned int flex_sum[4] = {0};
;unsigned char flex_mean[4] = {0};
;unsigned char flex_max[4] = {0, 0, 0, 0}; //tuning���� �ִ밪 �� �ּҰ��� �ֱ� ���� �迭
;unsigned char flex_min[4] = {255, 255, 255, 255};
;//*****************************************************************************************************************
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0058 {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R30
; 0000 0059     PORTC=0x01; //PC0를 인터럽트걸린 순간에 High로
	LDI  R30,LOW(1)
	RJMP _0x69
; 0000 005A }
;// Timer1 overflow A interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 005D {
_timer1_ovf_isr:
	ST   -Y,R30
; 0000 005E     PORTC=0x00; //PC0를 인터럽트걸린 순간에 Low로
	LDI  R30,LOW(0)
_0x69:
	OUT  0x15,R30
; 0000 005F }
	LD   R30,Y+
	RETI
;// Timer3 overflow B interrupt service routine
;interrupt [TIM3_COMPB] void timer3_compa_isr(void)
; 0000 0062 {
_timer3_compa_isr:
; 0000 0063     ;
; 0000 0064 }
	RETI
;// Timer1 output compare A interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 0067 {
_timer3_ovf_isr:
; 0000 0068     ;
; 0000 0069 }
	RETI
;// ********************************* ADC interrupt service routine ************************************************
;interrupt [ADC_INT] void adc_isr(void)
; 0000 006C {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 006D     // Read the AD conversion result
; 0000 006E     //for (h = 0; h<=6; h++);
; 0000 006F     //ADC���� high���� ������
; 0000 0070     if(mux>4)           flex_data[mux-4][sam_num] = ADCH;   // 4, 5, 6, 7
	LDS  R26,_mux
	CPI  R26,LOW(0x5)
	BRLO _0x6
	LDS  R30,_mux
	LDI  R31,0
	SBIW R30,4
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	CALL __MULW12U
	SUBI R30,LOW(-_flex_data)
	SBCI R31,HIGH(-_flex_data)
	RJMP _0x67
; 0000 0071     else                pressure_data[mux][sam_num] = ADCH;     // 0, 1, 2, 3
_0x6:
	LDS  R30,_mux
	LDI  R26,LOW(50)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_pressure_data)
	SBCI R31,HIGH(-_pressure_data)
_0x67:
	MOVW R26,R30
	LDS  R30,_sam_num
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x5
	ST   X,R30
; 0000 0072     //ADC sampling
; 0000 0073     if(sam_num == NUM_SAMP)
	LDS  R26,_sam_num
	CPI  R26,LOW(0x32)
	BRNE _0x8
; 0000 0074     {
; 0000 0075         mux++;
	LDS  R30,_mux
	SUBI R30,-LOW(1)
	STS  _mux,R30
; 0000 0076         sam_num=0;
	LDI  R30,LOW(0)
	STS  _sam_num,R30
; 0000 0077         d_flag=1;
	LDI  R30,LOW(1)
	STS  _d_flag,R30
; 0000 0078     }
; 0000 0079 
; 0000 007A     mux &= 0x07;  //mux : 0~7
_0x8:
	LDS  R30,_mux
	ANDI R30,LOW(0x7)
	STS  _mux,R30
; 0000 007B     ADMUX = mux | 0x60;
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 007C     ADCSRA |= 0x40;
	SBI  0x6,6
; 0000 007D     sam_num++;
	LDS  R30,_sam_num
	SUBI R30,-LOW(1)
	STS  _sam_num,R30
; 0000 007E }
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
;void mean_pressure(void)
; 0000 0082 {
_mean_pressure:
; 0000 0083     unsigned char num = 0; // counting variable for function
; 0000 0084     while(!d_flag);
	ST   -Y,R17
;	num -> R17
	LDI  R17,0
_0x9:
	LDS  R30,_d_flag
	CPI  R30,0
	BREQ _0x9
; 0000 0085     for(i=0;i<4;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0xD:
	CALL SUBOPT_0x0
	SBIW R26,4
	BRGE _0xE
; 0000 0086     {
; 0000 0087         for(num = 0; num < NUM_SAMP; num++)
	LDI  R17,LOW(0)
_0x10:
	CPI  R17,50
	BRSH _0x11
; 0000 0088             pressure_sum[i] += pressure_data[i][num];
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_pressure_data)
	SBCI R31,HIGH(-_pressure_data)
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	SUBI R17,-1
	RJMP _0x10
_0x11:
; 0000 0089 pressure_mean[i] = pressure_sum[i]/50;
	CALL SUBOPT_0x1
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	MOVW R22,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
; 0000 008A         pressure_sum[i] = 0;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x6
; 0000 008B     }
	CALL SUBOPT_0x7
	RJMP _0xD
_0xE:
; 0000 008C     d_flag=0;
	LDI  R30,LOW(0)
	STS  _d_flag,R30
; 0000 008D }
	RJMP _0x2080005
;//Pressure test
;void pressure_test(void)
; 0000 0090 {
_pressure_test:
; 0000 0091     unsigned char num = 0;
; 0000 0092     delay_ms(300);
	CALL SUBOPT_0x8
;	num -> R17
; 0000 0093 
; 0000 0094     while(Middle_switch_off)
_0x12:
	SBIS 0x1,2
	RJMP _0x14
; 0000 0095     {
; 0000 0096         mean_pressure();
	CALL SUBOPT_0x9
; 0000 0097 
; 0000 0098         lcd_clear();
; 0000 0099         lcd_gotoxy(0, 0);
; 0000 009A         lcd_putsf("Testing");
	CALL SUBOPT_0xA
; 0000 009B 
; 0000 009C         if(Left_switch_on)  num++;
	SBIS 0x1,1
	SUBI R17,-1
; 0000 009D         if(Right_switch_on) num--;
	SBIS 0x1,3
	SUBI R17,1
; 0000 009E         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x17
	LDI  R17,LOW(3)
; 0000 009F 
; 0000 00A0         lcd_gotoxy(0, 1);
_0x17:
	CALL SUBOPT_0xB
; 0000 00A1         sprintf(lcd_data, "%d", num);
	CALL SUBOPT_0xC
; 0000 00A2         lcd_puts(lcd_data);
; 0000 00A3         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xD
; 0000 00A4         sprintf(lcd_data, "%d", pressure_mean[num]);
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	CALL SUBOPT_0xC
; 0000 00A5         lcd_puts(lcd_data);
; 0000 00A6 
; 0000 00A7         delay_ms(200);
	CALL SUBOPT_0xE
; 0000 00A8     }
	RJMP _0x12
_0x14:
; 0000 00A9 }
	RJMP _0x2080005
;
;// Pressure tuning
;void pressure_tuning(void)
; 0000 00AD {
_pressure_tuning:
; 0000 00AE     unsigned char num = 0;
; 0000 00AF     delay_ms(500);
	CALL SUBOPT_0xF
;	num -> R17
; 0000 00B0 
; 0000 00B1     while(Middle_switch_off)
_0x18:
	SBIS 0x1,2
	RJMP _0x1A
; 0000 00B2     {
; 0000 00B3         mean_pressure();
	CALL SUBOPT_0x9
; 0000 00B4 
; 0000 00B5         lcd_clear();
; 0000 00B6         lcd_gotoxy(0, 0);
; 0000 00B7         lcd_putsf("Tunning");
	CALL SUBOPT_0x10
; 0000 00B8 
; 0000 00B9         if(Left_switch_on)  num++;
	SBIS 0x1,1
	SUBI R17,-1
; 0000 00BA         if(Right_switch_on) num--;
	SBIS 0x1,3
	SUBI R17,1
; 0000 00BB         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x1D
	LDI  R17,LOW(3)
; 0000 00BC 
; 0000 00BD         if(pressure_mean[num]>pressure_max[num])  pressure_max[num]=pressure_mean[num];
_0x1D:
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	CALL SUBOPT_0x12
	BRSH _0x1E
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_pressure_max)
	SBCI R27,HIGH(-_pressure_max)
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
; 0000 00BE         if(pressure_mean[num]<pressure_min[num])  pressure_min[num]=pressure_mean[num];
_0x1E:
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	CALL SUBOPT_0x15
	BRSH _0x1F
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_pressure_min)
	SBCI R27,HIGH(-_pressure_min)
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
; 0000 00BF 
; 0000 00C0         lcd_gotoxy(0, 7);
_0x1F:
	CALL SUBOPT_0x16
; 0000 00C1         sprintf(lcd_data, "%d", num);
; 0000 00C2         lcd_puts(lcd_data);
; 0000 00C3         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xB
; 0000 00C4         sprintf(lcd_data, "%d", pressure_min[num]);
	LDI  R31,0
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CALL SUBOPT_0xC
; 0000 00C5         lcd_puts(lcd_data);
; 0000 00C6         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xD
; 0000 00C7         sprintf(lcd_data, "%d", pressure_max[num]);
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CALL SUBOPT_0xC
; 0000 00C8         lcd_puts(lcd_data);
; 0000 00C9 
; 0000 00CA         delay_ms(100);
	CALL SUBOPT_0x17
; 0000 00CB     }
	RJMP _0x18
_0x1A:
; 0000 00CC }
	RJMP _0x2080005
;
;// ******************************** About Flex Sensor *******************************************************
;void mean_flex(void)
; 0000 00D0 {
_mean_flex:
; 0000 00D1     unsigned char num = 0; // counting variable for function
; 0000 00D2     while(!d_flag);
	ST   -Y,R17
;	num -> R17
	LDI  R17,0
_0x20:
	LDS  R30,_d_flag
	CPI  R30,0
	BREQ _0x20
; 0000 00D3     for(i=0;i<4;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x24:
	CALL SUBOPT_0x0
	SBIW R26,4
	BRGE _0x25
; 0000 00D4     {
; 0000 00D5         for(num = 0; num < NUM_SAMP; num++)
	LDI  R17,LOW(0)
_0x27:
	CPI  R17,50
	BRSH _0x28
; 0000 00D6             flex_sum[i] += flex_data[i][num];
	CALL SUBOPT_0x18
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_flex_data)
	SBCI R31,HIGH(-_flex_data)
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 00D7 flex_mean[i] = flex_sum[i]/50;
	CALL SUBOPT_0x1
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	MOVW R22,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x5
; 0000 00D8         flex_sum[i] = 0;
	LDI  R26,LOW(_flex_sum)
	LDI  R27,HIGH(_flex_sum)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x6
; 0000 00D9     }
	CALL SUBOPT_0x7
	RJMP _0x24
_0x25:
; 0000 00DA     d_flag=0;
	LDI  R30,LOW(0)
	STS  _d_flag,R30
; 0000 00DB }
	RJMP _0x2080005
;//Pressure test
;void flex_test(void)
; 0000 00DE {
_flex_test:
; 0000 00DF     unsigned char num = 0;
; 0000 00E0     delay_ms(300);
	CALL SUBOPT_0x8
;	num -> R17
; 0000 00E1 
; 0000 00E2     while(Middle_switch_off)
_0x29:
	SBIS 0x1,2
	RJMP _0x2B
; 0000 00E3     {
; 0000 00E4         mean_flex();
	CALL SUBOPT_0x19
; 0000 00E5 
; 0000 00E6         lcd_clear();
; 0000 00E7         lcd_gotoxy(0, 0);
; 0000 00E8         lcd_putsf("Testing");
	CALL SUBOPT_0xA
; 0000 00E9 
; 0000 00EA         if(Left_switch_on)  num++;
	SBIS 0x1,1
	SUBI R17,-1
; 0000 00EB         if(Right_switch_on) num--;
	SBIS 0x1,3
	SUBI R17,1
; 0000 00EC         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x2E
	LDI  R17,LOW(3)
; 0000 00ED 
; 0000 00EE         lcd_gotoxy(0, 1);
_0x2E:
	CALL SUBOPT_0xB
; 0000 00EF         sprintf(lcd_data, "%d", num);
	CALL SUBOPT_0xC
; 0000 00F0         lcd_puts(lcd_data);
; 0000 00F1         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xD
; 0000 00F2         sprintf(lcd_data, "%d", flex_mean[num]);
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	LD   R30,Z
	CALL SUBOPT_0xC
; 0000 00F3         lcd_puts(lcd_data);
; 0000 00F4 
; 0000 00F5         delay_ms(200);
	CALL SUBOPT_0xE
; 0000 00F6     }
	RJMP _0x29
_0x2B:
; 0000 00F7 }
	RJMP _0x2080005
;
;// flex tuning
;void flex_tuning(void)
; 0000 00FB {
_flex_tuning:
; 0000 00FC     unsigned char num = 0;
; 0000 00FD     delay_ms(500);
	CALL SUBOPT_0xF
;	num -> R17
; 0000 00FE 
; 0000 00FF     while(Middle_switch_off)
_0x2F:
	SBIS 0x1,2
	RJMP _0x31
; 0000 0100     {
; 0000 0101         mean_flex();
	CALL SUBOPT_0x19
; 0000 0102 
; 0000 0103         lcd_clear();
; 0000 0104         lcd_gotoxy(0, 0);
; 0000 0105         lcd_putsf("Tunning");
	CALL SUBOPT_0x10
; 0000 0106 
; 0000 0107         if(Left_switch_on)  num++;
	SBIS 0x1,1
	SUBI R17,-1
; 0000 0108         if(Right_switch_on) num--;
	SBIS 0x1,3
	SUBI R17,1
; 0000 0109         if(num>3) num=3;
	CPI  R17,4
	BRLO _0x34
	LDI  R17,LOW(3)
; 0000 010A 
; 0000 010B         if(flex_mean[num]>pressure_max[num])  flex_max[num]=pressure_mean[num];
_0x34:
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	CALL SUBOPT_0x12
	BRSH _0x35
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_flex_max)
	SBCI R27,HIGH(-_flex_max)
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
; 0000 010C         if(flex_mean[num]<pressure_min[num])  flex_min[num]=pressure_mean[num];
_0x35:
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_flex_mean)
	SBCI R31,HIGH(-_flex_mean)
	CALL SUBOPT_0x15
	BRSH _0x36
	CALL SUBOPT_0x13
	SUBI R26,LOW(-_flex_min)
	SBCI R27,HIGH(-_flex_min)
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
; 0000 010D 
; 0000 010E         lcd_gotoxy(0, 7);
_0x36:
	CALL SUBOPT_0x16
; 0000 010F         sprintf(lcd_data, "%d", num);
; 0000 0110         lcd_puts(lcd_data);
; 0000 0111         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xB
; 0000 0112         sprintf(lcd_data, "%d", flex_min[num]);
	LDI  R31,0
	SUBI R30,LOW(-_flex_min)
	SBCI R31,HIGH(-_flex_min)
	LD   R30,Z
	CALL SUBOPT_0xC
; 0000 0113         lcd_puts(lcd_data);
; 0000 0114         lcd_gotoxy(4, 1);
	CALL SUBOPT_0xD
; 0000 0115         sprintf(lcd_data, "%d", flex_max[num]);
	SUBI R30,LOW(-_flex_max)
	SBCI R31,HIGH(-_flex_max)
	LD   R30,Z
	CALL SUBOPT_0xC
; 0000 0116         lcd_puts(lcd_data);
; 0000 0117 
; 0000 0118         delay_ms(100);
	CALL SUBOPT_0x17
; 0000 0119     }
	RJMP _0x2F
_0x31:
; 0000 011A }
_0x2080005:
	LD   R17,Y+
	RET
;
;// ******************************** About PWM control *******************************************************
;void check_pwm(void)
; 0000 011E {
_check_pwm:
; 0000 011F     unsigned int temp = 350;//PWM interrupt control
; 0000 0120     delay_ms(100);
	CALL SUBOPT_0x1A
;	temp -> R16,R17
; 0000 0121 
; 0000 0122     while(Middle_switch_off)
_0x37:
	SBIS 0x1,2
	RJMP _0x39
; 0000 0123     {
; 0000 0124         if(Left_switch_on)  temp+=10;
	SBIC 0x1,1
	RJMP _0x3A
	__ADDWRN 16,17,10
; 0000 0125         if(Right_switch_on)  temp-=10;
_0x3A:
	SBIC 0x1,3
	RJMP _0x3B
	__SUBWRN 16,17,10
; 0000 0126         if(temp<=0) temp=0;
_0x3B:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x3C
	__GETWRN 16,17,0
; 0000 0127         if(temp>=ICR1)  temp=ICR1;
_0x3C:
	IN   R30,0x26
	IN   R31,0x26+1
	CP   R16,R30
	CPC  R17,R31
	BRLO _0x3D
	__INWR 16,17,38
; 0000 0128         // 솔레노이드 밸브 오기전까지 LED로 테스트
; 0000 0129         OCR1AH = temp>>8;
_0x3D:
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
; 0000 012A         OCR1AL = temp;
	OUT  0x2A,R16
; 0000 012B         lcd_clear();
	CALL SUBOPT_0x1B
; 0000 012C         lcd_gotoxy(0, 0);
; 0000 012D         lcd_putsf("TEST");
; 0000 012E         lcd_gotoxy(0, 1);
; 0000 012F         sprintf(lcd_data, "%d", temp);
; 0000 0130         lcd_puts(lcd_data);
; 0000 0131 
; 0000 0132         delay_ms(100);
; 0000 0133     }
	RJMP _0x37
_0x39:
; 0000 0134 }
	RJMP _0x2080004
;
;// ******************************** About PWM control *******************************************************
;void PUMP_test()
; 0000 0138 {
_PUMP_test:
; 0000 0139     unsigned int temp = 350;//PWM interrupt control
; 0000 013A     delay_ms(100);
	CALL SUBOPT_0x1A
;	temp -> R16,R17
; 0000 013B 
; 0000 013C     while(Middle_switch_off)
_0x3E:
	SBIS 0x1,2
	RJMP _0x40
; 0000 013D     {
; 0000 013E         if(Left_switch_on)  temp+=10;
	SBIC 0x1,1
	RJMP _0x41
	__ADDWRN 16,17,10
; 0000 013F         if(Right_switch_on)  temp-=10;
_0x41:
	SBIC 0x1,3
	RJMP _0x42
	__SUBWRN 16,17,10
; 0000 0140         if(temp<=0) temp=0;
_0x42:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x43
	__GETWRN 16,17,0
; 0000 0141         if(temp>=ICR1)  temp=ICR1;
_0x43:
	IN   R30,0x26
	IN   R31,0x26+1
	CP   R16,R30
	CPC  R17,R31
	BRLO _0x44
	__INWR 16,17,38
; 0000 0142 
; 0000 0143         OCR1BH = temp>>8;
_0x44:
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	OUT  0x29,R30
; 0000 0144         OCR1BL = temp;
	OUT  0x28,R16
; 0000 0145         lcd_clear();
	CALL SUBOPT_0x1B
; 0000 0146         lcd_gotoxy(0, 0);
; 0000 0147         lcd_putsf("TEST");
; 0000 0148         lcd_gotoxy(0, 1);
; 0000 0149         sprintf(lcd_data, "%d", temp);
; 0000 014A         lcd_puts(lcd_data);
; 0000 014B 
; 0000 014C         delay_ms(100);
; 0000 014D     }
	RJMP _0x3E
_0x40:
; 0000 014E }
_0x2080004:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;// ******************************** About Order *******************************************************
;unsigned char order(unsigned char sequence)
; 0000 0152 {
_order:
; 0000 0153     if(Up_thumb||Up_index||Up_middle||Up_rest)    EXTENSION;
;	sequence -> Y+0
	SBIS 0x19,0
	RJMP _0x46
	SBIS 0x19,2
	RJMP _0x46
	SBIS 0x19,4
	RJMP _0x46
	SBIC 0x19,6
	RJMP _0x45
_0x46:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	STS  135,R30
	LDI  R30,LOW(150)
	STS  134,R30
; 0000 0154     if(Down_thumb||Down_index||Down_middle||Down_rest)  FLEXTION;
_0x45:
	SBIS 0x19,1
	RJMP _0x49
	SBIS 0x19,3
	RJMP _0x49
	SBIS 0x19,5
	RJMP _0x49
	SBIC 0x19,7
	RJMP _0x48
_0x49:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	STS  135,R30
	LDI  R30,LOW(50)
	STS  134,R30
; 0000 0155     // sequence 0 : Thumb   PC0, PC4 on, PORTC = 0x11
; 0000 0156     // sequence 1 : Index   PC1, PC5 on, PORTC = 0x22
; 0000 0157     // sequence 2 : Middle  PC2, PC6 on, PORTC = 0x44
; 0000 0158     // sequence 3 : Rest    PC3, PC7 on, PORTC = 0x88
; 0000 0159     PORTC = 0x11<<sequence;
_0x48:
	LD   R30,Y
	LDI  R26,LOW(17)
	CALL __LSLB12
	OUT  0x15,R30
; 0000 015A     sequence++;
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 015B     if(sequence>3)  sequence=0;
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRLO _0x4B
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 015C     return sequence;
_0x4B:
	LD   R30,Y
	JMP  _0x2080001
; 0000 015D }
;// ********************************************* main ******************************************************************
;void main(void)
; 0000 0160 {
_main:
; 0000 0161 // Declare your local variables here
; 0000 0162 // menu
; 0000 0163 unsigned char menu = 0;
; 0000 0164 unsigned char menu_Max = 6;
; 0000 0165 unsigned char sequence=0;
; 0000 0166 
; 0000 0167 PORTA=0xFE;
;	menu -> R17
;	menu_Max -> R16
;	sequence -> R19
	LDI  R17,0
	LDI  R16,6
	LDI  R19,0
	LDI  R30,LOW(254)
	OUT  0x1B,R30
; 0000 0168 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0169 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 016A DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 016B PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 016C DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 016D PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 016E DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 016F PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0170 DDRE=0x8F;
	LDI  R30,LOW(143)
	OUT  0x2,R30
; 0000 0171 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0172 DDRF=0x00;
	STS  97,R30
; 0000 0173 PORTG=0x00;
	STS  101,R30
; 0000 0174 DDRG=0x00;
	STS  100,R30
; 0000 0175 
; 0000 0176 // Compare match interrupt  : Valve on
; 0000 0177 // Overflow interrupt       : Valve off
; 0000 0178 // Timer 1 B : PUMP pwm control by using OCR1B
; 0000 0179 // Timer 1   : Inlet Valve control
; 0000 017A // Timer 3   : Outlet Valve on
; 0000 017B 
; 0000 017C // Timer/Counter 1 initialization
; 0000 017D TCCR1A=0x22;//Timer 1 과 관련된 입출력 핀 중 OC1B만 PWM출력(TIM1_COMPAt시에 Low) 나머지는 GPIO로 사용
	LDI  R30,LOW(34)
	OUT  0x2F,R30
; 0000 017E TCCR1B=0x18;//Timer 1 : Fast PWM mode, 분주비=1, TOP=ICR1
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0000 017F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0180 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0181 ICR1H=0x13;
	LDI  R30,LOW(19)
	OUT  0x27,R30
; 0000 0182 ICR1L=0x87;
	LDI  R30,LOW(135)
	OUT  0x26,R30
; 0000 0183 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0184 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0185 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0186 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0187 OCR1CH=0x00;
	STS  121,R30
; 0000 0188 OCR1CL=0x00;
	STS  120,R30
; 0000 0189 // Timer/Counter 3 initialization
; 0000 018A TCCR3A=0x02;//Timer 3 과 관련된 입출력 핀은 GPIO로 사용
	LDI  R30,LOW(2)
	STS  139,R30
; 0000 018B TCCR3B=0x18;//Timer 3 : Fast PWM mode, 분주비=1, TOP=ICR3
	LDI  R30,LOW(24)
	STS  138,R30
; 0000 018C TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 018D TCNT3L=0x00;
	STS  136,R30
; 0000 018E ICR3H=0x00;
	STS  129,R30
; 0000 018F ICR3L=0x00;
	STS  128,R30
; 0000 0190 OCR3AH=0x00;
	STS  135,R30
; 0000 0191 OCR3AL=0x00;
	STS  134,R30
; 0000 0192 OCR3BH=0x00;
	STS  133,R30
; 0000 0193 OCR3BL=0x00;
	STS  132,R30
; 0000 0194 OCR3CH=0x00;
	STS  131,R30
; 0000 0195 OCR3CL=0x00;
	STS  130,R30
; 0000 0196 
; 0000 0197 //Activate timer interrupts
; 0000 0198 TIMSK = 0x14; //TIM1_COMPA interrupt on, TIM1_OVF interrupt on (Inlet Valve control)
	LDI  R30,LOW(20)
	OUT  0x37,R30
; 0000 0199 ETIMSK = 0x14;//TIM3_COMPA interrupt on, TIM3_OVF interrupt on (Outlet Valve control)
	STS  125,R30
; 0000 019A 
; 0000 019B //ADC setting
; 0000 019C ADMUX=0x21;
	LDI  R30,LOW(33)
	OUT  0x7,R30
; 0000 019D ADCSRA=0xCF;  //ADC enable, ADC start, ADC interrupt on, 분주비128(62.5kHz)
	LDI  R30,LOW(207)
	OUT  0x6,R30
; 0000 019E SFIOR=0x01;
	LDI  R30,LOW(1)
	OUT  0x20,R30
; 0000 019F 
; 0000 01A0 lcd_init(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01A1 // Global enable interrupts
; 0000 01A2 #asm("sei")
	sei
; 0000 01A3 //SREG = 0x80;
; 0000 01A4 while (1)
_0x4C:
; 0000 01A5       {
; 0000 01A6         if(Left_switch_on) menu++;
	SBIS 0x1,1
	SUBI R17,-1
; 0000 01A7         if(Right_switch_on) menu--;
	SBIS 0x1,3
	SUBI R17,1
; 0000 01A8         if(menu > menu_Max)    menu = 0;
	CP   R16,R17
	BRSH _0x51
	LDI  R17,LOW(0)
; 0000 01A9         if(menu == 0)
_0x51:
	CPI  R17,0
	BRNE _0x52
; 0000 01AA             if(Right_switch_on) menu = menu_Max;
	SBIS 0x1,3
	MOV  R17,R16
; 0000 01AB 
; 0000 01AC         switch(menu)
_0x52:
	CALL SUBOPT_0x11
; 0000 01AD         {
; 0000 01AE             // Sensor TEST
; 0000 01AF             case 0:
	SBIW R30,0
	BRNE _0x57
; 0000 01B0                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01B1                     lcd_gotoxy(0, 0);
; 0000 01B2                     lcd_putsf("1.Pressure TEST");
	__POINTW1FN _0x0,24
	CALL SUBOPT_0x1D
; 0000 01B3                     if(Middle_switch_on) pressure_test();
	SBIS 0x1,2
	RCALL _pressure_test
; 0000 01B4                     delay_ms(300);
	RJMP _0x68
; 0000 01B5                     break;
; 0000 01B6 
; 0000 01B7             case 1:
_0x57:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x59
; 0000 01B8                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01B9                     lcd_gotoxy(0, 0);
; 0000 01BA                     lcd_putsf("2.Pressure Tunning");
	__POINTW1FN _0x0,40
	CALL SUBOPT_0x1D
; 0000 01BB                     if(Middle_switch_on)    pressure_tuning();
	SBIS 0x1,2
	RCALL _pressure_tuning
; 0000 01BC                     delay_ms(300);
	RJMP _0x68
; 0000 01BD                     break;
; 0000 01BE 
; 0000 01BF             case 2:
_0x59:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5B
; 0000 01C0                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01C1                     lcd_gotoxy(0, 0);
; 0000 01C2                     lcd_putsf("3.Flex TEST");
	__POINTW1FN _0x0,59
	CALL SUBOPT_0x1D
; 0000 01C3                     if(Middle_switch_on)    flex_test();
	SBIS 0x1,2
	RCALL _flex_test
; 0000 01C4                     delay_ms(300);
	RJMP _0x68
; 0000 01C5                     break;
; 0000 01C6             case 3:
_0x5B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5D
; 0000 01C7                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01C8                     lcd_gotoxy(0, 0);
; 0000 01C9                     lcd_putsf("4.Flex Tunning");
	__POINTW1FN _0x0,71
	CALL SUBOPT_0x1D
; 0000 01CA                     if(Middle_switch_on)    flex_tuning();
	SBIS 0x1,2
	RCALL _flex_tuning
; 0000 01CB                     delay_ms(300);
	RJMP _0x68
; 0000 01CC                     break;
; 0000 01CD 
; 0000 01CE             case 4:
_0x5D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5F
; 0000 01CF                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01D0                     lcd_gotoxy(0, 0);
; 0000 01D1                     lcd_putsf("5.PWM TEST");
	__POINTW1FN _0x0,86
	CALL SUBOPT_0x1D
; 0000 01D2                     if(Middle_switch_on)    check_pwm();
	SBIS 0x1,2
	RCALL _check_pwm
; 0000 01D3                     delay_ms(300);
	RJMP _0x68
; 0000 01D4                     break;
; 0000 01D5 
; 0000 01D6             case 5:
_0x5F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x61
; 0000 01D7                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01D8                     lcd_gotoxy(0, 0);
; 0000 01D9                     lcd_putsf("6.PUMP TEST");
	__POINTW1FN _0x0,97
	CALL SUBOPT_0x1D
; 0000 01DA                     if(Middle_switch_on)    PUMP_test();
	SBIS 0x1,2
	RCALL _PUMP_test
; 0000 01DB                     delay_ms(300);
	RJMP _0x68
; 0000 01DC                     break;
; 0000 01DD 
; 0000 01DE             case 6:
_0x61:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x65
; 0000 01DF                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01E0                     lcd_gotoxy(0, 0);
; 0000 01E1                     lcd_putsf("7.Order TEST");
	__POINTW1FN _0x0,109
	CALL SUBOPT_0x1D
; 0000 01E2                     if(Middle_switch_on)    sequence=order(sequence);
	SBIC 0x1,2
	RJMP _0x64
	ST   -Y,R19
	RCALL _order
	MOV  R19,R30
; 0000 01E3                     delay_ms(300);
_0x64:
	RJMP _0x68
; 0000 01E4                     break;
; 0000 01E5 
; 0000 01E6              default :
_0x65:
; 0000 01E7                     lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01E8                     lcd_gotoxy(0, 0);
; 0000 01E9                     lcd_putsf("**BREAK!**");
	__POINTW1FN _0x0,122
	CALL SUBOPT_0x1D
; 0000 01EA                     delay_ms(300);
_0x68:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01EB                     break;
; 0000 01EC 
; 0000 01ED          }
; 0000 01EE       }
	RJMP _0x4C
; 0000 01EF 
; 0000 01F0 }
_0x66:
	RJMP _0x66
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
	CALL SUBOPT_0x1E
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x1F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x20
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
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
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x20
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x20
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
	CALL SUBOPT_0x23
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
	CALL SUBOPT_0x23
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
	LD   R30,Y
	LDI  R31,0
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
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x25
	LDI  R30,LOW(4)
	CALL SUBOPT_0x25
	LDI  R30,LOW(133)
	CALL SUBOPT_0x25
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
_pressure_max:
	.BYTE 0x4
_pressure_min:
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
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_pressure_sum)
	LDI  R27,HIGH(_pressure_sum)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LD   R23,Z
	LDD  R24,Z+1
	RCALL SUBOPT_0x0
	LDI  R30,LOW(50)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	MOVW R26,R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	LDI  R31,0
	ADD  R30,R23
	ADC  R31,R24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
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
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R17
	LDI  R17,0
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	CALL _mean_pressure
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xB:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:114 WORDS
SUBOPT_0xC:
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
SUBOPT_0xD:
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
SUBOPT_0xE:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	ST   -Y,R17
	LDI  R17,0
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__POINTW1FN _0x0,11
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_pressure_max)
	SBCI R31,HIGH(-_pressure_max)
	LD   R30,Z
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	SUBI R30,LOW(-_pressure_mean)
	SBCI R31,HIGH(-_pressure_mean)
	LD   R30,Z
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_pressure_min)
	SBCI R31,HIGH(-_pressure_min)
	LD   R30,Z
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
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
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x1
	LDI  R26,LOW(_flex_sum)
	LDI  R27,HIGH(_flex_sum)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	CALL _mean_flex
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,350
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x1B:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
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
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
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
	CALL _lcd_puts
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x1C:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1E:
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
SUBOPT_0x1F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
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
SUBOPT_0x22:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
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
