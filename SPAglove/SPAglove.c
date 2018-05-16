/*****************************************************
This program was produced by the JJH, KYY and Johnadan
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 2018 ������ǰ 12�� - S.P.A glove
Version : 1.0.0
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
#define NUM_SAMP  50  //MUST be Under 255
//About Switch
#define Left_switch_on    (!PINE.1)
#define Middle_switch_on  (!PINE.2)
#define Right_switch_on   (!PINE.3)
#define Left_switch_off   (PINE.1)
#define Middle_switch_off (PINE.2)
#define Right_switch_off  (PINE.3)
//About order
#define Up_thumb          (!PINA.0)
#define Down_thumb        (!PINA.1)
#define Up_index          (!PINA.2)
#define Down_index        (!PINA.3)
#define Up_middle         (!PINA.4)
#define Down_middle       (!PINA.5)
#define Up_rest           (!PINA.6)
#define Down_rest         (!PINA.7)

#define NO_SIGNAL_tu      (PINA.0)
#define NO_SIGNAL_td      (PINA.1)
#define NO_SIGNAL_iu      (PINA.2)
#define NO_SIGNAL_id      (PINA.3)
#define NO_SIGNAL_mu      (PINA.4)
#define NO_SIGNAL_md      (PINA.5)
#define NO_SIGNAL_ru      (PINA.6)
#define NO_SIGNAL_rd      (PINA.7)

//About u saturation
#define UPPER   100
#define LOWER   -100
//About RUN
#define IN_SPEED  800 //Only relates to reaction speed...
#define INITIATE  TIMSK = 0x14, ETIMSK = 0x14   //TIM1_COMPA interrupt on, TIM1_OVF interrupt on (Inlet Valve control)
                                                //TIM3_COMPA interrupt on, TIM3_OVF interrupt on (Outlet Valve control)

#define TERMINATE TIMSK = 0x00, ETIMSK = 0x00   //TIM1_COMPA interrupt off, TIM1_OVF interrupt off (Inlet Valve control)
                                                //TIM3_COMPA interrupt off, TIM3_OVF interrupt off (Outlet Valve control)
//*****************************************************************************************************************
// ****** Declare your global variables here  ******
unsigned char sam_num = 0; // counting variable for ADC interrupt
int i,j,k;
//*****************************************************************************************************************
// LCD
unsigned char lcd_data[40];
//*****************************************************************************************************************
// ADC
//unsigned char adc_data[4][100] = {0};
unsigned char mux = 0;
//unsigned char NUM_SAMP = 50;
unsigned char d_flag = 0;

// * Pressure
unsigned char pressure_data[4][NUM_SAMP] = {0};
unsigned int pressure_sum[4] = {0};
unsigned char pressure_mean[4] = {0};
unsigned char pressure_max[4] = {0, 0, 0, 0};
unsigned char pressure_min[4] = {255, 255, 255, 255};

// * Flex
unsigned char flex_data[4][NUM_SAMP] = {0};
unsigned int flex_sum[4] = {0};
unsigned char flex_mean[4] = {0};
unsigned char flex_max[4] = {0, 0, 0, 0};
unsigned char flex_min[4] = {255, 255, 255, 255};
// Moving
unsigned char E_flag=0; //EXTENSION : 1
unsigned char F_flag=0; //FLEXTION : 1
unsigned char Global_Sequence=0;
// PID
unsigned char kp=0.0001;
unsigned char ki=0.0000;
unsigned char kd=0.0000;
float error_old[4]={0};
float error_sum[4]={0};
unsigned char ang_desired=0;
unsigned char ang_old[4]={0};//Initial angle : 0 degrees
unsigned char delta_ang=10;//10 degrees per each sequence(EXPERIMENT NEED!)
unsigned const char Ts=60; //Control sequence term in [ms]
//*****************************************************************************************************************
// Timer 1 Controls INLET!!
// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
  PORTC = 0x01<<Global_Sequence;//INLET Valve on
}
// Timer1 overflow A interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  PORTC=0x00;//INLET Valve off
}
// Timer 3 Controls OUTLET!!
// Timer3 overflow B interrupt service routine
interrupt [TIM3_COMPB] void timer3_compa_isr(void)
{
  PORTC = 0x10<<Global_Sequence;//OUTLET Valve on
}
// Timer1 output compare A interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
  PORTC=0x00;//OUTLET Valve off
}
// ********************************* ADC interrupt service routine ************************************************
interrupt [ADC_INT] void adc_isr(void)
{
    // Read the AD conversion result
    //for (h = 0; h<=6; h++);
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
void mean_pressure(unsigned char sequence, unsigned char tunned)
{
    unsigned char num = 0; // counting variable for function
    while(!d_flag);
    for(num = 0; num < NUM_SAMP; num++)
        pressure_sum[sequence] += pressure_data[sequence][num];
    pressure_mean[sequence] = pressure_sum[sequence]/NUM_SAMP;
    pressure_sum[sequence] = 0;
    d_flag=0;
    if(tunned)
    {
      if(pressure_mean[seq]>pressure_max[seq])  pressure_mean[seq]=pressure_max[seq];
      if(pressure_mean[seq]<pressure_min[seq])  pressure_mean[seq]=pressure_min[seq];
    }
}
//Pressure test
void pressure_test(void)
{
    unsigned char num = 0;
    delay_ms(300);

    while(Middle_switch_off)
    {
        for(i=0;i<4;i++)
          mean_pressure((unsigned char)i,0);

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
        for(i=0;i<4;i++)
          mean_pressure((unsigned char)i,0);

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
void mean_flex(unsigned char sequence, unsigned char tunned)
{
    unsigned char num = 0; // counting variable for function
    while(!d_flag);
    for(num = 0; num < NUM_SAMP; num++)
        flex_sum[sequence] += flex_data[sequence][num];
    flex_mean[sequence] = flex_sum[sequence]/NUM_SAMP;
    flex_sum[sequence] = 0;
    d_flag=0;
    if(tunned)
    {
      if(flex_mean[seq]>flex_max[seq])  flex_mean[seq]=flex_max[seq];
      if(flex_mean[seq]<flex_min[seq])  flex_mean[seq]=flex_min[seq];
    }
}
//Pressure test
void flex_test(void)
{
    unsigned char num = 0;
    delay_ms(300);

    while(Middle_switch_off)
    {
        for(i=0;i<4;i++)
          mean_flex((unsigned char)i,0);

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
        for(i=0;i<4;i++)
          mean_flex((unsigned char)i,0);

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
        // TEST by LED berfore Valve delivered...
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
    if(Up_thumb||Up_index||Up_middle||Up_rest)
    {
      //EXTENSION;
      E_flag=1;
      F_flag=0;
    }
    if(Down_thumb||Down_index||Down_middle||Down_rest)
    {
      //FLEXTION;
      E_flag=0;
      F_flag=1;
    }
    if(NO_SIGNAL_tu||NO_SIGNAL_td||NO_SIGNAL_iu||NO_SIGNAL_id||NO_SIGNAL_mu||NO_SIGNAL_md||NO_SIGNAL_ru||NO_SIGNAL_rd)
    {
      E_flag=0;
      F_flag=0;
    }
    // sequence 0 : Thumb   PC0, PC4 on, PORTC = 0x11
    // sequence 1 : Index   PC1, PC5 on, PORTC = 0x22
    // sequence 2 : Middle  PC2, PC6 on, PORTC = 0x44
    // sequence 3 : Rest    PC3, PC7 on, PORTC = 0x88
    //PORTC = 0x11<<sequence;
    sequence++;
    if(sequence>3)  sequence=0;
    return sequence;
}

void test_order()
{
    unsigned char sequence=0;

    delay_ms(100);
    while(Middle_switch_on)
    {
      sequence=order(sequence);
      delay_ms(100);//Sequence term
    }
}

//**************************************%%%&&&&&&&&&&&&&&&&&&&&&&&%%%********************************************
//**************************************%%% About Actual Movement %%%********************************************
//**************************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%********************************************

// Moving fingers
void Move_finger(unsigned char seq, unsigned char P, unsigned char Bend)
{
  unsigned char threshold;//Actively changing by Bend
  unsigned char Grab=0;//if 1, no more Grab (NO FLEXTION)
  unsigned char E_OR_F;
  unsigned int OCR_in;
  unsigned int OCR_out;
  float r=0;//r=OCR_out/OCR_in
  float u=0;
  float error=0;

  /***INSERT TERM OF 'threshold' IN TERMS OF 'Bend'!!!***/

  // Grab or not?
  if(P>=threshold)  Grab=1;//Over the threshold : no more grab
  else Grab=0;//Under the threshold : Keep moving

  /*
  //Update angle (PID)
  E_OR_F = ((E_flag?-1:1)+(F_flag?1:-1))/2;//Extension:1, Flextion:-1, Do noting:0
  ang_desired = Bend+E_OR_F*delta_ang;//Ext:Bend+delta_ang, Flex:Bend-delta_ang, Stay:Bend
  error = ang_desired-ang_old[seq];
  error_sum[seq] += error;
  u = kp*error + ki*error_sum*(Ts/1000.) + kd*(error-error_old[seq])/(Ts/1000.);//Control value for OCR1A,OCR3A
  error_old[seq]=error;

  //Saturation condition...
  if(u>UPPER)       u=UPPER;
  else if(u<LOWER)  u=LOWER;
  */

  // Input update
  //Grab&Flextion:r=1, !Grab&Flextion:r=1.4, !Grab&E_flag:r=0.6, !Grab&stay:r=1, Grab&!F_flag:Extension(r=0.6) or stay(r=1)
  r = (Grab&&F_flag)?1:(((E_flag?0.2:1)+(F_flag?1.8:1))/2)
  OCR_in = IN_SPEED;  //Inlet
  OCR_out = r*OCR_in; //Outlet

  //Define action
  OCR1A = OCR_in;
  OCR3AH=OCR_out>>8;
  OCR3AL=OCR_out;
}

