/*****************************************************
This program was produced by the JJH, KYY and Johnadan
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 2018 ������ǰ 12�� - S.P.A glove
Version : 2.2.0
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
#define Left_switch_on    (!PINE.3)
#define Middle_switch_on  (!PINE.2)
#define Right_switch_on   (!PINE.1)
#define Left_switch_off   (PINE.3)
#define Middle_switch_off (PINE.2)
#define Right_switch_off  (PINE.1)
//About order
#define Up_thumb          (!PINE.5)
#define Down_thumb        (!PINA.1)
#define Up_index          (!PINA.2)
#define Down_index        (!PINA.3)
#define Up_middle         (!PINA.4)
#define Down_middle       (!PINA.5)
#define Up_rest           (!PINA.6)
#define Down_rest         (!PINA.7)

#define NO_SIGNAL_tu      (PINE.5)
#define NO_SIGNAL_td      (PINA.1)
#define NO_SIGNAL_iu      (PINA.2)
#define NO_SIGNAL_id      (PINA.3)
#define NO_SIGNAL_mu      (PINA.4)
#define NO_SIGNAL_md      (PINA.5)
#define NO_SIGNAL_ru      (PINA.6)
#define NO_SIGNAL_rd      (PINA.7)

//About u saturation
#define UPPER   3790
#define LOWER   1250
//About RUN
#define NORMAL_SPEED  500 //Only relates to reaction speed...
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
unsigned int  pressure_sum[4] = {0};
unsigned char pressure_mean[4] = {0};

// * Flex
unsigned char flex_data[4][NUM_SAMP] = {0};
unsigned int  flex_sum[4] = {0};
unsigned char flex_mean[4] = {0};

//tuning
unsigned char flex_max[4] = {0};
unsigned char flex_min[4] = {255, 255, 255, 255};
unsigned char pressure_max[4] = {0};
unsigned char pressure_min[4] = {255, 255, 255, 255};

// Moving
unsigned char E_flag[4]={0}; //EXTENSION : 1
unsigned char F_flag[4]={0}; //FLEXTION : 1
unsigned char Global_Sequence=0;

// PID
double kp=0.0001;
double ki=0.0000;
double kd=0.0000;
double error_old[4]={0};
double error_sum[4]={0};
unsigned char ang_desired=0;
unsigned char ang_old[4]={0};//Initial angle : 0 degrees
unsigned char delta_ang=10;//10 degrees per each sequence(EXPERIMENT NEED!)
unsigned const char Ts=60; //Control sequence term in [ms]
//*****************************************************************************************************************
// Timer 1 Controls INLET!!
// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
  PORTC |= 0x01<<Global_Sequence;//INLET Valve on
}
// Timer1 overflow A interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  PORTC=0x00;//INLET Valve off
}
// Timer 3 Controls OUTLET!!
// Timer3 comparematch A interrupt service routine
interrupt [TIM3_COMPA] void timer3_compa_isr(void)
{
  PORTC |= 0x10<<Global_Sequence;//OUTLET Valve on
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
      if(pressure_mean[sequence]>pressure_max[sequence])  pressure_mean[sequence]=pressure_max[sequence];
      if(pressure_mean[sequence]<pressure_min[sequence])  pressure_mean[sequence]=pressure_min[sequence];
    }
}
//Pressure test
void pressure_test(void)
{
    unsigned char num = 0;
    delay_ms(50);

    while(Middle_switch_off)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Testing");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;    
        mean_pressure((unsigned char)num,0);

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
    delay_ms(50);

    while(Middle_switch_off)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Tunning");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;            
        
        mean_pressure((unsigned char)num,0);  
        
        if(pressure_mean[num]>pressure_max[num])  pressure_max[num]=pressure_mean[num];
        if(pressure_mean[num]<pressure_min[num])  pressure_min[num]=pressure_mean[num];

        lcd_gotoxy(7, 0);
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
      if(flex_mean[sequence]>flex_max[sequence])  flex_mean[sequence]=flex_max[sequence];
      if(flex_mean[sequence]<flex_min[sequence])  flex_mean[sequence]=flex_min[sequence];
    }
}
//Pressure test
void flex_test(void)
{
    unsigned char num = 0;
    delay_ms(50);

    while(Middle_switch_off)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Testing");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;
        mean_flex((unsigned char)num,0);

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
    delay_ms(50);

    while(Middle_switch_off)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Tunning");

        if(Left_switch_on)  num++;
        if(Right_switch_on) num--;
        if(num>3) num=3;
        mean_flex((unsigned char)num,0);

        if(flex_mean[num]>flex_max[num])  flex_max[num]=flex_mean[num];
        if(flex_mean[num]<flex_min[num])  flex_min[num]=flex_mean[num];

        lcd_gotoxy(7, 0);
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
    char temp = 50;//PWM interrupt control, 50% duty
    delay_ms(50); 
    
    INITIATE; //Timer interrupts on
    while(Middle_switch_off)
    {
        if(Left_switch_on)  temp++;
        if(Right_switch_on)  temp--;
        if(temp<1) temp=1;
        if(temp>99)  temp=99;
        // TEST by LED berfore Valve delivered...
        OCR1AH = temp*50>>8;  
        OCR1AL = temp*50;   //duty ratioŬ���� ���Ⱑ ������(Compare Match Interrupt���� ON)     
        
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Duty");
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d %", temp);
        lcd_puts(lcd_data);   

        delay_ms(100);
    }  
    TERMINATE; //Timer interrupts off 
    PORTC=0x00;
    OCR1AH = 0;
    OCR1AL = 0;//0% duty
}

// ******************************** About PWM control *******************************************************
void PUMP_test()
{
    int temp = 50;//50% duty
    delay_ms(50);

    while(Middle_switch_off)
    {
        if(Left_switch_on)  temp++;
        if(Right_switch_on)  temp--;
        if(temp<1) temp=1;
        if(temp>99)  temp=99;
        // TEST by LED berfore Valve delivered...
        OCR1BH = temp*50 >>8; 
        OCR1BL = temp*50; 
        
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Duty");
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d %", temp);
        lcd_puts(lcd_data);   
        
        delay_ms(100);       
    }     
    OCR1BH=0x00;
    OCR1BL=0x00; //0% duty 
    PORTB=0x00;
}

// ******************************** About Order *******************************************************
void order(unsigned char * sequence)
{
    unsigned char seq=*sequence;      
    unsigned char Order=0x00;    
    
    if(Up_thumb)    Order|=0x01; 
    if(Up_index)    Order|=0x02; 
    if(Up_middle)   Order|=0x04; 
    if(Up_rest)     Order|=0x08;
    if(Down_thumb)  Order|=0x10;   
    if(Down_index)  Order|=0x20; 
    if(Down_middle) Order|=0x40; 
    if(Down_rest)   Order|=0x80;  
    if(NO_SIGNAL_tu&&NO_SIGNAL_td) Order&=0xEE; 
    if(NO_SIGNAL_iu&&NO_SIGNAL_id) Order&=0xDD; 
    if(NO_SIGNAL_mu&&NO_SIGNAL_md) Order&=0xBB; 
    if(NO_SIGNAL_ru&&NO_SIGNAL_rd) Order&=0x77;    
    /*
    lcd_clear();  
    lcd_gotoxy(0, 0);   
    sprintf(lcd_data, "%2x", Order);
    lcd_puts(lcd_data);
    */
    
    if(Order&(0x01<<seq))   
    {
        E_flag[seq]=1;
        F_flag[seq]=0;
    }  
    if(Order&(0x10<<seq))   
    {
        E_flag[seq]=0;
        F_flag[seq]=1;
    }
    if(!(Order&(0x01<<seq))&&!(Order&(0x10<<seq)))  
    {
        E_flag[seq]=0;
        F_flag[seq]=0;
    }
    
    // sequence 0 : Thumb   PC0, PC4 on, PORTC = 0x11
    // sequence 1 : Index   PC1, PC5 on, PORTC = 0x22
    // sequence 2 : Middle  PC2, PC6 on, PORTC = 0x44
    // sequence 3 : Rest    PC3, PC7 on, PORTC = 0x88
    //PORTC = 0x11<<sequence;
    seq++;
    if(seq>3) seq=0;
    *sequence=seq;
}

