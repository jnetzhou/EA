//+------------------------------------------------------------------+
//|                                                           om.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string symbol = Symbol();
int period = 0;
double is_lock_position = false; //锁仓标识
double is_retrace = false;      //是否回撤
double adjust_mark_price = 0;    //回调的标识价格、超过这个就自动解仓
double start_position_lots = 0.03;//开始持仓手数
double add_position_lots = 0.02; //加仓手数

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
//---

//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
{
   static datetime newtime = 0;
   if (newtime != Time[0])
   {
      newtime = Time[0];
      return(true);
   }
   return(false);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isAdjusting(bool isLong,double price,double ma10)
{
   if(isLong)
   {
      return price < ma10;
   }
   else
   {
      return price > ma10;
   }
   return false;
}

/**
   锁仓  long: true-做对应的手数的空单/false- 做对应的手数的多单 来锁
*/
bool lockPosition(bool isLong)
{
   int lots = getActiveLotsByType(isLong ? OP_BUY : OP_SELL);
   int cmd = isLong ? OP_SELL : OP_BUY;
   double price = ( cmd == OP_BUY ? Ask : Bid );
   int slippage = 3;
   double stopLoss = 0;
   if(isLong)   // long
   {
      cmd = OP_BUY;
      stopLoss = NormalizeDouble(iLow(symbol,period,1) - Point * 5,Digits);
   }
   else     // short
   {
      cmd = OP_SELL;
      stopLoss = NormalizeDouble(iHigh(symbol,period,1) + Point * 5,Digits);
   }
   int ticket = OrderSend(symbol,cmd,lots,price,slippage,stopLoss,0,NULL,0,0,cmd == OP_BUY?clrGreen:clrRed);
   return ticket > -1 ? true : false;
}

/**
   解仓 isLong 当前方向 true为多,解锁为平仓空单,相反亦然
*/
bool unlockPosition(bool isLong)
{
   stopOrders(isLong ? OP_SELL : OP_BUY);
   return false;
}

/**
   加仓
*/
bool addPosition(bool isLong)
{
   int lots = add_position_lots;
   int cmd = isLong ? OP_BUY : OP_SELL;
   double price = ( cmd == OP_BUY ? Ask : Bid );
   int slippage = 3;
   double stopLoss = 0;
   if(isLong)   // long
   {
      cmd = OP_BUY;
      stopLoss = NormalizeDouble(iLow(symbol,PERIOD_H1,1) - Point * 5,Digits);
   }
   else     // short
   {
      cmd = OP_SELL;
      stopLoss = NormalizeDouble(iHigh(symbol,PERIOD_H1,1) + Point * 5,Digits);
   }
   int ticket = OrderSend(symbol,cmd,lots,price,slippage,stopLoss,0,NULL,0,0,cmd == OP_BUY?clrGreen:clrRed);
   return ticket > -1 ? true : false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool makeOneOrder(double lots,int type)
{
   double price = 0;
   int slippage = 3;
   double stopLoss = 0;
   if(type == OP_BUY)
   {
      price = Ask;
      stopLoss = NormalizeDouble(getMinLowPrice(5,PERIOD_H1),Digits);
   }
   else
   {
      price = Bid;
      stopLoss = NormalizeDouble(getMaxHighPrice(5,PERIOD_H1),Digits);
   }
   int ticket = OrderSend(symbol,type,lots,price,slippage,stopLoss,0,NULL,0,0,type == OP_BUY?clrGreen:clrRed);
   if(ticket > -1)
   {
      Print("makeOneOrder() 成功 " + " lots:" + lots + " type:" + type );
   }
   else
   {
      Print("makeOneOrder() 失败 " + " lots:" + lots + " type:" + type + " " + GetLastError());
   }
   return ticket > -1 ? true : false;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getActiveOrderCountByType(int type)
{
   int count = 0;
   if(OrdersTotal() > 0)
   {
      for(int i = 0; i < OrdersTotal(); i++)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == type)
            {
               ++count;
            }
         }
      }
   }
   return count;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getActiveLotsByType(int type)
{
   double lots = 0.0;
   int count = 0;
   if(OrdersTotal() > 0)
   {
      for(int i = 0; i < OrdersTotal(); i++)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == type && StringCompare(OrderSymbol(),Symbol()) == 0)
            {
               lots += OrderLots();
            }
         }
      }
   }
   return lots;
}