// About Daily mode
void RUN_daily()
{
  unsigned char seq=0;
  float ANG[4]={0};

  delay_ms(100);
  while(Middle_switch_on)
  {
    INITIATE; //Initialization, Turn interrupts on

    seq = order(seq); //Control signal of each sequence
    Global_Sequence = seq;

    mean_pressure(seq,1);
    mean_flex(seq,1);
    ANG[seq] = flex_mean[seq]/(flex_max[seq]-flex_min[seq])*90.;//Angle : 0~90degrees

    Move_finger(seq,pressure_mean[seq], ANG[seq]);
    mean_flex(seq,1);
    ang_old[seq]=ANG[seq];
    delay_ms(Ts);//sequence gab,100times PWM pulse per each sequence
  }
  TERMINATE; // Turn interrupts off
  E_flag=0;
  F_flag=0;
  Global_Sequence=0;
}



// ********************************************* main ******************************************************************
void main(void)
{
// Declare your local variables here
// menu
unsigned char menu = 0;
unsigned char menu_Max = 6;

// PA0~7 : Control switch
PORTA=0xFE;
DDRA=0xFF;
// PB6 : Pump
PORTB=0x00;
DDRB=0xFF;
// PC0~3 : Inlet Valve
// PC4~7 : Outlet Valve
PORTC=0x00;
DDRC=0xFF;
// PD0~7 : LCD
PORTD=0x00;
DDRD=0xFF;
// PE0 : EMERGENCY switch
// PE1 : Interface switch - LEFT
// PE2 : Interface switch - MIDDLE
// PE3 : Interface switch - RIGHT
// PE4 : Mode change switch (Toggle)
PORTE=0x00;
DDRE=0xEF;
// PF0~3 : Pressure Sensor
// PF4~7 : Flex Sensor
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
TCCR1A=0x22;//Only OC1B can make PWM signal(whenever TIM1_COMPA is LOW), Else : GPIO
TCCR1B=0x18;//Timer 1 : Fast PWM mode, prescale=1, TOP=ICR1 (PWM period:0.6ms)
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
TCCR3A=0x02;//All port related with Timer3 : GPIO
TCCR3B=0x18;//Timer 3 : Fast PWM mode, prescale=1, TOP=ICR3
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
//Timer/counter interrupt
TIMSK = 0x00;
ETIMSK = 0x00;

//ADC setting
ADMUX=0x21;
ADCSRA=0xCF;  //ADC enable, ADC start, ADC interrupt on, prescale:128(62.5kHz)
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
                    if(Middle_switch_on)    test_order();
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
