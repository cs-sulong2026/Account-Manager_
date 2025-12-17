//+------------------------------------------------------------------+
//|                                            AM_ControlsDialog.mqh |
//|                                 Copyright 2025, Cheruhaya Sulong |
//|                           https://www.mql5.com/en/users/cssulong |
//| 09.12.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cheruhaya Sulong"
#property link      "https://www.mql5.com/en/users/cssulong"
#include <Trade/SymbolInfo.mqh>
#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Edit.mqh>
#include <Controls/SpinEdit.mqh>
#include <Controls/ComboBox.mqh>
#include <Controls/RadioGroup.mqh>
#include <Controls/Button.mqh>
// For Internal Use
// #include <AM_Defines.mqh>
// For VPS Use
#include "AM_Defines.mqh"
#include "AM_SpinEdit.mqh"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

//#region Control Sizes and Positions
#define IS_EXIST                             (m_idea_exist==true)
//--- indents and gaps
#define INDENT_LEFT                         (10)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (10)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (10)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (10)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (15)       // gap by X coordinate
#define CONTROLS_GAP_Y                      (10)      // gap by Y coordinate
#define CONTROL_WIDTH                       (130)     // size by X coordinate
#define LABEL_WIDTH                         (130)     // size by X coordinate
#define LABEL_HEIGHT                        (20)      // size by Y coordinate 
//--- for buttons
#define BUTTON_WIDTH                        (130)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate
//--- for the indication area
#define EDIT_HEIGHT                         (20)      // size by Y coordinate
#define COMBO_HEIGHT                        (20)      // size by Y coordinate
//--- for group controls
#define RADIO_HEIGHT                        (58)      // size by Y coordinate
//#endregion

//+------------------------------------------------------------------+
//| Class CAM_ControlsDialog                                         |
//| Usage: main dialog of the AM_ControlBox application              |
//+------------------------------------------------------------------+
class CAM_ControlsDialog : public CAppDialog
{
//#region Protected instance
protected:
   //--- dependent controls
   CLabel            m_ideaName_label;                // the label object
   CLabel            m_trailingSection_label;         // the label object
   CLabel            m_trailingSL_label;              // the label object
   CLabel            m_trailingType_label;            // the label object
   CLabel            m_trailingStart_label;           // the label object
   CLabel            m_trailingStep_label;            // the label object
   CLabel            m_CP_Section_label;              // the label object
   CLabel            m_CP_pos_label;                  // the label object
   CLabel            m_CP_type_label;                 // the label object
   CLabel            m_CP_start_label;                // the label object
   CLabel            m_CP_vol_label;                  // the label object
   CLabel            m_CP_onTP_label;                 // the label object
   CEdit             m_trailingStart_Edit;            // the input field object
   CEdit             m_trailingStep_Edit;             // the input field object
   CEdit             m_CP_start_Edit;                 // the input field object
   CComboBox         m_ideaName_combo;                // the display field object
   CRadioGroup       m_trailingType_RadioGroup;       // the check box group object
   CRadioGroup       m_CP_type_RadioGroup;            // the check box group object
   CSpinEditDouble   m_CP_vol_SpinEdit;               // the up-down object
   CButton           m_trailing_button;               // the fixed button object for trailing SL
   CButton           m_pos_CP_button;                 // the fixed button object for Close Partial
   CButton           m_CP_onTP_button;                // the fixed button object for Close Partial on TP position
   
