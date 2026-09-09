#ifndef GOLD_SCALP_AI_DAILY_LOSS_GUARD_MQH
#define GOLD_SCALP_AI_DAILY_LOSS_GUARD_MQH

#include "Config.mqh"

class CGSADailyLossGuard
  {
private:
   string BaselineKey(void) const
     {
      return StringFormat("GSA_DAILY_BASELINE_%I64d_%s",AccountInfoInteger(ACCOUNT_LOGIN),_Symbol);
     }

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
   bool Initialize(void)
     {
      const datetime day=StartOfServerDay();
      const string key=BaselineKey();
      const string day_key=key+"_DAY";
      if(GlobalVariableCheck(day_key) &&
         (datetime)GlobalVariableGet(day_key)==day && GlobalVariableCheck(key))
         return true;

      // Reconstruct a stable opening balance when attached after midnight. This is
      // intentionally account-wide: other account activity must not expand EA risk.
      datetime now=TimeTradeServer();
      if(now==0)
         now=TimeCurrent();
      if(!HistorySelect(day,now))
         return false;

      double today_account_result=0.0;
      for(int index=0;index<HistoryDealsTotal();index++)
        {
         const ulong ticket=HistoryDealGetTicket(index);
         if(ticket==0)
            continue;
         today_account_result+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         today_account_result+=HistoryDealGetDouble(ticket,DEAL_SWAP);
         today_account_result+=HistoryDealGetDouble(ticket,DEAL_COMMISSION);
        }
      const double baseline=AccountInfoDouble(ACCOUNT_BALANCE)-today_account_result;
      if(baseline<=0.0)
         return false;
      GlobalVariableSet(key,baseline);
      GlobalVariableSet(day_key,(double)day);
      return true;
     }

   double StartOfDayBalance(void) const
     {
      const string key=BaselineKey();
      return (GlobalVariableCheck(key) ? GlobalVariableGet(key) : 0.0);
     }

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
      const double baseline=StartOfDayBalance();
      if(baseline<=0.0)
         return false;
      const double maximum_loss=baseline*config.MaxDailyLossPercent()/100.0;
      return (TodayRealizedNetProfit(config.MagicNumber())>-maximum_loss);
     }
  };

#endif
