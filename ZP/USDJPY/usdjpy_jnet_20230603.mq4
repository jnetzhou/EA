//+------------------------------------------------------------------+
//|                                         usdjpy_jnet_20230603.mq4 |
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
extern double Lots = 0.05;
extern int ProfitTarget = 100;
extern int TrailingStop = 50;
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+


bool IsNewBar()
{
   static datetime newtime = 0;
   if (newtime != Time[0])
   {
      newtime = Time[0];
      return(true);
   }
   return(false);
}

void OnTick()
{
    if(!IsNewBar()) {
      return;
    }
    if (Period() != PERIOD_M15)
        return;

    static bool isLongTrade = false;
    static bool isShortTrade = false;

    double ma5 = iMA(Symbol(), PERIOD_M15, 5, 0, MODE_SMA, PRICE_CLOSE, 0);
    double ma10 = iMA(Symbol(), PERIOD_M15, 10, 0, MODE_SMA, PRICE_CLOSE, 0);
    double ma60 = iMA(Symbol(), PERIOD_M15, 60, 0, MODE_SMA, PRICE_CLOSE, 0);
    double close = Close[0];
    double low1 = Low[1];
    double low2 = Low[2];
    double high1 = High[1];
    double high2 = High[2];

    // 检查条件并执行交易操作
    if (ma5 > ma10 && close < ma10 && close < ma60)
    {
        if (!isShortTrade)
        {
            // 平掉已有的多单
            CloseAllBuyOrders();
            // 新开空单
            OpenSellOrder();
            isShortTrade = true;
        }
    }
    else if (ma5 < ma10 && close > ma10 && close > ma60)
    {
        if (!isLongTrade)
        {
            // 平掉已有的空单
            CloseAllSellOrders();
            // 新开多单
            OpenBuyOrder();
            isLongTrade = true;
        }
    }
    /*else if (ma5 < ma10 && close < ma10)
    {
        // 价格低于均线，平掉所有多单
        CloseAllBuyOrders();
        isLongTrade = false;
    }
    else if (ma5 > ma10 && close > ma10)
    {
        // 价格高于均线，平掉所有空单
        CloseAllSellOrders();
        isShortTrade = false;
    }*/

    MoveStopLoss();
}

void MoveStopLoss()
{
    int totalOrders = OrdersTotal();

    for (int i = totalOrders - 1; i >= 0; i--)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL))
            {
                double currentStopLoss = OrderStopLoss();
                double currentTakeProfit = OrderTakeProfit();
                double trailingStopLoss = 0;

                if (OrderType() == OP_BUY)
                {
                    trailingStopLoss = Bid - TrailingStop * Point;

                    if (currentStopLoss < trailingStopLoss)
                    {
                        OrderModify(OrderTicket(), OrderOpenPrice(), trailingStopLoss, currentTakeProfit, 0, clrNONE);
                    }
                }
                else if (OrderType() == OP_SELL)
                {
                    trailingStopLoss = Ask + TrailingStop * Point;

                    if (currentStopLoss > trailingStopLoss)
                    {
                        OrderModify(OrderTicket(), OrderOpenPrice(), trailingStopLoss, currentTakeProfit, 0, clrNONE);
                    }
                }
            }
        }
    }
}

void CloseAllBuyOrders()
{
    int totalOrders = OrdersTotal();

    for (int i = totalOrders - 1; i >= 0; i--)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderType() == OP_BUY)
            {
                OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
            }
        }
    }
}

void CloseAllSellOrders()
{
    int totalOrders = OrdersTotal();

    for (int i = totalOrders - 1; i >= 0; i--)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderType() == OP_SELL)
            {
                OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
            }
        }
    }
}

void OpenSellOrder()
{
    double stopLoss = High[2];
    double takeProfit = Ask - ProfitTarget * Point;

    OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, stopLoss, takeProfit, "Sell Order", 0, 0, Red);
}

void OpenBuyOrder()
{
    double stopLoss = Low[2];
    double takeProfit = Bid + ProfitTarget * Point;

    OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, stopLoss, takeProfit, "Buy Order", 1, 0, Blue);
}