   //--- parameters
   CSymbolInfo       m_symbol;                        // symbol info object
   CMyIdeas          *m_ideas;
   CTradeIdeas       *m_trade;
   // int               m_idea_total;
   int               m_idea_index;
   string            m_idea_name;
   bool              m_idea_trailing_enable, m_idea_CPartial_enable, m_idea_CPartialOnTP_enable;
   int               total_idea;
   int               curr_idea;
   static bool       m_idea_exist;
   ENUM_CONTROL_TYPE m_trailing_type;
   ENUM_CONTROL_TYPE m_CPartial_type;

//#endregion
public:
                        CAM_ControlsDialog(void);
                        CAM_ControlsDialog(CMyIdeas &idea_list);
                        ~CAM_ControlsDialog(void) {};
//#region Public
   virtual bool         OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- create
   virtual bool         Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool         GetIdeas(CMyIdeas &idea_list);
   //--- state
   bool                 IsExist(void) const { return(IS_EXIST); }
   //---
   bool                 IsTrailingEnabled(const int index) const;
   int                  IdeaControlSelect(void) {  return(m_idea_index);   }
   virtual CTradeIdeas* TradeIdeaAt(const int index);
   CTradeIdeas*         TradeIdeaRefresh(void);
//#endregion
//#region Protected Control
protected:
//--- create dependent controls
   bool              CreateIdeaNameLabel(void);
   bool              CreateTrailingSectionLabel(void);
   bool              CreateTrailingLabel(void);
   bool              CreateTrailingTypeLabel(void);
   bool              CreateTrailingStartLabel(void);
   bool              CreateTrailingStepLabel(void);
   bool              CreateCPSectionLabel(void);
   bool              CreateCPPosLabel(void);
   bool              CreateCPTypeLabel(void);
   bool              CreateCPStartLabel(void);
   bool              CreateCPVolLabel(void);
   bool              CreateCPonTPLabel(void);
//--- create display field
   bool              CreateIdeaNameCombo(void);
   bool              CreateTrailingButton(void);
   bool              CreateTrailingTypeCombo(void);
   bool              CreateTrailingStartGroup(void);
   bool              CreateTrailingStepCombo(void);
   bool              CreateTrailingTypeRadioGroup(void);
   bool              CreateTrailingStartEdit(void);
   bool              CreateTrailingStepEdit(void);
   bool              CreatePosCPButton(void);
   bool              CreateCPStartGroup(void);
   bool              CreateCPVolCombo(void);
   bool              CreateCPTypeRadioGroup(void);
   bool              CreateCPStartEdit(void);
   bool              CreateCPVolSpinEdit(void);
   bool              CreateCPonTPButton(void);
//#endregion
//#region Event
   //========== Object Event Handlers ==========
   void              OnChangeIdeaNameCombo(void);
   void              OnClickTrailingButton(void);
   void              OnClickPosCPButton(void);
   void              OnClickCPonTPButton(void);
   void              OnChangeTrailingRadioGroup(void);
   void              OnChangeCPartialRadioGroup(void);
   void              OnChangeTrailingStartEdit(void);
   void              OnChangeTrailingStepEdit(void);
   void              OnChangeCPartialStartEdit(void);
   void              OnChangeCPartialSpinEdit(void);
   //--- Checkers
   void              CheckTrailingButton(void);
   void              CheckCPartialButton(void);
   void              CheckCPartialTPButton(void);
   void              CheckTrailingTypeRadioGroup(void);
   void              CheckCPartialTypeRadioGroup(void);
   void              CheckTrailingStartEdit(void);
   void              CheckTrailingStepEdit(void);
   void              CheckCPartialStartEdit(void);
   void              CheckCPartialVolSpinEdit(void);
   //--- Setters for Labels
   void              SetCaption(void);
   void              SetTrailingCaption(void);
   void              SetTrailingStartTypeLabel(void);
   void              SetTrailingStepTypeLabel(void);
   void              SetCPartialCaption(void);
   void              SetCPartialStartTypeLabel(void);
public:
   bool              SetIdeaTrailing(const int idx) const;
   bool              SetIdeaClosePartial(const int idx) const;
   bool              SetIdeaCPartialOnTP(const int idx) const;

//#endregion
//#region Private
private:
   //---
   bool              Clear(const int idx);
   bool              SaveToDisk(const int idx);
   bool              LoadFromDisk(const int idx);
//#endregion
};
bool CAM_ControlsDialog::m_idea_exist=false;
//+------------------------------------------------------------------+
//| Constructor and Destructor                                      |
//+------------------------------------------------------------------+
CAM_ControlsDialog::CAM_ControlsDialog(void) :
   m_idea_index(0),
   m_idea_name(""),
   m_idea_trailing_enable(false),
   m_idea_CPartial_enable(false),
   m_idea_CPartialOnTP_enable(false),
   total_idea(0),
   curr_idea(-1),
   m_trailing_type(inpTrailingType),
   m_CPartial_type(inpTrailingType)
{

};
//#region Macros event

//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAM_ControlsDialog)
   ON_EVENT(ON_CHANGE,m_ideaName_combo,OnChangeIdeaNameCombo)
   ON_EVENT(ON_CLICK,m_trailing_button,OnClickTrailingButton)
   ON_EVENT(ON_CLICK,m_pos_CP_button,OnClickPosCPButton)
   ON_EVENT(ON_CLICK,m_CP_onTP_button,OnClickCPonTPButton)
   ON_EVENT(ON_CHANGE,m_trailingType_RadioGroup,OnChangeTrailingRadioGroup)
   ON_EVENT(ON_CHANGE,m_CP_type_RadioGroup,OnChangeCPartialRadioGroup)
   ON_EVENT(ON_END_EDIT,m_trailingStart_Edit,OnChangeTrailingStartEdit)
   ON_EVENT(ON_END_EDIT,m_trailingStep_Edit,OnChangeTrailingStepEdit)
   ON_EVENT(ON_END_EDIT,m_CP_start_Edit,OnChangeCPartialStartEdit)
   ON_EVENT(ON_CHANGE,m_CP_vol_SpinEdit,OnChangeCPartialSpinEdit)
EVENT_MAP_END(CAppDialog)
//#endregion
//#region Create Label