void disp(unsigned char x, unsigned char seq)
{
    lcd_gotoxy(x, 1);
    if(E_flag[seq])                     lcd_putsf("E");   
    if(F_flag[seq])                     lcd_putsf("F");   
    if((E_flag[seq]==0)&&(F_flag[seq]==0))  lcd_putsf("-");
}

void test_order()
{
    unsigned char sequence=0;

    delay_ms(50);
    while(Middle_switch_off)
    {
        order(&sequence);   
        
        lcd_clear();  
        
        lcd_gotoxy(0, 0);lcd_putsf("T");
        lcd_gotoxy(2, 0);lcd_putsf("I");
        lcd_gotoxy(4, 0);lcd_putsf("M");
        lcd_gotoxy(6, 0);lcd_putsf("R");
        
        disp(0,0);
        disp(2,1); 
        disp(4,2); 
        disp(6,3);   
        
              
        /*
        lcd_gotoxy(0, 1);
        sprintf(lcd_data, "%d", sequence);
        lcd_puts(lcd_data);
        */
        delay_ms(100);//Sequence term
    }
}

void valve_order()
{
    unsigned char seq=0; 
    unsigned char temp=0; 
    
    delay_ms(50);  
    INITIATE;   
    while(Middle_switch_off)
    {
        order(&seq);
        //Global_Sequence=seq;
        
        lcd_clear(); 
        lcd_gotoxy(0, 0);lcd_putsf("Valve!");   
        
        if(Left_switch_on)  Global_Sequence++;
        if(Right_switch_on)  Global_Sequence--;
        if(Global_Sequence>3)   Global_Sequence=0;
        if(Global_Sequence==0 && Right_switch_on)   Global_Sequence=3;   
        
        lcd_gotoxy(7, 0);   
        sprintf(lcd_data, "%d", Global_Sequence);
        lcd_puts(lcd_data);
        
        disp(0,Global_Sequence);    
        
        lcd_gotoxy(5, 1); 
        sprintf(lcd_data, "%d", E_flag[Global_Sequence]);
        lcd_puts(lcd_data);
        lcd_gotoxy(7, 1); 
        sprintf(lcd_data, "%d", F_flag[Global_Sequence]);
        lcd_puts(lcd_data);
                
        
        if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==0)) 
        {
            OCR1AH=500>>8;
            OCR1AL=500;
            OCR3AH=500>>8;
            OCR3AL=500;
        }  
        if((E_flag[Global_Sequence]==1)&&(F_flag[Global_Sequence]==0))
        { 
            OCR1AH=800>>8;
            OCR1AL=800;
            OCR3AH=200>>8;
            OCR3AL=200;
        }
        if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==1)) 
        {
            OCR1AH=200>>8;
            OCR1AL=200;
            OCR3AH=800>>8;
            OCR3AL=800;
        }     
        delay_ms(100);
    }     
    TERMINATE;                 
    Global_Sequence=0; 
    OCR1A =0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    for(i=0;i<4;i++)
    {
        E_flag[i]=0;
        F_flag[i]=0;
    }           
    PORTB=0x00;
    PORTC=0x00;        
}

