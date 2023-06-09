#include "gui.mqh"
#property copyright "智能交易网：www.zhinengjiaoyi.com"
#property link "http://www.zhinengjiaoyi.com"
CProgram program;
string    yingkui[15][2];
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
    int yidongdian=program.checkboxedit[0].GetValue();
    if(program.sbutton[5].IsPressed()==true && program.checkboxedit[0].CheckButtonState()==true)
     {
       yidong(yidongdian);
       printf("移动止损已经启动"+yidongdian);
     }
     yingkuitongji();
     for(int i=0;i<ArrayRange(yingkui,0);i++)
     {
       for(int j=0;j<ArrayRange(yingkui,1);j++)
        {
           program.table[0].SetValue(j,i,yingkui[i][j]);
        }
     }
    program.table[0].UpdateTable();
  }
void yidong(int 移动止损点数)
  {
    for(int i=0;i<OrdersTotal();i++)//移动止损通用代码,次代码会自动检测buy和sell单并对其移动止损
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
                if(OrderType()==0 && OrderSymbol()==Symbol())
                  {
                     if((Bid-OrderOpenPrice()) >=Point*移动止损点数)
                      {
                         if(OrderStopLoss()<(Bid-Point*移动止损点数) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*移动止损点数,OrderTakeProfit(),0,Green);
                           }
                      }      
                  }
                if(OrderType()==1 && OrderSymbol()==Symbol())
                  {
                    if((OrderOpenPrice()-Ask)>=(Point*移动止损点数))
                      {
                         if((OrderStopLoss()>(Ask+Point*移动止损点数)) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*移动止损点数,OrderTakeProfit(),0,Red);
                           }
                      }
                  }
               }
         }
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
void tongji(double &ri,double &zhou,double &yue,double &nian,int &liankuimax,int &lianyinmax,int &kuishu,int &yinshu,int &zongshu,double &liankuiqianmax,double &lianyinqianmax,double &kuizong,double &yinzong,double &zongshoushu,double &duoshoushu,double &kongshoushu)
  {
    ri=0;
    zhou=0;
    yue=0;
    nian=0;
    kuishu=0;
    yinshu=0;
    zongshu=0;
    kuizong=0;
    yinzong=0;
    zongshoushu=0;
    duoshoushu=0;
    kongshoushu=0;
    for(int i1=OrdersHistoryTotal()-1;i1>=0;i1--)
      {
          if(OrderSelect(i1,SELECT_BY_POS,MODE_HISTORY))
            {
              if(OrderType()<=1)
               {
                 zongshoushu=zongshoushu+OrderLots();
                 if(OrderType()==0) duoshoushu=duoshoushu+OrderLots();
                 if(OrderType()==1) kongshoushu=kongshoushu+OrderLots();
                 if((OrderProfit()+OrderSwap()+OrderCommission())>0)
                  {
                   yinshu++;
                   yinzong=yinzong+OrderProfit()+OrderSwap()+OrderCommission();
                  }
                 if((OrderProfit()+OrderSwap()+OrderCommission())<0)
                  {
                   kuishu++;
                   kuizong=kuizong+OrderProfit()+OrderSwap()+OrderCommission();
                  }
                  zongshu++;
                 if(TimeYear(OrderCloseTime())==Year())
                  {
                    nian=nian+(OrderProfit()+OrderSwap()+OrderCommission());
                    if(TimeMonth(OrderCloseTime())==Month())
                     {
                       yue=yue+(OrderProfit()+OrderSwap()+OrderCommission());
                       if(TimeDayOfWeek(OrderCloseTime())==DayOfWeek())
                        {
                          zhou=zhou+(OrderProfit()+OrderSwap()+OrderCommission());
                          if(TimeDay(OrderCloseTime())==Day())
                           {
                             ri=ri+(OrderProfit()+OrderSwap()+OrderCommission());
                           }
                        }
                     }
                  }
              }
            }
      }
    double acp=AccountProfit();
    nian=nian+acp;
    yue=yue+acp;
    zhou=zhou+acp;
    ri=ri+acp;
    liankuimax=0;
    lianyinmax=0;
    lianyinqianmax=0;
    liankuiqianmax=0;
    int lianyin,liankui;
    double lianyinqian,liankuiqian;
    for(int i=0;i<=OrdersHistoryTotal()-1;i++)
      {
          if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
            {
              if(OrderType()<=1)
                {
                  if((OrderProfit()+OrderSwap()+OrderCommission())>0)
                   {
                     lianyin++;
                     lianyinqian=lianyinqian+OrderProfit()+OrderSwap()+OrderCommission();
                     if(lianyinmax<lianyin)
                      {
                        lianyinmax=lianyin;
                      }
                     if(lianyinqianmax<lianyinqian)
                      {
                        lianyinqianmax=lianyinqian;
                      }
                   }
                  else
                   {
                     lianyin=0;
                     lianyinqian=0;
                   }
                 if((OrderProfit()+OrderSwap()+OrderCommission())<0)
                   {
                     liankui++;
                     liankuiqian=liankuiqian+OrderProfit()+OrderSwap()+OrderCommission();
                     
                     if(liankuiqianmax<(-1*liankuiqian))
                      {
                        liankuiqianmax=-1*liankuiqian;
                      }
                     if(liankuimax<liankui)
                      {
                        liankuimax=liankui;
                      }
                   }
                  else
                   {
                     liankui=0;
                     liankuiqian=0;
                   }
              }
            }
      }
  }