//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
{
   //--- other controls can be added here
   // if(!CreateComboBox())
   //    return(false);
   // if(!CreateCheckGroup())
   //    return(false);
   // if(!CreateButton1())
   //    return(false);
   //---
   if(!m_idea_exist) {
      Print(__FUNCTION__+"::CHECKED");
      m_idea_exist=true;
      //--- create base class
      if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
         return(false);
      //#region Control Labels
      if(!CreateIdeaNameLabel())
         return(false);
      if(!CreateTrailingSectionLabel())
         return(false);
      if(!CreateTrailingLabel())
         return(false);
      if(!CreateTrailingTypeLabel())
         return(false);
      if(!CreateTrailingStartLabel())
         return(false);
      if(!CreateTrailingStepLabel())
         return(false);
      if(!CreateCPSectionLabel())
         return(false);
      if(!CreateCPPosLabel())
         return(false);
      if(!CreateCPTypeLabel())
         return(false);
      if(!CreateCPStartLabel())
         return(false);
      if(!CreateCPVolLabel())
         return(false);
      if(!CreateCPonTPLabel())
         return(false);
//#endregion
      //#region Dependent Controls
      if(!CreateTrailingButton())
         return(false);
      if(!CreateTrailingTypeRadioGroup())
         return(false);
      if(!CreateTrailingStartEdit())
         return(false);
      if(!CreateTrailingStepEdit())
         return(false);
      if(!CreatePosCPButton())
         return(false);
      // if(!CreateCPStartGroup())
      //    return(false);
      // if(!CreateCPVolCombo())
      //    return(false);
      if(!CreateCPTypeRadioGroup())
         return(false);
      if(!CreateCPStartEdit())
         return(false);
      if(!CreateCPVolSpinEdit())
         return(false);
      if(!CreateCPonTPButton())
         return(false);
      if(!CreateIdeaNameCombo())
         return(false);
//#endregion
      SetCaption();
      //--- succeed
      return(true);
   }
   return(false);
}
//+------------------------------------------------------------------+
//| IdeaCreate
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::GetIdeas(CMyIdeas &idea_list)
{
   m_ideas=&idea_list;
   //---
   if(m_ideas==NULL)
      return(false);
   //---
   return(true);
}
//+------------------------------------------------------------------+
//| IsTrailingEnabled
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::IsTrailingEnabled(const int idx) const
{
   if(m_idea_index!=idx)
      return(false);   
   //---
   return m_idea_trailing_enable;
}
//+------------------------------------------------------------------+
//| TradeIdeaAt                                                   |
//+------------------------------------------------------------------+
CTradeIdeas *CAM_ControlsDialog::TradeIdeaAt(const int index)
{
   if(m_ideas==NULL)
      return NULL;
   //---
   if(index < 0 || index >= m_ideas.Total())
      return NULL;
   return (CTradeIdeas*)(m_ideas.At(index));
}
//+------------------------------------------------------------------+
//| TradeIdeaRefresh                                                 |
//+------------------------------------------------------------------+
// CTradeIdeas *CAM_ControlsDialog::TradeIdeaRefresh(void)
// {
//    if(m_IdeaList==NULL)
//       return NULL;
//    CTradeIdeas *trade=TradeIdeaAt(m_idea_index);
//    if(trade==NULL)
//       return NULL;
//    //---
//    return trade;
// }
//+------------------------------------------------------------------+
//| Create the label for Trading Idea field                          |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateIdeaNameLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1;
   int x2=x1+LABEL_WIDTH;
   int y2=y1+LABEL_HEIGHT;