void pump_valve()
{
    unsigned char seq=0; 
    unsigned char temp=50; 
    
    delay_ms(50);  
    INITIATE;   
    while(Middle_switch_off)
    {
        order(&seq);
        Global_Sequence=seq;
        
        lcd_clear(); 
        lcd_gotoxy(0, 0);lcd_putsf("Duty : ");
        lcd_gotoxy(6, 0);sprintf(lcd_data, "%2d %", temp);
        lcd_puts(lcd_data);
        
        disp(0,Global_Sequence);    
        
        lcd_gotoxy(5, 1); 
        sprintf(lcd_data, "%d", E_flag[Global_Sequence]);
        lcd_puts(lcd_data);
        lcd_gotoxy(7, 1); 
        sprintf(lcd_data, "%d", F_flag[Global_Sequence]);
        lcd_puts(lcd_data);
                
        
        if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==0)) 
        {
            OCR1AH=50*50>>8;
            OCR1AL=50*50;
            OCR3AH=50*50>>8;
            OCR3AL=50*50;
        }  
        if((E_flag[Global_Sequence]==1)&&(F_flag[Global_Sequence]==0))
        { 
            OCR1AH=70*50>>8;
            OCR1AL=70*50;
            OCR3AH=30*50>>8;
            OCR3AL=30*50;
        }
        if((E_flag[Global_Sequence]==0)&&(F_flag[Global_Sequence]==1)) 
        {
            OCR1AH=30*50>>8;
            OCR1AL=30*50;
            OCR3AH=70*50>>8;
            OCR3AL=70*50;
        }         
        
        if(Left_switch_on)  temp++;
        if(Right_switch_on)  temp--;
        if(temp<1) temp=1;
        if(temp>99)  temp=99;
        // TEST by LED berfore Valve delivered...
        OCR1BH = temp*50 >>8; 
        OCR1BL = temp*50; 
        
        delay_ms(500);
    }    
    TERMINATE;                 
    Global_Sequence=0; 
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00; 
    OCR1BL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    for(i=0;i<4;i++)
    {
        E_flag[i]=0;
        F_flag[i]=0;
    }         
    PORTB=0x00;
    PORTC=0x00;
}

