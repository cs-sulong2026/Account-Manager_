//+------------------------------------------------------------------+
//|                                                   AM_Defines.mqh |
//|                                 Copyright 2025, Cheruhaya Sulong |
//|                           https://www.mql5.com/en/users/cssulong |
//| 02.12.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cheruhaya Sulong"
#property link      "https://www.mql5.com/en/users/cssulong"
//---
#include <Trade/AccountInfo.mqh>
#include <Arrays/ArrayObj.mqh>
// For Internal Use
// #include <AM_Enumerations.mqh>
// For VPS Use
#include "AM_Enumerations.mqh"

//#region Input
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
input group "Account Preferences"
input ENUM_ACCOUNT_PACKAGE    inpPackages = ACCOUNT_PACKAGE_51010;      // Account Package
input ENUM_FUNDED_AMOUNT      inpFundedAmount = FUNDED_AMOUNT_10000;    // Funded Amount
input group "Trading Preferences"
input ENUM_MARKET_CONDITIONS  inpMarketMood = CLEAR_AND_STRONG_TREND;   // Current market conditions
input double                  inpDailyTarget = 100.00;                  // Daily Target in $
input bool                    inpApplyToPending = true;                 // Apply to pending orders too?

input group "Trailing Stop Preferences"
input bool                    inpTrailingStopEnabled = true;            // Enable Trailing Stop
input ENUM_CONTROL_TYPE       inpTrailingType = BY_PERCENTAGE;          // Trailing Stop Type
input bool                    inpTrailingClosePartial = false;          // Trailing Stop Close Partial
input double                  inpTrailingStart = 0.5;                   // Trailing Stop Start
input double                  inpTrailingCoverage = 30.0;                // Trailing Stop Distance in % Profit
input group "EA Preferences"
input bool                    inpShowControlPanel = false;                       // Enable Expert Advisor Management
// input bool                    inpShowStrategyInfo = false;              // Show or hide strategy info and recomendations
// input bool                    inpShowSymbolInfo = false;                // Show or hide current symbol on chart info
//#endregion

