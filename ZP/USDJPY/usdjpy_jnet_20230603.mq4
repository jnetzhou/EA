// 输入参数
extern int stopLossPips = 10; // 止损点数
extern double stopLossATRMultiplier = 1.5; // 止损ATR倍数
extern double takeProfitATRMultiplier = 1.0; // 止盈ATR倍数
extern int maxOrdersPerHour = 1; // 每小时最大下单次数

// 全局变量
bool isTradeAllowed = true; // 是否允许交易
int ordersPlaced = 0; // 当前小时下单次数
datetime lastOrderTime; // 上次下单时间
double atr; // 平均真实波幅

// 在OnInit函数中计算ATR值
int OnInit()
{
    // 设置时间周期为5分钟
    if (Period() != PERIOD_M5)
    {
        Print("请将程序运行在5分钟周期上");
        return INIT_FAILED;
    }

    // 计算ATR
    atr = iATR(NULL, 0, 14, 0);

    return INIT_SUCCEEDED;
}

// 在OnTick函数中执行交易逻辑
void OnTick()
{
    // 检测是否为新的一根K线
    if (IsNewBar())
    {
        // 获取指标数值
        double ma5 = iMA(NULL, 0, 5, 0, MODE_SMA, PRICE_CLOSE, 0);
        double ma10 = iMA(NULL, 0, 10, 0, MODE_SMA, PRICE_CLOSE, 0);
        double ma20 = iMA(NULL, 0, 20, 0, MODE_SMA, PRICE_CLOSE, 0);
        double ma30 = iMA(NULL, 0, 30, 0, MODE_SMA, PRICE_CLOSE, 0);
        double ma60 = iMA(NULL, 0, 60, 0, MODE_SMA, PRICE_CLOSE, 0);

        // 获取前一根K线的最高点和最低点
        double prevHigh = High[1];
        double prevLow = Low[1];

        // 获取当前价格
        double currentPrice = Close[0];

        // 判断是否满足做空条件
        bool shouldSell = ma5 < ma60 && ma10 < ma60 && ma20 < ma60 && ma30 < ma60 && currentPrice < ma5;

        // 判断是否满足做多条件
        bool shouldBuy = ma5 > ma60 && ma10 > ma60 && ma20 > ma60 && ma30 > ma60 && currentPrice > ma5;

        // 检查是否可以继续下单
        if (!CanPlaceOrder())
        {
            return;
        }

         double stopLoss,takeProfit;
        // 做空
        if (shouldSell)
        {
            // 计算止损和止盈
            stopLoss = prevHigh + stopLossPips * Point;
            takeProfit = currentPrice - takeProfitATRMultiplier * atr;

            // 执行卖出操作
            SendOrder(OP_SELL, 0.1, stopLoss, takeProfit);
        }
        // 做多
        else if (shouldBuy)
        {
            // 计算止损和止盈
            stopLoss = prevLow - stopLossPips * Point;
            takeProfit = currentPrice + takeProfitATRMultiplier * atr;

            // 执行买入操作
            SendOrder(OP_BUY, 0.1, stopLoss, takeProfit);
        }
    }
}

// 判断是否为新的一根K线
bool IsNewBar()
{
    static datetime lastTime = 0;
    datetime currentTime = Time[0];

    if (lastTime != currentTime)
    {
        lastTime = currentTime;
        return true;
    }

    return false;
}

// 检查是否可以继续下单
bool CanPlaceOrder()
{
    datetime currentTime = TimeCurrent();
    int currentHour = TimeHour(currentTime);

    // 检查是否超过每小时最大下单次数
    if (ordersPlaced >= maxOrdersPerHour && currentHour == TimeHour(lastOrderTime))
    {
        return false;
    }

    // 检查是否跨越新的一小时，重置下单次数
    if (currentHour != TimeHour(lastOrderTime))
    {
        ordersPlaced = 0;
    }

    return true;
}

// 发送订单函数
void SendOrder(int orderType, double volume, double stopLoss, double takeProfit)
{
    int slippage = 3; // 滑点

    // 设置止损和止盈
    double slPrice = NormalizeDouble(stopLoss, Digits);
    double tpPrice = NormalizeDouble(takeProfit, Digits);

    // 执行下单操作
    int ticket = OrderSend(Symbol(), orderType, volume, Ask, slippage, slPrice, tpPrice, "MyOrder", 0, 0, Green);

    if (ticket > 0)
    {
        // 下单成功，更新相关变量
        ordersPlaced++;
        lastOrderTime = TimeCurrent();

        Print("下单成功：", ticket);
    }
    else
    {
        Print("下单失败，错误码：", GetLastError());
    }
}