//**************************************%%%&&&&&&&&&&&&&&&&&&&&&&&%%%********************************************
//**************************************%%% About Actual Movement %%%********************************************
//**************************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%********************************************
//Measuring Grab threshold
void measure_threshold()
{
    int seq = 0;//50% duty
    delay_ms(50);

    while(Middle_switch_off)
    {
        if(Left_switch_on)  seq++;
        if(Right_switch_on)  seq--;
        if(seq>3)  seq=0;
        if(seq==0 && Right_switch_on)  seq=3;
        
        mean_flex(seq,1);
        mean_pressure(seq,1);                                      
        
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("FLEX");
        lcd_gotoxy(5, 0);
        sprintf(lcd_data, "%d %", flex_mean[seq]);
        lcd_puts(lcd_data); 
        
        lcd_gotoxy(0, 1);
        lcd_putsf("PRES");
        lcd_gotoxy(5, 1);
        sprintf(lcd_data, "%d %", pressure_mean[seq]);
        lcd_puts(lcd_data);  
        
        delay_ms(100);       
    }
}

// Moving fingers
void Move_finger(unsigned char seq, unsigned char P, unsigned char Bend)
{
  unsigned char threshold;//Actively changing by Bend
  unsigned char Grab=0;//if 1, no more Grab (NO FLEXTION)
  unsigned char E_OR_F;
  unsigned int OCR_in;
  unsigned int OCR_out;
  //double r=0;//r=OCR_out/OCR_in
  double r_in=1;//inlet speed ratio
  double r_out=1;//outlet speed ratio
  double u=0;
  double error=0;

  /***INSERT TERM OF 'threshold' IN TERMS OF 'Bend'!!!***/
  threshold = 70;//�ϴܸ𸣴ϱ� ����� ��
  // Grab or not?
  if(P>=threshold)  Grab=1;//Over the threshold : no more grab
  else Grab=0;//Under the threshold : Keep moving


  //Update angle (PID)
  E_OR_F = ((E_flag[seq]?-1:1)+(F_flag[seq]?1:-1))/2;//Extension:1, Flextion:-1, Do noting:0
  ang_desired = Bend+E_OR_F*delta_ang;//Ext:Bend+delta_ang, Flex:Bend-delta_ang, Stay:Bend
  error = ang_desired-ang_old[seq];
  error_sum[seq] += error;
  u = kp*error + ki*error_sum[seq]*(Ts/1000.) + kd*(error-error_old[seq])/(Ts/1000.);//Control value for OCR1A,OCR3A
  error_old[seq]=error;

  //Saturation condition...
  if(u>UPPER)       u=UPPER;
  else if(u<LOWER)  u=LOWER;


  // Input update       
  /*������... (Input-Output ratio calcultate)
  //Grab&Flextion:r=1, !Grab&Flextion:r=1.4, !Grab&E_flag:r=0.6, !Grab&stay:r=1, Grab&!F_flag:Extension(r=0.6) or stay(r=1)
  r = (Grab&&F_flag[seq])?1:(((E_flag[seq]?0.2:1)+(F_flag[seq]?1.8:1))/2);  
  
  
  //without PID
  OCR_in = IN_SPEED;  //Inlet
  OCR_out = r*OCR_in; //Outlet
  
  //with PID
  OCR_in = u;           //Inlet
  OCR_out = r*OCR_in;   //Outlet     
  */    
     
  /*�Ź���...
  ���� �ӵ��� PID�� ���� �� 
  1. Grab ������ ���� ���� ��� Flextion�̸� inlet�� ���� ������ outlet�� ���� ������ �Ҵ�
  2. Grab ������ ���� ���� ��� Extension�̸� inlet�� ���� ������ outlet�� ���� ������ �Ҵ�
  3. Grab ������ �� ��� Flextion�̸� inlet/outlet ��� ���ؼӵ���� 
  4. Grab ������ �� ��� Extension�̸� inlet�� ���� ������ outlet�� ���� ������ �Ҵ�  
  5. �ƹ��� �Է��� ���� ��� �����������¸� ����
  */                 
  //Grab&Flextion:r=1, !Grab&Flextion:r=1.4, !Grab&E_flag:r=0.6, !Grab&stay:r=1, Grab&!F_flag:Extension(r=0.6) or stay(r=1)
  r_in = (Grab&&F_flag[seq])?1:(((E_flag[seq]?0.2:1)+(F_flag[seq]?1.8:1))/2);   
  //Grab&Flextion:r=1, !Grab&Flextion:r=0.6, !Grab&E_flag:r=1.4, !Grab&stay:r=1, Grab&!F_flag:Extension(r=1.4) or stay(r=1)     
  r_out = (Grab&&F_flag[seq])?1:(((E_flag[seq]?1.8:1)+(F_flag[seq]?0.2:1))/2);      
  
  //with PID
  OCR_in = r_in*u;          //Inlet
  OCR_out = r_out*u;        //Outlet 
  
  //Define action
  OCR1AH = OCR_in>>8;
  OCR1AL = OCR_in;
  OCR3AH = OCR_out>>8;
  OCR3AL = OCR_out;
}

