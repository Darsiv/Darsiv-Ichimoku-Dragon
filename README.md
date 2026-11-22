# 🐉 Darsiv Ichimoku Dragon (DID)
**Creator & Formulator:** Darsiv  
**Mathematical Model:** 4-Cycle Modern Market Equilibrium (`6 - 11 - 17 - 22 - 44`)  
**Dual-Stage Senkou A Formula:** `((6+11)/2 + (17+22)/2) / 2 = (8.5 + 19.5) / 2 = 14`  
**Temporal Median Shift:** `±22 Periods` (Exact 50% Center of Gravity of the 44-Period Box)

---

## 📖 Abstract & Overview
**Darsiv Ichimoku Dragon (DID)** is a comprehensive mathematical, calendar-based, and fractal re-engineering of the classic equilibrium system, specifically calibrated for **modern 5-day financial markets (Forex, Equities, and Commodities)** and the **Western 4-week institutional cycle**.

While Goichi Hosoda’s classic Ichimoku (`9-26-52`) was designed for the 1930s Japanese 6-day workweek and the traditional Eastern 3-decade monthly calendar (*Jun* / 旬), modern institutional order flow operates on a **5-day workweek** and a **4-week monthly cycle**. Created by **Darsiv**, the **Ichimoku Dragon (DID)** resolves the temporal phase-lag of the classic system by introducing a **4-Cycle Weekly Matrix (6 - 11 - 17 - 22 - 44)** and a novel **Dual-Stage Weighted Senkou A Formula**.

---

## 🧮 1. The Mathematical & Economic Calendar Logic (Why 6-11-17-22-44?)
In modern financial markets, both Saturdays and Sundays are closed:
* **Total Calendar Days:** 365 days/year (52 weeks).
* **Total Weekend Days:** 52 Saturdays + 52 Sundays = 104 closed days.
* **Net Active Trading Days:** $365 - 104 = \mathbf{261 \text{ trading days/year}}$.
* **Exact Monthly Equilibrium:** $261 \div 12 \text{ months} = \mathbf{21.75 \text{ trading days/month}}$ (rounded to **22**).
* **Exact Bi-Monthly Box:** $21.75 \times 2 = \mathbf{43.5 \text{ trading days}}$ (rounded to **44**).

