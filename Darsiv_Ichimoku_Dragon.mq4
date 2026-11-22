//+------------------------------------------------------------------+
//|                                       Darsiv_Ichimoku_Dragon.mq4 |
//|                         Copyright © 2024, Darsiv Trading Systems |
//|                     Creator of the 4-Cycle Ichimoku Dragon Model |
//+------------------------------------------------------------------+
#property copyright   "Copyright © 2024, Darsiv. All rights reserved."
#property version     "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 9

// --- Official Description in MetaTrader 4 About Tab ---
#property description "=== DARSIV ICHIMOKU DRAGON (DID) - MT4 ==="
#property description "Created by Darsiv: Modern 4-Cycle Equilibrium System (6-11-17-22-44)."
#property description "Mathematical Formula: SA1(8.5) & SA2(19.5) -> Master Senkou A (14)."
#property description "Time-Median Shift: +/- 22 Periods (Center of 44-Period Box)."

// --- Line Colors, Widths, and Styles ---
#property indicator_color1 clrDodgerBlue      // 1. W1: Dragon Head (6)
#property indicator_width1 2
#property indicator_color2 clrDeepSkyBlue     // 2. W2: Dragon Heart (11)
#property indicator_style2 STYLE_DOT
#property indicator_color3 clrDarkOrange      // 3. W3: Dragon Body (17)
#property indicator_style3 STYLE_DOT
#property indicator_color4 clrCrimson         // 4. W4: Dragon Spine (22)
#property indicator_width4 2

#property indicator_color5 clrLightSeaGreen   // 5. Wing A1 (8.5)
#property indicator_style5 STYLE_DASH
#property indicator_color6 clrGoldenrod       // 6. Wing A2 (19.5)
#property indicator_style6 STYLE_DASH
#property indicator_color7 clrForestGreen     // 7. Master Senkou A (14)
#property indicator_width7 2
#property indicator_color8 clrFireBrick       // 8. Dragon Base Senkou B (44)
#property indicator_width8 2
#property indicator_color9 clrDarkOrchid      // 9. Dragon Tail Chikou (-22)
#property indicator_width9 1

// --- 1. Period Settings ---
input string   Sep1               = "=== 1. Darsiv Dragon Cycles ==="; 
input int      Period_W1_Head     = 6;     // W1: Dragon Head (Week 1)
input int      Period_W2_Heart    = 11;    // W2: Dragon Heart (Week 2)
input int      Period_W3_Body     = 17;    // W3: Dragon Body (Week 3)
input int      Period_W4_Spine    = 22;    // W4: Dragon Spine (Full Month)
input int      Period_SenkouB     = 44;    // 2M: Dragon Base (Senkou B)
input int      Shift_Median       = 22;    // Time-Median Shift (+22 / -22)

// --- 2. Visibility Toggles for Weekly Lines (true = ON / false = OFF) ---
input string   Sep2               = "=== 2. Show/Hide Weekly Lines ==="; 
input bool     Show_W1_Head_6     = true;  // Show W1: Dragon Head (6 - Blue)
input bool     Show_W2_Heart_11   = true;  // Show W2: Dragon Heart (11 - Aqua)
input bool     Show_W3_Body_17    = true;  // Show W3: Dragon Body (17 - Orange)
input bool     Show_W4_Spine_22   = true;  // Show W4: Dragon Spine (22 - Red)
input bool     Show_Dragon_Tail   = true;  // Show Dragon Tail (Chikou -22)

// --- 3. Visibility Toggles for Dragon Kumo (+22) ---
input string   Sep3               = "=== 3. Show/Hide Dragon Kumo ==="; 
input bool     Show_Wing_A1_8_5   = false; // Show Upper Wing A1 (8.5)
input bool     Show_Wing_A2_19_5  = false; // Show Lower Wing A2 (19.5)
input bool     Show_Master_SA_14  = true;  // Show Master Senkou A (14)
input bool     Show_Base_SB_44    = true;  // Show Base Senkou B (44)