// About Daily mode
void RUN_daily()
{
  unsigned char seq=0;
  float ANG[4]={0};

  delay_ms(100);
  INITIATE; //Initialization, Turn interrupts on
  while(Middle_switch_on)
  {
    order(&seq); //Control signal of each sequence
    Global_Sequence = seq;

    mean_pressure(seq,1);
    mean_flex(seq,1);
    ANG[seq] = (flex_max[seq]-flex_mean[seq])/(flex_max[seq]-flex_min[seq])*90.;//Angle : 0~90degrees, ������ ������ Ŭ���� �������� �۾���

    Move_finger(seq,pressure_mean[seq], ANG[seq]);
    ang_old[seq]=ANG[seq];
    delay_ms(Ts);//sequence gab,100times PWM pulse per each sequence
  } 
  for(i=0;i<4;i++)
  {
    E_flag[i]=0;
    F_flag[i]=0;
  }
  Global_Sequence=0; 
  OCR1AH=0x00;
  OCR1AL=0x00;
  OCR1BH=0x00; 
  OCR1BL=0x00;
  OCR1BH=0x00;
  OCR1BL=0x00;  
  PORTC=0x00;
  TERMINATE; // Turn interrupts off 
}

// About Rhabilitation
void Rehab()
{    
    unsigned char seq=0;
    
    delay_ms(100);      
    INITIATE; //Initialization, Turn interrupts on
    while(Middle_switch_on)
    {
        order(&seq); //Control signal of each sequence
        Global_Sequence = seq;

        mean_flex(seq,1);
        ANG[seq] = (flex_max[seq]-flex_mean[seq])/(flex_max[seq]-flex_min[seq])*90.;//Angle : 0~90degrees, ������ ������ Ŭ���� �������� �۾���        
        
        /* 
        ...
        */
        
        delay_ms(Ts);//sequence gab,100times PWM pulse per each sequence
    }
    Global_Sequence=0; 
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00; 
    OCR1BL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;  
    PORTC=0x00;
    TERMINATE; // Turn interrupts off   
} 

// ********************************************* main ******************************************************************
void main(void)
{
// Declare your local variables here
// menu
unsigned char menu = 0;
unsigned char menu_Max = 9;

// PA1~7 : Control switch (PA0�ȵ�)
PORTA=0x00;
DDRA=0x01;
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
// * PE5 : Thumb up....
PORTE=0x00;
DDRE=0xC0;
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
TCCR1A=0x22;//Only OC1B can make PWM signal(whenever TIM1_COMPB is LOW), Else : GPIO
//TCCR1A=0x02;
TCCR1B=0x1C;//Timer 1 : Fast PWM mode, prescale=256, TOP=ICR1 (PWM period:80ms)
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
TCCR3B=0x1C;//Timer 3 : Fast PWM mode, prescale=256, TOP=ICR3, f=clk/((TOP+1)*prescale)=80ms
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x13;
ICR3L=0x87;
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
                    delay_ms(100);
                    break;

            case 1:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("2.Pressure Tunning");
                    if(Middle_switch_on)    pressure_tuning();
                    delay_ms(100);
                    break;

            case 2:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("3.Flex TEST");
                    if(Middle_switch_on)    flex_test();
                    delay_ms(100);
                    break;
            case 3:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("4.Flex Tunning");
                    if(Middle_switch_on)    flex_tuning();
                    delay_ms(100);
                    break;

            case 4:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("5.PWM TEST");
                    if(Middle_switch_on)    check_pwm();
                    delay_ms(100);
                    break;

            case 5:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("6.PUMP TEST");
                    if(Middle_switch_on)    PUMP_test();
                    delay_ms(100);
                    break;

            case 6:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("7.Order TEST");
                    if(Middle_switch_on)    test_order();
                    delay_ms(100);
                    break;
                     
            case 7:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("8.Valve Order");
                    if(Middle_switch_on)    valve_order();
                    delay_ms(100);
                    break;
                    
            case 8:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("9.Threshold?");
                    if(Middle_switch_on)    measure_threshold();
                    delay_ms(100);
                    break;
            
            case 9:
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("10.PUMP VALVE");
                    if(Middle_switch_on)    pump_valve();
                    delay_ms(100);
                    break;
            
             default :
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_putsf("**BREAK!**");
                    delay_ms(100);
                    break;

         }
      }

}
