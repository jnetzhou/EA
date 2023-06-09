#include "gui.mqh"
#property copyright "智能交易网：www.zhinengjiaoyi.com"
#property link "http://www.zhinengjiaoyi.com"
CProgram program;
extern int 小均线周期=13;
extern int 大均线周期=21;
extern double 下单手数=0.1;
extern int 止损点数=269;
extern int 止盈点数=2000;
extern int 移动止损点数=0;
extern int 盈利几点启动保本=100;
datetime buytime=0;
datetime selltime=0;
int magic=45456456;
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
void OnTick()
  {
    if(program.sbutton[0].IsPressed()==true)
     {
       小均线周期=StrToInteger(program.edit[0].LabelText());
       大均线周期=StrToInteger(program.edit[1].LabelText());
       下单手数=StrToDouble(program.edit[2].LabelText());
       止损点数=StrToInteger(program.edit[3].LabelText());
       止盈点数=StrToInteger(program.edit[4].LabelText());
       移动止损点数=StrToInteger(program.edit[5].LabelText());
       盈利几点启动保本=StrToInteger(program.edit[6].LabelText());
       program.sbutton[0].IsPressed(false);
     }
    //printf(小均线周期);
    if(program.sbutton[1].IsPressed()==false)
     {
       return;
     }
     printf("EA启动了");
     program.label[7].LabelText("持仓总单数:"+IntegerToString(danshu1()));
    yidong();
    double xiaoma1=iMA(Symbol(),0,小均线周期,0,MODE_SMA,PRICE_CLOSE,1);
    double xiaoma2=iMA(Symbol(),0,小均线周期,0,MODE_SMA,PRICE_CLOSE,2);
    double dama1=iMA(Symbol(),0,大均线周期,0,MODE_SMA,PRICE_CLOSE,1);
    double dama2=iMA(Symbol(),0,大均线周期,0,MODE_SMA,PRICE_CLOSE,2);
    if(xiaoma1>dama1 && xiaoma2<dama2)//金叉
      { 
         pingkong();
         if(buytime!=Time[0])
          {
             if(danshu()==0)
              {
                 if(buy(下单手数,止损点数,止盈点数,Symbol()+"buy",magic)>0)//开buy
                    {
                      buytime=Time[0];
                    }
              }
          }
      }
     if(xiaoma1<dama1 && xiaoma2>dama2)//死叉
       {
          pingduo();
          if(selltime!=Time[0])
          {  
             if(danshu()==0)
               {
                  if(sell(下单手数,止损点数,止盈点数,Symbol()+"sell",magic)>0)//开sell
                    {
                      selltime=Time[0];
                    }
               }
          }
       }
  }
int danshu1()
  {
    int a=0;
     for(int i=0;i<OrdersTotal();i++)
               {
                   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                     {
                       //if(OrderMagicNumber()==magic)
                         {
                           //if(OrderComment()==(Symbol()+"buy") || OrderComment()==(Symbol()+"sell"))    
                             {
                               a=a+1;                   
                             } 
                         }
                      }
               }
     return(a);
  }
int danshu()
  {
    int a=0;
     for(int i=0;i<OrdersTotal();i++)
               {
                   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderMagicNumber()==magic)
                         {
                           if(OrderComment()==(Symbol()+"buy") || OrderComment()==(Symbol()+"sell"))    
                             {
                               a=a+1;                   
                             } 
                         }
                      }
               }
     return(a);
  }
