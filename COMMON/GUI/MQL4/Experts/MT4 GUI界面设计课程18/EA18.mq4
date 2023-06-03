#include "gui.mqh"
CProgram program;
int OnInit()
  {
    program.OnInitEvent();
    program.CreateExpertPanel();
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {
    program.OnDeinitEvent(reason);
   EventKillTimer();
      
  }
void OnTick()
  {

  }
void OnTimer()
  {
     program.OnTimerEvent();
  }
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
    program.ChartEvent(id,lparam,dparam,sparam);
  }