/**
   平仓 type: OP_BUY/OP_SELL
*/
void stopOrders(int type)
{
   while(getActiveOrderCountByType(type) > 0)
   {
      for(int i = 0; i < OrdersTotal(); i++)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == type && StringCompare(OrderSymbol(),Symbol()) == 0)
            {
               if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrNONE))
               {
                  Print("平仓成功 OrderTicket:" + IntegerToString(OrderTicket()));
               }
               else
               {
                  Print("平仓失败 OrderTicket:" + IntegerToString(OrderTicket()) + " Error:" + GetLastError());
               }
            }
         }
      }
   }
}

/**
   判断是否适合加仓
*/
bool isSuitToAddPosition(bool isLong)
{
   double maxPosition = 0.01;
   double account = AccountBalance();  //获取当前余额
   if(account > 50.0 && account < 100.0)
   {
      maxPosition = 0.02;
   }
   else if(account > 100.00 && account < 150.0)
   {
      maxPosition = 0.05;
   }
   else if(account > 150.0)      //每增加50$可增持0.01
   {
      maxPosition = 0.05 + (((int)( account - 100.0 )) / 50) * 0.01;
   }
   double lots = getActiveLotsByType(isLong ? OP_BUY : OP_SELL);
   if(lots < maxPosition)
   {
      return true;
   }
   return false;
}

