/*****************************************************
This program was produced by the JJH, KYY and Johnadan
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 2018 ������ǰ 12�� - S.P.A glove
Version : 0.0.0
Date    : 2018-05-03
Author  : JJH
Company : Chungnam National University
Comments: Holy Fucking Shit...


Chip type               : Atmega128
AVR Core Clock frequency: 16.000000 MHz
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include <stdio.h>

// Alphanumeric LCD Module functions
#include <lcd.h>
#asm
 .equ __lcd_port = 0x12 //PORTD 8
#endasm
// About ADC
#define ADC_VREF_TYPE 0x60
#define NUM_SAMP  50
//About Switch
#define Left_switch_on    (!PINE.1)
#define Middle_switch_on  (!PINE.2)
#define Right_switch_on   (!PINE.3)
#define Left_switch_off   (PINE.1)
#define Middle_switch_off (PINE.2)
#define Right_switch_off  (PINE.3)
//About order
#define Up_thumb    (!PINA.0)
#define Down_thumb  (!PINA.1)
#define Up_index    (!PINA.2)
#define Down_index  (!PINA.3)
#define Up_middle   (!PINA.4)
#define Down_middle (!PINA.5)
#define Up_rest     (!PINA.6)
#define Down_rest   (!PINA.7)
//About In/Out ratio
#define FLEXTION   OCR1A=150, OCR3AH=50>>8, OCR3AL=50  //많이 들어오고 적게나감
#define EXTENSION  OCR1A=50, OCR3AH=150>>8, OCR3AL=150  //적게 들어오고 많이 나감
//*****************************************************************************************************************
// ****** Declare your global variables here  ******
unsigned char sam_num = 0; // counting variable for ADC interrupt
int i,j,k;
//*****************************************************************************************************************
// LCD
unsigned char lcd_data[40];
//*****************************************************************************************************************
// ADC
//unsigned char adc_data[4][100] = {0}; //adc �� IR/�з¼���/cds���� ������
unsigned char mux = 0;
//unsigned char NUM_SAMP = 50;
unsigned char d_flag = 0;

// * PSD
unsigned char dist_data[2][NUM_SAMP] = {0}; //adc��ȯ ���� PSD���� �����Ǵ� �迭
unsigned int dist_sum[2]={0};
unsigned char dist_mean[2]={0};
unsigned char dist_max[2] = {0, 0}; //tuning���� �ִ밪 �� �ּҰ��� �ֱ� ���� �迭
unsigned char dist_min[2] = {255, 255};

// * Pressure
unsigned char pressure_data[4][NUM_SAMP] = {0}; //adc �� �з¼������� ������
unsigned int pressure_sum[4] = {0};
unsigned char pressure_mean[4] = {0};
unsigned char pressure_max[4] = {0, 0, 0, 0}; //tuning���� �ִ밪 �� �ּҰ��� �ֱ� ���� �迭
unsigned char pressure_min[4] = {255, 255, 255, 255};

// * Flex
unsigned char flex_data[4][NUM_SAMP] = {0}; //adc �� �з¼������� ������
unsigned int flex_sum[4] = {0};
unsigned char flex_mean[4] = {0};
unsigned char flex_max[4] = {0, 0, 0, 0}; //tuning���� �ִ밪 �� �ּҰ��� �ֱ� ���� �迭
unsigned char flex_min[4] = {255, 255, 255, 255};
//*****************************************************************************************************************
// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    PORTC=0x01; //PC0를 인터럽트걸린 순간에 High로
}
// Timer1 overflow A interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    PORTC=0x00; //PC0를 인터럽트걸린 순간에 Low로
}
// Timer3 overflow B interrupt service routine
interrupt [TIM3_COMPB] void timer3_compa_isr(void)
{
    ;
}
// Timer1 output compare A interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
    ;
}
// ********************************* ADC interrupt service routine ************************************************
interrupt [ADC_INT] void adc_isr(void)
{
    // Read the AD conversion result
    //for (h = 0; h<=6; h++);
    //ADC���� high���� ������
    if(mux>4)           flex_data[mux-4][sam_num] = ADCH;   // 4, 5, 6, 7
    else                pressure_data[mux][sam_num] = ADCH;     // 0, 1, 2, 3
    //ADC sampling
    if(sam_num == NUM_SAMP)
    {
        mux++;
        sam_num=0;
        d_flag=1;
    }

    mux &= 0x07;  //mux : 0~7
    ADMUX = mux | 0x60;
    ADCSRA |= 0x40;
    sam_num++;
}

// ******************************** About Pressure Sensor *******************************************************
void mean_pressure(void)
{
    unsigned char num = 0; // counting variable for function
    while(!d_flag);
    for(i=0;i<4;i++)
    {
        for(num = 0; num < NUM_SAMP; num++)
            pressure_sum[i] += pressure_data[i][num];
        pressure_mean[i] = pressure_sum[i]/NUM_SAMP;
        pressure_sum[i] = 0;
    }
    d_flag=0;
}
//Pressure test
void pressure_test(void)
{
    unsigned char num = 0;
    delay_ms(300);

    while(Middle_switch_off)
    {
        mean_pressure();

        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Testing");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;

        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", num);
        lcd_puts(lcd_data);
        lcd_gotoxy(4, 1);
        sprintf(lcd_data, "%d", pressure_mean[num]);
        lcd_puts(lcd_data);

        delay_ms(200);
    }
}

// Pressure tuning
void pressure_tuning(void)
{
    unsigned char num = 0;
    delay_ms(500);

    while(Middle_switch_off)
    {
        mean_pressure();

        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Tunning");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;

        if(pressure_mean[num]>pressure_max[num])  pressure_max[num]=pressure_mean[num];
        if(pressure_mean[num]<pressure_min[num])  pressure_min[num]=pressure_mean[num];

        lcd_gotoxy(0, 7);
        sprintf(lcd_data, "%d", num);
        lcd_puts(lcd_data);
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", pressure_min[num]);
        lcd_puts(lcd_data);
        lcd_gotoxy(4, 1);
        sprintf(lcd_data, "%d", pressure_max[num]);
        lcd_puts(lcd_data);

        delay_ms(100);
    }
}

// ******************************** About Flex Sensor *******************************************************
void mean_flex(void)
{
    unsigned char num = 0; // counting variable for function
    while(!d_flag);
    for(i=0;i<4;i++)
    {
        for(num = 0; num < NUM_SAMP; num++)
            flex_sum[i] += flex_data[i][num];
        flex_mean[i] = flex_sum[i]/NUM_SAMP;
        flex_sum[i] = 0;
    }
    d_flag=0;
}
//Pressure test
void flex_test(void)
{
    unsigned char num = 0;
    delay_ms(300);

    while(Middle_switch_off)
    {
        mean_flex();

        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Testing");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;

        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", num);
        lcd_puts(lcd_data);
        lcd_gotoxy(4, 1);
        sprintf(lcd_data, "%d", flex_mean[num]);
        lcd_puts(lcd_data);

        delay_ms(200);
    }
}

// flex tuning
void flex_tuning(void)
{
    unsigned char num = 0;
    delay_ms(500);

    while(Middle_switch_off)
    {
        mean_flex();

        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Tunning");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;

        if(flex_mean[num]>pressure_max[num])  flex_max[num]=pressure_mean[num];
        if(flex_mean[num]<pressure_min[num])  flex_min[num]=pressure_mean[num];

        lcd_gotoxy(0, 7);
        sprintf(lcd_data, "%d", num);
        lcd_puts(lcd_data);
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", flex_min[num]);
        lcd_puts(lcd_data);
        lcd_gotoxy(4, 1);
        sprintf(lcd_data, "%d", flex_max[num]);
        lcd_puts(lcd_data);

        delay_ms(100);
    }
}

// ******************************** About PWM control *******************************************************
void check_pwm(void)
{
    unsigned int temp = 350;//PWM interrupt control
    delay_ms(100);

    while(Middle_switch_off)
    {
        if(Left_switch_on)  temp+=10;
        if(Right_switch_on)  temp-=10;
        if(temp<=0) temp=0;
        if(temp>=ICR1)  temp=ICR1;
        // 솔레노이드 밸브 오기전까지 LED로 테스트
        OCR1AH = temp>>8;
        OCR1AL = temp;
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("TEST");
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", temp);
        lcd_puts(lcd_data);

        delay_ms(100);
    }
}

// ******************************** About PWM control *******************************************************
void PUMP_test()
{
    unsigned int temp = 350;//PWM interrupt control
    delay_ms(100);

    while(Middle_switch_off)
    {
        if(Left_switch_on)  temp+=10;
        if(Right_switch_on)  temp-=10;
        if(temp<=0) temp=0;
        if(temp>=ICR1)  temp=ICR1;

        OCR1BH = temp>>8;
        OCR1BL = temp;
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("TEST");
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", temp);
        lcd_puts(lcd_data);

        delay_ms(100);
    }
}

// ******************************** About Order *******************************************************
unsigned char order(unsigned char sequence)
{
    if(Up_thumb||Up_index||Up_middle||Up_rest)    EXTENSION;
    if(Down_thumb||Down_index||Down_middle||Down_rest)  FLEXTION;
    // sequence 0 : Thumb   PC0, PC4 on, PORTC = 0x11
    // sequence 1 : Index   PC1, PC5 on, PORTC = 0x22
    // sequence 2 : Middle  PC2, PC6 on, PORTC = 0x44
    // sequence 3 : Rest    PC3, PC7 on, PORTC = 0x88
    PORTC = 0x11<<sequence;
    sequence++;
    if(sequence>3)  sequence=0;
    return sequence;
}
// ********************************************* main ******************************************************************
void main(void)
{
// Declare your local variables here
// menu
unsigned char menu = 0;
unsigned char menu_Max = 6;
unsigned char sequence=0;

PORTA=0xFE;
DDRA=0xFF;
PORTB=0x00;
DDRB=0xFF;
PORTC=0x00;
DDRC=0xFF;
PORTD=0x00;
DDRD=0xFF;
PORTE=0x00;
DDRE=0x8F;
PORTF=0x00;
DDRF=0x00;
PORTG=0x00;
DDRG=0x00;

// Compare match interrupt  : Valve on
// Overflow interrupt       : Valve off
// Timer 1 B : PUMP pwm control by using OCR1B
// Timer 1   : Inlet Valve control
// Timer 3   : Outlet Valve on

// Timer/Counter 1 initialization
TCCR1A=0x22;//Timer 1 과 관련된 입출력 핀 중 OC1B만 PWM출력(TIM1_COMPAt시에 Low) 나머지는 GPIO로 사용
TCCR1B=0x18;//Timer 1 : Fast PWM mode, 분주비=1, TOP=ICR1
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x13;
ICR1L=0x87;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;
// Timer/Counter 3 initialization
TCCR3A=0x02;//Timer 3 과 관련된 입출력 핀은 GPIO로 사용
TCCR3B=0x18;//Timer 3 : Fast PWM mode, 분주비=1, TOP=ICR3
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

//Activate timer interrupts
TIMSK = 0x14; //TIM1_COMPA interrupt on, TIM1_OVF interrupt on (Inlet Valve control)
ETIMSK = 0x14;//TIM3_COMPA interrupt on, TIM3_OVF interrupt on (Outlet Valve control)

//ADC setting
ADMUX=0x21;
ADCSRA=0xCF;  //ADC enable, ADC start, ADC interrupt on, 분주비128(62.5kHz)
SFIOR=0x01;

lcd_init(8);
// Global enable interrupts
#asm("sei")
//SREG = 0x80;
while (1)
      {
        if(Left_switch_on) menu++;
        if(Right_switch_on) menu--;
        if(menu > menu_Max)    menu = 0;
        if(menu == 0)
            if(Right_switch_on) menu = menu_Max;

        switch(menu)
        {
            // Sensor TEST
            case 0:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("1.Pressure TEST");
                    if(Middle_switch_on) pressure_test();
                    delay_ms(300);
                    break;

            case 1:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("2.Pressure Tunning");
                    if(Middle_switch_on)    pressure_tuning();
                    delay_ms(300);
                    break;

            case 2:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("3.Flex TEST");
                    if(Middle_switch_on)    flex_test();
                    delay_ms(300);
                    break;
            case 3:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("4.Flex Tunning");
                    if(Middle_switch_on)    flex_tuning();
                    delay_ms(300);
                    break;

            case 4:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("5.PWM TEST");
                    if(Middle_switch_on)    check_pwm();
                    delay_ms(300);
                    break;

            case 5:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("6.PUMP TEST");
                    if(Middle_switch_on)    PUMP_test();
                    delay_ms(300);
                    break;

            case 6:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("7.Order TEST");
                    if(Middle_switch_on)    sequence=order(sequence);
                    delay_ms(300);
                    break;

             default :
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("**BREAK!**");
                    delay_ms(300);
                    break;

         }
      }

}