void yidong()
  {
    for(int i=0;i<OrdersTotal();i++)//移动止损通用代码,次代码会自动检测buy和sell单并对其移动止损
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
                if(OrderType()==0 && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                  {
                     if(移动止损点数>0 && (Bid-OrderOpenPrice()) >=Point*移动止损点数)
                      {
                         if(OrderStopLoss()<(Bid-Point*移动止损点数) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*移动止损点数,OrderTakeProfit(),0,Green);
                           }
                      }      
                     if((Bid-OrderOpenPrice()) >=Point*盈利几点启动保本)
                      {
                         if(OrderStopLoss()<(Bid+Point*1) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Bid+Point*1,OrderTakeProfit(),0,Green);
                           }
                      }   
                  }
                if(OrderType()==1 && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                  {
                    if(移动止损点数>0 && (OrderOpenPrice()-Ask)>=(Point*移动止损点数))
                      {
                         if((OrderStopLoss()>(Ask+Point*移动止损点数)) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*移动止损点数,OrderTakeProfit(),0,Red);
                           }
                      }
                    if((OrderOpenPrice()-Ask)>=(Point*盈利几点启动保本))
                      {
                         if((OrderStopLoss()>(Ask-Point*1)) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Ask-Point*1,OrderTakeProfit(),0,Red);
                           }
                      }
                  }
               }
         }
  }
void pingkong()
{
  for(int i1=0;i1<OrdersTotal();i1++)
               {
                   if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol()&& OrderMagicNumber()==magic)    
                         {
                            if(OrderComment()==(Symbol()+"sell"))
                              {
                                 if(OrderClose(OrderTicket(),OrderLots(),Ask,300,Blue)==true)//平sell
                                       {
                                         
                                       }
                              }       
                         } 
                      }
               } 
}
void pingduo()
{
   for(int i1=0;i1<OrdersTotal();i1++)
               {
                   if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol()&& OrderMagicNumber()==magic)   
                         {
                            if(OrderComment()==(Symbol()+"buy"))
                              {
                                     if(OrderClose(OrderTicket(),OrderLots(),Bid,300,Blue)==true)//平buy
                                       {
                                         
                                       }
                              }
                         } 
                      }
               } 
}
int buy(double Lots,double sun,double ying,string comment,int magic)
  {
          int kaiguan=0;
            for(int i=0;i<OrdersTotal();i++)
               {
                   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                     {
                       if((OrderComment()==comment)&&(OrderMagicNumber()==magic))    
                         {
                           kaiguan=1;                     
                         } 
                      }
               }
            if(kaiguan==0)
              {
                   int ticket=OrderSend(Symbol( ) ,OP_BUY,Lots,Ask,500,0,0,comment,magic,0,White);
                   if(ticket>0)
                   {
                    if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
                      {
                       if((sun!=0)&&(ying!=0))
                        {
                          OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-sun*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()+ying*MarketInfo(Symbol(),MODE_POINT),0,Red); 
                        }
                       if((sun==0)&&(ying!=0))
                        {
                          OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()+ying*MarketInfo(Symbol(),MODE_POINT),0,Red); 
                        }
                       if((sun!=0)&&(ying==0))
                        {
                          OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-sun*MarketInfo(Symbol(),MODE_POINT),0,0,Red); 
                        }
                      }
                   }
              return(ticket);
              }
             else
              {
               return(0);
              }
  }
int sell(double Lots,double sun,double ying,string comment,int magic)
    {
               int kaiguan=0;
                 for(int i=0;i<OrdersTotal();i++)
                    {
                        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                          {
                            if((OrderComment()==comment)&&(OrderMagicNumber()==magic))   
                              {
                                kaiguan=1;                     
                              } 
                           }
                    }
                 if(kaiguan==0)
                   {
                        int ticket=OrderSend(Symbol( ) ,OP_SELL,Lots,Bid,500,0,0,comment,magic,0,Red);
                        if(ticket>0)
                        {
                          if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
                           {
                             if((sun!=0)&&(ying!=0))
                              {
                               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+sun*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()-ying*MarketInfo(Symbol(),MODE_POINT),0,Red);
                              } 
                             if((sun==0)&&(ying!=0))
                              {
                               OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()-ying*MarketInfo(Symbol(),MODE_POINT),0,Red);
                              } 
                             if((sun!=0)&&(ying==0))
                              {
                               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+sun*MarketInfo(Symbol(),MODE_POINT),0,0,Red);
                              } 
                           }
                        }
                        return(ticket);
                   }
                  else
                   {
                    return(0);
                   } 
  }