//--- create
   if(!m_ideaName_label.Create(m_chart_id,m_name+"_IdeaName_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_ideaName_label.Text("Idea Name"))
      return(false);
   if(!Add(m_ideaName_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Section field                               |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingSectionLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+LABEL_HEIGHT;
//--- create
   if(!m_trailingSection_label.Create(m_chart_id,m_name+"_trailingSection_Label ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingSection_label.Text("Trailing Stop Control Panel"))
      return(false);
   if(!m_trailingSection_label.Font("Microsoft Sans Serif Bold"))
      return(false);
   if(!Add(m_trailingSection_label))
      return(false);
//--- succeed
   // Print(m_trailingSection_label.C)
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Trailing SL field                           |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_trailingSL_label.Create(m_chart_id,m_name+"_TrailingSL_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingSL_label.Text("Trailing SL"))
      return(false);
   if(!Add(m_trailingSL_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Trailing Type field                         |
//+------------------------------------------------------------------+
// bool CAM_ControlsDialog::CreateTrailingTypeLabel(void) // Combo m_trailingType_combo
// {
// //--- coordinates
//    int x1=INDENT_LEFT;
//    int y1=INDENT_TOP+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y);
//    int x2=x1+LABEL_WIDTH;
//    int y2=y1+COMBO_HEIGHT;
// //--- create
//    if(!m_trailingType_label.Create(m_chart_id,m_name+"_TrailingType_Label",m_subwin,x1,y1,x2,y2))
//       return(false);
//    if(!m_trailingType_label.Text("Trailing Type"))
//       return(false);
//    if(!Add(m_trailingType_label))
//       return(false);
// //--- succeed
//    return(true);
// }
bool CAM_ControlsDialog::CreateTrailingTypeLabel(void) // Radio Group m_trailingType_RadioGroup
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+RADIO_HEIGHT;
//--- create
   if(!m_trailingType_label.Create(m_chart_id,m_name+"_TrailingType_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingType_label.Text("Trailing Type"))
      return(false);
   if(!Add(m_trailingType_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Trailing Start field                        |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingStartLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_trailingStart_label.Create(m_chart_id,m_name+"_TrailingStart_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingStart_label.Text("Trailing Start"))
      return(false);
   if(!Add(m_trailingStart_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Trailing Step field                         |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingStepLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+COMBO_HEIGHT;
//--- create
   if(!m_trailingStep_label.Create(m_chart_id,m_name+"_TrailingStep_Label ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingStep_label.Text("Trailing Coverage"))
      return(false);
   if(!Add(m_trailingStep_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateCPSectionLabel
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPSectionLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+LABEL_HEIGHT;
//--- create
   if(!m_CP_Section_label.Create(m_chart_id,m_name+"_CP_Section_Label ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_Section_label.Text("Close Partial Control Panel "))
      return(false);
   if(!Add(m_CP_Section_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Position Close Partial field                |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPPosLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_CP_pos_label.Create(m_chart_id,m_name+"_CP_Pos_Label ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_pos_label.Text("Close Partial Position"))
      return(false);
   if(!Add(m_CP_pos_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateCPTypeLabel
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPTypeLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+RADIO_HEIGHT;
//--- create
   if(!m_CP_type_label.Create(m_chart_id,m_name+"_CP_Type_Label ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_type_label.Text("Close Partial Type"))
      return(false);
   if(!Add(m_CP_type_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Close Partial Start field                   |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPStartLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_CP_start_label.Create(m_chart_id,m_name+"_CPStart_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_start_label.Text("Close Partial Start"))
      return(false);
   if(!Add(m_CP_start_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Close Partial Volume field                  |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPVolLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_CP_vol_label.Create(m_chart_id,m_name+"_CPVol_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_vol_label.Text("Close Partial Volume"))
      return(false);
   if(!Add(m_CP_vol_label))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| Create the label for Close Partial on TP field                   |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPonTPLabel(void)
{
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+1+(LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+LABEL_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_CP_onTP_label.Create(m_chart_id,m_name+"_CPonTP_Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_onTP_label.Text("Close Partial on TP"))
      return(false);
   if(!Add(m_CP_onTP_label))
      return(false);
//--- succeed
   return(true);
}
//#endregion
//#region Create Control

//+------------------------------------------------------------------+
//| Create the display field for Trading Idea name                   |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateIdeaNameCombo(void) 
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=x1+CONTROL_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_ideaName_combo.Create(m_chart_id,m_name+"_IdeaName_Combo",m_subwin,x1,y1,x2,y2))
      return(false);
   //---
   if(!Add(m_ideaName_combo))
      return(false);
//--- fill out with strings
   int ideas_total=m_ideas.Total();
   Print(__FUNCTION__+"::Total Ideas Found: "+IntegerToString(ideas_total));
   for(int i = 0; i < ideas_total; i++)
   {
      CTradeIdeas* trade = TradeIdeaAt(i);
      if(trade==NULL)
         return(false);
      if(!m_ideaName_combo.ItemAdd(trade.ideaName,i))
         return(false);
      //---
      Print(__FUNCTION__+"::Added Idea Name: "+trade.ideaName+" from index "+IntegerToString(i));
   }
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingButton(void)
{
   //--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
   //---
   if(!m_trailing_button.Create(m_chart_id,m_name+"_Trailing_Button",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailing_button.Text("OFF"))
      return(false);
   if(!Add(m_trailing_button))
      return(false);
   m_trailing_button.Locking(true);
   //--- succeed
   return(true);
}
// //+------------------------------------------------------------------+
// //+------------------------------------------------------------------+
// bool CAM_ControlsDialog::CreateTrailingTypeCombo(void)
// {
// //--- coordinates
//    int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
//    int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
//                      (LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y);
//    int x2=x1+CONTROL_WIDTH;
//    int y2=y1+COMBO_HEIGHT;
// //--- create
//    if(!m_trailingType_combo.Create(m_chart_id,m_name+"_TrailingType_Combo",m_subwin,x1,y1,x2,y2))
//       return(false);
//    if(!m_trailingType_combo.ItemAdd("By Pips",TrailingType(m_trailing_type)==BY_PIPS))
//       return(false);
//    if(!m_trailingType_combo.ItemAdd("By Percentage",TrailingType(m_trailing_type)==BY_PERCENTAGE))
//       return(false);
//    if(!m_trailingType_combo.ItemAdd("By Amount",TrailingType(m_trailing_type)==BY_DOLLAR_AMOUNT))
//       return(false);
//    if(!Add(m_trailingType_combo))
//       return(false);
// //--- succeed
//    return(true);
// }
// //+------------------------------------------------------------------+
// //+------------------------------------------------------------------+
// bool CAM_ControlsDialog::CreateTrailingStartGroup(void)
// {
// //--- coordinates
//    int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
//    int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
//                      (LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
//                      (COMBO_HEIGHT+CONTROLS_GAP_Y);
//    int x2=x1+CONTROL_WIDTH;
//    int y2=y1+RADIO_HEIGHT;
// //--- create
//    if(!m_trailingStart_group.Create(m_chart_id,m_name+"_TrailingStart_Group",m_subwin,x1,y1,x2,y2))
//       return(false);
//    if(!m_trailingStart_group.AddItem("Option 1"))
//       return(false);
//    if(!m_trailingStart_group.AddItem("Option 2"))
//       return(false);
//    if(!m_trailingStart_group.AddItem("Option 3"))
//       return(false);
//    if(!Add(m_trailingStart_group))
//       return(false);
//    //--- succeed
//    return(true);
// }
// //+------------------------------------------------------------------+
// //+------------------------------------------------------------------+
// bool CAM_ControlsDialog::CreateTrailingStepCombo(void)
// {
// //--- coordinates
//    int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
//    int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
//                      (LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
//                      (COMBO_HEIGHT+CONTROLS_GAP_Y)+
//                      (RADIO_HEIGHT+CONTROLS_GAP_Y);
//    int x2=x1+CONTROL_WIDTH;
//    int y2=y1+COMBO_HEIGHT;
// //--- create
//    if(!m_trailingStep_combo.Create(m_chart_id,m_name+"_TrailingStep_Combo",m_subwin,x1,y1,x2,y2))
//       return(false);
//    if(!m_trailingStep_combo.ItemAdd("Step 1"))
//       return(false);
//    if(!m_trailingStep_combo.ItemAdd("Step 2"))
//       return(false);
//    if(!m_trailingStep_combo.ItemAdd("Step 3"))
//       return(false);
//    if(!Add(m_trailingStep_combo))
//       return(false);
//    //--- succeed
//    return(true);
// }
//+------------------------------------------------------------------+
//| CreateTrailingTypeRadioGroup
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingTypeRadioGroup(void)
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+CONTROL_WIDTH;
   int y2=y1+RADIO_HEIGHT;
//--- create
   if(!m_trailingType_RadioGroup.Create(m_chart_id,m_name+"_TrailingType_RadioGroup ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingType_RadioGroup.AddItem("By Pips",BY_PIPS))        // value=1
      return(false);
   if(!m_trailingType_RadioGroup.AddItem("By Percentage",BY_PERCENTAGE))     // value=2
      return(false);
   if(!m_trailingType_RadioGroup.AddItem("By Amount",BY_DOLLAR_AMOUNT))      // value=3
      return(false);
   if(!Add(m_trailingType_RadioGroup))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateTrailingStartEdit
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingStartEdit(void)
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+CONTROL_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_trailingStart_Edit.Create(m_chart_id,m_name+"_TrailingStart_Edit ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingStart_Edit.ReadOnly(false))
      return(false);
   if(!Add(m_trailingStart_Edit))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateTrailingStepEdit
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateTrailingStepEdit(void)
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+CONTROL_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_trailingStep_Edit.Create(m_chart_id,m_name+"_TrailingStep_Edit ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_trailingStep_Edit.ReadOnly(false))
      return(false);
   if(!Add(m_trailingStep_Edit))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreatePosCPButton(void)
{
   //--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
   //--- create
   if(!m_pos_CP_button.Create(m_chart_id,m_name+"_Pos_CP_Button ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_pos_CP_button.Text("OFF"))
      return(false);
   if(!Add(m_pos_CP_button))
      return(false);
   m_pos_CP_button.Locking(true);
   //--- succeed
   return(true);
}
// //+------------------------------------------------------------------+
// //+------------------------------------------------------------------+
// bool CAM_ControlsDialog::CreateCPStartGroup(void)
// {
//    //--- coordinates
//    int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
//    int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
//                      (LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
//                      (COMBO_HEIGHT+CONTROLS_GAP_Y)+
//                      (RADIO_HEIGHT+CONTROLS_GAP_Y)+
//                      (COMBO_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y);
//    int x2=x1+CONTROL_WIDTH;
//    int y2=y1+RADIO_HEIGHT;
//    //--- create
//    if(!m_CP_start_group.Create(m_chart_id,m_name+"_CP_start_Group",m_subwin,x1,y1,x2,y2))
//       return(false);
//    if(!m_CP_start_group.AddItem("Option 1"))
//       return(false);
//    if(!m_CP_start_group.AddItem("Option 2"))
//       return(false);
//    if(!m_CP_start_group.AddItem("Option 3"))
//       return(false);
//    if(!Add(m_CP_start_group))
//       return(false);
//    //--- succeed
//    return(true);
// }
// //+------------------------------------------------------------------+
// //+------------------------------------------------------------------+
// bool CAM_ControlsDialog::CreateCPVolCombo(void)
// {
//    //--- coordinates
//    int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
//    int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
//                      (LABEL_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
//                      (COMBO_HEIGHT+CONTROLS_GAP_Y)+
//                      (RADIO_HEIGHT+CONTROLS_GAP_Y)+
//                      (COMBO_HEIGHT+CONTROLS_GAP_Y)+
//                      (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
//                      (RADIO_HEIGHT+CONTROLS_GAP_Y);
//    int x2=x1+CONTROL_WIDTH;
//    int y2=y1+COMBO_HEIGHT;
//    //--- create
//    if(!m_CP_vol_combo.Create(m_chart_id,m_name+"_CP_vol_Combo",m_subwin,x1,y1,x2,y2))
//       return(false);
//    if(!m_CP_vol_combo.ItemAdd("Volume 1"))
//       return(false);
//    if(!m_CP_vol_combo.ItemAdd("Volume 2"))
//       return(false);
//    if(!m_CP_vol_combo.ItemAdd("Volume 3"))
//       return(false);
//    if(!Add(m_CP_vol_combo))
//       return(false);
//    //--- succeed
//    return(true);
// }
//+------------------------------------------------------------------+
//| CreateCPTypeRadioGroup
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPTypeRadioGroup(void)
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+RADIO_HEIGHT;
//--- create
   if(!m_CP_type_RadioGroup.Create(m_chart_id,m_name+"_CP_Type_RadioGroup ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_type_RadioGroup.AddItem("By Pips",BY_PIPS))
      return(false);
   if(!m_CP_type_RadioGroup.AddItem("By Percentage",BY_PERCENTAGE))
      return(false);
   if(!m_CP_type_RadioGroup.AddItem("By Amount",BY_DOLLAR_AMOUNT))
      return(false);
   if(!Add(m_CP_type_RadioGroup))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateCPStartEdit
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPStartEdit(void)
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_CP_start_Edit.Create(m_chart_id,m_name+"_CP_Start_Edit ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_start_Edit.ReadOnly(false))
      return(false);
   if(!Add(m_CP_start_Edit))
      return(false);
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateCPVolSpinEdit
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPVolSpinEdit(void)
{
//--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_CP_vol_SpinEdit.Create(m_chart_id,m_name+"_CP_Vol_SpinEdit ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_CP_vol_SpinEdit))
      return(false);

//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
//| CreateCPonTPButton
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::CreateCPonTPButton(void)
{
   //--- coordinates
   int x1=INDENT_LEFT+CONTROL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (COMBO_HEIGHT+CONTROLS_GAP_Y)+
                     (LABEL_HEIGHT+CONTROLS_GAP_Y)+
                     (BUTTON_HEIGHT+CONTROLS_GAP_Y)+
                     (RADIO_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y)+
                     (EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
   //--- create
   if(!m_CP_onTP_button.Create(m_chart_id,m_name+"_CP_onTP_Button ",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CP_onTP_button.Text("OFF"))
      return(false);
   if(!Add(m_CP_onTP_button))
      return(false);
   m_CP_onTP_button.Locking(true);
   //--- succeed
   return(true);
}
//#endregion
//#region Event Handler

//+------------------------------------------------------------------+
//| OnChangeIdeaNameCombo
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeIdeaNameCombo(void)
{
   m_idea_index=(int)m_ideaName_combo.Value();
   //---
   m_trade=TradeIdeaAt(m_idea_index);
   // //---
   if(m_trade!=NULL) {
      m_symbol.Name(m_trade.ideaSymbol);
      Print(__FUNCTION__+"::Change Idea to "+m_trade.ideaName+" at index "+IntegerToString(m_idea_index));
      CheckTrailingButton();
      CheckCPartialButton();
      CheckCPartialTPButton();
      CheckTrailingTypeRadioGroup();
      CheckCPartialTypeRadioGroup();
      CheckTrailingStartEdit();
      CheckTrailingStepEdit();
      CheckCPartialStartEdit();
      CheckCPartialVolSpinEdit();
      //---
      SetCaption();
      SetTrailingStartTypeLabel();
      SetTrailingStepTypeLabel();
      SetCPartialStartTypeLabel();
   }
}
//+------------------------------------------------------------------+
//| OnClickTrailingButton
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnClickTrailingButton(void)
{
   if(m_trade!=NULL)
   {
      if(m_trailing_button.Pressed())
         m_trade.ideaTrailingStopEnable=true;
      else
         m_trade.ideaTrailingStopEnable=false;
      //---
      // string is_enabled=(m_trade.ideaTrailingStopEnable)?"ENABLED":"DISABLED";
      // Print(__FUNCTION__+"::CHANGE "+m_trade.ideaName+" Trailing Stop to "+is_enabled);
   }
   //---
   CheckTrailingButton();
}
//+------------------------------------------------------------------+
//| OnClickPosCPButton
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnClickPosCPButton(void)
{
   if(m_trade!=NULL)
   {
      if(m_pos_CP_button.Pressed())
         m_trade.ideaCPartialEnable=true;
      else
         m_trade.ideaCPartialEnable=false;
   }
   //---
   CheckCPartialButton();
}
//+------------------------------------------------------------------+
//| OnClickCPonTPButton
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnClickCPonTPButton(void)
{
   if(m_trade!=NULL)
   {
      if(m_pos_CP_button.Pressed())
         m_trade.ideaCPartialOnTPEnable=true;
      else
         m_trade.ideaCPartialOnTPEnable=false;
   }
   //---
   CheckCPartialTPButton();
}
//+------------------------------------------------------------------+
//| OnChangeTrailingRadioGroup
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeTrailingRadioGroup(void)
{
   if(m_trade!=NULL)
   {
      m_trade.ideaTrailingType=TrailingType(m_trailingType_RadioGroup.Value());
      // Print(__FUNCTION__+"::Change "+m_trade.ideaName+" Trailing Type to "+EnumToString(m_trade.ideaTrailingType));
      CheckTrailingTypeRadioGroup();
      CheckTrailingStartEdit();
      SetTrailingStartTypeLabel();
      SetTrailingStepTypeLabel();
   }
   //---
}
//+------------------------------------------------------------------+
//| OnChangeCPartialRadioGroup
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeCPartialRadioGroup(void)
{
   if(m_trade!=NULL)
   {
      m_trade.ideaCPartialType=TrailingType(m_CP_type_RadioGroup.Value());
      // Print(__FUNCTION__+"::Change "+m_trade.ideaName+" Trailing Type to "+EnumToString(m_trade.ideaTrailingType));
      CheckTrailingTypeRadioGroup();
      SetCPartialStartTypeLabel();
   }
   //---
}
//+------------------------------------------------------------------+
//| OnChangeTrailingStartEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeTrailingStartEdit(void)
{
   if(m_trade!=NULL)
      m_trade.ideaTrailingStart=StringToDouble(m_trailingStart_Edit.Text());
   //---
   CheckTrailingStartEdit();
}
//+------------------------------------------------------------------+
//| OnChangeTrailingStepEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeTrailingStepEdit(void)
{
   if(m_trade!=NULL)
   {
      //--- KIV
   }
   //---
   CheckTrailingStepEdit();
}
//+------------------------------------------------------------------+
//| OnChangeCPartialStartEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeCPartialStartEdit(void)
{
   if(m_trade!=NULL)
      m_trade.ideaCPartialStart=StringToDouble(m_CP_start_Edit.Text());
   //---
   CheckCPartialStartEdit();
}
//+------------------------------------------------------------------+
//| OnChangeCPartialSpinEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::OnChangeCPartialSpinEdit(void)
{
   if(m_trade!=NULL)
      m_trade.ideaCPartialVol=m_CP_vol_SpinEdit.Value();
}
//#endregion
//#region Checker

//+------------------------------------------------------------------+
//| CheckTrailingButton
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckTrailingButton(void)
{
   if(m_trade!=NULL) 
   {
      // string is_enabled=(m_trade.ideaTrailingStopEnable)?"ENABLED":"DISABLED";
      // Print(__FUNCTION__+"::CHECK "+m_trade.ideaName+" Trailing Stop is "+is_enabled+" before setting button");
      switch (m_trade.ideaTrailingStopEnable)
      {
      case true:
         m_trailing_button.Pressed(true);
         m_trailing_button.Text("ON");
         break;
      case false:
         m_trailing_button.Pressed(false);
         m_trailing_button.Text("OFF");
         break;
      }
   }
}
//+------------------------------------------------------------------+
//| CheckCPartialButton
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckCPartialButton(void)
{
   if(m_trade!=NULL) 
   {
      if(m_trade.ideaCPartialEnable) {
         m_pos_CP_button.Pressed(true);
         m_pos_CP_button.Text("ON");
      }
      else {
         m_pos_CP_button.Pressed(false);
         m_pos_CP_button.Text("OFF");
      }
   }
}
//+------------------------------------------------------------------+
//| CheckCPartialTPButton
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckCPartialTPButton(void)
{
   if(m_trade!=NULL)
   {
      if(m_trade.ideaCPartialOnTPEnable) {
         m_CP_onTP_button.Pressed(true);
         m_CP_onTP_button.Text("ON");
      }
      else {
         m_CP_onTP_button.Pressed(false);
         m_CP_onTP_button.Text("OFF");
      }
   }
}
//+------------------------------------------------------------------+
//| CheckTrailingTypeRadioGroup
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckTrailingTypeRadioGroup(void)
{
   if(m_trade!=NULL)
   {
      switch (m_trade.ideaTrailingType)
      {
      case BY_PIPS:
         m_trailingType_RadioGroup.Value(BY_PIPS);
         // Print(__FUNCTION__+"::Check "+m_trade.ideaName+" m_trailingType_RadioGroup value is BY_PIPS");
         break;
      case BY_PERCENTAGE:
         m_trailingType_RadioGroup.Value(BY_PERCENTAGE);
         // Print(__FUNCTION__+"::Check "+m_trade.ideaName+" m_trailingType_RadioGroup value is BY_PERCENTAGE");
         break;
      case BY_DOLLAR_AMOUNT:
         m_trailingType_RadioGroup.Value(BY_DOLLAR_AMOUNT);
         // Print(__FUNCTION__+"::Check "+m_trade.ideaName+" m_trailingType_RadioGroup value is BY_DOLLAR_AMOUNT");
         break;
      }
   }
}
//+------------------------------------------------------------------+
//| CheckCPartialTypeRadioGroup
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckCPartialTypeRadioGroup(void)
{
   if(m_trade!=NULL)
   {
      switch (m_trade.ideaCPartialType)
      {
      case BY_PIPS:
         m_CP_type_RadioGroup.Value(BY_PIPS);
         break;
      case BY_PERCENTAGE:
         m_CP_type_RadioGroup.Value(BY_PERCENTAGE);
         break;
      case BY_DOLLAR_AMOUNT:
         m_CP_type_RadioGroup.Value(BY_DOLLAR_AMOUNT);
         break;
      }
   }
}
//+------------------------------------------------------------------+
//| CheckTrailingStartEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckTrailingStartEdit(void)
{
   if(m_trade!=NULL)
   {
      switch (m_trade.ideaTrailingType)
      {
      case BY_PIPS:
         m_trailingStart_Edit.Text(DoubleToString(m_trade.ideaTrailingStart,0));
         break;
      case BY_PERCENTAGE:
         m_trailingStart_Edit.Text(DoubleToString(m_trade.ideaTrailingStart,0));
         break;
      case BY_DOLLAR_AMOUNT:
         m_trailingStart_Edit.Text(DoubleToString(m_trade.ideaTrailingStart,2));
         break;
      }
   }
}
//+------------------------------------------------------------------+
//| CheckTrailingStepEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckTrailingStepEdit(void)
{
   if(m_trade!=NULL)
   {
      Print(__FUNCTION__+"::Checking "+m_trade.ideaName+" Trailing Step Edit");
      // m_trailingStep_Edit.Value(m_trade.ideaTrailingStep);
   }
}
//+------------------------------------------------------------------+
//| CheckCPartialStartEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckCPartialStartEdit(void)
{
   if(m_trade!=NULL)
   {
      switch (m_trade.ideaTrailingType)
      {
      case BY_PIPS:
         m_CP_start_Edit.Text(DoubleToString(m_trade.ideaCPartialStart,0));
         break;
      case BY_PERCENTAGE:
         m_CP_start_Edit.Text(DoubleToString(m_trade.ideaCPartialStart,0));
         break;
      case BY_DOLLAR_AMOUNT:
         m_CP_start_Edit.Text(DoubleToString(m_trade.ideaCPartialStart,2));
         break;
      }
   }
}
//+------------------------------------------------------------------+
//| CheckCPartialVolSpinEdit
//+------------------------------------------------------------------+
void CAM_ControlsDialog::CheckCPartialVolSpinEdit(void)
{
   if(m_trade!=NULL)
   {
      m_CP_vol_SpinEdit.Symbol(m_trade.ideaSymbol);
      if(m_trade.ideaCPartialVol<=m_symbol.LotsMin()) {
         m_CP_vol_SpinEdit.MinValue(m_symbol.LotsMin());
         m_CP_vol_SpinEdit.MaxValue(m_trade.ideaVolume-m_symbol.LotsMin());
         m_CP_vol_SpinEdit.Value(m_CP_vol_SpinEdit.MaxValue());
         // Print(__FUNCTION__+"::Checking Minimum Lot Size: "+DoubleToString(m_CP_vol_SpinEdit.MinValue(),2));
         // Print(__FUNCTION__+"::Checking Maximum Lot Size: "+DoubleToString(m_CP_vol_SpinEdit.MaxValue(),2));
         // Print(__FUNCTION__+"::Checking Selected Lot Size: "+DoubleToString(m_CP_vol_SpinEdit.Value(),2));
         m_trade.ideaCPartialVol=m_CP_vol_SpinEdit.Value();
      }
      else
         m_CP_vol_SpinEdit.Value(m_trade.ideaCPartialVol);
      //---
   }
}
//#endregion
//#region Setter
//+------------------------------------------------------------------+
//| SetIdeaNameCaption
//+------------------------------------------------------------------+
void CAM_ControlsDialog::SetCaption(void)
{
   Caption(m_ideaName_combo.Select()+" Idea's Control Panel");
}
//+------------------------------------------------------------------+
//| SetTrailingCaption
//+------------------------------------------------------------------+
void CAM_ControlsDialog::SetTrailingCaption(void)
{
   // string idea_name="";
   // if(m_ideaName_combo.Select(m_idea_index))
   //    idea_name=m_ideaName_combo.Select();
   //---
   Print(__FUNCTION__+"::Idea Name: "+m_ideaName_combo.Select());
   m_trailingSection_label.Text("'"+m_ideaName_combo.Select()+"' "+m_trailingSection_label.Text());
}
//+------------------------------------------------------------------+
//| SetTrailingStartType
//+------------------------------------------------------------------+
void CAM_ControlsDialog::SetTrailingStartTypeLabel(void)
{
   m_trailingStart_label.Text("Trailing Start "+TypeToString(TrailingType(m_trailingType_RadioGroup.Value())));
}
//+------------------------------------------------------------------+
//| SetTrailingStepType
//+------------------------------------------------------------------+
void CAM_ControlsDialog::SetTrailingStepTypeLabel(void)
{
   m_trailingStep_label.Text("Trailing Coverage "+TypeToString(TrailingType(m_trailingType_RadioGroup.Value())));
}
//+------------------------------------------------------------------+
//| SetCPartialCaption
//+------------------------------------------------------------------+
void CAM_ControlsDialog::SetCPartialCaption(void)
{
   m_CP_Section_label.Text("'"+m_ideaName_combo.Select()+"' "+m_CP_Section_label.Text());
}
//+------------------------------------------------------------------+
//| SetCPartialStartType
//+------------------------------------------------------------------+
void CAM_ControlsDialog::SetCPartialStartTypeLabel(void)
{
   m_CP_start_label.Text("Close Partial Start "+TypeToString(TrailingType(m_CP_type_RadioGroup.Value())));
}
//+------------------------------------------------------------------+
//| SetTrailingEnabled
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::SetIdeaTrailing(const int idx) const
{
   if(m_idea_index!=idx)
      return(false);   
   //---
   return(m_idea_trailing_enable);
}
//+------------------------------------------------------------------+
//| SetIdeaClosePartial
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::SetIdeaClosePartial(const int idx) const
{
   if(m_idea_index!=idx)
      return(false);   
   //---
   return(m_idea_CPartial_enable);
}
//+------------------------------------------------------------------+
//| SetIdeaCPartialOnTP
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::SetIdeaCPartialOnTP(const int idx) const
{
   if(m_idea_index!=idx)
      return(false);   
   //---
   return(m_idea_CPartialOnTP_enable);
}
//#endregion
//#region Getter

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//#endregion
//#region Internal Used
//+------------------------------------------------------------------+
//| Create the "ComboBox" element                                    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Create the "CheckGroup" element                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Create the "Button1" button                                      |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::Clear(const int idx)
{  
   //---
   return(true);
}
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::SaveToDisk(const int idx)
{
   int fh;
   //---
   fh=FileOpen("Objects_State_"+IntegerToString(idx)+".bin",FILE_WRITE|FILE_BIN);
   if(fh==INVALID_HANDLE)
      return(false);
   if(!m_trailing_button.Save(fh))
      return(false);
   // FileWriteInteger(fh, m_idea_trailing_enable ? 1 : 0);
   //---
   FileClose(fh);
   return(true);
}
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
bool CAM_ControlsDialog::LoadFromDisk(const int idx)
{
   int fh;
   //---
   fh=FileOpen("Objects_State_"+IntegerToString(idx)+".bin",FILE_READ|FILE_BIN);
   if(fh==INVALID_HANDLE)
      return(false);
   if(!m_trailing_button.Load(fh))
      return(false);
   //---
   FileClose(fh);
   return(true);
}
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
//#endregion
//+------------------------------------------------------------------+
