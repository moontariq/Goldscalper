#ifndef GOLD_SCALP_AI_TREND_ANALYZER_MQH
#define GOLD_SCALP_AI_TREND_ANALYZER_MQH

#include "Enums.mqh"
#include "IndicatorManager.mqh"

class CGSATrendAnalyzer
  {
public:
   ENUM_GSA_MARKET_TREND GetTrend(const CGSAIndicatorManager &indicators) const
     {
      double fast_ema=0.0;
      double slow_ema=0.0;
      if(!indicators.GetFastEma(fast_ema) || !indicators.GetSlowEma(slow_ema))
         return GSA_TREND_UNKNOWN;

      if(fast_ema>slow_ema)
         return GSA_TREND_BULLISH;
      if(fast_ema<slow_ema)
         return GSA_TREND_BEARISH;
      return GSA_TREND_NEUTRAL;
     }
  };

#endif