void yingkuitongji()
{
   double ri, zhou, yue, nian;
   int liankui,lianyin,kuishu,yinshu,zongshu;
   double liankuiqianmax,lianyinqianmax,kuizong,yinzong,zongshoushu,duoshoushu,kongshoushu;
   tongji(ri,zhou,yue,nian,liankui,lianyin,kuishu,yinshu,zongshu,liankuiqianmax,lianyinqianmax,kuizong,yinzong,zongshoushu,duoshoushu,kongshoushu);
   double jz=AccountEquity();
   yingkui[0][0]="账户盈亏统计";
   yingkui[0][1]="统计值";
   
   yingkui[1][0]="本日盈亏:";
   if(jz>0) yingkui[1][1]=DoubleToStr(ri,1)+" 占百分比:"+DoubleToStr((ri/(jz+ri))*100,2)+"%";
   else  yingkui[1][1]=DoubleToStr(ri,1)+" 占百分比:0%";
   
   yingkui[2][0]="本周盈亏:";
   if((jz+zhou)>0) yingkui[2][1]=DoubleToStr(zhou,1)+" 占百分比:"+DoubleToStr((zhou/(jz+zhou))*100,2)+"%";
   else yingkui[2][1]=DoubleToStr(zhou,1)+" 占百分比:0%";
   
   yingkui[3][0]="本月盈亏:";
   if((jz+yue)>0) yingkui[3][1]=DoubleToStr(yue,1)+" 占百分比:"+DoubleToStr((yue/(jz+yue))*100,2)+"%";
   else yingkui[3][1]=DoubleToStr(yue,1)+" 占百分比:0%";
   
   yingkui[4][0]="本年盈亏:";
   if((jz+nian)>0) yingkui[4][1]=DoubleToStr(nian,1)+" 占百分比:"+DoubleToStr((nian/(jz+nian))*100,2)+"%";
   else yingkui[4][1]=DoubleToStr(nian,1)+" 占百分比:0%";
   
   yingkui[5][0]="总单数:";
   yingkui[5][1]=DoubleToStr(zongshu,0);
   
   yingkui[6][0]="亏损单数:";
   yingkui[6][1]=DoubleToStr(kuishu,0);
   
   yingkui[7][0]="盈利单数";
   yingkui[7][1]=DoubleToStr(yinshu,0);
   
   yingkui[8][0]="总下单手数:";
   yingkui[8][1]=DoubleToStr(zongshoushu,2);
   
   yingkui[9][0]="多单手数:";
   yingkui[9][1]=DoubleToStr(duoshoushu,2);
   
   yingkui[10][0]="空单手数:";
   yingkui[10][1]=DoubleToStr(kongshoushu,2);
   
   yingkui[11][0]="最多连亏单数:";
   yingkui[11][1]=DoubleToStr(liankui,0);
   
   yingkui[12][0]="最多连亏金额:";
   yingkui[12][1]=DoubleToStr(liankuiqianmax,1);
  
   yingkui[13][0]="最多连盈单数:";
   yingkui[13][1]=DoubleToStr(lianyin,0);
   
   yingkui[14][0]="多连盈金额:";
   yingkui[14][1]=DoubleToStr(lianyinqianmax,1);
}