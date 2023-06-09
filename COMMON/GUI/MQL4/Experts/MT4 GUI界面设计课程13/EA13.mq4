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
void OnDeinit(const int reason)
  {
   program.OnDeinitEvent(reason);
   EventKillTimer();
  }
void OnTick()
  {
   string price[5][4];
   price[0][0]="开盘价";
   price[0][1]="最高价";
   price[0][2]="最低价";
   price[0][3]="收盘价";
   for(int i=1;i<5;i++)
     {
       price[i][0]=DoubleToStr(Open[i-1],Digits);
       price[i][1]=DoubleToStr(High[i-1],Digits);
       price[i][2]=DoubleToStr(Low[i-1],Digits);
       price[i][3]=DoubleToStr(Close[i-1],Digits);
     }
    for(int i=0;i<ArrayRange(price,0);i++)
     {
       for(int j=0;j<ArrayRange(price,1);j++)
        {
           program.table[0].SetValue(j,i,price[i][j]);
        }
     }
    program.table[0].UpdateTable();
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