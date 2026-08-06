#ifndef GOLD_SCALP_AI_MARKET_DATA_MQH
#define GOLD_SCALP_AI_MARKET_DATA_MQH

class CGSAMarketData
  {
public:
   bool GetLatestClosedBar(const ENUM_TIMEFRAMES timeframe,MqlRates &bar) const
     {
      MqlRates rates[];
      ArraySetAsSeries(rates,true);
      if(CopyRates(_Symbol,timeframe,1,1,rates)!=1)
         return false;

      bar=rates[0];
      return true;
     }

   bool GetClosedBars(const ENUM_TIMEFRAMES timeframe,const int requested_count,
                      MqlRates &bars[]) const
     {
      if(requested_count<=0)
         return false;

      ArraySetAsSeries(bars,true);
      const int copied=CopyRates(_Symbol,timeframe,1,requested_count,bars);
      return (copied==requested_count);
     }
  };

#endif
