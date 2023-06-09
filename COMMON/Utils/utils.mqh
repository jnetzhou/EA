//+------------------------------------------------------------------+
//|                                                        utils.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

/**
判断是否当前周期的新K线
*/
bool IsNewKBar()
{
   static datetime newtime = 0;
   if (newtime != Time[0])
   {
      newtime = Time[0];
      return true;
   }
   return false;
}

/**
判断当前运行的脚本品种是否指定品种
*/
bool IsSymbolMatch(const string& symbol)
{
    string currentSymbol = Symbol();
    return (currentSymbol == symbol);
}

/**
将点数转换成价格
*/
double PointsToPrice(double points)
{
    double price = points / Point;
    return price;
}

/**
将价格转换成点数
*/
double PriceToPoints(double price)
{
    double point = Point;
    double points = price / point;
    return points;
}

/**
函数将美元金额除以每个点的价值和市场的点值来计算对应的点数值，并返回结果

void ExampleUsage()
{
    double stopLossAmountUSD = 20.0;  // 假设止损金额为 20 美元
    double stopLossPoints = AmountToPoints(stopLossAmountUSD);

    Print("止损金额(美元):", stopLossAmountUSD);
    Print("止损点数:", stopLossPoints);
}
*/
double AmountToPoints(double amount)
{
    double point = Point;
    double points = amount / (point * MarketInfo(Symbol(), MODE_TICKVALUE));
    return points;
}

double CalculatePointValue(double lotSize)
{
    double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
    return lotSize * tickSize;
}


/**
平仓所有多单
*/
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

/**
平仓所有空单
**/
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


/*
平仓 minPrice-maxPrice的多单
*/
void CloseBuyOrdersInRange(double minPrice, double maxPrice)
{
    int totalOrders = OrdersTotal();

    for (int i = totalOrders - 1; i >= 0; i--)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderOpenPrice() >= minPrice && OrderOpenPrice() <= maxPrice)
            {
                OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
            }
        }
    }
}

/*
平仓 minPrice-maxPrice的空单
*/
void CloseSellOrdersInRange(double minPrice, double maxPrice)
{
    int totalOrders = OrdersTotal();

    for (int i = totalOrders - 1; i >= 0; i--)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderOpenPrice() >= minPrice && OrderOpenPrice() <= maxPrice)
            {
                OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
            }
        }
    }
}

