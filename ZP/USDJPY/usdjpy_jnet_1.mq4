//+------------------------------------------------------------------+
//|                                                usdjpy_jnet_1.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "jnetzhou"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//运行在15分钟的策略
//注意该策略所有下的单都必须要设置止损价格
//因为有些判断准则会引用单子的止损价格来做筛选条件

string symbol = "USDJPYm";             //品种
int period = PERIOD_M15;               //周期

double sameDirectionLots = 0.1;        //与日线方向一致下单的手数
double notSameDirectionLots = 0.05;    //与日线方向不一致下单的手数
double strengthRatio = 0.0;            // ( close - open ) / open
const int DIRECTION_LONG = 1;          //方向常量-多
const int DIRECTION_SHORT = -1;        //方向常量-空
const int DIRECTION_UNKNOWN = 0;       //方向常量-未知

const int maxStopLossCnt = 10;          //当天最大止损次数
const int maxKeepOrderCnt = 0.3;         //当天最大的持仓手数
const int maxStopLossCntOneSymbol = 3; //单一品种当日最大止损次数
const int slippage = 3;                //滑点数
datetime g_LastTradingDay = 0;         // 记录最后交易日的日期
int g_StopLossCount = 0;               // 记录当天的止损次数

enum Direction {
   LONG,
   SHORT,
   NOT_KNOWN
};

int OnInit() {

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---

}

/**
判断当前周期中这根是否新的K线
*/
bool isNewKBar() {
   static datetime newtime = 0;
   if (newtime != Time[0]) {
      newtime = Time[0];
      return true;
   }
   return false;
}


// 判断是否是新的交易日
bool isNewTradingDay() {
   datetime currentTime = TimeCurrent();

   // 检查当前日期是否与最后交易日不同
   if (TimeDay(currentTime) != TimeDay(g_LastTradingDay)) {
      return true;
   }
   return false;
}

// 检查止损次数是否超过3次，并在超过时停止运行
bool checkStopLossCountInDay() {
   if (g_StopLossCount >= maxStopLossCnt) {
      // 停止运行，等待第二天再启动
      return true;
   }
   return false;
}

/**
*  获得当天的止损单子总数
*/
int getStopLossCountForCurrentDay() {
   int stopLossCount = 0;
   datetime currentDayStart = iTime(NULL, PERIOD_D1, 0); // 当天开始时间
   datetime currentDayEnd = currentDayStart + 86399; // 当天结束时间

   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         // 检查订单是否是当天的订单
         if (OrderOpenTime() >= currentDayStart && OrderOpenTime() <= currentDayEnd) {
            // 检查订单是否是止损单
            if (OrderType() == OP_SELL || OrderType() == OP_BUY) {
               double stopLoss = OrderStopLoss();
               double profit = OrderProfit();
               if (stopLoss != 0.0 && profit < 0) {
                  stopLossCount++;
               }
            }
         }
      }
   }

   return stopLossCount;
}

/**
   获得当前EA运行的品种当天的止损次数
**/
int getStopLossCountForCurrentDayAndCurrentSymbol() {

   datetime currentDayStart = iTime(NULL, PERIOD_D1, 0); // 当天开始时间
   datetime currentDayEnd = currentDayStart + 86399; // 当天结束时间
   int stopLossCount = 0;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         // 检查订单是否是当天的订单
         if (OrderOpenTime() >= currentDayStart && OrderOpenTime() <= currentDayEnd) {
            // 检查订单是否是USDJPY的止损单
            if (OrderSymbol() == Symbol() &&
                  (OrderType() == OP_SELL || OrderType() == OP_BUY)) {
               double stopLoss = OrderStopLoss();
               double profit = OrderProfit();
               if (stopLoss != 0.0 && profit < 0) {
                  stopLossCount++;
               }
            }
         }
      }
   }

   return stopLossCount;
}

/*
Ask:开多单和平仓空单的价格

Bid:开空单或平仓多单的价格
*/
/**
平仓当前品种所有多单
*/
void closeAllBuyOrders() {
   int totalOrders = OrdersTotal();

   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() == OP_BUY) {
            OrderClose(OrderTicket(), OrderLots(), Bid, slippage, clrNONE);
         }
      }
   }
}

/**
平仓当前品种所有空单
**/
void closeAllSellOrders() {
   int totalOrders = OrdersTotal();

   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() == OP_SELL) {
            OrderClose(OrderTicket(), OrderLots(), Ask, slippage, clrNONE);
         }
      }
   }
}


/*
平仓当前品种 minPrice-maxPrice的多单
*/
void closeBuyOrdersInRange(double minPrice, double maxPrice) {
   int totalOrders = OrdersTotal();

   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderOpenPrice() >= minPrice && OrderOpenPrice() <= maxPrice) {
            OrderClose(OrderTicket(), OrderLots(), Bid, slippage, clrNONE);
         }
      }
   }
}

/*
平仓当前品种 minPrice-maxPrice的空单
*/
void closeSellOrdersInRange(double minPrice, double maxPrice) {
   int totalOrders = OrdersTotal();

   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderOpenPrice() >= minPrice && OrderOpenPrice() <= maxPrice) {
            OrderClose(OrderTicket(), OrderLots(), Ask, slippage, clrNONE);
         }
      }
   }
}


/**
获取指定品种持单总手数
**/
double getTotalEffectiveOrderLotsBySymbol(string symbol) {
   double lots = 0;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if ( OrderSymbol() == symbol && OrderCloseTime() == 0 ) {
            lots += OrderLots();
         }
      }
   }
   return count;
}

