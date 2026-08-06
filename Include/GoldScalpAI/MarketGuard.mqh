#ifndef GOLD_SCALP_AI_MARKET_GUARD_MQH
#define GOLD_SCALP_AI_MARKET_GUARD_MQH

#include "Config.mqh"

class CGSAMarketGuard
  {
public:
   bool IsSymbolTradable(void) const
     {
      const long trade_mode=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE);
      return (trade_mode==SYMBOL_TRADE_MODE_FULL ||
              trade_mode==SYMBOL_TRADE_MODE_LONGONLY ||
              trade_mode==SYMBOL_TRADE_MODE_SHORTONLY);
     }

   bool IsSpreadAcceptable(const CGSAConfig &config) const
     {
      MqlTick tick={};
      if(!SymbolInfoTick(_Symbol,tick) || tick.ask<=0.0 || tick.bid<=0.0 || _Point<=0.0)
         return false;

      const int spread_points=(int)MathRound((tick.ask-tick.bid)/_Point);
      return (spread_points>=0 && spread_points<=config.MaxSpreadPoints());
     }
  };

#endif
