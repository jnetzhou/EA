//+------------------------------------------------------------------+
//|                                                            T.mq4 |
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
int OnInit() {
   string smtpServer = "smtp.163.com";
   int smtpPort = 25;
   string senderEmail = "jnetzhou@63.com";
   string senderPassword = "SZWSCFPBDVAPBWEM";
   string recipientEmail = "742408364@qq.com";
   string subject = "Test Email";
   string body = "This is a test email.";

   bool result = SendMail(smtpServer, smtpPort, senderEmail, senderPassword, recipientEmail, subject, body);
   if(result) {
      Print("Email sent successfully.");
   } else {
      Print("Failed to send email.");
   }
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double AmountToPoints(double amount) {
   double point = Point;
   double points = amount / (point * MarketInfo(Symbol(), MODE_TICKVALUE));
   return points;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculatePointValue(double lotSize) {
   double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   return lotSize * tickSize;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick() {
//---
   double atp = CalculatePointValue(0.01);
   printf("CalculatePointValue" + atp);

}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
