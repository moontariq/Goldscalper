#ifndef GOLD_SCALP_AI_STATISTICS_MANAGER_MQH
#define GOLD_SCALP_AI_STATISTICS_MANAGER_MQH

#include "Config.mqh"
#include "Enums.mqh"

class CGSAStatisticsManager
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
   bool GetToday(const CGSAConfig &config,GSA_TRADE_STATISTICS &statistics) const
     {
      statistics.closed_trades=0;
      statistics.wins=0;
      statistics.losses=0;
      statistics.net_profit=0.0;
      statistics.gross_profit=0.0;
      statistics.gross_loss=0.0;

      datetime now=TimeTradeServer();
      if(now==0)
         now=TimeCurrent();
      if(!HistorySelect(StartOfServerDay(),now))
         return false;

      const int deal_count=HistoryDealsTotal();
      for(int index=0;index<deal_count;index++)
        {
         const ulong ticket=HistoryDealGetTicket(index);
         if(ticket==0 || HistoryDealGetString(ticket,DEAL_SYMBOL)!=_Symbol)
            continue;
         if((long)HistoryDealGetInteger(ticket,DEAL_MAGIC)!=config.MagicNumber())
            continue;

         const ENUM_DEAL_ENTRY entry=(ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket,DEAL_ENTRY);
         if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY)
            continue;

         const double result=HistoryDealGetDouble(ticket,DEAL_PROFIT)+
                             HistoryDealGetDouble(ticket,DEAL_SWAP)+
                             HistoryDealGetDouble(ticket,DEAL_COMMISSION);
         statistics.closed_trades++;
         statistics.net_profit+=result;
         if(result>0.0)
           {
            statistics.wins++;
            statistics.gross_profit+=result;
           }
         else if(result<0.0)
           {
            statistics.losses++;
            statistics.gross_loss+=result;
           }
        }
      return true;
     }
  };

#endif
