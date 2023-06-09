#include "gui.mqh"
#property copyright "智能交易网：www.zhinengjiaoyi.com"
#property link "http://www.zhinengjiaoyi.com"
CProgram program;
int OnInit()
  {
    program.OnInitEvent();
    program.CreateExpertPanel();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   program.OnDeinitEvent(reason);   
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
   program.OnTimerEvent();
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
     program.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