//+------------------------------------------------------------------+
//| Account Manager structure                                        |
//+------------------------------------------------------------------+
struct SAccountManager
{
   //--- Account Package Parameters
   string               PackageName;
   string               FundProcess;
   bool                 ScaleUpPlan;
   double               DailyPercent;
   double               MaxPercent;
   bool                 NoProfitTarget;
   double               TargetPercent;
   bool                 ProfitConsistencyRule;
   bool                 RiskConsistencyRule;
   double               RiskConsistencyRulePercent;
   bool                 DailyLossBased;
   double               DailyLossBreachedPercent;
   double               Payout;
   //--- Chart Parameters
   string               chartSymbol;
   ENUM_TIMEFRAMES      chartTimeframe;
   //---
   ENUM_MARKET_CONDITIONS marketMood;
   //--- Calculated Parameters
   int                  totalDaysTraded;
   int                  maxUtilizeRatePts;
   int                  maxDrawdownPts;
   int                  tradesToPercentage;
   int                  daysToPercentage;
   int                  winTrades;
   int                  lossTrades;
   double               initialBalance;
   double               dailyLoss;
   double               dailyLossLimit;
   double               dailyRemaining;
   double               dailyRemainingPercent;
   double               dailyTargetLimit;
   double               todayTarget;
   double               pipsTarget;
   double               profitTargetPerTrade;
   double               minProfitTarget;
   double               maxLoss;
   double               maxLossLimit;
   double               maxRemaining;
   double               maxRemainingPercent;
   double               riskInMoney;
   double               riskRuleInMoney;
   double               percentToRiskRule;
   double               totalPercentToRiskRule;
   double               profitRemain;
   double               profitRemaining;
   double               profitRemainingPercent;
   double               profitConsistencyPercent;
   double               closedPL;
   double               dailyNetPL;
   double               bestDailyNetPL;
   double               totalDailyNetPL;
   double               profitability;
   double               maximalPeak;
   double               nextMinimalPeak;
   double               utilizeRate;
   double               maxUtilizeRate;
   double               drawdown;
   double               maxDrawdown;
   double               riskRatio;
   double               tradeRating;
   double               pipValue;
   double               profitShare;
   double               profitSharePercent;
   //---
   double               lastDailyBalance;
   double               lastDailyEquity;
   datetime             lastDailyLogTime;
//#region OnTradeProcessing
   int                  digits;
   int                  pos_modified;
   bool                 is_found;
   bool                 is_triggered;
   bool                 daily_target_reached;
   bool                 result;
   ulong                ticket;
   string               type;
   string               symbol;
   string               name;
   double               point;
   double               tick_value;
   double               tick_size;
   double               bid;
   double               ask;
   double               price_open;
   double               price_current;
   double               op_price_weighted;
   double               cu_price_weighted;
   double               sl_price_weighted;
   double               tp_price_weighted;
   double               volume;
   double               change;
   double               stop_loss;
   double               percent_to_SL;
   double               take_profit;
   double               percent_to_TP;
   double               float_PnL;
   double               float_pips;
   double               reward;
   double               reward_pips;
   double               BE_start;
   double               trailing_start;
//#endregion
//#region OnTradeIdeas
   bool                 trade_with_SL;
   bool                 trade_with_TP;
   string               trade_name;
   double               trade_price_weighted;
   double               trade_volume;
   double               trade_PnL;
   double               trade_pips;
   double               trade_change;
   double               diff_weighted_1;
   double               diff_weighted_2;
//#endregion
   CAccountInfo         acc;

//#region Methods
   void InitializePackage(ENUM_ACCOUNT_PACKAGE accPackage) {
      switch (accPackage)
      {
      case ACCOUNT_PACKAGE_FREE:
         // Set conditions for Free Package
         break;
      case ACCOUNT_PACKAGE_STANDARD:
         // Set conditions for Standard Package
         break;
      case ACCOUNT_PACKAGE_PERSONALIZED:
         // Set conditions for Personalized Package
         {
            PackageName = "Customized";
            FundProcess = "Instant Funding";
            ScaleUpPlan = true;
            DailyPercent = 2.0;
            MaxPercent = 4.0;
            NoProfitTarget = false;
            TargetPercent = 6.0; // Check this
            ProfitConsistencyRule = true;
            RiskConsistencyRule = true;
            RiskConsistencyRulePercent = 2.0; // Check this
            DailyLossBased = false;
            DailyLossBreachedPercent = 0.0; // Check this
            Payout = 0; // Check this
         }
         break;
      case ACCOUNT_PACKAGE_BOGO:
         // Set conditions for BOGO Package
         break;
      case ACCOUNT_PACKAGE_51010:
         // Set conditions for 51010 Package
         {
            PackageName = "51010";
            FundProcess = "Instant Funding";
            ScaleUpPlan = true;
            DailyPercent = 5.0;
            MaxPercent = 10.0;
            NoProfitTarget = false;
            TargetPercent = 10.0; // Check this
            ProfitConsistencyRule = true;
            RiskConsistencyRule = true;
            RiskConsistencyRulePercent = 2.0; // Check this
            DailyLossBased = false;
            DailyLossBreachedPercent = 0.0; // Check this
            Payout = 0; // Check this
         }
         break;
      case ACCOUNT_PACKAGE_510Zero:
         // Set conditions for 510Zero Package
         {
            PackageName = "510Zero";
            FundProcess = "Instant Funding";
            ScaleUpPlan = true;
            DailyPercent = 5.0;
            MaxPercent = 10.0;
            NoProfitTarget = true;
            TargetPercent = 0.0; // Check this
            ProfitConsistencyRule = true;
            RiskConsistencyRule = true;
            RiskConsistencyRulePercent = 2.0; // Check this
            DailyLossBased = false;
            DailyLossBreachedPercent = 0.0; // Check this
            Payout = 0; // Check this
         }
         break;
      case ACCOUNT_PACKAGE_51010_NoPC:
         // Set conditions for 51010 NoPC Package
         {
            PackageName = "51010-NoPC";
            FundProcess = "Instant Funding";
            ScaleUpPlan = true;
            DailyPercent = 5.0;
            MaxPercent = 10.0;
            NoProfitTarget = false;
            TargetPercent = 10.0; // Check this
            ProfitConsistencyRule = true;
            RiskConsistencyRule = true;
            RiskConsistencyRulePercent = 2.0; // Check this
            DailyLossBased = true;
            DailyLossBreachedPercent = 1.0; // Check this
            Payout = 0; // Check this 
         }
         break;
      case FUNDING_PIPS_COMPETITION:
         {
            PackageName = "Monthly Competition";
            FundProcess = "Funding Pips";
            ScaleUpPlan = false;
            DailyPercent = 5.0;
            MaxPercent = 10.0;
            NoProfitTarget = false;
            TargetPercent = 800.0; // Check this
            ProfitConsistencyRule = false;
            RiskConsistencyRule = false;
            RiskConsistencyRulePercent = 2.0; // Check this
            DailyLossBased = false;
            DailyLossBreachedPercent = 0.0; // Check this
            Payout = 0; // Check this
         }
         break;
      }
   }
   //---
   void Initializing() {
      InitializePackage(inpPackages);
      initialBalance = FundedCapital(inpFundedAmount);
      dailyLoss = initialBalance * (DailyPercent / 100.0);
      DailyTargetLimit();
      //dailyTargetLimit = acc.Balance() + inpDailyTarget;
      if (totalDaysTraded == 0) {
         dailyLossLimit = initialBalance - dailyLoss;
         maxUtilizeRate = 0.0;
         maxDrawdown = 0.0;
      }
      maxLoss = initialBalance * (MaxPercent / 100.0);
      maxLossLimit = initialBalance - (initialBalance * (MaxPercent / 100.0));
      // if (!NoProfitTarget) minProfitTarget = initialBalance * (TargetPercent / 100.0);
      // else minProfitTarget = 0.0;
      riskRuleInMoney = (initialBalance * RiskConsistencyRulePercent) / 100.0;
   }
   //--- OnTradeProcessing Initializing
   void OnTradeProcessingInit() {
      ticket = 0;
      type = "";
      symbol = "";
      name = "";
      digits = 0;
      point = 0.0;
      tick_value = 0.0;
      tick_size = 0.0;
      bid = 0.0;
      ask = 0.0;
      volume = 0.0;
      price_open = 0.0;
      price_current = 0.0;
      op_price_weighted = 0.0;
      cu_price_weighted = 0.0;
      stop_loss = 0.0;
      take_profit = 0.0;
      sl_price_weighted = 0.0;
      tp_price_weighted = 0.0;
      change = 0.0;
      float_PnL = 0.0;
      float_pips = 0.0;
      riskInMoney = 0.0;
      percentToRiskRule = 0.0;
      reward = 0.0;
      reward_pips = 0.0;
      trade_price_weighted = 0.0;
      trade_volume = 0.0;
      trade_PnL = 0.0;
      trade_pips = 0.0;
      trade_change = 0.0;
      diff_weighted_1 = 0.0;
      diff_weighted_2 = 0.0;
   }
   //--- OnTradeIdeas Initializing
   void OnTradeIdeasInit() {
      digits = 0;
      pos_modified = 0;
      is_found = false;
      is_triggered = false;
      daily_target_reached = false;
      result = false;
      trade_with_SL = false;
      trade_with_TP = false;
      trade_name = "";
   }
   //--- TradeRefresh
   void TradeRefresh() {
      trade_price_weighted = 0.0;
      trade_volume = 0.0;
      trade_PnL = 0.0;
      trade_pips = 0.0;
      trade_change = 0.0;
      diff_weighted_1 = 0.0;
      diff_weighted_2 = 0.0;
   }
   //---
   double DailyLossLimit() {
      dailyLossLimit = 0.0;
      if (totalDaysTraded == 0)
         dailyLossLimit = initialBalance - dailyLoss;
      //---
      return dailyLossLimit;
   }
   //---
   double DailyRemaining() {
      double equity = acc.Equity();
      if (dailyLossLimit != 0)
         dailyRemaining = equity - dailyLossLimit;
      if (dailyRemaining > dailyLoss)
         dailyRemaining = dailyLoss;
      return dailyRemaining;
   }
   //---
   double DailyRemainingPercent() {
      dailyRemainingPercent = 0.0;
      if (dailyLossLimit != 0)
         dailyRemainingPercent = 100.0 - (dailyRemaining / dailyLoss) * 100.0;
      if (dailyRemainingPercent > 100.0)
         dailyRemainingPercent = 100.0;
      //---
      return dailyRemainingPercent;
   }
   //---
   double MaxRemaining() {
      maxRemaining = 0.0;
      double equity = acc.Equity();
      //---
      if (maxLossLimit != 0)
         maxRemaining = equity - maxLossLimit;
      //---
      return maxRemaining;
   }
   //---
   double MaxRemainingPercent(double float_PL) {
      maxRemainingPercent = 0.0;
      double openLoss = -acc.Profit();
      double currMaxLoss = acc.Balance() - maxLossLimit;
      if (acc.Balance() != acc.Equity())
         maxRemainingPercent = 100.0 - ((maxLoss - float_PL) / currMaxLoss) * 100.0;
      if (maxRemainingPercent > 100.0)
         maxRemainingPercent = 100.0;
      //---
      return maxRemainingPercent;
   }
   //--- Min Profit Target
   double MinProfitTarget() {
      minProfitTarget = 0.0;
      if (!NoProfitTarget)
         minProfitTarget = initialBalance * (TargetPercent / 100.0);
      else
         minProfitTarget = inpDailyTarget * 5;
      //---
      return minProfitTarget;
   }
   //--- Profit Remains
   double ProfitRemain() {
      profitRemain = 0.0;
      if (!NoProfitTarget) {
         profitRemain = minProfitTarget - closedPL;
         if (profitRemain < 0.0)
            profitRemain = 0.0;
      }
      else
         return profitRemain;
      //---
      return profitRemain;
   }
   //--- Profit Remaining
   double ProfitRemaining() {
      profitRemaining = 0.0;
      double equity = acc.Equity();
      //---
      if (!NoProfitTarget) {
         profitRemaining = minProfitTarget - equity + initialBalance;
         if (profitRemaining < 0.0)
            profitRemaining = 0.0;
      }
      else
         profitRemaining = 0.0;
      //---
      return profitRemaining;
   }
   //--- % to Profit Target
   double ProfitRemainingPercent() {
      profitRemainingPercent = 0.0;
      profitRemaining = ProfitRemaining();
      //---
      if (!NoProfitTarget) {
         if (profitRemaining >= 0.0)
            profitRemainingPercent = (minProfitTarget - profitRemaining) / minProfitTarget * 100.0;
            if (profitRemainingPercent > 100.0)
               profitRemainingPercent = 100.0;
         else
            return profitRemainingPercent;
      }
      else
         return profitRemainingPercent;
      //---
      return profitRemainingPercent;
   }
   //--- profitConsistencyPercent
   double ProfitConsistencyPercent() {
      profitConsistencyPercent = 0.0;
      if (totalDaysTraded > 0)
         if (bestDailyNetPL < 0.0)
            profitConsistencyPercent = 0.0;
         else
            profitConsistencyPercent = (bestDailyNetPL > 0) ? (bestDailyNetPL/totalDailyNetPL) * 100.0 : 100.0;
         //---
         if (profitConsistencyPercent > 100.0)
            profitConsistencyPercent = 100.0;
      else
         return profitConsistencyPercent;
      //---
      return profitConsistencyPercent;
   }
   //--- Profitability
   double Profitability() {
      profitability = 0.0;
      double equity = acc.Equity();
      if (initialBalance > 0)
         profitability = ((equity - initialBalance) / initialBalance) * 100.0;
      //---
      return profitability;
   }
   //--- Utilize Rate
   double UtilizeRate() {
      utilizeRate = 0.0;
      double equity = acc.Equity();
      double margin = acc.Margin();
      if (margin > 0)
         utilizeRate = (margin / equity) * 100.0;
      else
         return utilizeRate;
      //---
      return utilizeRate;
   }
   //--- Drawdown
   double Drawdown() {
      drawdown = 0.0;
      profitability = Profitability();
      nextMinimalPeak = DBL_MAX;
      //---
      if (profitability >= maximalPeak) {
         maximalPeak = profitability;
         nextMinimalPeak = maximalPeak;
         drawdown = 0.0;
      }
      else if (profitability < nextMinimalPeak) {
         nextMinimalPeak = profitability;
         //---
         drawdown = ((maximalPeak - nextMinimalPeak) / (maximalPeak + 100.0)) * 100.0;
         // currDrawdown = drawdown;
      }
      //---
      return drawdown;
   }
   //--- Max Utilize Rate Point
   int MaxUtilizeRatePoint() {
      return CalculateWeightFactor(maxUtilizeRate);
   }
   //--- Max Drawdown Point
   int MaxDrawdownPoint() {
      return CalculateWeightFactor(maxDrawdown);
   }
   //--- Risk Ratio
   double RiskRatio() {
      riskRatio = 0.0;
      maxDrawdownPts = MaxDrawdownPoint();
      maxUtilizeRatePts = MaxUtilizeRatePoint();
      if (maxDrawdownPts != 0 && maxUtilizeRatePts != 0)
         riskRatio = (maxDrawdownPts * 0.5)+(maxUtilizeRatePts * 0.3)+(10 * 0.1)+(10 * 0.1);
      //---
      return riskRatio;
   }
   //--- Trade Rating
   double TradeRating() {
      tradeRating = 0.0;
      if (profitability != 0.0)
         tradeRating = profitability / riskRatio;
      //---
      return tradeRating;
   }
   //---
   double ProfitShare() {
      profitShare = 0.0;
      double balance = acc.Balance();
      if (profitConsistencyPercent > 0)
         profitShare = ((balance - initialBalance)*profitSharePercent)/100.0;
      //---
      return profitShare;
   }
   //---
   double ProfitSharePercent() {
      profitSharePercent = 0.0;
      if (profitConsistencyPercent > 0)
      {
         if (profitConsistencyPercent < 20)
            profitSharePercent = 90;
         else if (profitConsistencyPercent < 30)
            profitSharePercent = 10;
      }
      else
         return profitSharePercent;
      //---
      return profitSharePercent;
   }
   //---
   void RefreshChart() {
      chartSymbol = ChartSymbol();
      chartTimeframe = ChartPeriod(0);
   }
   //---
   double PipValue(string c_symbol="") {
      pipValue = 0.0;
      double tickSize = 0.0;
      double tickValue = 0.0;
      if (c_symbol == "") {
         tickSize = SymbolInfoDouble(chartSymbol, SYMBOL_TRADE_TICK_SIZE);
         tickValue = SymbolInfoDouble(chartSymbol, SYMBOL_TRADE_TICK_VALUE);
         //---
         pipValue = (1*0.01)*((tickValue/tickSize)*tickSize);
      }
      else {
         tickSize = SymbolInfoDouble(c_symbol, SYMBOL_TRADE_TICK_SIZE);
         tickValue = SymbolInfoDouble(c_symbol, SYMBOL_TRADE_TICK_VALUE);
         //---
         pipValue = (1*0.01)*((tickValue/tickSize)*tickSize);
      }
      //---
      return pipValue;
   }
   //--- Daily Target Limit
   double DailyTargetLimit() {
      dailyTargetLimit = 0.0;
      // double balance = acc.Balance(); // 10077.68
      //---
      if (totalDaysTraded == 0)
         dailyTargetLimit = initialBalance + inpDailyTarget; // 9977.68 | 10177.68
      //---
      return dailyTargetLimit;
   }
   //--- Today's Target $
   double TodayTarget() {
      double x = MathRound(closedPL / inpDailyTarget);
      double balance = acc.Balance();
      todayTarget = 0.0;
      //---
      if (dailyTargetLimit != 0.0)
         todayTarget = dailyTargetLimit - balance;
         if (todayTarget > inpDailyTarget)
            todayTarget = inpDailyTarget;
         else if (todayTarget < 0.0)
            dailyTargetLimit = balance + inpDailyTarget;
      //---
      return todayTarget;
   }
   //---
   double PipsTargetBySymbol() {
      pipsTarget = 0.0;
      double tickSize = SymbolInfoDouble(chartSymbol, SYMBOL_TRADE_TICK_SIZE);
      double tickValue = SymbolInfoDouble(chartSymbol, SYMBOL_TRADE_TICK_VALUE);
      if (tickSize > 0 && tickValue > 0) {
         double pips_value = (minProfitTarget * tickValue) / tickSize;
         pipsTarget = pips_value;
      }
      return pipsTarget;
   }
   //--- Pips per trade
   double ProfitTargetPerTrade() {
      profitTargetPerTrade = 0.0;
      if (inpDailyTarget > 0)
         profitTargetPerTrade = 0.2*inpDailyTarget;
      //---
      return profitTargetPerTrade;
   }
   //--- Trades to 10%
   int TradesToPercentage() {
      tradesToPercentage = 0;
      if (inpDailyTarget > 0)
         tradesToPercentage = (int)MathCeil((minProfitTarget - closedPL) / profitTargetPerTrade);
      //---
      return tradesToPercentage;
   }
   //--- Days to 10%
   int DaysToPercentage() {
      daysToPercentage = 0;
      if (inpDailyTarget > 0)
         daysToPercentage = (int)MathCeil((minProfitTarget - closedPL) / inpDailyTarget);
      //---
      return daysToPercentage;
   }
   //---
   void GetScore() {
      int win = 0;
      int loss = 0;
      //---
      if (!HistorySelect(0, TimeCurrent()))
         return;
      //---
      int deals_total = HistoryDealsTotal();
      for (int i = 0; i < deals_total; i++)
      {
         ulong deal_ticket = HistoryDealGetTicket(i);
         if (deal_ticket == 0)
            continue;
         ENUM_DEAL_ENTRY deal_entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(deal_ticket, DEAL_ENTRY);
         ENUM_DEAL_TYPE deal_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(deal_ticket, DEAL_TYPE);
         if (deal_type != DEAL_TYPE_BUY && deal_type != DEAL_TYPE_SELL)
            continue;
         //--- process each deal associated with the position_id
         double deal_profit = HistoryDealGetDouble(deal_ticket, DEAL_PROFIT);
         if (deal_entry == DEAL_ENTRY_OUT)
         {
            if (deal_profit > 0) win++;
            else if (deal_profit < 0) loss++;
         }
      }
      winTrades = win;
      lossTrades = loss;
   }
   //--- Closed PL
   double ClosedPL() {
      closedPL = 0.0;
      double balance = acc.Balance();
      //---
      if (initialBalance != balance)
         closedPL = balance - initialBalance;
      else
         return closedPL;
      //---
      return closedPL;
   }
   //--- Daily Net PL
   double DailyNetPL() {
      double closed_PL = ClosedPL();
      double openLoss = 0.0;
      double currFloatPL = acc.Profit();
      //---
      if (currFloatPL < 0.0)
         openLoss = -currFloatPL;
      else
         openLoss = 0.0;
      //---
      return dailyNetPL = closed_PL - openLoss;
   }
   //---
   ENUM_MARKET_CONDITIONS MarketMood() {
      return marketMood = inpMarketMood;
   }
//#endregion
}am;
//+------------------------------------------------------------------+
//| Method CalculateWeightFactor                                     |
//+------------------------------------------------------------------+
int CalculateWeightFactor(const double max_value)
{
   if (max_value >= 50.0) return 10;
   else if (max_value >= 40.0) return 9;
   else if (max_value >= 35.0) return 8;
   else if (max_value >= 30.0) return 7;
   else if (max_value >= 25.0) return 6;
   else if (max_value >= 20.0) return 5;
   else if (max_value >= 15.0) return 4;
   else if (max_value >= 10.0) return 3;
   else if (max_value >= 5.0) return 2;
   else return 1;
}
//+------------------------------------------------------------------+
//| Method CurrentAccountInfo                                        |
//+------------------------------------------------------------------+
string CurrentAccountInfo(string server)
{
   int eq_pos = StringFind(server,"-");
   string server_name = (eq_pos != -1) ? StringSubstr(server, 0, eq_pos) : server;
   Print("Account Server: ",server_name);
   return(server_name);
}
//+------------------------------------------------------------------+
//| Method CurrentDate                                               |
//+------------------------------------------------------------------+
bool CurrentDate(datetime curr_date, datetime today_date)
{
   if(curr_date != today_date)
   {
      curr_date = today_date;
      return(true);
   }
   return(false);
}
//+------------------------------------------------------------------+
//| Method RemoveDots                                                |
//+------------------------------------------------------------------+
string RemoveDots(string str)
{
   StringReplace(str,".","");
   return(str);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// datetime DummyDatetime(
//    int year=2024,
//    int month=12,
//    int day=0,
//    int hour=0,
//    int min=0,
//    int sec=0
// )
// {
//    MqlDateTime dummyDt;
//    dummyDt.year=year;
//    dummyDt.mon=month;
//    dummyDt.day=inpDummyDay;
//    dummyDt.hour=hour;
//    dummyDt.min=min;
//    dummyDt.sec=sec;
//    return StructToTime(dummyDt);
// }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
datetime DateToString()
{
   string dateStr = TimeToString(TimeLocal(), TIME_DATE);
   return StringToTime(dateStr);
}
//+------------------------------------------------------------------+
//| Method CreateFolder                                              |
//+------------------------------------------------------------------+
bool CreateFolder(string folder_name, bool common_flag)
{
   int flag = common_flag ? FILE_COMMON : 0;
   string working_folder;
   if (common_flag)
      working_folder = TerminalInfoString(TERMINAL_COMMONDATA_PATH)+"\\MQL5\\Files";
   else
      working_folder = TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files";
   //---
   // PrintFormat("folder_path=%s",folder_name);
   //---
   if (FolderCreate(folder_name, flag))
   {
      // PrintFormat("Created the folder %s",working_folder+"\\"+folder_name);
      ResetLastError();
      return(true);
   }
   else
      PrintFormat("Failed to create the folder %s. Error code %d",working_folder+folder_name,GetLastError());
   //--- 
   return(false);
}
//+------------------------------------------------------------------+
//| Class CMyIdeas                                                   |
//+------------------------------------------------------------------+
class CMyIdeas : public CArrayObj
{
public:
   virtual bool CreateElement(const int index) override
   {
      m_data[index] = new CTradeIdeas();
      return (m_data[index] != NULL);
   }
};
//+------------------------------------------------------------------+
// Class CTradeIdeas                                                 |
//+------------------------------------------------------------------+
class CTradeIdeas : public CObject
{
public:
   string ideaSymbol;
   string ideaType;
   string ideaName;
   int ideaBuyTotal;;
   int ideaSellTotal;
   int ideaWithSL;
   int ideaWithTP;
   double ideaPriceWeighted;
   double ideaVolume;
   double ideaStopLoss;
   double ideaPercentToSL;
   double ideaRisk;
   double ideaRiskPercent;
   double ideaReward;
   double ideaRewardPips;
   double ideaFloatPnL;
   double ideaFloatPips;
   double ideaChange;
   double ideaTrailingStart;
   double ideaTrailingCoverage;
   double ideaCPartialStart;
   double ideaCPartialVol;
   bool ideaTrailingStopEnable;
   bool ideaCPartialEnable;
   bool ideaCPartialOnTPEnable;
   //---
   ENUM_CONTROL_TYPE ideaTrailingType;
   ENUM_CONTROL_TYPE ideaCPartialType;
   //---
   double ideaProfitability;
   double ideaMaximalPeak;
   double ideaNextMinimalPeak;
   double ideaDrawdown;
   double ideaMaxDrawdown;
public:
   CTradeIdeas(void) :
      ideaSymbol(""),
      ideaType(""),
      ideaName(""),
      ideaBuyTotal(0),
      ideaSellTotal(0),
      ideaWithSL(0),
      ideaWithTP(0),
      ideaPriceWeighted(0.0),
      ideaVolume(0.0),
      ideaStopLoss(0.0),
      ideaPercentToSL(0.0),
      ideaRisk(0.0),
      ideaRiskPercent(0.0),
      ideaReward(0.0),
      ideaRewardPips(0.0),
      ideaFloatPnL(0.0),
      ideaFloatPips(0.0),
      ideaChange(0.0),
      ideaTrailingStart(0.0),
      ideaTrailingCoverage(0.0),
      ideaCPartialStart(0.0),
      ideaCPartialVol(0.0),
      ideaTrailingStopEnable(false),
      ideaCPartialEnable(false),
      ideaCPartialOnTPEnable(false),
      ideaTrailingType(BY_PERCENTAGE),
      ideaCPartialType(BY_PERCENTAGE),
      ideaProfitability(0.0),
      ideaMaximalPeak(0.0),
      ideaNextMinimalPeak(0.0),
      ideaDrawdown(0.0),
      ideaMaxDrawdown(0.0)
   {};
   ~CTradeIdeas() {};
   //--- Idea Refresh
   void IdeaRefresh()
   {
      // ideaSymbol = "";
      // ideaType = "";
      // ideaName = "";
      ideaBuyTotal = 0;
      ideaSellTotal = 0;
      ideaWithSL = 0;
      ideaWithTP = 0;
      ideaPriceWeighted = 0.0;
      ideaVolume = 0.0;
      ideaStopLoss = 0.0;
      ideaPercentToSL = 0.0;
      ideaRisk = 0.0;
      ideaRiskPercent = 0.0;
      ideaReward = 0.0;
      ideaRewardPips = 0.0;
      ideaFloatPnL = 0.0;
      ideaFloatPips = 0.0;
      ideaChange = 0.0;
      // ideaTrailingStart = 0.0;
      // ideaTrailingCoverage = 0.0;
      // ideaCPartialStart = 0.0;
      // ideaCPartialVol = 0.0;
      // ideaTrailingStopEnabled = false;
      // ideaCPartialEnabled = false;
      // ideaCPartialOnTPEnabled = false;
      // ideaTrailingType = BY_PERCENTAGE;
      // ideaCPartialType = BY_PERCENTAGE;
      // ideaProfitability = 0.0;
      // ideaMaximalPeak = 0.0;
      // ideaNextMinimalPeak = 0.0;
      // ideaDrawdown = 0.0;
      // ideaMaxDrawdown = 0.0;
   }
   //---
   double IdeaProfitability(void)
   {
      ideaProfitability = 0.0;
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      //---
      if (balance > 0)
         ideaProfitability = (ideaFloatPnL / balance) * 100.0;
      //---
      return ideaProfitability;
   }
   //--- Drawdown
   double IdeaDrawdown(void)
   {
      ideaDrawdown = 0.0;
      ideaProfitability = IdeaProfitability();
      // ideaNextMinimalPeak = DBL_MAX;
      //---
      double max_peak = 0.0;
      double next_min_peak = DBL_MAX;
      //---
      if (ideaProfitability >= ideaMaximalPeak) {
         max_peak = ideaProfitability;
         next_min_peak = max_peak;
         ideaDrawdown = 0.0;
      }
      else if (ideaProfitability < next_min_peak) {
         next_min_peak = ideaProfitability;
         //---
      }
      ideaMaximalPeak = max_peak;
      ideaNextMinimalPeak = next_min_peak;
      //---
      return ideaDrawdown = ((ideaMaximalPeak - ideaNextMinimalPeak) / (ideaMaximalPeak + 100.0)) * 100.0;
   }
   //---
   virtual bool IsTrailingEnabled() {
      if(ideaName==NULL)
         return(false);
      //---
      return(ideaTrailingStopEnable);
   }
   //---
   virtual bool TrailingEnable(const bool state) {
      if(ideaName==NULL)
         return(false);
      //---
      return(ideaTrailingStopEnable=state);
   }
   //--- 
   virtual ENUM_CONTROL_TYPE getTrailingType() {
      if(ideaName==NULL)
         return(BY_PERCENTAGE);
      //---
      return(ideaTrailingType);
   }
   virtual ENUM_CONTROL_TYPE setTrailingType(const ENUM_CONTROL_TYPE type) {
      if(ideaName==NULL)
         return(BY_PERCENTAGE);
      //---
      return(ideaTrailingType=type);
   }
};
//+------------------------------------------------------------------+