// --- Indicator Buffers ---
double Buf_W1[], Buf_W2[], Buf_W3[], Buf_W4[];
double Buf_SA1[], Buf_SA2[], Buf_SAMaster[], Buf_SB[], Buf_Chikou[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("Darsiv Ichimoku Dragon (DID)");

   SetIndexBuffer(0, Buf_W1);       SetIndexLabel(0, "DID Head (W1: 6)");
   SetIndexBuffer(1, Buf_W2);       SetIndexLabel(1, "DID Heart (W2: 11)");
   SetIndexBuffer(2, Buf_W3);       SetIndexLabel(2, "DID Body (W3: 17)");
   SetIndexBuffer(3, Buf_W4);       SetIndexLabel(3, "DID Spine (W4: 22)");
   
   SetIndexBuffer(4, Buf_SA1);      SetIndexLabel(4, "DID Wing A1 (8.5)");
   SetIndexShift(4, Shift_Median);
   
   SetIndexBuffer(5, Buf_SA2);      SetIndexLabel(5, "DID Wing A2 (19.5)");
   SetIndexShift(5, Shift_Median);
   
   SetIndexBuffer(6, Buf_SAMaster); SetIndexLabel(6, "DID Master Senkou A (14)");
   SetIndexShift(6, Shift_Median);
   
   SetIndexBuffer(7, Buf_SB);       SetIndexLabel(7, "DID Base Senkou B (44)");
   SetIndexShift(7, Shift_Median);
   
   SetIndexBuffer(8, Buf_Chikou);   SetIndexLabel(8, "DID Tail (Chikou -22)");
   SetIndexShift(8, -Shift_Median);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Darsiv Equilibrium Calculation: (High + Low) / 2                 |
//+------------------------------------------------------------------+
double GetMidpoint(int period, int shift)
  {
   int high_idx = iHighest(NULL, 0, MODE_HIGH, period, shift);
   int low_idx  = iLowest(NULL, 0, MODE_LOW, period, shift);
   if(high_idx == -1 || low_idx == -1) return(0);
   return (High[high_idx] + Low[low_idx]) / 2.0;
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   if(rates_total <= Period_SenkouB) return(0);

   int limit = rates_total - prev_calculated;
   if(prev_calculated > 0) limit++;

   for(int i = 0; i < limit; i++)
     {
      // 1. Calculate 4 Weekly Cycles & 2-Month Base
      double w1 = GetMidpoint(Period_W1_Head, i);
      double w2 = GetMidpoint(Period_W2_Heart, i);
      double w3 = GetMidpoint(Period_W3_Body, i);
      double w4 = GetMidpoint(Period_W4_Spine, i);
      double sb = GetMidpoint(Period_SenkouB, i);

      // 2. Darsiv Dual-Stage Senkou A Formula:
      // SA1 = (6+11)/2 = 8.5 | SA2 = (17+22)/2 = 19.5 | Master = (8.5+19.5)/2 = 14
      double sa1       = (w1 + w2) / 2.0;
      double sa2       = (w3 + w4) / 2.0;
      double sa_master = (sa1 + sa2) / 2.0;

      // 3. Plot Active Lines
      Buf_W1[i]       = Show_W1_Head_6    ? w1        : EMPTY_VALUE;
      Buf_W2[i]       = Show_W2_Heart_11  ? w2        : EMPTY_VALUE;
      Buf_W3[i]       = Show_W3_Body_17   ? w3        : EMPTY_VALUE;
      Buf_W4[i]       = Show_W4_Spine_22  ? w4        : EMPTY_VALUE;

      Buf_SA1[i]      = Show_Wing_A1_8_5  ? sa1       : EMPTY_VALUE;
      Buf_SA2[i]      = Show_Wing_A2_19_5 ? sa2       : EMPTY_VALUE;
      Buf_SAMaster[i] = Show_Master_SA_14 ? sa_master : EMPTY_VALUE;
      Buf_SB[i]       = Show_Base_SB_44   ? sb        : EMPTY_VALUE;
      
      Buf_Chikou[i]   = Show_Dragon_Tail  ? close[i]  : EMPTY_VALUE;
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
