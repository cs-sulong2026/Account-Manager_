//+------------------------------------------------------------------+
//|                                                        AM_V3.mqh |
//|                                 Copyright 2025, Cheruhaya Sulong |
//|                           https://www.mql5.com/en/users/cssulong |
//| 02.12.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cheruhaya Sulong"
#property link      "https://www.mql5.com/en/users/cssulong"
//---
#include <ChartObjects/ChartObjectsTxtControls.mqh>
#include <Trade/AccountInfo.mqh>
#include <Trade/Trade.mqh>
#include <errordescription.mqh>
// For Internal Use
// #include <AM_ChartObjectsInit.mqh>
// #include <AM_ControlsDialog.mqh>
// For VPS Use
#include "AM_ControlsDialog.mqh"
#include "AM_ChartObjectsInit.mqh"
//+------------------------------------------------------------------+
//| Account Manager classes                                          |
//+------------------------------------------------------------------+
class CAccountManager
{
protected:
   CTrade               *Trade;
   CMyIdeas             IdeaList;
   CAccountInfo         m_account;
   //--- Chart Objects
   CChartObjectLabel    m_lower_label[14];
   CChartObjectLabel    m_lower_label_info[14];
   CChartObjectLabel    m_upper_label[27];
   CChartObjectLabel    m_upper_label_info[27];
   CChartObjectLabel    m_idea_label[26];
   CChartObjectLabel    m_idea_label_info[26][4];
private:
   static int           m_log_counter, m_counter;
   static bool          m_IsFirstRun, m_is_new_day, m_TrailingEnabled;
   static double        m_stop_loss;
   datetime             m_today_date, m_current_date, m_yesterday_date;
   int                  m_LogFile, m_acc_login, m_interval_minutes, m_pos_total, m_OrderOpRetry, m_idea_total;
   bool                 m_CommonFolder, m_MinuteTimerSet, m_DailyTimerSet;
   string               m_LogFileName, m_FileName, m_DailyLogFileName, m_UtilRateFileName, m_ProfitabilityFileName, m_DrawdownFileName, m_expert_folder, m_work_folder;
   double               m_dailyNetPnL[], m_utilize_rate[], m_profitability[], m_drawdown[];
   bool                 m_arrTrailingEnabled[];
public:
                        CAccountManager(void);
                        ~CAccountManager() {    delete Trade;     };
   //------------- Initialization -------------
   bool                 SilentLogging;
   CAM_ControlsDialog   ExtDialog;
   CMyIdeas             GetIdeaList(void)               {      return(&IdeaList);      }
   void                 Logging(const string message);
   bool                 AccountInit(void);
   bool                 InfoObjectsInit(void);
   bool                 IdeaObjectsInit(void);
   bool                 DialogInit(void);
   //============ Expert Events ==============
   void                 DeInit(int reason) { ExtDialog.Destroy(reason); };
   void                 InfoRunning(void);
   void                 OnTradeProcessing(void);
   bool                 OnTimerSet(void);
   bool                 OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //============ File Operations ==============
   bool                 SaveToDisk(datetime today_date=datetime(0));
   bool                 LoadFromDisk(void);
   //============ Getter Operations ==============
   // int                  GetTotalIdeas(void) { return (IdeaList.Total()); }
protected:
   // void                 OnTradeIdeas_Old(void);
   virtual void         OnTradeIdeas(void);
   virtual void         OnTradeCheck(void);
   virtual void         OnTradeWithTP(void);
   virtual bool         OnTradePositionModify(const ulong ticket,const double sl,const double tp);
   virtual bool         OnTradePositionClose(const ulong ticket);
   virtual bool         OnTradePositionClosePartial(const ulong ticket,const double volume);
   void                 InfoToChart(void);
   CTradeIdeas*         TradeIdea(const int index)       const { return(dynamic_cast<CTradeIdeas*>(IdeaList.At(index))); }
   void                 TradeIdeaRefresh(void);
   void                 ExpertMoneyAction(SAccountManager &stats);
   //=========== Getter Operations =============
   // bool                 CurrentDate(void);
   double               MaxUtilizationRate(void);
   double               MaxProfitability(void);
   double               MaxDrawdown(void);
   double               HighestDailyNetPnL(void);
   double               TotalDailyNetPnL(void);
   virtual CTradeIdeas  *TradeIdeaAt(const int idx) {
                           if (idx >= 0 && idx < IdeaList.Total()) {
                              return IdeaList.At(idx);
                           }
                           return NULL;
                        }
   // CTradeIdeas          *TradeName(const string idea_name) {
   //                         for (int i = 0; i < IdeaList.Total(); i++) {
   //                            CTradeIdeas *trade_idea = (CTradeIdeas *)IdeaList.At(i);
   //                            if (trade_idea != NULL && trade_idea.ideaName == idea_name)
   //                               return (trade_idea);
   //                         }
   //                         return (NULL);
   //                      }
};
int CAccountManager::m_log_counter = 0;
int CAccountManager::m_counter = 0;
bool CAccountManager::m_IsFirstRun = true;
bool CAccountManager::m_TrailingEnabled = false;
bool CAccountManager::m_is_new_day = false;
double CAccountManager::m_stop_loss = 0.0;
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAccountManager::CAccountManager(void) :
   m_pos_total(0),
   m_idea_total(0)
{
   m_today_date = DateToString();
   m_yesterday_date = m_today_date - 86400;
   m_LogFile = INVALID_HANDLE;
   m_acc_login = (int)m_account.Login();
   m_interval_minutes = 15;
   m_expert_folder = "AM_Data";
   m_work_folder = m_expert_folder + "\\" + CurrentAccountInfo(m_account.Server()) + "_" + IntegerToString(m_acc_login);
   m_LogFileName = "\\AM_LOG_" +RemoveDots(TimeToString(DateToString(), TIME_DATE))+ ".log";
   m_FileName = "\\AM_Data_"+IntegerToString(m_acc_login)+".dat";
   m_DailyLogFileName = "\\AM_DailyLog_"+IntegerToString(m_acc_login)+".txt";
   m_UtilRateFileName = "\\AM_UtilizationRate_"+RemoveDots(TimeToString(DateToString(), TIME_DATE))+".txt";
   m_ProfitabilityFileName = "\\AM_Profitability_"+RemoveDots(TimeToString(DateToString(), TIME_DATE))+".txt";
   m_DrawdownFileName = "\\AM_Drawdown_"+RemoveDots(TimeToString(DateToString(), TIME_DATE))+".txt";
   ArrayInitialize(m_dailyNetPnL, 0);
   ArrayInitialize(m_utilize_rate, 0);
   ArrayInitialize(m_profitability, 0);
   ArrayInitialize(m_drawdown, 0);
   SilentLogging = false;
   m_CommonFolder = false;
   m_MinuteTimerSet = false;
   m_DailyTimerSet = false;
   m_OrderOpRetry = 5;
   Trade = new CTrade();
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Method Logging                                                   |
//+------------------------------------------------------------------+
void CAccountManager::Logging(const string message)
{
   m_log_counter++;
   if (StringLen(m_LogFileName) > 0)
   {
      if (!FileIsExist(m_work_folder+m_LogFileName)) {
         if (CreateFolder(m_work_folder, m_CommonFolder)) {
            Print("New log folder created: ", m_work_folder);
            ResetLastError();
         }
         else {
            Print("Failed to create log folder: ", m_work_folder, ". Error code ", GetLastError());
            return;
         }
      }
      //---
      if (m_LogFile == INVALID_HANDLE)
         m_LogFile = FileOpen(m_work_folder + m_LogFileName, FILE_CSV|FILE_READ|FILE_WRITE, ' ');
      //---
      if (m_LogFile == INVALID_HANDLE)
         Alert("Cannot open file for logging: ", m_work_folder + m_LogFileName);
      else if (FileSeek(m_LogFile, 0, SEEK_END))
      {
         FileWrite(m_LogFile, TimeToString(TimeLocal(), TIME_DATE | TIME_MINUTES | TIME_SECONDS), " #", m_log_counter, " ", message);
         FileFlush(m_LogFile);
         FileClose(m_LogFile);
         m_LogFile = INVALID_HANDLE;
      }
      else Alert("Unexpected error accessing log file: ", m_work_folder + m_LogFileName);
   }      
   if (!SilentLogging)
      Print(message);
}
//+------------------------------------------------------------------+
//| Method AccountInit                                               |
//+------------------------------------------------------------------+
bool CAccountManager::AccountInit(void)
{
   //---
   am.Initializing();
   //---
   if (!LoadFromDisk())
      Logging("Account Manager data file not found. Starting fresh.");
   //---
   if (m_IsFirstRun) {
      Logging("First-run data is being saved...");
      // m_today_date = CurrentDate();
      // m_yesterday_date = m_today_date - 86400;
      // m_UtilRateFileName = "\\AM_UtilizationRate_"+RemoveDots(TimeToString(m_today_date, TIME_DATE))+".txt";
      // m_ProfitabilityFileName = "\\AM_Profitability_"+RemoveDots(TimeToString(m_today_date, TIME_DATE))+".txt";
      // m_DrawdownFileName = "\\AM_Drawdown_"+RemoveDots(TimeToString(m_today_date, TIME_DATE))+".txt";
      SaveToDisk(m_current_date);
   }
   //---
   Logging("Today's Date: "+TimeToString(m_today_date, TIME_DATE));
   Logging("Current Date: "+TimeToString(m_current_date, TIME_DATE));
   Logging("Yesterday's Date: "+TimeToString(m_yesterday_date, TIME_DATE));
   Logging("Util Rate File: "+m_UtilRateFileName);
   Logging("Profitability File: "+m_ProfitabilityFileName);
   Logging("Drawdown File: "+m_DrawdownFileName);
   Logging("Check is First Run flag: "+((m_IsFirstRun==true) ? "Yes" : "No"));
   Logging("Check is New Day flag: "+((m_is_new_day) ? "Yes" : "No"));
   //---
   // if (inpShowControlPanel) {
   //    Logging("Initializing Info and Idea Control Panel...");
   //    DialogRun();
   // }
   //---
   if (InfoObjectsInit()) {
      IdeaObjectsInit();
      InfoRunning();
      return (true);
   }
   //---
   return (false);
}
//+------------------------------------------------------------------+
//| Method InfoObjectsInit                                           |
//+------------------------------------------------------------------+
bool CAccountManager::InfoObjectsInit(void)
{
   //--- create lower info labels
   int i,sy = 10;
   int dy = 16;
   color color_info,color_label;
   //---
   color_info = (color)(ChartGetInteger(0,CHART_COLOR_BACKGROUND)^0xFFFFFF);
   color_label = (color)(color_info^0x707070);
   //#region Lower Labels
   sy -= 7;
   //---
   for (i = 0; i < 14; i++)
   {
      m_lower_label[i].Create(0,"lower_label_"+IntegerToString(i),0,ll_x[i],sy+dy*ll_y[i]);
      m_lower_label[i].Description(ll_desc[i]);
      m_lower_label[i].Color(color_label);
      m_lower_label[i].FontSize(8);
      m_lower_label[i].Corner(CORNER_LEFT_LOWER);
      //---
      m_lower_label_info[i].Create(0,"lower_label_info_"+IntegerToString(i),0,lli_x[i],sy+dy*ll_y[i]);
      m_lower_label_info[i].Description("");
      m_lower_label_info[i].Color(color_info);
      m_lower_label_info[i].FontSize(8);
      m_lower_label_info[i].Corner(CORNER_LEFT_LOWER);
   }
   //#endregion
   //#region Upper Labels
   i = 10;
   sy = 10;
   dy = 16;
   //---
   if (ChartGetInteger(0, CHART_SHOW_OHLC))
      sy += 16;
   //---
   for (i = 0; i < 27; i++)
   {
      m_upper_label[i].Create(0,"Label"+IntegerToString(i),0,20,sy+dy*i);
      m_upper_label[i].Description(ul_desc[i]);
      m_upper_label[i].Color(color_label);
      m_upper_label[i].FontSize(8);
      //---
      //m_upper_left_label[14].Description((stats.profitConsistencyPercent == 0) ? "P/L to < 30%" : (stats.profitConsistencyPercent < 20) ? "P/L to < 20%" : "P/L to < 30%");
      // m_upper_left_label[24].Description("Trades to "+DoubleToString(stats.TargetPercent, 0)+"%");
      // m_upper_left_label[25].Description("Days to "+DoubleToString(stats.TargetPercent, 0)+"%");
      //---
      m_upper_label_info[i].Create(0,"LabelInfo"+IntegerToString(i),0,110,sy+dy*i);
      m_upper_label_info[i].Description(" ");
      m_upper_label_info[i].Color(color_info);
      m_upper_label_info[i].FontSize(8);  
   }
   //#endregion
   InfoToChart();
   ChartRedraw();
   //---
   return(true);
}
//+------------------------------------------------------------------+
//| Method IdeaObjectsInit                                           |
//+------------------------------------------------------------------+
bool CAccountManager::IdeaObjectsInit(void)
{
   //--- create idea info labels
   int i,sy = 10;
   int dy = 16;
   color color_info,color_label;
   //---
   color_info = (color)(ChartGetInteger(0,CHART_COLOR_BACKGROUND)^0xFFFFFF);
   color_label = (color)(color_info^0x707070);
   //---
   if (ChartGetInteger(0, CHART_SHOW_OHLC))
      sy += 16;
   //---
   int j;
   int idea_total = IdeaList.Total();
   //---
   if (idea_total != m_idea_total) {
      m_idea_total = idea_total;
      if (m_idea_total > 0 && m_idea_total <= 4) {
         //--- clear existing ideas labels
         for (i = 0; i < 26; i++)
         {
            for (j = 0; j < 4; j++) {
               if (ObjectFind(0, "idea_label_info" + IntegerToString(i) + "_" + IntegerToString(j)) >= 0)
                  m_idea_label_info[i][j].Delete();
            }
            if (ObjectFind(0, "idea_label" + IntegerToString(i)) >= 0)
               m_idea_label[i].Delete();
         }
         //--- create ideas labels
         for (i = 0; i < 26; i++) {
            m_idea_label[i].Create(0, "idea_label" + IntegerToString(i), 0, 200, sy+dy*i);
            m_idea_label[i].Description(init_il_str[i]);
            m_idea_label[i].Color(color_label);
            m_idea_label[i].FontSize(8);
            //---
            if (m_idea_total == 2)
               m_idea_label[0].Description("============  TRADING IDEAS  ============");
            // else if (m_idea_total == 3)
            //    m_idea_label[0].Description("============  TRADING IDEAS  ============");
            // else if (m_idea_total == 4)
            //    m_idea_label[0].Description("============  TRADING IDEAS  ============");
            //---
            if (inpTrailingType==BY_PIPS) {
               m_idea_label[19].Description("TSL Start in Pips");
            }
            else if (inpTrailingType==BY_PERCENTAGE) {
               m_idea_label[19].Description("TSL Start in %");
            }
            else if (inpTrailingType==BY_DOLLAR_AMOUNT) {
               m_idea_label[19].Description("TSL Start in $");
            }
         }
         //--- create dynamic info labels
         for (i = 0; i < 26; i++)
         {
            for (int j = 0; j < idea_total; j++) {
               m_idea_label_info[i][j].Create(0, "idea_label_info" + IntegerToString(i) + "_" + IntegerToString(j), 0, init_il_x[j], sy+dy*i);
               m_idea_label_info[i][j].Description(" "); // Replace with actual dynamic data later
               m_idea_label_info[i][j].Color(color_info);
               m_idea_label_info[i][j].FontSize(8);
            }
         }
         InfoToChart();
         ChartRedraw();
         //---
         return(true);
      }
      else
      {
         //--- clear existing ideas labels
         for (i = 0; i < 26; i++)
         {
            for (j = 0; j < 4; j++) {
               if (ObjectFind(0, "idea_label_info" + IntegerToString(i) + "_" + IntegerToString(j)) >= 0)
                  m_idea_label_info[i][j].Delete();
            }
            if (ObjectFind(0, "idea_label" + IntegerToString(i)) >= 0)
               m_idea_label[i].Delete();
         }
         InfoToChart();
         ChartRedraw();
         //---
         return(true);
      }
   }
   //---
   return(false);
}
//+------------------------------------------------------------------+
//| Method DialogInit                                                |
//+------------------------------------------------------------------+
bool CAccountManager::DialogInit(void)
{
   OnTradeProcessing();
   //---
   if(!ExtDialog.GetIdeas(IdeaList)) {
      Print(__FUNCTION__+"::Idea list is NULL");
      return(false);
   }
   //---
   if(!ExtDialog.Create(0,"Trading Idea's Control Panel ",0,470,26,790,498)) {
      Print(__FUNCTION__+"::Failed to create Control Panel");
      return(false);
   }
   //---
   ExtDialog.Run();
   //---
   return(true);
}
//+------------------------------------------------------------------+
//| Method InfoRunning                                               |
//+------------------------------------------------------------------+
void CAccountManager::InfoRunning(void)
{
   am.GetScore();
   //--- update info on chart
   InfoToChart();
   // InfoToDialog();
   ChartRedraw();
   //---
   Sleep(50);
}
//+------------------------------------------------------------------+
//| Method InfoProcessing                                            |
//+------------------------------------------------------------------+
void CAccountManager::OnTradeProcessing(void)
{
   int p;
   //---
   m_pos_total = PositionsTotal();
   //---
   TradeIdeaRefresh();
   //--- 
   if (am.dailyRemainingPercent >= 90.0) {
      Logging("Daily Loss Limit almost reached! Closing all positions...");
      for (p = m_pos_total - 1; p >= 0; p--) {
         am.ticket = PositionGetTicket(p);
         //---
         am.result = Trade.PositionClose(am.ticket);
         if (am.result) {
            Logging("Position #"+IntegerToString((int)am.ticket)+" closed successfully.");
            Sleep(50);
         }
         else {
            Logging("Failed to close position with ticket #"+IntegerToString((int)am.ticket)+
                  ". Error: "+IntegerToString(GetLastError()));
         }
      }
   }
   //---
   for (p = m_pos_total - 1; p >= 0; p--)
   {
      am.ticket = PositionGetTicket(p);
      if(!PositionSelectByTicket(am.ticket)) continue;
      //---
      am.type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? "BUY" : "SELL");
      am.symbol = PositionGetString(POSITION_SYMBOL);
      string direction = (am.type == "BUY") ? "LONG" : "SHORT";
      string base = StringSubstr(am.symbol, 0, 3);
      string quote = StringSubstr(am.symbol, 3, 1);
      am.name = direction + "::" + base;
      if (StringToLower(quote))
         am.name += quote;
      //---
      am.digits = (int)SymbolInfoInteger(am.symbol,SYMBOL_DIGITS);
      am.point = SymbolInfoDouble(am.symbol,SYMBOL_POINT);
      am.tick_value = SymbolInfoDouble(am.symbol,SYMBOL_TRADE_TICK_VALUE);
      am.tick_size = SymbolInfoDouble(am.symbol,SYMBOL_TRADE_TICK_SIZE);
      am.bid = SymbolInfoDouble(am.symbol,SYMBOL_BID);
      am.ask = SymbolInfoDouble(am.symbol,SYMBOL_ASK);
      //---
      am.volume = PositionGetDouble(POSITION_VOLUME);
      am.price_open = PositionGetDouble(POSITION_PRICE_OPEN);
      am.price_current = PositionGetDouble(POSITION_PRICE_CURRENT);
      am.op_price_weighted = am.price_open * am.volume;
      am.cu_price_weighted = am.price_current * am.volume;
      //---
      am.stop_loss = PositionGetDouble(POSITION_SL);
      am.take_profit = PositionGetDouble(POSITION_TP);
      am.sl_price_weighted = (am.stop_loss != 0.0) ? am.stop_loss * am.volume : 0.0;
      am.tp_price_weighted = (am.take_profit != 0.0) ? am.take_profit * am.volume : 0.0;
      //---
      am.change = (am.type == "BUY") ?
                     ((am.cu_price_weighted - am.op_price_weighted) / am.op_price_weighted) * 100.0 :
                     ((am.op_price_weighted - am.cu_price_weighted) / am.op_price_weighted) * 100.0;
      //---
      am.float_PnL = PositionGetDouble(POSITION_PROFIT);
      am.float_pips = (am.type == "BUY") ?
                         ((am.price_current - am.price_open) / am.point) :
                         ((am.price_open - am.price_current) / am.point);
      //---
      if (am.stop_loss != 0.0) {
         am.riskInMoney = (am.type == "BUY") ?
                      ((am.stop_loss * am.volume) - am.op_price_weighted) * am.tick_value / am.tick_size :
                      (am.op_price_weighted - (am.stop_loss * am.volume)) * am.tick_value / am.tick_size;
         am.percentToRiskRule = (am.riskInMoney / am.riskRuleInMoney) * 100.0;
         //---
         if (am.riskInMoney < 0.0)
            am.percentToRiskRule = MathAbs(am.percentToRiskRule);
         else if (am.riskInMoney > 0.0)
            am.percentToRiskRule = 0.0;
         //---
      } else {
         am.riskInMoney = 0.0;
         am.percentToRiskRule = 0.0;
      }
      //---
      if (am.take_profit != 0.0) {
         am.reward = (am.type == "BUY") ?
                        ((am.take_profit * am.volume) - am.op_price_weighted) * am.tick_value / am.tick_size :
                        (am.op_price_weighted - (am.take_profit * am.volume)) * am.tick_value / am.tick_size;
         am.reward_pips = (am.type == "BUY") ?
                             ((am.take_profit - am.price_open) / am.point) :
                             ((am.price_open - am.take_profit) / am.point);
      } else {
         am.reward = 0.0;
         am.reward_pips = 0.0;
      }
      //---
      OnTradeIdeas(); 
   }
   //---
   if (IdeaObjectsInit())
      InfoToChart();
   //---
}
//+------------------------------------------------------------------+
//| Method OnTimerSet                                                |
//+------------------------------------------------------------------+
bool CAccountManager::OnTimerSet(void)
{
   SilentLogging = true;
   //---
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   //---
   m_today_date = DateToString();
   m_yesterday_date = m_today_date - 86400;
   // m_UtilRateFileName = "\\AM_UtilizationRate_"+RemoveDots(TimeToString(m_today_date, TIME_DATE))+".txt";
   // m_ProfitabilityFileName = "\\AM_Profitability_"+RemoveDots(TimeToString(m_today_date, TIME_DATE))+".txt";
   // m_DrawdownFileName = "\\AM_Drawdown_"+RemoveDots(TimeToString(m_today_date, TIME_DATE))+".txt";
   //---
   MqlDateTime tm = {};
   datetime time = TimeTradeServer(tm);
   int hours = tm.hour;
   int minutes = tm.min;
   int seconds = tm.sec;
   //---
   bool is_minute_time = (seconds == 0 && ((minutes % m_interval_minutes) == 0));
   bool is_daily_time = (hours == 23 && minutes == 55 && seconds == 0);
   //---
   if (is_minute_time)
      m_MinuteTimerSet = true;
   //---
   if (m_MinuteTimerSet)
   {
      m_is_new_day = CurrentDate(m_current_date, m_today_date);
      //---
      Logging("Today's Date: "+TimeToString(m_today_date, TIME_DATE));
      Logging("Current Date: "+TimeToString(m_current_date, TIME_DATE));
      Logging("Yesterday's Date: "+TimeToString(m_yesterday_date, TIME_DATE));
      Logging("Util Rate File: "+m_UtilRateFileName);
      Logging("Profitability File: "+m_ProfitabilityFileName);
      Logging("Drawdown File: "+m_DrawdownFileName);
      Logging("Check is First Run flag: "+((m_IsFirstRun==true) ? "Yes" : "No"));
      Logging("Check is New Day flag: "+((m_is_new_day) ? "Yes" : "No"));
      //---
      if (!m_is_new_day) {
         Logging("Logging data at "+TimeToString(time,TIME_DATE|TIME_MINUTES|TIME_SECONDS));
         //--- Deposit Utilization Rate
         ArrayResize(m_utilize_rate,ArraySize(m_utilize_rate)+1);
         m_utilize_rate[ArraySize(m_utilize_rate)-1] = am.utilizeRate;
         //--- Profitability
         ArrayResize(m_profitability,ArraySize(m_profitability)+1);
         m_profitability[ArraySize(m_profitability)-1] = am.maximalPeak;
         //--- Drawdown
         ArrayResize(m_drawdown,ArraySize(m_drawdown)+1);
         m_drawdown[ArraySize(m_drawdown)-1] = am.drawdown;
      }
      //--- Save to Disk
      SaveToDisk();
      //---
      am.maxUtilizeRate = MaxUtilizationRate();
      am.maximalPeak = MaxProfitability();
      am.maxDrawdown = MaxDrawdown();
      //---
      Logging("Max Utilization Rate: "+DoubleToString(am.maxUtilizeRate,2)+" %");
      Logging("Max Profitability: "+DoubleToString(am.maximalPeak,2)+" %");
      Logging("Max Drawdown: "+DoubleToString(am.maxDrawdown,2)+" %");
      //---
      m_MinuteTimerSet = false;
      m_is_new_day = false;
      SilentLogging = false;
      return (true);
   }
   //---
   if (is_daily_time)
      m_DailyTimerSet = true;
   //---
   if (m_DailyTimerSet)
   {
      am.lastDailyLogTime = TimeLocal();
      Logging("\nDAILY TIMER TRIGGERED");
      //---
      ArrayResize(m_dailyNetPnL, am.totalDaysTraded + 1);
      m_dailyNetPnL[am.totalDaysTraded] = am.dailyNetPL;
      am.totalDaysTraded++;
      //---
      if (equity > balance)
         am.dailyLossLimit = equity - am.dailyLoss;
      else
         am.dailyLossLimit = balance - am.dailyLoss;
      //---
      am.dailyTargetLimit = balance - inpDailyTarget;
      //--- Save to Disk
      SaveToDisk();
      //---
      am.bestDailyNetPL = HighestDailyNetPnL();
      am.totalDailyNetPL = TotalDailyNetPnL();
      //---
      Logging("Daily Log Time: " + TimeToString(am.lastDailyLogTime, TIME_DATE | TIME_MINUTES));
      Logging("Balance: " + DoubleToString(balance, 2));
      Logging("Equity: " + DoubleToString(equity, 2));
      Logging("Days Traded: " + IntegerToString(am.totalDaysTraded));
      Logging("Daily PnL logged: " + DoubleToString(am.dailyNetPL, 2));
      Logging("Best Daily PnL: " + DoubleToString(am.bestDailyNetPL, 2));
      Logging("Total Daily PnL: " + DoubleToString(am.totalDailyNetPL, 2));
      Logging("Reset daily loss limit to: " + DoubleToString(am.dailyLossLimit, 2));
      Logging("Reset daily target limit to: " + DoubleToString(am.dailyTargetLimit, 2));
      Logging("Reset today's target to: " + DoubleToString(am.todayTarget, 2));
      //---
      m_DailyTimerSet = false;
      SilentLogging = false;
      return (true);
   }
   //--- Delete old log file at midnight
   string old_utilRate_file = m_work_folder + "\\AM_UtilizationRate_" + RemoveDots(TimeToString(m_yesterday_date, TIME_DATE)) + ".txt";
   string old_profitability_file = m_work_folder + "\\AM_Profitability_" + RemoveDots(TimeToString(m_yesterday_date, TIME_DATE)) + ".txt";
   string old_drawdown_file = m_work_folder + "\\AM_Drawdown_" + RemoveDots(TimeToString(m_yesterday_date, TIME_DATE)) + ".txt";
   //---
   // if (FileIsExist(old_utilRate_file)) {
   //    if (FileDelete(old_utilRate_file))
   //       Logging("Old Utilization Rate file deleted: " + old_utilRate_file);
   //    else
   //       Logging("Failed to delete old Utilization Rate file: " + old_utilRate_file);
   // }
   // if (FileIsExist(old_profitability_file)) {
   //    if (FileDelete(old_profitability_file))
   //       Logging("Old Profitability file deleted: " + old_profitability_file);
   //    else
   //       Logging("Failed to delete old Profitability file: " + old_profitability_file);
   // }
   // if (FileIsExist(old_drawdown_file)) {
   //    if (FileDelete(old_drawdown_file))
   //       Logging("Old Drawdown file deleted: " + old_drawdown_file);
   //    else
   //       Logging("Failed to delete old Drawdown file: " + old_drawdown_file);
   // }
   //---
   SilentLogging = false;
   return (false);
}
//+------------------------------------------------------------------+
//| Method DialogRun                                                 |
//+------------------------------------------------------------------+
// bool CAccountManager::DialogRun(void)
// {
//    int ideas_total = IdeaList.Total();
//    //--- Run the dialog
//    if(!ExtDialog.Create(0,"Trading Idea's Controls",0,20,20,320,450))
//    {
//       Logging("Failed to create settings dialog.");
//       return (false);
//    }
//    //--- Initialize dialog controls here
//    if(!InfoToDialog())
//    {
//       Logging("Failed to initialize dialog controls.");
//       return (false);
//    }
//    //--- Run the dialog
//    ExtDialog.Run();
//    return (true);
// }
//+------------------------------------------------------------------+
//| Method OnEvent                                                   |
//+------------------------------------------------------------------+
bool CAccountManager::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   //--- Process dialog events here
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);
   ENUM_CHART_EVENT evt = (ENUM_CHART_EVENT)id;
   if(evt==CHARTEVENT_OBJECT_ENDEDIT && CHARTEVENT_CUSTOM<id) {
      PrintFormat("%s %lld %f '%s'", EnumToString(evt), lparam, dparam, sparam);
      Logging(EnumToString(evt)+" "+IntegerToString(lparam)+" "+DoubleToString(dparam)+" "+sparam);
   }

   // ENUM_CHART_EVENT evt = (ENUM_CHART_EVENT)id;
   // if(evt!=CHARTEVENT_MOUSE_MOVE) {
   //    PrintFormat("%s %lld %f '%s'", EnumToString(evt), lparam, dparam, sparam);
   // }
   // //--- clicking on a graphical object
   //    if(id==CHARTEVENT_OBJECT_CLICK)
   //       Print("CHARTEVENT_OBJECT_CLICK: '"+sparam+"'");
   // //--- object removed
   //    if(id==CHARTEVENT_OBJECT_DELETE)
   //       Print("CHARTEVENT_OBJECT_DELETE: ",sparam);
   // //--- object created
   //    if(id==CHARTEVENT_OBJECT_CREATE)
   //       Print("CHARTEVENT_OBJECT_CREATE: ",sparam);
   // //--- changed object
   //    if(id==CHARTEVENT_OBJECT_CHANGE)
   //       Print("CHARTEVENT_OBJECT_CHANGE: ",sparam);
   // //--- changed a text in the input field of the Edit graphical object
   //    if(id==CHARTEVENT_OBJECT_ENDEDIT)
   //       Print("CHARTEVENT_OBJECT_ENDEDIT: ",sparam,"  id=",id);
   // //--- event of resizing the chart or modifying the chart properties using the properties dialog window
   //    if(id==CHARTEVENT_CHART_CHANGE)
   //       Print("CHARTEVENT_CHART_CHANGE");
   // //--- custom event
   //    if(id>CHARTEVENT_CUSTOM)
   //       PrintFormat("CHARTEVENT_CUSTOM: %d, lparam: %d, dparam: %G, sparam: %s",id,lparam,dparam,sparam);
   return (true);
}
//======================== FILE OPERATIONS ===========================
//+------------------------------------------------------------------+
//| Method SaveToDisk                                                |
//+------------------------------------------------------------------+
bool CAccountManager::SaveToDisk(datetime today_date=datetime(0))
{
   SilentLogging = true;
   //---
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   //---
   int fh,i;
   string line;
   string is_firstRun = (m_IsFirstRun==true) ? "Is First Run" : "Is Not First Run";
   //--- Implementation of saving data to disk
   if (m_IsFirstRun)
   {
   //--- First Run Daily Log
      am.lastDailyLogTime = today_date;
      am.dailyLossLimit = am.DailyLossLimit();
      //---
      fh = FileOpen(m_work_folder+m_DailyLogFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
      if (fh != INVALID_HANDLE)
      {
         FileWrite(fh, am.lastDailyLogTime);
         FileWrite(fh, balance);
         FileWrite(fh, equity);
         FileWrite(fh, am.dailyLossLimit);
         FileWrite(fh, am.totalDaysTraded);
         FileClose(fh);
         //---
         Logging("Daily Log "+is_firstRun);
         Logging("First Run Daily Log Time " + TimeToString(am.lastDailyLogTime, TIME_DATE));
         Logging("First Run Account Balance " + DoubleToString(balance, 2));
         Logging("First Run Account Equity " + DoubleToString(equity, 2));
         Logging("First Run Daily Loss Limit " + DoubleToString(am.dailyLossLimit, 2));
         Logging("First Run Day Traded: " + IntegerToString(am.totalDaysTraded));
      }
      else
         Logging("Cannot create Daily Log file: "+m_work_folder+m_DailyLogFileName+". Error: "+IntegerToString(GetLastError()));
   //--- Deposit Utilization Rate
      fh = FileOpen(m_work_folder+m_UtilRateFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
      if (fh != INVALID_HANDLE)
      {
         // stats.maxUtilizeRate = 0.0;
         // FileWrite(fh, DoubleToString(stats.maxUtilizeRate, 2));
         //---
         ArrayResize(m_utilize_rate, 1);
         m_utilize_rate[0] = am.UtilizeRate();
         FileWrite(fh, DoubleToString(m_utilize_rate[0], 2));
         //---
         FileClose(fh);
         Logging("Array Utilization Rate "+is_firstRun+". Value: "+DoubleToString(m_utilize_rate[0],2));
      }
      else
         Logging("Cannot create Utilization Rate file: "+m_work_folder+m_UtilRateFileName+". Error: "+IntegerToString(GetLastError()));
   //--- Profitability
      fh = FileOpen(m_work_folder+m_ProfitabilityFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
      if (fh != INVALID_HANDLE)
      {
         // stats.maximalPeak = 0.0;
         // FileWrite(fh, DoubleToString(stats.maximalPeak, 2));
         //---
         ArrayResize(m_profitability, 1);
         m_profitability[0] = am.Profitability();
         FileWrite(fh, DoubleToString(m_profitability[0], 2));
         //---
         FileClose(fh);
         Logging("Array Profitability "+is_firstRun+". Value: "+DoubleToString(m_profitability[0],2));
      }
      else
         Logging("Cannot create Profitability file: "+m_work_folder+m_ProfitabilityFileName+". Error: "+IntegerToString(GetLastError()));
   //--- Drawdown
      fh = FileOpen(m_work_folder+m_DrawdownFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
      if (fh != INVALID_HANDLE)
      {
         // stats.maxDrawdown = 0.0;
         // FileWrite(fh, DoubleToString(stats.drawdown, 2));
         //---
         ArrayResize(m_drawdown, 1);
         m_drawdown[0] = am.Drawdown();
         FileWrite(fh, DoubleToString(m_drawdown[0], 2));
         //---
         FileClose(fh);
         Logging("Array Drawdown "+is_firstRun+". Value: "+DoubleToString(m_drawdown[0],2));
      }
      else
         Logging("Cannot create Drawdown file: "+m_work_folder+m_DrawdownFileName+". Error: "+IntegerToString(GetLastError()));
   //--- Save Main Data
      fh = FileOpen(m_work_folder+m_FileName, FILE_WRITE|FILE_BIN);
      if (fh != INVALID_HANDLE)
      {
         m_IsFirstRun = false;
         //--- Write header
         FileWriteInteger(fh, m_acc_login);
         //--- Write data to file
         //--- Write today's date
         // (fh, m_today_date); m_yesterday_date
         FileWriteLong(fh, today_date);
         FileWriteInteger(fh, m_IsFirstRun ? 1 : 0);
         FileWriteInteger(fh, m_is_new_day ? 1 : 0);
         FileWriteDouble(fh, am.dailyTargetLimit);
         //---
         FileClose(fh);
      }
      else
         Logging("Cannot create Account Manager data file: "+m_work_folder+m_FileName+". Error: "+IntegerToString(GetLastError()));
   }
   else
   {
      fh = FileOpen(m_work_folder+m_FileName, FILE_WRITE|FILE_BIN);
      if (fh != INVALID_HANDLE)
      {
         // m_IsFirstRun = false;
         //--- Write header
         FileWriteInteger(fh, m_acc_login);
         //--- Write data to file
         //--- Write today's date
         // (fh, m_today_date); m_yesterday_date
         FileWriteLong(fh, m_current_date);
         FileWriteInteger(fh, m_IsFirstRun ? 1 : 0);
         FileWriteInteger(fh, m_is_new_day ? 1 : 0);
         FileWriteDouble(fh, am.dailyTargetLimit);
         //---
         FileClose(fh);
      }
      else
         Logging("Cannot create Account Manager data file: "+m_work_folder+m_FileName+". Error: "+IntegerToString(GetLastError()));
   }
   //---
   if (m_MinuteTimerSet)
   {
      if (m_is_new_day) {
      //--- Deposit Utilization Rate
         fh = FileOpen(m_work_folder+m_UtilRateFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
         if (fh != INVALID_HANDLE)
         {
            double maxUtilRate = MaxUtilizationRate();
            double utilRate = am.UtilizeRate();
            //---
            ArrayResize(m_utilize_rate, 2);
            m_utilize_rate[0] = maxUtilRate;
            m_utilize_rate[1] = utilRate;
            FileWrite(fh, DoubleToString(m_utilize_rate[0], 2));
            FileWrite(fh, DoubleToString(m_utilize_rate[1], 2));
            //---
            FileClose(fh);
            Logging("New Utilization Rate file created for new date: "+m_work_folder+m_UtilRateFileName);
         }
         else
            Logging("Cannot create new Utilization Rate file for new date: "+m_work_folder+m_UtilRateFileName+". Error: "+IntegerToString(GetLastError()));
      //--- Profitability
         fh = FileOpen(m_work_folder+m_ProfitabilityFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
         if (fh != INVALID_HANDLE)
         {
            double maxProfitability = MaxProfitability();
            double profitability = am.Profitability();
            //---
            ArrayResize(m_profitability, 2);
            m_profitability[0] = maxProfitability;
            m_profitability[1] = profitability;
            FileWrite(fh, DoubleToString(m_profitability[0], 2));
            FileWrite(fh, DoubleToString(m_profitability[1], 2));
            //---
            FileClose(fh);
            Logging("New Profitability file created for new date: "+m_work_folder+m_ProfitabilityFileName);
         }
         else
            Logging("Cannot create new Profitability file for new date: "+m_work_folder+m_ProfitabilityFileName+". Error: "+IntegerToString(GetLastError()));
      //--- Drawdown
         fh = FileOpen(m_work_folder+m_DrawdownFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
         if (fh != INVALID_HANDLE)
         {
            double maxDrawdown = MaxDrawdown();
            double drawdown = am.Drawdown();
            //---
            ArrayResize(m_drawdown, 2);
            m_drawdown[0] = maxDrawdown;
            m_drawdown[1] = drawdown;
            FileWrite(fh, DoubleToString(m_drawdown[0], 2));
            FileWrite(fh, DoubleToString(m_drawdown[1], 2));
            //---
            FileClose(fh);
            Logging("New Drawdown file created for new date: "+m_work_folder+m_DrawdownFileName);
         }
         else
            Logging("Cannot create new Drawdown file for new date: "+m_work_folder+m_DrawdownFileName+". Error: "+IntegerToString(GetLastError()));
         //---
         m_is_new_day = false;
      }
      else {
      //--- Deposit Utilization Rate
         fh = FileOpen(m_work_folder+m_UtilRateFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
         if (fh != INVALID_HANDLE)
         {
            for (i = 0; i < ArraySize(m_utilize_rate); i++) {
               FileWrite(fh, DoubleToString(m_utilize_rate[i], 2));
               line += DoubleToString(m_utilize_rate[i], 2);
            }
            FileClose(fh);
         }
         else
            Logging("Cannot open Utilization Rate file: "+m_work_folder+m_UtilRateFileName+". Error: "+IntegerToString(GetLastError()));
      //--- Profitability
         fh = FileOpen(m_work_folder+m_ProfitabilityFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
         if (fh != INVALID_HANDLE)
         {
            for (i = 0; i < ArraySize(m_profitability); i++) {
               FileWrite(fh, DoubleToString(m_profitability[i], 2));
               line += DoubleToString(m_profitability[i], 2);
            }
            FileClose(fh);
         }
         else
            Logging("Cannot open Profitability file: "+m_work_folder+m_ProfitabilityFileName+". Error: "+IntegerToString(GetLastError()));
      //--- Drawdown
         fh = FileOpen(m_work_folder+m_DrawdownFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
         if (fh != INVALID_HANDLE)
         {
            for (i = 0; i < ArraySize(m_drawdown); i++) {
               FileWrite(fh, DoubleToString(m_drawdown[i], 2));
               line += DoubleToString(m_drawdown[i], 2);
            }
            FileClose(fh);
         }
         else
            Logging("Cannot open Drawdown file: "+m_work_folder+m_DrawdownFileName+". Error: "+IntegerToString(GetLastError()));
      }
   }
   //--- Save Daily Log
   if (m_DailyTimerSet)
   {
      fh = FileOpen(m_work_folder+m_DailyLogFileName, FILE_WRITE|FILE_TXT|FILE_ANSI);
      if (fh != INVALID_HANDLE)
      {
         FileWrite(fh, am.lastDailyLogTime);
         FileWrite(fh, balance);
         FileWrite(fh, equity);
         FileWrite(fh, am.dailyLossLimit);
         FileWrite(fh, am.totalDaysTraded);
         //---
         for (i = 0; i < am.totalDaysTraded; i++) {
            FileWrite(fh, DoubleToString(m_dailyNetPnL[i], 2));
            line += DoubleToString(m_dailyNetPnL[i], 2);
         }
         //---
         FileClose(fh);
      }
      else
         Logging("Cannot create Daily Log file: "+m_work_folder+m_DailyLogFileName+". Error: "+IntegerToString(GetLastError()));
   }
   //---
   SilentLogging = false;
   return(true);
}
//+------------------------------------------------------------------+
//| Method LoadFromDisk                                              |
//+------------------------------------------------------------------+
bool CAccountManager::LoadFromDisk(void)
{
   SilentLogging = true;
   //---
   int fh;
   int error_flag = 0;
   string line;
   //--- Load Main Data
   fh = FileOpen(m_work_folder+m_FileName, FILE_READ|FILE_BIN);
   if (fh == INVALID_HANDLE) {
      Logging("Cannot open Account Manager data file: "+m_work_folder+m_FileName+". Error: "+IntegerToString(GetLastError()));
      error_flag++;
   }
   while (!FileIsEnding(fh)) {
      int marker = FileReadInteger(fh);
      if (marker != m_acc_login) {
         Logging("Invalid file format or corrupted data file!");
         FileClose(fh);
         return(false);
      }
      //--- Read data from file
      m_current_date = (datetime)FileReadLong(fh);
      m_IsFirstRun = (FileReadInteger(fh) == 1) ? true : false;
      m_is_new_day = (FileReadInteger(fh) == 1) ? true : false;
      am.dailyTargetLimit = FileReadDouble(fh);
   }
   FileClose(fh);
   //--- Load Deposit Utilization Rate
   fh = FileOpen(m_work_folder+m_UtilRateFileName, FILE_READ|FILE_TXT|FILE_ANSI);
   if (fh == INVALID_HANDLE) {
      Logging("Cannot open Utilization Rate file: "+m_work_folder+m_UtilRateFileName+". Error: "+IntegerToString(GetLastError()));
      error_flag++;
   }
   while (!FileIsEnding(fh)) {
      line = FileReadString(fh);
      ArrayResize(m_utilize_rate, ArraySize(m_utilize_rate)+1);
      m_utilize_rate[ArraySize(m_utilize_rate)-1] = StringToDouble(line);
   }
   FileClose(fh);
   //--- Load Profitability
   fh = FileOpen(m_work_folder+m_ProfitabilityFileName, FILE_READ|FILE_TXT|FILE_ANSI);
   if (fh == INVALID_HANDLE) {
      Logging("Cannot open Profitability file: "+m_work_folder+m_ProfitabilityFileName+". Error: "+IntegerToString(GetLastError()));
      error_flag++;
   }
   while (!FileIsEnding(fh)) {
      line = FileReadString(fh);
      ArrayResize(m_profitability, ArraySize(m_profitability)+1);
      m_profitability[ArraySize(m_profitability)-1] = StringToDouble(line);
   }
   FileClose(fh);
   //--- Load Drawdown
   fh = FileOpen(m_work_folder+m_DrawdownFileName, FILE_READ|FILE_TXT|FILE_ANSI);
   if (fh == INVALID_HANDLE) {
      Logging("Cannot open Drawdown file: "+m_work_folder+m_DrawdownFileName+". Error: "+IntegerToString(GetLastError()));
      error_flag++;
   }
   while (!FileIsEnding(fh)) {
      line = FileReadString(fh);
      ArrayResize(m_drawdown, ArraySize(m_drawdown)+1);
      m_drawdown[ArraySize(m_drawdown)-1] = StringToDouble(line);
   }
   FileClose(fh);
   //--- Load Daily Log
   fh = FileOpen(m_work_folder+m_DailyLogFileName, FILE_READ|FILE_TXT|FILE_ANSI);
   if (fh == INVALID_HANDLE) {
      Logging("Cannot open Daily Log file: "+m_work_folder+m_DailyLogFileName+". Error: "+IntegerToString(GetLastError()));
      error_flag++;
   }
   while (!FileIsEnding(fh))
   {
      line = FileReadString(fh);
      am.lastDailyLogTime = StringToTime(line);
      line = FileReadString(fh);
      am.lastDailyBalance = StringToDouble(line);
      line = FileReadString(fh);
      am.lastDailyEquity = StringToDouble(line);
      line = FileReadString(fh);
      am.dailyLossLimit = StringToDouble(line);
      line = FileReadString(fh);
      am.totalDaysTraded = (int)StringToInteger(line);
      for (int i = 0; i < am.totalDaysTraded; i++)
      {
         line = FileReadString(fh);
         ArrayResize(m_dailyNetPnL, ArraySize(m_dailyNetPnL) + 1);
         m_dailyNetPnL[ArraySize(m_dailyNetPnL) - 1] = StringToDouble(line);
      }
      //---
      if (am.totalDaysTraded != 0) {
         am.bestDailyNetPL = HighestDailyNetPnL();
         am.totalDailyNetPL = TotalDailyNetPnL();
      }
   }
   FileClose(fh);
   //--- Success?
   if (error_flag == 5) {
      SilentLogging = false;
      return(false);
   }
   else {
      Logging(" ");
      // Logging("Today's date: "+TimeToString(m_today_date,TIME_DATE));
      // Logging("Is New Day flag: "+((m_is_new_day==true) ? "true" : "false"));
      // Logging("Is First Run flag: "+((m_IsFirstRun==true) ? "true" : "false"));
      //--- Update stats
      if (m_IsFirstRun==false) {
         am.maxUtilizeRate = MaxUtilizationRate();
         am.maximalPeak = MaxProfitability();
         am.maxDrawdown = MaxDrawdown();
      }
      //---
      Logging("Total Utilization Rate records loaded: "+IntegerToString(ArraySize(m_utilize_rate)));
      Logging("Max Utilization Rate: "+DoubleToString(am.maxUtilizeRate,2)+" %");
      Logging("Total Profitability records loaded: "+IntegerToString(ArraySize(m_profitability)));
      Logging("Max Profitability: "+DoubleToString(am.maximalPeak,2)+" %");
      Logging("Total Drawdown records loaded: "+IntegerToString(ArraySize(m_drawdown)));
      Logging("Max Drawdown: "+DoubleToString(am.maxDrawdown,2)+" %");
      //---
      SilentLogging = false;
      return(true);
   }
}
//=========================== PRIVATE ================================
//+------------------------------------------------------------------+
//| Method TradingIdeas                                              |
//+------------------------------------------------------------------+
// void CAccountManager::OnTradeIdeas_Old(void)
// {
//    int i,p;
//    int idea_total = IdeaList.Total();
//    // int pos_modified = 0;
//    // int digits = 0;
//    // //---
//    // bool is_found = false;
//    // bool trailing_triggered = false;
//    // bool daily_target_reached = false;
//    // bool res = false;
//    // //---
//    // string idea_name = stats.name;
//    // string idea_type = stats.type;
//    // double trade_PnL = 0.0;
//    // double trade_pips = 0.0;
//    // double trade_change = 0.0;
//    // double idea_op_weighted = stats.price_open * stats.volume;
//    // double idea_cu_weighted = stats.price_current * stats.volume;
//    // double idea_SL_weighted = stats.stop_loss * stats.volume;
//    // double diff_weighted_1 = 0.0;
//    // double diff_weighted_2 = 0.0;
//    am.OnTradeIdeasInit();
//    //---
//    for (i = 0; i < idea_total; i++)
//    {
//       CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
//       if (trade == NULL) continue;
//       if (trade.ideaName == am.name && trade.ideaSymbol == am.symbol) {
//          if (am.type == "BUY")
//             trade.ideaBuyTotal += 1;
//          else
//             trade.ideaSellTotal += 1;
//          //---
//          trade.ideaPriceWeighted += am.op_price_weighted;
//          trade.ideaVolume += am.volume;
//          trade.ideaFloatPnL += am.float_PnL;
//          trade.ideaFloatPips += am.float_pips;
//          trade.ideaChange += am.change;
//          //---
//          am.trade_PnL = trade.ideaFloatPnL;
//          am.trade_pips = trade.ideaFloatPips;
//          am.trade_change = trade.ideaChange;
//          //---
//          if(trade.ideaTrailingStopEnabled && !am.is_triggered)
//          {
//             if (inpTrailingType==BY_PIPS) {
//                am.is_triggered = am.trade_pips >= inpTrailingStart;
//             } else if (inpTrailingType==BY_PERCENTAGE) {
//                am.is_triggered = am.trade_change >= inpTrailingStart;
//             } else {
//                am.is_triggered = am.trade_PnL >= inpTrailingStart;
//             }
//          }
//          else
//             am.is_triggered = false;
//          // if(trailing_triggered)
//          //    Print("Trailing Triggered!");
//          //---
//          if (am.trade_PnL >= (inpDailyTarget*2) && !am.daily_target_reached)
//             am.daily_target_reached = true;
//          //---
//          if (trade.ideaStopLoss != am.stop_loss) {
//             trade.ideaStopLoss = am.stop_loss;
//             // Print("SL stats ", DoubleToString(stats.stop_loss,2));
//             // Print("SL idea ", DoubleToString(trade.ideaStopLoss,2));
//             trade.ideaWithSL = 1;
//             trade.ideaRisk = am.riskInMoney;
//             trade.ideaRiskPercent = am.percentToRiskRule;
//             //---
//             am.diff_weighted_1 = MathAbs(am.op_price_weighted - am.sl_price_weighted);
//             am.diff_weighted_2 = MathAbs(am.cu_price_weighted - am.sl_price_weighted);
//             trade.ideaPercentToSL = (am.diff_weighted_1 - am.diff_weighted_2) / am.diff_weighted_1 * 100.0; 
//             //---
//             am.trade_with_SL = true;
//          }
//          //---
//          if (am.stop_loss != 0.0 && trade.ideaStopLoss == am.stop_loss) {
//             trade.ideaWithSL += 1;
//             trade.ideaRisk += am.riskInMoney;
//             trade.ideaRiskPercent += am.percentToRiskRule;
//             //---
//             am.diff_weighted_1 += MathAbs(am.op_price_weighted - am.sl_price_weighted);
//             am.diff_weighted_2 += MathAbs(am.cu_price_weighted - am.sl_price_weighted);
//             trade.ideaPercentToSL = (am.diff_weighted_1 - am.diff_weighted_2) / am.diff_weighted_1 * 100.0; 
//             //---
//             // trade.ideaBreakEvenEnabled = (stats.type == "BUY") ?
//             //                              (stats.stop_loss > stats.price_open) ?
//             //                              (trade.ideaFloatPnL < inpDailyTarget) ?
//             //                              true : false : false : false;
//             //---
//             // stats.trade_with_SL = false;
//          }
//          // else if (stats.stop_loss == 0.0) {
//          //    trade_PnL = trade.ideaFloatPnL;
//          //    //---
//          //    if (trade_PnL >= inpDailyTarget + (inpDailyTarget/2)) {
//          //       trade.ideaTrailingStopEnabled = true;
//          //       trailing_triggered = true;
//          //    }
//          // }
//          //---
//          if (am.take_profit != 0.0) {
//             trade.ideaWithTP += 1;
//             trade.ideaReward += am.reward;
//             trade.ideaRewardPips += am.reward_pips;
//          }
//          //---
//          am.is_found = true;
//          break;
//       }
//    }
//    //---
//    if (!am.is_found) {
//       CTradeIdeas *new_idea = new CTradeIdeas();
//       new_idea.ideaSymbol = am.symbol;
//       new_idea.ideaType = am.type;
//       new_idea.ideaName = am.name;
//       if (am.type == "BUY")
//          new_idea.ideaBuyTotal = 1;
//       else
//          new_idea.ideaSellTotal = 1;
//       //---
//       new_idea.ideaPriceWeighted = am.op_price_weighted;
//       new_idea.ideaVolume = am.volume;
//       new_idea.ideaFloatPnL = am.float_PnL;
//       new_idea.ideaFloatPips = am.float_pips;
//       //---
//       // new_idea.ideaTrailingStopEnabled = ExtDialog.TrailingEnabledGetValue()
//       new_idea.ideaTrailingStart = inpTrailingStart;
//       //---
//       new_idea.ideaChange = am.change;
//       //---
//       if (am.stop_loss != 0.0) {
//          new_idea.ideaStopLoss = am.stop_loss;
//          // Print("SL ", DoubleToString(new_idea.ideaStopLoss,2));
//          new_idea.ideaWithSL = 1;
//          new_idea.ideaRisk = am.riskInMoney;
//          new_idea.ideaRiskPercent = am.percentToRiskRule;
//          // new_idea.ideaTrailingStopEnabled = m_TrailingEnabled;
//          //---
//          am.diff_weighted_1 = MathAbs(am.op_price_weighted - am.sl_price_weighted);
//          am.diff_weighted_2 = MathAbs(am.cu_price_weighted - am.sl_price_weighted);
//          new_idea.ideaPercentToSL = (am.diff_weighted_1 - am.diff_weighted_2) / am.diff_weighted_1 * 100.0;
//          //---
//          // stats.trade_with_SL = true;
//       }
//       //---
//       if (am.take_profit != 0.0) {
//          new_idea.ideaWithTP = 1;
//          new_idea.ideaReward = am.reward;
//          new_idea.ideaRewardPips = am.reward_pips;
//       }
//       //---
//       IdeaList.Add(new_idea);
//    }
//    //---
//    if (am.trade_with_SL) { 
//       double pos_newSL = 0.0;
//       for (p = m_pos_total - 1; p >= 0; p--)
//       {
//          ulong pos_ticket = PositionGetTicket(p);
//          if(!PositionSelectByTicket(pos_ticket)) continue;
//          //---
//          string pos_type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? "BUY" : "SELL");
//          string pos_symbol = PositionGetString(POSITION_SYMBOL);
//          string direction = (pos_type == "BUY") ? "LONG" : "SHORT";
//          string base = StringSubstr(pos_symbol, 0, 3);
//          string quote = StringSubstr(pos_symbol, 3, 1);
//          string pos_name = direction + "::" + base;
//          if (StringToLower(quote))
//             pos_name += quote;
//          //---
//          if (idea_total == 0) return;
//          //---
//          for (i = 0; i < idea_total; i++)
//          {
//             CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
//             if (trade == NULL) continue;
//             if (trade.ideaName == pos_name && am.trade_with_SL) {
//                //---
//                am.digits = (int)SymbolInfoInteger(pos_symbol, SYMBOL_DIGITS);
//                //---
//                double pos_SL = PositionGetDouble(POSITION_SL);
//                double pos_TP = PositionGetDouble(POSITION_TP);
//                pos_newSL = NormalizeDouble(trade.ideaStopLoss, am.digits);
//                //---
//                if (pos_SL == pos_newSL) continue;
//                Print("SL idea ", DoubleToString(trade.ideaStopLoss,am.digits));
//                Print("New SL ", DoubleToString(pos_newSL,am.digits));
//                //---
//                if (trade.ideaWithSL >= 1) {
//                   if (trade.ideaType == "BUY" && pos_type == "BUY")
//                   {
//                      if (pos_SL != pos_newSL || pos_SL == 0.0) {
//                         am.result = Trade.PositionModify(pos_ticket, pos_newSL, pos_TP);
//                         if (am.result)
//                            am.pos_modified++;
//                         else
//                            Logging("Failed to modify position Ticket#: "+IntegerToString(pos_ticket)+" to updating Stop Loss to "+DoubleToString(pos_newSL,am.digits)+
//                                  ". Error: "+IntegerToString(GetLastError()));
//                      }
//                   }
//                   else if (trade.ideaType == "SELL" && pos_type == "SELL")
//                   {
//                      if (pos_SL != pos_newSL || pos_SL == 0.0) {
//                         am.result = Trade.PositionModify(pos_ticket, pos_newSL, pos_TP);
//                         if (am.result)
//                            am.pos_modified++;
//                         else
//                            Logging("Failed to modify position Ticket#: "+IntegerToString(pos_ticket)+" to updating Stop Loss to "+DoubleToString(pos_newSL,am.digits)+
//                                  ". Error: "+IntegerToString(GetLastError()));
//                      }
//                   }
//                }
//             }
//          }
//       }
//       if (am.pos_modified > 0)
//          Logging("Total positions modified with new SL "+DoubleToString(pos_newSL,am.digits)+" is "+IntegerToString(am.pos_modified)+" for idea "+am.idea_name+".");
//       // new_SL = 0.0;
//    }
//    // new_SL = 0.0;
//    //---
//    if (am.is_triggered) {
//       double pos_newSL = 0.0;
//       bool triggered = false;
//       Sleep(1000);
//       for (p = m_pos_total - 1; p >= 0; p--)
//       {
//          ulong pos_ticket = PositionGetTicket(p);
//          if(!PositionSelectByTicket(pos_ticket)) continue;
//          //---
//          string pos_type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? "BUY" : "SELL");
//          string pos_symbol = PositionGetString(POSITION_SYMBOL);
//          string direction = (pos_type == "BUY") ? "LONG" : "SHORT";
//          string base = StringSubstr(pos_symbol, 0, 3);
//          string quote = StringSubstr(pos_symbol, 3, 1);
//          string pos_name = direction + "::" + base;
//          if (StringToLower(quote))
//             pos_name += quote;
//          //---
//          if (idea_total == 0) return;
//          //---
//          for (i = 0; i < idea_total; i++)
//          {
//             CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
//             if (trade == NULL) continue;
//             //---
//             am.trade_PnL = trade.ideaFloatPnL;
//             am.trade_pips = trade.ideaFloatPips;
//             am.trade_change = trade.ideaChange;
//             //---
//             // if (inpTrailingType==BY_PIPS) {
//             //    triggered = trade_pips >= inpTrailingStart;
//             // } else if (inpTrailingType==BY_PERCENTAGE) {
//             //    triggered = trade_change >= inpTrailingStart;
//             // } else {
//             //    triggered = trade_PnL >= inpTrailingStart;
//             // }
//             //---
//             if (trade.ideaName == pos_name && am.is_triggered && trade.ideaTrailingStopEnabled)
//             {
//                am.digits = (int)SymbolInfoInteger(pos_symbol, SYMBOL_DIGITS);
//                double pos_tick_value = SymbolInfoDouble(pos_symbol, SYMBOL_TRADE_TICK_VALUE);
//                double pos_tick_size = SymbolInfoDouble(pos_symbol, SYMBOL_TRADE_TICK_SIZE);
//                double pos_SL = PositionGetDouble(POSITION_SL);
//                double pos_TP = PositionGetDouble(POSITION_TP);
//                //---
//                int x = (trade.ideaType == "BUY") ? trade.ideaBuyTotal : trade.ideaSellTotal;
//                //---
//                trade.ideaTrailingCoverage = (inpTrailingCoverage/100.0)*trade.ideaFloatPnL;
//                // profit_threshold /= 2.0;
//                trade.ideaTrailingCoverage = (trade.ideaTrailingCoverage*pos_tick_size)/pos_tick_value;
//                //---
//                trade.ideaStopLoss = (trade.ideaType == "BUY" && pos_type == "BUY") ?
//                                     (trade.ideaPriceWeighted + trade.ideaTrailingCoverage) / trade.ideaVolume :
//                                     (trade.ideaPriceWeighted - trade.ideaTrailingCoverage) / trade.ideaVolume;
//                //---
//                trade.ideaStopLoss = (pos_type == "BUY") ?
//                                     pos_SL > trade.ideaStopLoss ? pos_SL : trade.ideaStopLoss :
//                                     pos_SL < trade.ideaStopLoss ? pos_SL : trade.ideaStopLoss;
//                //---
//                pos_newSL = NormalizeDouble(trade.ideaStopLoss, am.digits);
//                //---
//                if (pos_SL == pos_newSL) continue;
//                //---
//                if (trade.ideaType == "BUY" && pos_type == "BUY")
//                {
//                   if (pos_SL < pos_newSL || pos_SL == 0.0) {
//                      //---
//                      am.result = Trade.PositionModify(pos_ticket, pos_newSL, pos_TP);
//                      if (am.result)
//                         am.pos_modified++;
//                      else
//                         Logging("Failed to modify position Ticket#: "+IntegerToString(pos_ticket)+" to updating Stop Loss to "+DoubleToString(pos_newSL,am.digits)+
//                               ". Error: "+IntegerToString(GetLastError()));
//                   }
//                }
//                else if (trade.ideaType == "SELL" && pos_type == "SELL")
//                {
//                   if (pos_SL > pos_newSL || pos_SL == 0.0) {
//                      //---
//                      am.result = Trade.PositionModify(pos_ticket, pos_newSL, pos_TP);
//                      if (am.result)
//                         am.pos_modified++;
//                      else
//                         Logging("Failed to modify position Ticket#: "+IntegerToString(pos_ticket)+" to updating Stop Loss to "+DoubleToString(pos_newSL,am.digits)+
//                               ". Error: "+IntegerToString(GetLastError()));
//                   }
//                }
//             }
//          }
//       }
//       if (am.pos_modified > 0)
//          // Logging("Total positions modified with new SL "+DoubleToString(pos_newSL,digits)+" is "+IntegerToString(pos_modified)+" for idea "+idea_name+".");
//          Logging("Trailing updated to :"+DoubleToString(pos_newSL,am.digits)+" for idea "+am.idea_name+".");
//    }
//    if (am.daily_target_reached) {
//       double new_vol = 0.0;
//       for (p = m_pos_total - 1; p >= 0; p--)
//       {
//          ulong pos_ticket = PositionGetTicket(p);
//          if(!PositionSelectByTicket(pos_ticket)) continue;
//          //---
//          string pos_type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? "BUY" : "SELL");
//          string pos_symbol = PositionGetString(POSITION_SYMBOL);
//          string direction = (pos_type == "BUY") ? "LONG" : "SHORT";
//          string base = StringSubstr(pos_symbol, 0, 3);
//          string quote = StringSubstr(pos_symbol, 3, 1);
//          string pos_name = direction + "::" + base;
//          if (StringToLower(quote))
//             pos_name += quote;
//          //---
//          if (idea_total == 0) return;
//          //---
//          for (i = 0; i < idea_total; i++)
//          {
//             CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
//             if (trade == NULL) continue;
//             if (trade.ideaName == pos_name && am.daily_target_reached) {
//                //---
//                am.digits = (int)SymbolInfoInteger(pos_symbol, SYMBOL_DIGITS);
//                double pos_tp = PositionGetDouble(POSITION_TP);
//                double pos_volume = PositionGetDouble(POSITION_VOLUME);
//                new_vol = pos_volume / 2.0;
//                new_vol = NormalizeDouble(new_vol, am.digits);
//                //---
//                if (pos_tp != 0.0) continue;
//                //---
//                am.result = Trade.PositionClosePartial(pos_ticket, new_vol);
//                if (am.result)
//                   am.pos_modified++;
//                else
//                   Logging("Failed to partially close position Ticket#: "+IntegerToString(pos_ticket)+" to volume "+DoubleToString(new_vol,am.digits)+
//                         ". Error: "+IntegerToString(GetLastError()));
//                //---
//                break;
//             }
//          }
//       }
//       if (am.pos_modified > 0)
//          Logging("Total positions partially closed to volume "+DoubleToString(new_vol,am.digits)+" is "+IntegerToString(am.pos_modified)+" for idea "+am.idea_name+" as daily target reached.");
//    }
//    //--- Calculating total Risk by Trade Ideas
//    if (m_pos_total > 0) {
//       am.totalPercentToRiskRule = 0.0;
//       for (i = 0; i < idea_total; i++)
//       {
//          CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
//          if (trade == NULL) continue;
//          //---
//          am.totalPercentToRiskRule += trade.ideaRiskPercent;
//       }
//    } else {
//       am.totalPercentToRiskRule = 0.0;
//    }
//    m_stop_loss = 0.0;
// }
void CAccountManager::OnTradeIdeas(void)
{
   int i;
   int idea_total = IdeaList.Total();
   //---
   am.OnTradeIdeasInit();
   //---
   for (i = 0; i < idea_total; i++)
   {
      CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
      if (trade == NULL) continue;
      if (trade.ideaName == am.name && trade.ideaSymbol == am.symbol) {
         if (am.type == "BUY")
            trade.ideaBuyTotal += 1;
         else
            trade.ideaSellTotal += 1;
         //---
         trade.ideaPriceWeighted += am.op_price_weighted;
         trade.ideaVolume += am.volume;
         trade.ideaFloatPnL += am.float_PnL;
         trade.ideaFloatPips += am.float_pips;
         trade.ideaChange += am.change;
         //---
         if(trade.ideaTrailingStopEnable && !am.is_triggered)
         {
            if (trade.ideaTrailingType==BY_PIPS) {
               am.is_triggered = am.trade_pips >= trade.ideaTrailingStart;
            } else if (trade.ideaTrailingType==BY_PERCENTAGE) {
               am.is_triggered = am.trade_change >= trade.ideaTrailingStart;
            } else {
               am.is_triggered = am.trade_PnL >= trade.ideaTrailingStart;
            }
         }
         else
            am.is_triggered = false;
         // if(trailing_triggered)
         //    Print("Trailing Triggered!");
         //---
         if (am.trade_PnL >= (inpDailyTarget*2) && !am.daily_target_reached)
            am.daily_target_reached = true;     // To Do: Implement Trading Ideas Conditions with enum
         //---
         if (trade.ideaStopLoss != am.stop_loss) {
            trade.ideaStopLoss = am.stop_loss;
            // trade.ideaWithSL = 1;
            // trade.ideaRisk = am.riskInMoney;
            // trade.ideaRiskPercent = am.percentToRiskRule;
            // //---
            // am.diff_weighted_1 = MathAbs(am.op_price_weighted - am.sl_price_weighted);
            // am.diff_weighted_2 = MathAbs(am.cu_price_weighted - am.sl_price_weighted);
            // trade.ideaPercentToSL = (am.diff_weighted_1 - am.diff_weighted_2) / am.diff_weighted_1 * 100.0; 
            //---
            am.trade_with_SL = true;
         }
         //---
         if (am.stop_loss != 0.0 && trade.ideaStopLoss == am.stop_loss) {
            trade.ideaWithSL += 1;
            trade.ideaRisk += am.riskInMoney;
            trade.ideaRiskPercent += am.percentToRiskRule;
            //---
            am.diff_weighted_1 += MathAbs(am.op_price_weighted - am.sl_price_weighted);
            am.diff_weighted_2 += MathAbs(am.cu_price_weighted - am.sl_price_weighted);
            trade.ideaPercentToSL = (am.diff_weighted_1 - am.diff_weighted_2) / am.diff_weighted_1 * 100.0; 
         }
         //---
         if (am.take_profit != 0.0) {
            trade.ideaWithTP += 1;
            trade.ideaReward += am.reward;
            trade.ideaRewardPips += am.reward_pips;
         }
         //---
         am.is_found = true;
         break;
      }
   }
   //---
   if(!am.is_found)
   {
      CTradeIdeas *new_idea = new CTradeIdeas();
      new_idea.ideaSymbol = am.symbol;
      new_idea.ideaType = am.type;
      new_idea.ideaName = am.name;
      if (am.type == "BUY")
         new_idea.ideaBuyTotal = 1;
      else
         new_idea.ideaSellTotal = 1;
      //---
      new_idea.ideaPriceWeighted = am.op_price_weighted;
      new_idea.ideaVolume = am.volume;
      new_idea.ideaFloatPnL = am.float_PnL;
      new_idea.ideaFloatPips = am.float_pips;
      //---
      new_idea.ideaChange = am.change;
      //---
      if (am.stop_loss != 0.0) {
         new_idea.ideaStopLoss = am.stop_loss;
         new_idea.ideaWithSL = 1;
         new_idea.ideaRisk = am.riskInMoney;
         new_idea.ideaRiskPercent = am.percentToRiskRule;
         //---
         am.diff_weighted_1 = MathAbs(am.op_price_weighted - am.sl_price_weighted);
         am.diff_weighted_2 = MathAbs(am.cu_price_weighted - am.sl_price_weighted);
         new_idea.ideaPercentToSL = (am.diff_weighted_1 - am.diff_weighted_2) / am.diff_weighted_1 * 100.0;
         //---
         am.trade_with_SL = true;
      }
      //---
      if (am.take_profit != 0.0) {
         new_idea.ideaWithTP = 1;
         new_idea.ideaReward = am.reward;
         new_idea.ideaRewardPips = am.reward_pips;
      }
      //---
      IdeaList.Add(new_idea); 
   }
   OnTradeCheck();
}
//+------------------------------------------------------------------+
//| Method OnTradeCheck
//+------------------------------------------------------------------+
void CAccountManager::OnTradeCheck(void)
{
   MqlTradeCheckResult check;
   Trade.CheckResult(check);
   //---
   if(check.retcode==TRADE_RETCODE_MARKET_CLOSED)
      return;
   //---
   int p,i;
   int idea_total = IdeaList.Total();
   int pos_modified = 0;
   //---
   if (am.trade_with_SL) { 
      double pos_newSL = 0.0;
      Sleep(1000);
      for (p = m_pos_total - 1; p >= 0; p--)
      {
         ulong pos_ticket = PositionGetTicket(p);
         if(!PositionSelectByTicket(pos_ticket)) continue;
         //---
         string pos_type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? "BUY" : "SELL");
         string pos_symbol = PositionGetString(POSITION_SYMBOL);
         string direction = (pos_type == "BUY") ? "LONG" : "SHORT";
         string base = StringSubstr(pos_symbol, 0, 3);
         string quote = StringSubstr(pos_symbol, 3, 1);
         string pos_name = direction + "::" + base;
         if (StringToLower(quote))
            pos_name += quote;
         //---
         if (idea_total == 0) return;
         //---
         for (i = 0; i < idea_total; i++)
         {
            CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
            if (trade == NULL) continue;
            if (trade.ideaName == pos_name && am.trade_with_SL) {
               //---
               am.digits = (int)SymbolInfoInteger(pos_symbol, SYMBOL_DIGITS);
               double pos_SL = PositionGetDouble(POSITION_SL);
               double pos_TP = PositionGetDouble(POSITION_TP);
               pos_newSL = NormalizeDouble(trade.ideaStopLoss, am.digits);
               //---
               if (pos_SL == pos_newSL) continue;
               //---
               if (trade.ideaWithSL >= 1) {
                  if (trade.ideaType == "BUY" && pos_type == "BUY")
                  {
                     if (pos_SL != pos_newSL || pos_SL == 0.0) {
                        am.result = Trade.PositionModify(pos_ticket, pos_newSL, pos_TP);
                        if (am.result)
                           pos_modified++;
                        else
                           Logging("Failed to modify position Ticket#: "+IntegerToString(pos_ticket)+" to updating Stop Loss to "+DoubleToString(pos_newSL,am.digits)+
                                 ". Error: "+IntegerToString(GetLastError()));
                     }
                  }
                  else if (trade.ideaType == "SELL" && pos_type == "SELL")
                  {
                     if (pos_SL != pos_newSL || pos_SL == 0.0) {
                        am.result = Trade.PositionModify(pos_ticket, pos_newSL, pos_TP);
                        if (am.result)
                           pos_modified++;
                        else
                           Logging("Failed to modify position Ticket#: "+IntegerToString(pos_ticket)+" to updating Stop Loss to "+DoubleToString(pos_newSL,am.digits)+
                                 ". Error: "+IntegerToString(GetLastError()));
                     }
                  }
               }
            }
         }
      }
      if (pos_modified > 0)
         Logging("Total positions modified with new SL "+DoubleToString(am.stop_loss,am.digits)+" is "+IntegerToString(pos_modified)+".");
   }
   else if(am.is_triggered) {
      // To Do: Implement Trailing Stop Logic
   }
   else if (am.daily_target_reached) {
      double new_vol = 0.0;
      for (p = m_pos_total - 1; p >= 0; p--)
      {
         ulong pos_ticket = PositionGetTicket(p);
         if(!PositionSelectByTicket(pos_ticket)) continue;
         //---
         string pos_type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? "BUY" : "SELL");
         string pos_symbol = PositionGetString(POSITION_SYMBOL);
         string direction = (pos_type == "BUY") ? "LONG" : "SHORT";
         string base = StringSubstr(pos_symbol, 0, 3);
         string quote = StringSubstr(pos_symbol, 3, 1);
         string pos_name = direction + "::" + base;
         if (StringToLower(quote))
            pos_name += quote;
         //---
         if (idea_total == 0) return;
         //---
         for (i = 0; i < idea_total; i++)
         {
            CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
            if (trade == NULL) continue;
            if (trade.ideaName == pos_name && am.daily_target_reached) {
               //---
               am.digits = (int)SymbolInfoInteger(pos_symbol, SYMBOL_DIGITS);
               double pos_tp = PositionGetDouble(POSITION_TP);
               double pos_volume = PositionGetDouble(POSITION_VOLUME);
               new_vol = pos_volume / 2.0;
               new_vol = NormalizeDouble(new_vol, am.digits);
               //---
               if (pos_tp != 0.0) continue;
               //---
               am.result = Trade.PositionClosePartial(pos_ticket, new_vol);
               if (am.result)
                  am.pos_modified++;
               else
                  Logging("Failed to partially close position Ticket#: "+IntegerToString(pos_ticket)+" to volume "+DoubleToString(new_vol,am.digits)+
                        ". Error: "+IntegerToString(GetLastError()));
               //---
               break;
            }
         }
      }
      if (pos_modified > 0)
         Logging("Total positions partially closed to volume "+DoubleToString(am.volume,am.digits)+" is "+IntegerToString(pos_modified)+".");
   }
   //--- Calculating total Risk by Trade Ideas
   if (m_pos_total > 0) {
      am.totalPercentToRiskRule = 0.0;
      for (i = 0; i < idea_total; i++)
      {
         CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
         if (trade == NULL) continue;
         //---
         am.totalPercentToRiskRule += trade.ideaRiskPercent;
      }
   } else {
      am.totalPercentToRiskRule = 0.0;
   }
}
//+------------------------------------------------------------------+
//| Method OnTradeWithTP
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Method OnTradePositionModify
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Method OnTradePositionClose
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Method OnTradePositionClosePartial
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Method InfoToChart                                               |
//+------------------------------------------------------------------+
void CAccountManager::InfoToChart(void)
{
   //#region Lower Labels Info

   //--- % to Daily Loss
   m_lower_label_info[0].Description(DoubleToString(am.DailyRemainingPercent(), 2) + " %");
   //--- % to Target Profit
   m_lower_label_info[1].Description((am.NoProfitTarget) ? DoubleToString(am.PipsTargetBySymbol(), 0) : DoubleToString(am.ProfitRemainingPercent(), 2)+" %");
   //--- Today's Net PnL
   m_lower_label_info[2].Description((AccountInfoDouble(ACCOUNT_BALANCE) == am.initialBalance) ? DoubleToString(am.ClosedPL(), 2) : DoubleToString(am.DailyNetPL(), 2));
   //--- Utilize Rate
   m_lower_label_info[3].Description(DoubleToString(am.UtilizeRate(), 2)+" %");
   //--- Max Utilize Rate
   m_lower_label_info[4].Description(DoubleToString(am.maxUtilizeRate, 2)+" %");
   //--- Max Utilize Rate Pts
   m_lower_label_info[5].Description(IntegerToString(am.MaxUtilizeRatePoint()));
   //--- Risk Ratio
   m_lower_label_info[6].Description(DoubleToString(am.RiskRatio(), 0));
   //--- Daily Remaining
   m_lower_label_info[7].Description(DoubleToString(am.DailyRemaining(), 2));
   //--- Max Remaining
   m_lower_label_info[8].Description(DoubleToString(am.MaxRemaining(), 2));
   //--- Profitability
   m_lower_label_info[9].Description(DoubleToString(am.Profitability(), 2)+" %");
   //--- Drawdown
   m_lower_label_info[10].Description(DoubleToString(am.Drawdown(), 2)+" %");
   //--- Max Drawdown
   m_lower_label_info[11].Description(DoubleToString(am.maxDrawdown, 2)+" %");
   //--- Max Drawdown Pts
   m_lower_label_info[12].Description(IntegerToString(am.MaxDrawdownPoint()));
   //--- Trade Rating
   m_lower_label_info[13].Description(DoubleToString(am.TradeRating(), 2)+" %");
   //#endregion
   //#region Upper Labels Info

   //--- Fund Process
   // m_upper_left_label_info[1].Description(stats.FundProcess);
   m_upper_label_info[1].Description(am.PackageName);
   //--- Package Name
   // m_upper_left_label_info[2].Description(stats.PackageName);
   m_upper_label_info[2].Description(am.FundProcess);
   //--- Fund Amount
   m_upper_label_info[3].Description("$"+DoubleToString(am.initialBalance, 2));
   //--- Scale Up Plan
   // m_upper_left_label_info[4].Description((stats.ScaleUpPlan) ? "Yes" : "No");
   m_upper_label_info[4].Description((am.ScaleUpPlan) ? "Yes" : "Prohibited");
   //--- Daily Loss %
   m_upper_label_info[5].Description(DoubleToString(am.DailyPercent, 0)+" %  ($"+DoubleToString(am.dailyLoss, 0)+")");
   //--- Max Loss %
   m_upper_label_info[6].Description(DoubleToString(am.MaxPercent, 0)+" %  ($"+DoubleToString(am.maxLoss, 0)+")");
   //--- Target Profit %
   m_upper_label_info[7].Description((am.NoProfitTarget) ? "No Profit Target" : DoubleToString(am.TargetPercent, 0) + " %  ($"+DoubleToString(am.MinProfitTarget(), 0)+")");
   //--- Daily Loss Limit
   m_upper_label_info[8].Description((am.totalDaysTraded == 0) ? "$"+DoubleToString(am.DailyLossLimit(), 2) : "$"+DoubleToString(am.dailyLossLimit, 2));
   //--- Max Loss Limit
   m_upper_label_info[9].Description("$"+DoubleToString(am.maxLossLimit, 2));
   //--- Target Profit Left
   m_upper_label_info[10].Description("$"+DoubleToString(am.ProfitRemain(), 2));
   //--- Risk Rule
   m_upper_label_info[11].Description((am.RiskConsistencyRule) ? "Yes" : "No");
   //--- Risk Rule %
   m_upper_label_info[12].Description((am.RiskConsistencyRule) ? DoubleToString(am.RiskConsistencyRulePercent, 0) + " %  ($"+DoubleToString(am.riskRuleInMoney, 0)+")" : "N/A");
   //--- % to Risk Rule
   m_upper_label_info[13].Description((am.RiskConsistencyRule) ? DoubleToString(am.totalPercentToRiskRule, 2)+" %" : "N/A");
   //--- Profit Rule
   m_upper_label_info[14].Description((am.ProfitConsistencyRule) ? "Yes" : "No");
   //--- Profit Rule %
   m_upper_label_info[15].Description((am.ProfitConsistencyRule) ? DoubleToString(am.ProfitConsistencyPercent(), 2)+" %" : "N/A");
   //--- Loss Breached
   m_upper_label_info[16].Description((am.DailyLossBased) ? "Yes" : "N/A");
   //--- Loss Breached %
   m_upper_label_info[17].Description((am.DailyLossBased) ? DoubleToString(am.DailyLossBreachedPercent, 2) : "N/A"); 
   //--- Profit Share %
   // m_upper_left_label_info[18].Description((stats.sharePercent > 0) ? DoubleToString(stats.ProfitSharePercent(),0) + " %  ($"+DoubleToString(stats.ProfitShare(),2)+")" : "Not Eligible Yet");
   m_upper_label_info[18].Description("N/A");
   //--- Days Traded
   m_upper_label_info[19].Description((am.totalDaysTraded == 0) ? "First Day Trade" : IntegerToString(am.totalDaysTraded));
   //--- Win / Loss
   m_upper_label_info[20].Description(IntegerToString(am.winTrades) + " / " + IntegerToString(am.lossTrades));
   //--- Best Daily P/L
   m_upper_label_info[21].Description("$"+DoubleToString(am.bestDailyNetPL, 2));
   //--- Total Daily P/L
   m_upper_label_info[22].Description("$"+DoubleToString(am.totalDailyNetPL, 2));
   //--- Today's Target 
   m_upper_label_info[23].Description("$"+DoubleToString(am.TodayTarget(), 2));
   //--- Trades to 10%
   m_upper_label_info[24].Description(IntegerToString(am.TradesToPercentage()) + "  ($" + DoubleToString(am.ProfitTargetPerTrade(),0) + " / Trade)");
   //--- Days to 10%
   m_upper_label_info[25].Description(IntegerToString(am.DaysToPercentage()) + "  ($" + DoubleToString(inpDailyTarget,0) + " / Day)");
   //--- TEST
   m_upper_label_info[26].Description((m_DailyTimerSet) ? "$"+DoubleToString(am.todayTarget, 2) : "$"+DoubleToString(am.TodayTarget(), 2));
   //#endregion
   //#region Idea Labels Info
   int ideas_total = IdeaList.Total();
   for (int i = 0; i < ideas_total; i++)
   {
      CTradeIdeas *trade=(CTradeIdeas*)IdeaList.At(i);
      if (trade != NULL) {
         //---
         int digits = (int)SymbolInfoInteger(trade.ideaSymbol, SYMBOL_DIGITS);
         // trade.ideaTrailingStopEnable = ExtDialog.SetIdeaTrailing(i);
         // trade.ideaCPartialEnable = ExtDialog.SetIdeaClosePartial(i);
         // trade.ideaCPartialOnTPEnable = ExtDialog.SetIdeaCPartialOnTP(i);
         string trailingStop = (trade.ideaTrailingStopEnable == false) ? "ON" : "TRIGGERED";
         //--- Idea Name
         m_idea_label_info[1][i].Description(trade.ideaName);
         //--- Total Trades
         m_idea_label_info[2][i].Description((trade.ideaType == "BUY") ? IntegerToString(trade.ideaBuyTotal) : IntegerToString(trade.ideaSellTotal));
         //--- Volume Size
         m_idea_label_info[3][i].Description(DoubleToString(trade.ideaVolume, 2));
         //--- Stop Loss
         m_idea_label_info[4][i].Description((trade.ideaStopLoss == 0) ? "Set SL first!" : DoubleToString(trade.ideaStopLoss, digits));
         //--- Trades with SL
         m_idea_label_info[5][i].Description((trade.ideaWithSL==0) ? "Set SL first!" : IntegerToString(trade.ideaWithSL));
         //--- SL Hit in $
         if (trade.ideaTrailingStopEnable == true) {
            m_idea_label[6].Description("Trailing Hit in $");
            m_idea_label_info[6][i].Description(DoubleToString(trade.ideaRisk, 2));
         }
         else {
            m_idea_label_info[6][i].Description((trade.ideaStopLoss == 0) ? "Set SL first!" : DoubleToString(trade.ideaRisk, 2));
         }
         //--- % to Stop Loss
         // if (trade.ideaTrailingStopEnabled == true) {
         //    m_idea_label_info[7][i].Description((trade.ideaPercentToSL<0.0) ? "IN PROFIT" :);
         // }
         m_idea_label_info[7][i].Description((trade.ideaStopLoss == 0) ? "Set SL first!" :
                                             (trade.ideaPercentToSL<0.0 || trade.ideaRisk>0) ? "IN PROFIT" : DoubleToString(trade.ideaPercentToSL, 2) + " %");
         //--- % to Risk Rule
         m_idea_label_info[8][i].Description((trade.ideaStopLoss == 0) ? "Set SL first!" :
                                             (trade.ideaRiskPercent==0.0) ? "SECURED" : DoubleToString(trade.ideaRiskPercent, 2) + " %");
         //--- Trades with TP
         m_idea_label_info[9][i].Description((trade.ideaWithTP==0) ? "Set TP first!" : IntegerToString(trade.ideaWithTP));
         //--- TP Hit in $
         m_idea_label_info[10][i].Description((trade.ideaWithTP==0) ? "Set TP first!" : DoubleToString(trade.ideaReward, 2));
         //--- TP Hit in Pips
         m_idea_label_info[11][i].Description((trade.ideaWithTP==0) ? "Set TP first!" : DoubleToString(trade.ideaRewardPips, 0));
         //--- Pip Value
         m_idea_label_info[12][i].Description(DoubleToString(am.PipValue(trade.ideaSymbol), 5));
         //--- Pips Running
         m_idea_label_info[13][i].Description(DoubleToString(trade.ideaFloatPips, 0));
         //--- Current Price
         m_idea_label_info[14][i].Description((trade.ideaType == "BUY") ? DoubleToString(SymbolInfoDouble(trade.ideaSymbol, SYMBOL_BID), digits) : DoubleToString(SymbolInfoDouble(trade.ideaSymbol, SYMBOL_ASK), digits));
         //--- Change %
         m_idea_label_info[15][i].Description(DoubleToString(trade.ideaChange, 2)+" %");
         //--- PnL
         m_idea_label_info[16][i].Description(DoubleToString(trade.ideaFloatPnL, 2));
         //--- Profitability %
         m_idea_label_info[17][i].Description(DoubleToString(trade.IdeaProfitability(), 2)+" %");
         //--- Break Even
         // m_idea_label_info[18][i].Description(breakEven);
         //--- BE Start in %
         // m_idea_label_info[19][i].Description(DoubleToString(stats.BE_start, 2)+" %");
         //--- Trailing SL
         m_idea_label_info[18][i].Description((trade.ideaTrailingStopEnable) ? "ON" : "OFF");
         //--- TSL Start in $
         m_idea_label_info[19][i].Description(DoubleToString(trade.ideaTrailingStart, 2));
         //--- Idea TSL Coverage
         m_idea_label_info[20][i].Description(DoubleToString(trade.ideaTrailingCoverage, 2));
         //--- Close Partial Pos.
         m_idea_label_info[21][i].Description((trade.ideaCPartialEnable) ? "ON" : "OFF");
         //--- CP Start in $
         m_idea_label_info[22][i].Description(DoubleToString(trade.ideaCPartialStart,2));      // 
         //--- % Sizes Close
         m_idea_label_info[23][i].Description(DoubleToString(trade.ideaCPartialVol,2));       // 
         //--- Include TP Pos
         m_idea_label_info[24][i].Description((trade.ideaCPartialOnTPEnable) ? "YES" : "NO");
         //--- Check State
         m_idea_label_info[25][i].Description(IntegerToString(i));

         // //--- Idea Maximal Peak
         // m_idea_label_info[22][i].Description(DoubleToString(trade.ideaMaximalPeak, 2));
         // //--- Idea Next Minimal Peak
         // m_idea_label_info[23][i].Description(DoubleToString(trade.ideaNextMinimalPeak, 2));
         // //--- Idea Drawdown
         // m_idea_label_info[24][i].Description(DoubleToString(trade.IdeaDrawdown(), 2));
         //--- Idea Max Drawdown
         // m_idea_label_info[25][i].Description(DoubleToString(trade.IdeaDrawdown(), 2));
      }
   }
   //#endregion
}
//+------------------------------------------------------------------+
//| Method TradeIdeaRefresh                                          |
//+------------------------------------------------------------------+
void CAccountManager::TradeIdeaRefresh(void)
{
   int idea_total = IdeaList.Total();
   for (int i = 0; i < idea_total; i++)
   {
      CTradeIdeas *trade=TradeIdea(i);
      if (trade == NULL)
         continue;
      //---
      trade.IdeaRefresh();
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void CAccountManager::ExpertMoneyAction(SAccountManager &stats)
{

}
//+------------------------------------------------------------------+
//| Method ModifyPosition                                            |
//+------------------------------------------------------------------+
// void CAccountManager::ModifyPosition(const ulong ticket, double new_sl, double new_tp, string symbol, string trade_name)
// {
//    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
//    //---
//    // CTrade *Trade;
//    // Trade = new CTrade();
//    //---
//    // if (m_TrailingEnabled)
//    //    Logging("TRAILING STOP TRIGGERED!");
//    // else
//    //    Logging("BREAKEVEN TRIGGERED!");
//    //---
//    for (int i = 1; i <= m_OrderOpRetry; i++) // Several attempts to modify the position.
//    {
//       bool result = Trade.PositionModify(ticket, new_sl, new_tp);
//       if (result) {
//          Logging("Position Ticket#: "+IntegerToString(ticket)+" modified successfully. New SL: "+DoubleToString(new_sl, digits)+". Trade Idea: "+trade_name+".");
//          break;
//       }
//       else {
//          int Error = GetLastError();
//          string ErrorText = ErrorDescription(Error);
//          Logging("Failed to modify Position Ticket#: "+IntegerToString(ticket)+
//                 ". Attempt: "+IntegerToString(i)+" of "+IntegerToString(m_OrderOpRetry));
//          Logging("Error: "+IntegerToString(Error)+" - "+ErrorText);
//          Sleep(500);
//       }
//    }
//    //---
//    // m_TrailingEnabled = false;
//    // delete Trade;
// }
//+------------------------------------------------------------------+
//| Method ClosePartialPosition                                      |
//+------------------------------------------------------------------+
// void CAccountManager::ClosePartialPosition(const ulong ticket, const double volume_to_close, string symbol, string trade_name)
// {
//    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
//    //---
//    // CTrade *Trade;
//    // Trade = new CTrade();
//    //---
//    for (int i = 1; i <= m_OrderOpRetry; i++) // Several attempts to close the position partially.
//    {
//       bool result = Trade.PositionClosePartial(ticket, volume_to_close);
//       if (result) {
//          Logging("Position Ticket#: "+IntegerToString(ticket)+" closed partially successfully. Volume closed: "+DoubleToString(volume_to_close, digits)+". Trade Idea: "+trade_name+".");
//          break;
//       }
//       else {
//          int Error = GetLastError();
//          string ErrorText = ErrorDescription(Error);
//          Logging("Failed to close partially Position Ticket#: "+IntegerToString(ticket)+
//                 ". Attempt: "+IntegerToString(i)+" of "+IntegerToString(m_OrderOpRetry));
//          Logging("Error: "+IntegerToString(Error)+" - "+ErrorText);
//          Sleep(500);
//       }
//    }
//    //---
//    // delete Trade;
// }
//=========================== GETTER =================================
//+------------------------------------------------------------------+
//| Method CurrentDate                                               |
//+------------------------------------------------------------------+
// bool CAccountManager::CurrentDate(void)
// {
//    if (m_current_date != m_today_date)
//    {
//       m_current_date = m_today_date;
//       //---
//       if (m_IsFirstRun)
//          SaveToDisk(m_current_date);
//       //---
//       return true;
//    }
//    else
//       return false;
// }
//+------------------------------------------------------------------+
//| Method MaxUtilizationRate                                        |
//+------------------------------------------------------------------+
double CAccountManager::MaxUtilizationRate(void)
{
   double max_util_rate = -DBL_MAX;
   for (int i = 0; i < ArraySize(m_utilize_rate); i++)
      if (m_utilize_rate[i] > max_util_rate)
         max_util_rate = m_utilize_rate[i];
   //---
   return (max_util_rate);
}
//+------------------------------------------------------------------+
//| Method MaxProfitability                                          |
//+------------------------------------------------------------------+
double CAccountManager::MaxProfitability(void)
{
   double max_profitability = -DBL_MAX;
   for (int i = 0; i < ArraySize(m_profitability); i++)
      if (m_profitability[i] > max_profitability)
         max_profitability = m_profitability[i];
   //---
   return (max_profitability);
}
//+------------------------------------------------------------------+
//| Method MaxDrawdown                                               |
//+------------------------------------------------------------------+
double CAccountManager::MaxDrawdown(void)
{
   double max_drawdown = -DBL_MAX;
   for (int i = 0; i < ArraySize(m_drawdown); i++)
      if (m_drawdown[i] > max_drawdown)
         max_drawdown = m_drawdown[i];
   //---
   return (max_drawdown);
}
//+------------------------------------------------------------------+
//| Method HighestDailyNetPnL                                        |
//+------------------------------------------------------------------+
double CAccountManager::HighestDailyNetPnL(void)
{
   double highestDailyNetPL = -DBL_MAX;
   for (int i = 0; i < ArraySize(m_dailyNetPnL); i++)
      if (m_dailyNetPnL[i] > highestDailyNetPL)
         highestDailyNetPL = m_dailyNetPnL[i];
   //---
   return highestDailyNetPL;
}
//+------------------------------------------------------------------+
//| Method TotalDailyNetPnL                                          |
//+------------------------------------------------------------------+
double CAccountManager::TotalDailyNetPnL(void)
{
   double sumDailyNetPL = 0.0;
   for (int i = 0; i < ArraySize(m_dailyNetPnL); i++)
      sumDailyNetPL += m_dailyNetPnL[i];
   //---
   return sumDailyNetPL;
}
//+------------------------------------------------------------------+
