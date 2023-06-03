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

// 封装发送订单的函数
void SendOrderEx(string symbol, bool isBuy, double volume, double stopLoss, double takeProfit)
{
    double slippage = 5;  // 设置滑点值

    // 获取当前市场价格
    double price = isBuy == true ? MarketInfo(symbol, MODE_ASK) : MarketInfo(symbol, MODE_BID);

    // 设置订单参数
    int cmd = isBuy == true ? OP_BUY : OP_SELL;
    double deviation = 10;

    // 发送订单
    int ticket = OrderSend(symbol, cmd, volume, price, deviation, stopLoss, takeProfit, "MyOrder", 0, 0, isBuy ? clrGreen : clrRed);

    // 检查订单发送结果
    if (ticket < 0)
    {
        // 发送订单失败
        Print("Failed to send order. Error code xxxxxxxxxx: ", GetLastError());
    }
    else
    {
        // 发送订单成功
        Print("Order sent successfully. Ticket xxxxxxxxxx: ", ticket);
    }
}

bool isTrade = false;
void OnTick()
  {
//---
   //if(!isTrade) {
    //  isTrade = true;
      SendOrderEx(NULL,true,0.1,0,0);
   //}
  }
//+------------------------------------------------------------------+
