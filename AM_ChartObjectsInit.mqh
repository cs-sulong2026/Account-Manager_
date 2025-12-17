//+------------------------------------------------------------------+
//|                                          AM_ChartObjectsInit.mqh |
//|                                 Copyright 2025, Cheruhaya Sulong |
//|                           https://www.mql5.com/en/users/cssulong |
//| 02.12.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cheruhaya Sulong"
#property link      "https://www.mql5.com/en/users/cssulong"

//#region Lower Labels
int ll_x[]=
{
   20,200,380,560,740,920,1100,
   20,200,380,560,740,920,1100
};
int ll_y[]=
{
   2,2,2,2,2,2,2,
   1,1,1,1,1,1,1
};
string ll_desc[]=
{
   "% to Daily Loss", "% to Target Profit", "Today's Net PnL", "Utilize Rate (DUR)", "Max Utilize Rate", "Max Utilize Rate Pts", "Risk Ratio",
   "Daily Remaining", "Max Remaining", "Profitability", "Drawdown (RD)", "Max Drawdown", "Max Drawdown Pts", "Trade Rating"
};
int lli_x[]=
{
   130,310,490,670,850,1050,1210,
   130,310,490,670,850,1050,1210
};
//#endregion
//#region Upper Labels
string ul_desc[]=
{
   "===  ACCOUNT PARAMETERS  ===",
   "Fund Process",
   "Package Name",
   "Fund Amount",
   "Scale Up Plan",
   "Daily Loss %",
   "Max Loss %",
   "Target Profit %",
   "Daily Loss Limit",
   "Max Loss Limit",
   "Target Profit Left", // new
   "Risk Rule",
   "Risk Rule %",
   "% to Risk Rule",
   "Profit Rule",
   "Profit Rule %",
   "Loss Breached",
   "Loss Breached %",
   "Profit Share %",
   "Days Traded",
   "Win / Loss",
   "Best Daily PnL",
   "Sum Daily PnL",
   "Today's Target",
   "Trades to 10%",
   "Days to 10%",
   "TEST"
};
//#endregion
//#region Idea Labels
string init_il_str[]=
{
	"=====  TRADING IDEAS  ======",
   "Idea Name",
   "Total Trades",
   "Volume Size",
   "Stop Loss",
   "Trades with SL",
   "SL Hit in $",
   "% to Stop Loss",
	"% to Risk Rule",
   "Trades with TP",
   "TP Hit in $",
   "TP Hit in Pips",
   "Pip Value",
   "Pips Running",
   "Current Price",
   "Change %",
   "PnL",
   "Profitability",
   "Trailing SL (TSL)",
   "TSL Start in $",
   "TSL Coverage",      // [20]
   "Close Partial Pos.",
   "CP Start in $",
   "% Sizes Close",
   "Include TP Pos",
   "Check State"
   // "Idea Profitability",
   // "Idea Maximal Peak",
   // "Idea Next Minimal Peak",
   // "Idea Drawdown",
   // "Idea Max Drawdown"
};
int init_il_x[]=
{
	290,380,470,560
};
//endregion

//+------------------------------------------------------------------+