Instead of dividing the month into 3 Eastern decades, the **Darsiv Model** divides the 22-day institutional month into **4 distinct weekly equilibrium stations** ($22 \div 4 = 5.5$):
1. **Period 6 (W1 - Dragon Head):** Represents Week 1 (5.5 rounded up to 6 to account for Monday's weekend-gap overlap).
2. **Period 11 (W2 - Dragon Heart):** Represents Week 2 (the exact 50% temporal midpoint of the trading month).
3. **Period 17 (W3 - Dragon Body):** Represents Week 3 (16.5 rounded to 17, capturing the third-quarter monthly expansion).
4. **Period 22 (W4 - Dragon Spine / Kijun):** Represents Week 4 (100% full monthly institutional equilibrium).
5. **Period 44 (2M - Dragon Base / Senkou B):** Represents the full 2-month (8-week) macro equilibrium box.

---

## ⚖️ 2. The Darsiv Dual-Stage Senkou A Formula (The Secret of 14)
In a 4-cycle system (`6, 11, 17, 22`), a simple two-line average ignores the internal price extremes of Weeks 2 and 3. To capture the true 4-dimensional equilibrium of the entire month, **Darsiv Ichimoku Dragon** introduces a **Dual-Stage Midpoint Formula**:

* **Stage 1 (First-Half Month Average - Upper Wing $SA_1$):**
  $$SA_1 = \frac{\text{Period } 6 + \text{Period } 11}{2} = \frac{17}{2} = \mathbf{8.5}$$
* **Stage 2 (Second-Half Month Average - Lower Wing $SA_2$):**
  $$SA_2 = \frac{\text{Period } 17 + \text{Period } 22}{2} = \frac{39}{2} = \mathbf{19.5}$$
* **Stage 3 (Master Senkou A - Full 4-Week Weighted Equilibrium):**
  $$\text{Master Senkou A} = \frac{SA_1 (8.5) + SA_2 (19.5)}{2} = \frac{28}{2} = \mathbf{14}$$

### Mathematical Symmetry & Golden Ratio Convergence:
* **Absolute Symmetry:** $6 + 22 = 28$ ($\div 2 = 14$), $11 + 17 = 28$ ($\div 2 = 14$), and $8.5 + 19.5 = 28$ ($\div 2 = 14$).
* **Internal Golden Ratio:** $14 \div 22 = \mathbf{0.636}$ (converging with the Fibonacci Golden Ratio **0.618**).
* **Macro Kumo Ratio:** $14 \div 44 = \mathbf{0.318}$ (maintaining the ~1/3 harmonic Kumo proportion while incorporating all 4 weekly equilibriums).

---

## ⏳ 3. The Time-Median Shift Principle (±22 Center of Gravity)
* **Senkou B (44)** calculates the *Price Midpoint* (50% height) of a 44-candle box.
* Shifting the Kumo forward by **+22** and the Chikou Span backward by **-22** establishes a 44-period temporal span from **-22 to +22**, placing **Present Price (Candle 0)** at the exact **50% Temporal Median (Center of Gravity)** of the bi-monthly cycle.

---

## 💻 4. TradingView Pine Script™ Code (v6)
```pinescript
// This Pine Script™ code is subject to the terms of the Mozilla Public License 2.0
// © Darsiv - Creator of Darsiv Ichimoku Dragon (DID)
// Mathematical Model: 4-Cycle Modern Market Equilibrium (6-11-17-22-44)
// Dual-Stage Senkou Formula: SA1(8.5) + SA2(19.5) / 2 = Master Senkou A (14)

//@version=6
indicator(title="Darsiv Ichimoku Dragon [6-11-17-22-44]", shorttitle="Darsiv Dragon (DID)", overlay=true)

grp_periods = "1. Darsiv Dragon Cycles (Forex 4-Week Logic)"
p_w1    = input.int(6,  title="W1: Dragon Head (Tenkan - Week 1)", minval=1, group=grp_periods)
p_w2    = input.int(11, title="W2: Dragon Heart (Mid-Month - Week 2)", minval=1, group=grp_periods)
p_w3    = input.int(17, title="W3: Dragon Body (Week 3)", minval=1, group=grp_periods)
p_w4    = input.int(22, title="W4: Dragon Spine (Kijun - Full Month)", minval=1, group=grp_periods)
p_sb    = input.int(44, title="2M: Dragon Base (Senkou B - 2 Months)", minval=1, group=grp_periods)
p_shift = input.int(22, title="Time Median Shift (+22 / -22)", minval=1, group=grp_periods)

grp_weeks = "2. Weekly Equilibrium Lines (Present)"
show_w1     = input.bool(true, title="Show W1: Dragon Head (6 - Blue)", group=grp_weeks)
show_w2     = input.bool(true, title="Show W2: Dragon Heart (11 - Aqua)", group=grp_weeks)
show_w3     = input.bool(true, title="Show W3: Dragon Body (17 - Orange)", group=grp_weeks)
show_w4     = input.bool(true, title="Show W4: Dragon Spine (22 - Red)", group=grp_weeks)
show_chikou = input.bool(true, title="Show Dragon Tail (Chikou -22 Purple)", group=grp_weeks)

grp_kumo = "3. Dragon Kumo Cloud Components (+22)"
show_sa1       = input.bool(false, title="Show Upper Wing: Senkou A1 (Avg 6,11 = 8.5)", group=grp_kumo)
show_sa2       = input.bool(false, title="Show Lower Wing: Senkou A2 (Avg 17,22 = 19.5)", group=grp_kumo)
show_sa_master = input.bool(true,  title="Show Dragon Core: Master Senkou A (14)", group=grp_kumo)
show_sb        = input.bool(true,  title="Show Dragon Base: Senkou B (44)", group=grp_kumo)
show_cloud     = input.bool(true,  title="Fill Main Dragon Cloud (14 vs 44)", group=grp_kumo)
show_sub_cloud = input.bool(false, title="Fill Inner Wing Cloud (8.5 vs 19.5)", group=grp_kumo)

donchian(len) => math.avg(ta.lowest(len), ta.highest(len))

line_w1 = donchian(p_w1)
line_w2 = donchian(p_w2)
line_w3 = donchian(p_w3)
line_w4 = donchian(p_w4)
line_sb = donchian(p_sb)

senkou_a1     = math.avg(line_w1, line_w2)
senkou_a2     = math.avg(line_w3, line_w4)
senkou_master = math.avg(senkou_a1, senkou_a2)

plot(show_w1 ? line_w1 : na, color=color.new(color.blue, 0),   title="W1: Dragon Head (6)",  linewidth=2)
plot(show_w2 ? line_w2 : na, color=color.new(color.aqua, 0),   title="W2: Dragon Heart (11)", linewidth=2, style=plot.style_circles)
plot(show_w3 ? line_w3 : na, color=color.new(color.orange, 0), title="W3: Dragon Body (17)", linewidth=2, style=plot.style_circles)
plot(show_w4 ? line_w4 : na, color=color.new(color.red, 0),    title="W4: Dragon Spine (22)", linewidth=2)

plot(show_chikou ? close : na, offset = -p_shift, color=color.new(color.purple, 15), title="Dragon Tail (Chikou -22)", linewidth=1)

plot_sa1 = plot(show_sa1 ? senkou_a1 : na,           offset = p_shift, color=color.new(color.teal, 20),   title="Wing A1 (8.5)", linewidth=1)
plot_sa2 = plot(show_sa2 ? senkou_a2 : na,           offset = p_shift, color=color.new(color.olive, 20),  title="Wing A2 (19.5)", linewidth=1)
plot_sam = plot(show_sa_master ? senkou_master : na, offset = p_shift, color=color.new(color.green, 0),   title="Master Senkou A (14)", linewidth=2)
plot_sb  = plot(show_sb ? line_sb : na,              offset = p_shift, color=color.new(color.maroon, 0),  title="Senkou B (44)", linewidth=2)

kumo_main_col = senkou_master > line_sb ? color.new(color.green, 82) : color.new(color.red, 82)
fill(plot_sam, plot_sb, color = show_cloud ? kumo_main_col : na, title="Main Dragon Cloud (14 vs 44)")

kumo_sub_col = senkou_a1 > senkou_a2 ? color.new(color.aqua, 85) : color.new(color.orange, 85)
fill(plot_sa1, plot_sa2, color = show_sub_cloud ? kumo_sub_col : na, title="Inner Wing Cloud (8.5 vs 19.5)")
```

---

## 💻 5. MetaTrader 4 (MQL4) Source Code
*(See the repository files or copy the MQL4 implementation from `Darsiv_Ichimoku_Dragon.mq4`)*

---
*© Copyright Darsiv. All Rights Reserved.*
