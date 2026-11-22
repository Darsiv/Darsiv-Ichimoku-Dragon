//+------------------------------------------------------------------+
//|                                       Darsiv_Ichimoku_Dragon.mq5 |
//|                         Copyright © 2024, Darsiv Trading Systems |
//|                     Creator of the 4-Cycle Ichimoku Dragon Model |
//+------------------------------------------------------------------+
#property copyright   "Copyright © 2024, Darsiv. All rights reserved."
#property link  https://www.youtube.com/@Ichimokudragon
#property version     "1.00"
#property indicator_chart_window
#property indicator_buffers 11
#property indicator_plots   10

// --- Official Description in MetaTrader 5 About Tab ---
#property description "=== DARSIV ICHIMOKU DRAGON (DID) - MT5 ==="
#property description "Created by Darsiv: Modern 4-Cycle Equilibrium System (6-11-17-22-44)."
#property description "Mathematical Formula: SA1(8.5) & SA2(19.5) -> Master Senkou A (14)."
#property description "Time-Median Shift: +/- 22 Periods (Center of 44-Period Box)."

// --- Plot 1: Dragon Kumo Cloud Fill (Between Master SA 14 and Base SB 44) ---
#property indicator_label1  "DID Kumo Cloud (14 vs 44)"
#property indicator_type1   DRAW_FILLING
#property indicator_color1  clrMediumSeaGreen, clrLightCoral
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

// --- Plot 2: W1 Dragon Head (6) ---
#property indicator_label2  "DID Head (W1: 6)"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDodgerBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

// --- Plot 3: W2 Dragon Heart (11) ---
#property indicator_label3  "DID Heart (W2: 11)"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDeepSkyBlue
#property indicator_style3  STYLE_DOT
#property indicator_width3  1

// --- Plot 4: W3 Dragon Body (17) ---
#property indicator_label4  "DID Body (W3: 17)"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrDarkOrange
#property indicator_style4  STYLE_DOT
#property indicator_width4  1

// --- Plot 5: W4 Dragon Spine (22 - Kijun) ---
#property indicator_label5  "DID Spine (W4: 22)"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrCrimson
#property indicator_style5  STYLE_SOLID
#property indicator_width5  2

// --- Plot 6: Upper Wing Senkou A1 (8.5) ---
#property indicator_label6  "DID Wing A1 (8.5)"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrLightSeaGreen
#property indicator_style6  STYLE_DASH
#property indicator_width6  1

// --- Plot 7: Lower Wing Senkou A2 (19.5) ---
#property indicator_label7  "DID Wing A2 (19.5)"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrGoldenrod
#property indicator_style7  STYLE_DASH
#property indicator_width7  1

// --- Plot 8: Master Senkou A (14) ---
#property indicator_label8  "DID Master Senkou A (14)"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrForestGreen
#property indicator_style8  STYLE_SOLID
#property indicator_width8  2

// --- Plot 9: Base Senkou B (44) ---
#property indicator_label9  "DID Base Senkou B (44)"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrFireBrick
#property indicator_style9  STYLE_SOLID
#property indicator_width9  2

// --- Plot 10: Dragon Tail Chikou (-22) ---
#property indicator_label10 "DID Tail (Chikou -22)"
#property indicator_type10  DRAW_LINE
#property indicator_color10 clrDarkOrchid
#property indicator_style10 STYLE_SOLID
#property indicator_width10 1

// --- 1. Period Settings ---
input string   Sep1               = "=== 1. Darsiv Dragon Cycles ==="; 
input int      Period_W1_Head     = 6;     // W1: Dragon Head (Week 1)
input int      Period_W2_Heart    = 11;    // W2: Dragon Heart (Week 2)
input int      Period_W3_Body     = 17;    // W3: Dragon Body (Week 3)
input int      Period_W4_Spine    = 22;    // W4: Dragon Spine (Full Month)
input int      Period_SenkouB     = 44;    // 2M: Dragon Base (Senkou B)
input int      Shift_Median       = 22;    // Time-Median Shift (+22 / -22)

// --- 2. Visibility Toggles for Weekly Lines ---
input string   Sep2               = "=== 2. Show/Hide Weekly Lines ==="; 
input bool     Show_W1_Head_6     = true;  // Show W1: Dragon Head (6 - Blue)
input bool     Show_W2_Heart_11   = true;  // Show W2: Dragon Heart (11 - Aqua)
input bool     Show_W3_Body_17    = true;  // Show W3: Dragon Body (17 - Orange)
input bool     Show_W4_Spine_22   = true;  // Show W4: Dragon Spine (22 - Red)
input bool     Show_Dragon_Tail   = true;  // Show Dragon Tail (Chikou -22)

// --- 3. Visibility Toggles for Dragon Kumo (+22) ---
input string   Sep3               = "=== 3. Show/Hide Dragon Kumo ==="; 
input bool     Show_Kumo_Fill     = true;  // Fill Main Dragon Cloud (14 vs 44)
input bool     Show_Wing_A1_8_5   = false; // Show Upper Wing A1 (8.5)
input bool     Show_Wing_A2_19_5  = false; // Show Lower Wing A2 (19.5)
input bool     Show_Master_SA_14  = true;  // Show Master Senkou A Line (14)
input bool     Show_Base_SB_44    = true;  // Show Base Senkou B Line (44)

