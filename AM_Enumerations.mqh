//+------------------------------------------------------------------+
//|                                              AM_Enumerations.mqh |
//|                                 Copyright 2025, Cheruhaya Sulong |
//|                           https://www.mql5.com/en/users/cssulong |
//| 02.12.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cheruhaya Sulong"
#property link      "https://www.mql5.com/en/users/cssulong"
//---
enum ENUM_FUNDED_AMOUNT
{
   FUNDED_AMOUNT_5000,        // 5000.00
   FUNDED_AMOUNT_10000,       // 10000.00
   FUNDED_AMOUNT_25000,       // 25000.00
   FUNDED_AMOUNT_50000,       // 50000.00
   FUNDED_AMOUNT_100000,      // 100k
   FUNDED_AMOUNT_200000,      // 200k
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_ACCOUNT_PACKAGE
{
   ACCOUNT_PACKAGE_FREE,   // Challenge Packages
   ACCOUNT_PACKAGE_STANDARD,  // Standard Packages
   ACCOUNT_PACKAGE_PERSONALIZED,  // Personalized Packages
   ACCOUNT_PACKAGE_BOGO,     // BOGO Packages
   ACCOUNT_PACKAGE_51010,     //51010 Packages
   ACCOUNT_PACKAGE_510Zero,     //510Zero Packages
   ACCOUNT_PACKAGE_51010_NoPC,     //51010 NoPC Packages
   FUNDING_PIPS_COMPETITION      // Funding Pips Monthly Competition
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_TRADING_STYLE
{
   SWING_TRADING, // Swing Trading
   DAY_TRADING, // Day Trading
   SCALPING, // Scalping
   UNKNOWN // To be determined
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_GTRADE_STRATEGY
{
   PRICE_ACTION_SWING_TRADING, // Recommended 
   TREND_FOLLOWING_MA_50200, // Suitable during a clear long term trend
   RANGE_TRADING, // Suitable during market sideways
   BREAKOUT_TRADING, // Suitable when price breakout of a consolidation or range period
   SCALPING_TRADING, // Suitable when market in short term strong trend or momentum
   NOT_DECIDED // Not decided yet
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_MARKET_CONDITIONS
{
   CLEAR_AND_STRONG_TREND, // Clear & strong momentum trend
   CONSOLIDATE_AND_RANGE, // Price sideways
   AHEAD_OF_BIG_NEWS, // Before big news release
   NOT_VALIDATE // Not analize yet
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_ENTRY_STATUS
{
   PLACED,
   FILLED, 
   CHANGED,
   MODIFIED,
   CANCELED,
   CLOSED,
   RECOUNT,
   REFRESH
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_PROCESS_STATUS
{
   NEW,
   ADD,
   CHECK,
   UPDATE,
   REMOVE,
   CLEAR
};
enum ENUM_BUTTON_STATE
{
   ENABLED,
   DISABLED
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
enum ENUM_CONTROL_TYPE
{
   BY_PIPS,          // Pips
   BY_PERCENTAGE,    // Percentage
   BY_DOLLAR_AMOUNT  // Dollar Amount
};
//+------------------------------------------------------------------+
//| Swithes for all enumerations used in Account Manager.mq4  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Returns the funded capital based on                                  |
//| ENUM_FUNDED_AMOUNT                                                 |
//+------------------------------------------------------------------+
double FundedCapital(ENUM_FUNDED_AMOUNT amount)
{
   switch (amount)
   {
      case FUNDED_AMOUNT_5000:
         return 5000.0;
      case FUNDED_AMOUNT_10000:
         return 10000.0;
      case FUNDED_AMOUNT_25000:
         return 25000.0;
      case FUNDED_AMOUNT_50000:
         return 50000.0;
      case FUNDED_AMOUNT_100000:
         return 100000.0;
      case FUNDED_AMOUNT_200000:
         return 200000.0;
      default:
         return 0.0;
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string TradingStyleName(ENUM_TRADING_STYLE g_style)
{
   string str;
   ENUM_TIMEFRAMES period = ChartPeriod();
   switch (g_style)
   {
   case SWING_TRADING:
      str = "SWING_TRADING";
      break;
   case DAY_TRADING:
      str = "DAY_TRADING";
      break;
   case SCALPING:
      str = "Scalping";
      break;
   case UNKNOWN:
      str = "TBD";
      break;
   }
   return str;
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string TradingStyle(ENUM_TIMEFRAMES chart_tf)
{
   string str = "";
   switch (chart_tf)
   {
      case PERIOD_D1:
         str = "SWING_TRADE";
         break;
      case PERIOD_H4:
         str = "SWING_TRADE";
         break;
      case PERIOD_H1:
         str = "SWING / INTRADAY";
         break;
      case PERIOD_M30:
         str = "INTRADAY";
         break;
      case PERIOD_M15:
         str = "INTRADAY";
         break;
      case PERIOD_M5:
         str = "SCALPING";
         break;
      case PERIOD_M1:
         str = "SCALPING";
         break;
   }
   return str;
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string MarketMood(ENUM_MARKET_CONDITIONS m_mood) {
   string str;
   switch (m_mood)
   {
   case CLEAR_AND_STRONG_TREND:
      str = "Clear & Strong";
      break;
   case CONSOLIDATE_AND_RANGE:
      str = "Sideways";
      break;
   case AHEAD_OF_BIG_NEWS:
      str = "On News";
      break;
   case NOT_VALIDATE:
      str = "TBD";
      break;
   }
   return str;
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string GTrade(ENUM_GTRADE_STRATEGY g_trade)
{
   string str = "";
   switch (g_trade)
   {
   case PRICE_ACTION_SWING_TRADING:
      str = "321 Action!";
      break;
   case TREND_FOLLOWING_MA_50200:
      str = "Horse Riding";
      break;
   case RANGE_TRADING:
      str = "On Sideways";
      break;
   case BREAKOUT_TRADING:
      str = "Let's me in!";
      break;
   case SCALPING_TRADING:
      str = "Seek & Destroy";
      break;
   case NOT_DECIDED:
      str = "TBD";
      break;
   }
   return str;
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string TradingStrategy(ENUM_MARKET_CONDITIONS m_mood)
{
   string str = "";
   switch (m_mood)
   {
   case CLEAR_AND_STRONG_TREND:
      {
         if (ChartPeriod() == PERIOD_D1 || ChartPeriod() == PERIOD_H4 || ChartPeriod() == PERIOD_H1) str = "PRICE_ACTION";
         else if (ChartPeriod() == PERIOD_M30 || ChartPeriod() == PERIOD_M15) str = "TREND_50200";
         else str = "SUPERTREND";
      }
      break;
   case CONSOLIDATE_AND_RANGE:
      {
         if (ChartPeriod() == PERIOD_D1 || ChartPeriod() == PERIOD_H4 || ChartPeriod() == PERIOD_H1) str = "PRICE_ACTION";
         else if (ChartPeriod() == PERIOD_M30) str = "BREAKOUT_TRADING";
         else if (ChartPeriod() == PERIOD_M15) str = "RANGE_TRADING";
         else str = "SCALPING";
      }
      break;
   case AHEAD_OF_BIG_NEWS:
      {
         if (ChartPeriod() == PERIOD_D1 || ChartPeriod() == PERIOD_H4 || ChartPeriod() == PERIOD_H1) str = "PRICE_ACTION";
         else if (ChartPeriod() == PERIOD_M30 || ChartPeriod() == PERIOD_M15) str = "TREND_50200";
         else str = "SCALPING";
      }
      break;
   case NOT_VALIDATE:
      str = "TBD";
      break;
   }
   return str;
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// long TrailingType(ENUM_CONTROL_TYPE type)
// {
//    long value=0;
//    switch (type)
//    {
//       case BY_PIPS: value=1; break;
//       case BY_PERCENTAGE: value=2; break;
//       case BY_DOLLAR_AMOUNT: value=3; break;
//    }
//    return(value);
// };

ENUM_CONTROL_TYPE TrailingType(long type)
{
   ENUM_CONTROL_TYPE value=BY_PIPS;
   switch ((int)type)
   {
      case 0: value=BY_PIPS; break;
      case 1: value=BY_PERCENTAGE; break;
      case 2: value=BY_DOLLAR_AMOUNT; break;
   }
   return(value);
};
string TypeToString(ENUM_CONTROL_TYPE type)
{
   string str="";
   switch (type)
   {
      case BY_PIPS: str="in Pips"; break;
      case BY_PERCENTAGE: str="in %"; break;
      case BY_DOLLAR_AMOUNT: str="in $"; break;
   }
   return(str);
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string DeinitializeReasonTxt(int reasonCode)
{
   string text="";
//---
   switch(reasonCode)
     {
      case REASON_ACCOUNT:
         text="Account was changed";break;
      case REASON_CHARTCHANGE:
         text="Symbol or timeframe was changed";break;
      case REASON_CHARTCLOSE:
         text="Chart was closed";break;
      case REASON_PARAMETERS:
         text="Input-parameter was changed";break;
      case REASON_RECOMPILE:
         text="Program "+__FILE__+" was recompiled";break;
      case REASON_REMOVE:
         text="Program "+__FILE__+" was removed from chart";break;
      case REASON_TEMPLATE:
         text="New template was applied to chart";break;
      default:text="Another reason";
     }
//---
   return text;
}
//+------------------------------------------------------------------+