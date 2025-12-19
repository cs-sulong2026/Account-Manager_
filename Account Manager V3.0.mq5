//+------------------------------------------------------------------+
//|                                         Account Manager V3.0.mq5 |
//|                                 Copyright 2025, Cheruhaya Sulong |
//|                           https://www.mql5.com/en/users/cssulong |
//| 02.12.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#define	   Copyright   	   "Copyright © 2025 Cheruhaya Sulong"
#define	   ExpertName  	   "Account Manager"
#define	   Link        		"https://www.mql5.com/en/users/cssulong"
#define	   Version     		"3.50"
#property   copyright         Copyright
#property   link              Link
#property   version           Version
//---
// #include <AM_V3.mqh>       // For Internal Use
#include "AM_V3.mqh"          // For VPS Use
//---
CAccountManager      ExtManager;
//---
int DeinitializationReason = -1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   ExtManager.SilentLogging = true;
   //---
   string msg = ExpertName + "   Version 142.0." + Version + "   ";
   string c = Copyright;
   string i = "INITIALIZATION STARTED";
   string is = "INITIALIZATION SUCCESSFUL";
   ExtManager.Logging("\n<---------- " + msg + c +" ---------->\n                                                 "
      + i + "\n\nTimeStamp:               PID:  Log Message:");
   //---
   if (DeinitializationReason == REASON_CHARTCHANGE)
   {
      //---
      EventSetTimer(1); // Set timer to 1 seconds interval
      return(INIT_SUCCEEDED);
   }
   //---
   if (!ExtManager.AccountInit()) {
      Print("Initialization failed!");
      return(INIT_FAILED);
   }
   if (inpShowControlPanel) {
      if(!ExtManager.DialogInit()) {
         Print("Control Panel initialization failed! Continuing without control panel.");
      }
   }
   ExtManager.Logging(is + "\n");
   //--- create timer
   EventSetTimer(1);
   ExtManager.SilentLogging = false;
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   DeinitializationReason = reason;
//--- destroy timer
   EventKillTimer();
   ExtManager.Logging("Deinitializing reason: " + DeinitializeReasonTxt(_UninitReason) + "\n");
   ExtManager.DeInit(reason);
   if (DeinitializationReason == REASON_RECOMPILE)
      ExtManager.SaveToDisk();
   // ExtManager.Logging("Last total trade ideas: " + IntegerToString(ExtManager.GetTotalIdeas()));
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---
   ExtManager.OnTimerSet();
   ExtManager.InfoRunning();
   ExtManager.OnTradeProcessing();
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---
   ExtManager.OnEvent(id,lparam,dparam,sparam);
}

//+------------------------------------------------------------------+
