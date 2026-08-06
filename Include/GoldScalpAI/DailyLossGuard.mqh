#ifndef GOLD_SCALP_AI_DAILY_LOSS_GUARD_MQH
#define GOLD_SCALP_AI_DAILY_LOSS_GUARD_MQH

#include "Config.mqh"

class CGSADailyLossGuard
  {
private:
   datetime StartOfServerDay(void) const
     {
      datetime now=TimeTradeServer();
      if(now==0)
         now=TimeCurrent();

      MqlDateTime date_time={};
      TimeToStruct(now,date_time);
      date_time.hour=0;
      date_time.min=0;
      date_time.sec=0;
      return StructToTime(date_time);
     }

public:
   double TodayRealizedNetProfit(const long magic_number) const
     {
      datetime now=TimeTradeServer();
      if(now==0)
         now=TimeCurrent();
      if(!HistorySelect(StartOfServerDay(),now))
         return 0.0;

      double net_profit=0.0;
      const int deal_count=HistoryDealsTotal();
      for(int index=0;index<deal_count;index++)
        {
         const ulong ticket=HistoryDealGetTicket(index);
         if(ticket==0)
            continue;
         if(HistoryDealGetString(ticket,DEAL_SYMBOL)!=_Symbol)
            continue;
         if((long)HistoryDealGetInteger(ticket,DEAL_MAGIC)!=magic_number)
            continue;

         const ENUM_DEAL_ENTRY entry=(ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket,DEAL_ENTRY);
         if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY)
            continue;

         net_profit+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         net_profit+=HistoryDealGetDouble(ticket,DEAL_SWAP);
         net_profit+=HistoryDealGetDouble(ticket,DEAL_COMMISSION);
        }
      return net_profit;
     }

   bool IsWithinLimit(const CGSAConfig &config) const
     {
      const double maximum_loss=AccountInfoDouble(ACCOUNT_BALANCE)*config.MaxDailyLossPercent()/100.0;
      return (TodayRealizedNetProfit(config.MagicNumber())>-maximum_loss);
     }
  };

#endif