/**
   计算持仓头寸
*/
double calculatePosition()
{
   return 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getMaxHighPrice(int knum,int period)
{
   double highPrice = 0,price;
   for(int i = 1; i <= knum; i++)
   {
      price = iHigh(NULL,period,i);
      if(highPrice == 0)
      {
         highPrice = price;
      }
      else
      {
         highPrice = MathMax(highPrice,price);
      }
   }
   return highPrice;
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getMinLowPrice(int knum,int period)
{
   double lowPrice = 0,price;
   for(int i = 1; i <= knum; i++)
   {
      price = iLow(NULL,period,i);
      if(lowPrice == 0)
      {
         lowPrice = price;
      }
      else
      {
         lowPrice = MathMin(lowPrice,price);
      }
   }
   return lowPrice;
}

/**
   调整止损
*/
void stopLossAdjust(int type,int knum)
{
   double stopLoss = 0.0,price = 0.0,ref_price = 0.0;
   for(int i = 1; i <= knum; i++)
   {
      if(type == OP_BUY)
      {
         price = iLow(symbol,period,i);
         if(ref_price == 0.0)
         {
            ref_price = price;
         }
         else
         {
            stopLoss = MathMin(ref_price,price);
         }
      }
      else     // sell
      {
         price = iHigh(symbol,period,i);
         if(ref_price == 0.0)
         {
            ref_price = price;
         }
         else
         {
            stopLoss = MathMax(ref_price,price);
         }
      }
   }

   //遍历所有type类型的单
   int orderCount = OrdersTotal();
   if(orderCount > 0)
   {
      bool isModified = false;
      for(int i = 0; i < orderCount; i++)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == type && StringCompare(OrderSymbol(),Symbol()) == 0)
            {
               double orderStopLoss = OrderStopLoss();
               if(type == OP_BUY)
               {
                  if(orderStopLoss < stopLoss)     //多单，修改的止损位置必须高于原来止损
                  {
                     isModified = OrderModify(OrderTicket(),OrderOpenPrice(),stopLoss,0,0,0);
                     if(isModified)
                     {
                        Print("多单单子 " + OrderTicket() + " 止损从:" + DoubleToString(orderStopLoss) + "改为:" + DoubleToString(stopLoss) + "成功" );
                     }
                     else
                     {
                        Print("多单单子 " + OrderTicket() + " 止损从:" + DoubleToString(orderStopLoss) + "改为:" + DoubleToString(stopLoss) + "失败:" + GetLastError() );
                     }
                  }
               }
               else     //sell
               {
                  if(orderStopLoss > stopLoss)     //空单，修改的止损位置必须低于原来止损
                  {
                     isModified = OrderModify(OrderTicket(),OrderOpenPrice(),stopLoss,0,0,0);
                     if(isModified)
                     {
                        Print("空单单子 " + OrderTicket() + " 止损从:" + DoubleToString(orderStopLoss) + "改为:" + DoubleToString(stopLoss) + "成功" );
                     }
                     else
                     {
                        Print("空单单子 " + OrderTicket() + " 止损从:" + DoubleToString(orderStopLoss) + "改为:" + DoubleToString(stopLoss) + "失败:" + GetLastError() );
                     }
                  }
               }
            }
         }
      }
   }

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void runWorkTask()
{
   if(!isNewBar())
   {
      Print("当前K线已做判断,暂不进行下一步操作!");
      return;
   }
// testMakeOrder(OP_BUY);
   // return;
//---
   //方向:多空在于价格是否处于MA60之上(下)
   //是否回调:没有变方向(价格仍处于原来MA60) 以MA10作为回调参考
   double prev1Ma5  = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma10 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma20 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma30 = iMA(symbol,period,30,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma60 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,1);

   double prev2Ma5  = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,2);
   double prev2Ma10 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,2);
   double prev2Ma20 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,2);
   double prev2Ma30 = iMA(symbol,period,30,0,MODE_SMA,PRICE_CLOSE,2);
   double prev2Ma60 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,2);

   double prev1KClose = iClose(symbol,period,1);
   double prev2KClose = iClose(symbol,period,2);
   double prev3KClose = iClose(symbol,period,3);
   double prev4KClose = iClose(symbol,period,4);



   bool prev1Ma5_10 = prev1Ma5 > prev1Ma10;
   bool prev1Ma10_5 = prev1Ma10 > prev1Ma5;
   bool prev1Ma5_10_20 = prev1Ma5 > prev1Ma10 && prev1Ma10 > prev1Ma20;
   bool prev1Ma20_10_5 = prev1Ma20 > prev1Ma10 && prev1Ma10 > prev1Ma5;
   bool prev1Ma5_10_20_30 = prev1Ma5 > prev1Ma10 && prev1Ma10 > prev1Ma20 && prev1Ma20 > prev1Ma30;
   bool prev1Ma30_20_10_5 = prev1Ma30 > prev1Ma20 && prev1Ma20 > prev1Ma10 && prev1Ma10 > prev1Ma5;

   bool isLong = prev1Ma5 > prev1Ma10 && prev1Ma10 > prev1Ma60;
   bool isShort = prev1Ma5 < prev1Ma10 && prev1Ma10 < prev1Ma60;

   if(prev1Ma5 > prev1Ma10 && prev1Ma10 > prev1Ma20 && prev1Ma20 > prev1Ma30)   //long
   {
      stopOrders(false);  //平掉空单
      if(prev1KClose < prev1Ma10)     //回调
      {
         /*if(!is_lock_position) {   //          //非锁仓状态
           if(lockPosition(true)) {
              is_lock_position = true;
              adjust_mark_price = prev1KClose;
           }
         } else {     //如果是锁仓状态
           if(prev1KClose > prev1Ma10) {
              /*if(is_lock_position) {  //锁仓状态
                 if(unlockPosition(true)) { //解锁
                    is_lock_position = false;
                    adjust_mark_price = 0;
                    //if(isSuitToAddPosition(true)) {  //判断是否适合加仓
                       //加仓
                    addPosition(true);
                   // }
                   //调整止损
                   //stopLossAdjust(OP_BUY,5);
                 }
              }
           }
         }*/
         stopOrders(true);   //平掉多单
         //if(getActiveLotsByType(OP_SELL) == 0) {
         //   makeOneOrder(start_position_lots,OP_SELL);
         //}
      }
      else       //非回调状态
      {
         //看看有没有单子,没有就加一单测试
         if(getActiveLotsByType(OP_BUY) == 0)
         {
            makeOneOrder(start_position_lots,OP_BUY);
         }

      }
   }
   else if(prev1Ma5 < prev1Ma10 && prev1Ma10 < prev1Ma20 && prev1Ma20 < prev1Ma30)     //short 前两根K线都处于MA60之下认为是空头
   {
      stopOrders(true); //平掉多单
      if(prev1KClose > prev1Ma10)   //回调
      {
         /*
            //锁仓
            if(!is_lock_position) {    //非锁仓状态
               if(lockPosition(false)) {
                  is_lock_position = true;
                  adjust_mark_price = prev1KClose;
               }
            } else { //在锁仓状态下,判断需不需要解锁
               if(prev1KClose < prev1Ma10) {
                 if(is_lock_position) {
                   if(unlockPosition(false)) {  //解锁
                     is_lock_position = false;
                     adjust_mark_price = 0;
                     addPosition(false);
                     //调整止损
                     //stopLossAdjust(OP_SELL,5);
                   }
                 }
               }
            }*/
         stopOrders(false);   //平掉空单
         //if(getActiveLotsByType(OP_BUY) == 0) {
         //   makeOneOrder(start_position_lots,OP_BUY);
         // }

      }
      else
      {
         //看看有没有单子,没有就加一单测试
         if(getActiveLotsByType(OP_SELL) == 0)
         {
            makeOneOrder(start_position_lots,OP_SELL);
         }
      }
   }
   else
   {
      //do nothing
      Print("没有合适机会，先观望...");
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void mainTask2()
{

   if(!isNewBar())
   {
      Print("当前K线已做判断,暂不进行下一步操作!");
      return;
   }

   double prev1Ma5 = iMA(symbol,PERIOD_H1,5,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma10 = iMA(symbol,PERIOD_H1,10,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma20 = iMA(symbol,PERIOD_H1,20,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma30 = iMA(symbol,PERIOD_H1,30,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Ma60 = iMA(symbol,PERIOD_H1,60,0,MODE_SMA,PRICE_CLOSE,1);
   double prev1Close = iClose(symbol,PERIOD_H1,1);

   if(prev1Ma5 > prev1Ma10 && prev1Ma10 > prev1Ma20 && prev1Ma20 > prev1Ma30 && prev1Ma30 > prev1Ma60)
   {
      if(prev1Close > prev1Ma10)
      {
         if(getActiveLotsByType(OP_BUY) == 0)
         {
            makeOneOrder(start_position_lots,OP_BUY);
         }
      }
      else
      {
         stopOrders(true);
      }
   }
   else if(prev1Ma5 < prev1Ma10 && prev1Ma10 < prev1Ma20 && prev1Ma20 < prev1Ma30 && prev1Ma30 < prev1Ma60)
   {
      if(prev1Close < prev1Ma10)
      {
         if(getActiveLotsByType(OP_SELL) == 0)
         {
            makeOneOrder(start_position_lots,OP_SELL);
         }
      }
      else
      {
         stopOrders(false);
      }
   }
   else
   {
      Print("没有合适机会，先观望...");
   }

}

int direction = -1; // 0 long 1 short -1 no direction

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isFaraway()
{

   double ma5 = iMA(symbol,PERIOD_H1,5,0,MODE_SMA,PRICE_CLOSE,1);
   double ma60 = iMA(symbol,PERIOD_H1,60,0,MODE_SMA,PRICE_CLOSE,1);
   double open = iOpen(symbol,PERIOD_H1,1);
   double close = iClose(symbol,PERIOD_H1,1);
   double distance_ma = ma5 > ma60 ? ma5 - ma60 : ma60 - ma5;
   double delta = open > close ? open - close : close - open;
   if(delta == 0)
   {
      return false;
   }
   return distance_ma / delta > 6 ? true : false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void extTask()
{

   if(!isNewBar())
   {
      Print("当前K线已做判断,暂不进行下一步操作!");
      return;
   }
   double ma5_prev1  = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,1);
   double ma10_prev1 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,1);
   double ma20_prev1 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,1);
   double ma30_prev1 = iMA(symbol,period,30,0,MODE_SMA,PRICE_CLOSE,1);
   double ma60_prev1 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,1);

   double ma5_prev2  = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,2);
   double ma10_prev2 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,2);
   double ma20_prev2 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,2);
   double ma30_prev2 = iMA(symbol,period,30,0,MODE_SMA,PRICE_CLOSE,2);
   double ma60_prev2 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,2);

   double prev1KClose = iClose(symbol,PERIOD_H1,1);
   double prev2KClose = iClose(symbol,PERIOD_H1,2);

   if(ma5_prev1 < ma10_prev1 && ma5_prev1 > ma60_prev1 || prev1KClose < ma20_prev1)
   {
      stopOrders(OP_BUY);
   }

   if(ma5_prev1 > ma10_prev1 && ma5_prev1 < ma60_prev1 || prev1KClose > ma20_prev1)
   {
      stopOrders(OP_SELL);
   }
   if(ma5_prev1 > ma10_prev1 && ma10_prev1 > ma20_prev1 && ma20_prev1 > ma30_prev1)
   {
      if(prev1KClose > ma5_prev1)
      {
         stopOrders(OP_SELL);
         if(getActiveLotsByType(OP_BUY) == 0)
         {
            makeOneOrder(start_position_lots,OP_BUY);
         }
      }
   }
   else if(ma5_prev1 < ma10_prev1 && ma10_prev1 < ma20_prev1 && ma20_prev1 < ma30_prev1)
   {
      if(prev1KClose < ma5_prev1)
      {
         stopOrders(OP_BUY);
         if(getActiveLotsByType(OP_SELL) == 0)
         {
            makeOneOrder(start_position_lots,OP_SELL);
         }
      }
   }
   else
   {
      Print("没有合适机会，先观望...");
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void extTask2()
{
   double ma10 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,1);
   double ma20 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,1);
   double ma60 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,1);
   double prevKPrice = iClose(symbol,period,1);
   if(ma20 > ma60 && prevKPrice > ma20)
   {
      stopOrders(OP_SELL);
      if(getActiveLotsByType(OP_BUY) == 0)
      {
         makeOneOrder(start_position_lots,OP_BUY);
      }
   }
   else if(ma20 < ma60 && prevKPrice < ma20)
   {
      stopOrders(OP_BUY);
      if(getActiveLotsByType(OP_SELL) == 0)
      {
         makeOneOrder(start_position_lots,OP_SELL);
      }
   }
   else if(ma20 > ma60 && prevKPrice < ma10)
   {
      stopOrders(OP_BUY);
   }
   else if(ma20 < ma60 && prevKPrice > ma10)
   {
      stopOrders(OP_SELL);
   }
   else
   {
      Print("没有合适机会，先观望...");
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void extTask3()
{

   double ma5_prev1  = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,1);
   double ma10_prev1 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,1);
   double ma20_prev1 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,1);
   double ma30_prev1 = iMA(symbol,period,30,0,MODE_SMA,PRICE_CLOSE,1);
   double ma60_prev1 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,1);

   double ma5_prev2  = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,2);
   double ma10_prev2 = iMA(symbol,period,10,0,MODE_SMA,PRICE_CLOSE,2);
   double ma20_prev2 = iMA(symbol,period,20,0,MODE_SMA,PRICE_CLOSE,2);
   double ma30_prev2 = iMA(symbol,period,30,0,MODE_SMA,PRICE_CLOSE,2);
   double ma60_prev2 = iMA(symbol,period,60,0,MODE_SMA,PRICE_CLOSE,2);

   double prev1KPrice = iClose(symbol,period,1);
   double prev2KPrice = iClose(symbol,period,2);

   bool lg_start_trp = !(ma5_prev2 > ma10_prev2 && ma10_prev2 > ma20_prev2 && ma20_prev2 > ma30_prev2 && prev2KPrice > ma5_prev2)
                       &&ma5_prev1 > ma10_prev1 && ma10_prev1 > ma20_prev1 && ma20_prev1 > ma30_prev1 && prev1KPrice > ma5_prev2;

   bool st_start_trp = !(ma5_prev2 < ma10_prev2 && ma10_prev2 < ma20_prev2 && ma20_prev2 < ma30_prev2 && prev2KPrice < ma5_prev2)
                       &&ma5_prev1 < ma10_prev1 && ma10_prev1 < ma20_prev1 && ma20_prev1 < ma30_prev1 && prev1KPrice < ma5_prev2;

   bool lg_stop_trp = (ma5_prev1 > ma10_prev1 && ma10_prev1 > ma20_prev1 && ma20_prev1 > ma30_prev1 && prev1KPrice < ma10_prev1);
   bool st_stop_trp = (ma5_prev1 < ma10_prev1 && ma10_prev1 < ma20_prev1 && ma20_prev1 < ma30_prev1 && prev1KPrice > ma10_prev1);

   if(lg_start_trp)
   {
      if(getActiveLotsByType(OP_BUY) == 0)
      {
         makeOneOrder(start_position_lots,OP_BUY);
      }
   }
   if(lg_start_trp)
   {
      if(getActiveLotsByType(OP_SELL) == 0)
      {
         makeOneOrder(start_position_lots,OP_SELL);
      }
   }
   if(lg_stop_trp)
   {
      stopOrders(OP_BUY);
   }
   if(st_stop_trp)
   {
      stopOrders(OP_SELL);
   }

}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   // double lots = getActiveLotsByType(OP_BUY);
   //Print("Symbol:" + Symbol() + "lots:" + lots);
   extTask3();
}
//+------------------------------------------------------------------+
