//+------------------------------------------------------------------+
//|                                                     3sma_jim.mq4 |
//|                                                              jim |
//|                                                     3sma.jim.com |
//+------------------------------------------------------------------+
#property copyright "jim"
#property link      "3sma.jim.com"
//---- input parameters
extern int       SMA1=5;
extern int       SMA2=20;
extern int       SMA3=50;
extern double    lots=0.1;
extern int       SMAspread=0;
extern int       StopLoss=0;
extern int       Slippage=4;
double   ma1,ma2,ma3;
int      i, buys, sells;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   //get moving average info
   ma1=iMA(Symbol(),0,SMA1,1,MODE_SMA,PRICE_CLOSE,0);
   ma2=iMA(NULL,0,SMA2,1,MODE_SMA,PRICE_CLOSE,0);
   ma3=iMA(NULL,0,SMA3,1,MODE_SMA,PRICE_CLOSE,0);
   //check for open orders first 
   if (OrdersTotal()>0)
     {
      buys=0;
      sells=0;
      for(i=0;i<OrdersTotal();i++)
        {
         OrderSelect(i,SELECT_BY_POS);
         if (OrderSymbol()==Symbol())
           {
            if (OrderType()== OP_BUY)
              {
               if (ma1 < ma2 && ma2<ma3) OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,Orange);
               else buys++;
              }
            if (OrderType()== OP_SELL)
              {
               if (ma1 > ma2 && ma2>ma3) OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,Yellow);
               else sells++;
              }
           }
        }
     }
   if (ma1>(ma2+SMAspread*Point) && ma2 > (ma3+SMAspread*Point) && buys==0 && Close[0] > ma1 && getDeviationRatio(Ask,ma1,ma2,ma3))
     {
     //Print("Buy condition ma2:"+getDeviationRatio(Ask,ma2)+"ma3:"+getDeviationRatio(Ask,ma3)+"ma1:"+getDeviationRatio(Ask,ma1));
   OrderSend(Symbol(),OP_BUY,lots,Ask,Slippage,0/*(Ask-StopLoss*Point)*/,0,"3SMA",123,0,Green);
     }
   if (ma1<(ma2-SMAspread*Point) && ma2 < (ma3-SMAspread*Point) && sells ==0 && Close[0] < ma1&& getDeviationRatio(Bid,ma1,ma2,ma3))
     {
      //Print("Sell condition ma2:"+getDeviationRatio(Bid,ma2)+"ma3:"+getDeviationRatio(Bid,ma3)+"ma1:"+getDeviationRatio(Bid,ma1));
   OrderSend(Symbol(),OP_SELL,lots,Bid,Slippage,0/*(Bid+StopLoss*Point)*/,0,"3SMA",123,0,Red);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+

   bool getDeviationRatio(double price,double ma1,double ma2,double ma3){
     /** double ratioMa1 = (price-ma1)/ma1*100.0;
      double ratioMa2 = (price-ma2)/ma2*100.0;
      double ratioMa3 = (price-ma3)/ma3*100.0;
      bool result = false;
      if(MathAbs(ratioMa3-ratioMa1)<0.2 && MathAbs(ratioMa2-ratioMa1)<0.2){
         result = true;
      }**/
      
      
     return true;
   }