// --- Indicator Buffers ---
double Buf_Fill_A[], Buf_Fill_B[];
double Buf_W1[], Buf_W2[], Buf_W3[], Buf_W4[];
double Buf_SA1[], Buf_SA2[], Buf_SAMaster[], Buf_SB[], Buf_Chikou[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME, "Darsiv Ichimoku Dragon (DID)");

   // Map Buffers
   SetIndexBuffer(0,  Buf_Fill_A,   INDICATOR_DATA);
   SetIndexBuffer(1,  Buf_Fill_B,   INDICATOR_DATA);
   SetIndexBuffer(2,  Buf_W1,       INDICATOR_DATA);
   SetIndexBuffer(3,  Buf_W2,       INDICATOR_DATA);
   SetIndexBuffer(4,  Buf_W3,       INDICATOR_DATA);
   SetIndexBuffer(5,  Buf_W4,       INDICATOR_DATA);
   SetIndexBuffer(6,  Buf_SA1,      INDICATOR_DATA);
   SetIndexBuffer(7,  Buf_SA2,      INDICATOR_DATA);
   SetIndexBuffer(8,  Buf_SAMaster, INDICATOR_DATA);
   SetIndexBuffer(9,  Buf_SB,       INDICATOR_DATA);
   SetIndexBuffer(10, Buf_Chikou,   INDICATOR_DATA);

   // Apply Temporal Shifts (+22 for Kumo, -22 for Chikou)
   PlotIndexSetInteger(0, PLOT_SHIFT,  Shift_Median); // Cloud Fill
   PlotIndexSetInteger(5, PLOT_SHIFT,  Shift_Median); // Wing A1
   PlotIndexSetInteger(6, PLOT_SHIFT,  Shift_Median); // Wing A2
   PlotIndexSetInteger(7, PLOT_SHIFT,  Shift_Median); // Master SA (14)
   PlotIndexSetInteger(8, PLOT_SHIFT,  Shift_Median); // Base SB (44)
   PlotIndexSetInteger(9, PLOT_SHIFT, -Shift_Median); // Chikou Tail (-22)

   // Set Empty Values
   for(int p = 0; p < 10; p++)
      PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   // Set Buffers as TimeSeries (0 = Current Bar)
   ArraySetAsSeries(Buf_Fill_A,   true);
   ArraySetAsSeries(Buf_Fill_B,   true);
   ArraySetAsSeries(Buf_W1,       true);
   ArraySetAsSeries(Buf_W2,       true);
   ArraySetAsSeries(Buf_W3,       true);
   ArraySetAsSeries(Buf_W4,       true);
   ArraySetAsSeries(Buf_SA1,      true);
   ArraySetAsSeries(Buf_SA2,      true);
   ArraySetAsSeries(Buf_SAMaster, true);
   ArraySetAsSeries(Buf_SB,       true);
   ArraySetAsSeries(Buf_Chikou,   true);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Helper Function: Calculate Midpoint (High + Low) / 2             |
//+------------------------------------------------------------------+
double GetMidpointMT5(const double &high[], const double &low[], int period, int shift, int total)
  {
   if(shift + period > total) return(EMPTY_VALUE);
   double max_h = high[shift];
   double min_l = low[shift];
   for(int k = shift + 1; k < shift + period; k++)
     {
      if(high[k] > max_h) max_h = high[k];
      if(low[k]  < min_l) min_l = low[k];
     }
   return (max_h + min_l) / 2.0;
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

   ArraySetAsSeries(high,  true);
   ArraySetAsSeries(low,   true);
   ArraySetAsSeries(close, true);

   int limit = rates_total - prev_calculated;
   if(prev_calculated == 0)
      limit = rates_total - Period_SenkouB - 1;
   else
      limit++;

   for(int i = 0; i <= limit && i < rates_total - Period_SenkouB; i++)
     {
      // 1. Calculate 4 Weekly Cycles & 2-Month Base
      double w1 = GetMidpointMT5(high, low, Period_W1_Head,  i, rates_total);
      double w2 = GetMidpointMT5(high, low, Period_W2_Heart, i, rates_total);
      double w3 = GetMidpointMT5(high, low, Period_W3_Body,  i, rates_total);
      double w4 = GetMidpointMT5(high, low, Period_W4_Spine, i, rates_total);
      double sb = GetMidpointMT5(high, low, Period_SenkouB,  i, rates_total);

      // 2. Darsiv Dual-Stage Senkou A Formula:
      // SA1 = (6+11)/2 = 8.5 | SA2 = (17+22)/2 = 19.5 | Master = (8.5+19.5)/2 = 14
      double sa1       = (w1 + w2) / 2.0;
      double sa2       = (w3 + w4) / 2.0;
      double sa_master = (sa1 + sa2) / 2.0;

      // 3. Assign Buffers Based on User Toggles
      Buf_Fill_A[i]   = Show_Kumo_Fill    ? sa_master : EMPTY_VALUE;
      Buf_Fill_B[i]   = Show_Kumo_Fill    ? sb        : EMPTY_VALUE;

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