/**
获取当前有效的订单总手数
*/
double getCurrentDayTotalEffectiveOrderLotsForSymbol(string symbol) {
   double lots = 0.0;
   int totalOrders = OrdersTotal();
   if(totalOrders > 0) {
      for(int i = totalOrders - 1; i >= 0; i--) {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) {
            if( OrderSymbol() == symbol &&( OrderType() == OP_BUY || OrderType() == OP_SELL ) && OrderCloseTime() == 0
            && TimeDay(OrderOpenTime()) == TimeDay(TimeCurrent())
            ) {   //还没关闭的单子
               lots += OrderLots();
            }
         }
      }
   }
   return lots;
}

/**
获取当天有效的订单总手数
*/
double getTotalEffectiveOrderLots() {
   double lots = 0.0;
   int totalOrders = OrdersTotal();
   if(totalOrders > 0) {
      for(int i = totalOrders - 1; i >= 0; i--) {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) {
            if(( OrderType() == OP_BUY || OrderType() == OP_SELL ) && OrderCloseTime() == 0) {   //还没关闭的单子
               lots += OrderLots();
            }
         }
      }
   }
   return lots;
}

/**
   是否多头K线
*/
bool isKBarLong(int shift) {
   double open = Open[shift];
   double close = Close[shift];
   return open < close;
}

/**
   是否空头K线
*/
bool isKBarShort(int shift) {
   double open = Open[shift];
   double close = Close[shift];
   return open > close;
}


/**
前N根k线是否连续是多头
*/
bool prevKBarsIsLong(int n) {
   bool isMatch = false;
   if( n > 0) {
      for( int i = 1; i <= n; i++) {
         isMatch = isKBarLong(i);
         if(isMatch == false) {
            break;
         }
      }
   }
   return isMatch;
}

/**
前N根k线是否连续是空头
*/
bool prevKBarsIsShort(int n) {
   bool isMatch = false;
   if( n > 0) {
      for( int i = 1; i <= n; i++) {
         isMatch = isKBarLong(i);
         if(isMatch == false) {
            break;
         }
      }
   }
   return isMatch;
}

/**
判断指定的K线是否为强K
**/
bool isStrengthKBar(int shift) {
   double open = Open[shift];
   double close = Close[shift];
   double high = High[shift];
   double low = Low[shift];

   double candleBody = MathAbs(close - open);
   double upperShadowBody = high - open;
   double lowerShadowBody = close - low;
   //实体部分大于(上下影线的实体部分之和*因子 )则认为是强K
   return candleBody > (upperShadowBody + lowerShadowBody) * 0.85;
}


/*
   猜测当前周期方向
*/
int guessDirection() {
   int direction = DIRECTION_UNKNOWN;
   double longStrength = 0.0;
   double shortStrength = 0.0;
   //计算前N根K线强度来估算方向
   int cnt = 4;
   for(int i = 1; i <= cnt; i++) {
      double open = Open[i];
      double close = Close[i];
      double candleBody = MathAbs(close - open);
      if(open < close) {
         longStrength += candleBody;
      } else {
         shortStrength += candleBody;
      }

   }

   printf("longStrength:" + longStrength);
   printf("shortStrength:" + shortStrength);
   if(longStrength > shortStrength ) {
      printf("多头");
      direction = DIRECTION_LONG;
   } else {
      printf("空头");
      direction = DIRECTION_SHORT;
   }
   return direction;
}


/**
是否适合下单
**/
bool isSuitToMakeOrder() {
   bool isSuit = false;
   int direction = guessDirection();
   if((direction == DIRECTION_LONG && isKBarLong(1))
      || (direction == DIRECTION_SHORT && isKBarShort(1))
   ) {
      isSuit = true;
   } 
   return isSuit && isStrengthKBar(1);
   return isSuit;
}


void OnTick() {

   //所有附加该品种的EA当日暂停检测
   if(getStopLossCountForCurrentDay() > maxStopLossCnt) {
      return;
   }

   //该品种超过当天最大止损次数，检测暂停至新一交易日
   if(getStopLossCountForCurrentDayAndCurrentSymbol() > maxStopLossCntOneSymbol) {
      return;
   }

   if(!isNewKBar()) {
      return;
   }

   /*double ma5 = iMA(NULL, period, 5, 0, MODE_SMA, PRICE_OPEN, 0);
   double ma10 = iMA(NULL, period, 10, 0, MODE_SMA, PRICE_OPEN, 0);
   double ma20 = iMA(NULL, period, 20, 0, MODE_SMA, PRICE_OPEN, 0);
   double ma30 = iMA(NULL, period, 30, 0, MODE_SMA, PRICE_OPEN, 0);
   double ma60 = iMA(NULL, period, 60, 0, MODE_SMA, PRICE_OPEN, 0);
   double ma240 = iMA(NULL,period,240,0,MODE_SMA,PRICE_OPEN,0);

   double curKOpenPrice = iOpen(NULL,period,0);*/
   printf(Symbol());
   string msg = "(" + Symbol() + " guess Direction: " + (guessDirection() == DIRECTION_LONG ? "多" : "空" )  + ")";
   printf(msg);

   if(Symbol() == "USDJPYm") {
      printf("当前品种匹配");
   } else {
      printf("当前品种不匹配");
   }

}

//+------------------------------------------------------------------+
