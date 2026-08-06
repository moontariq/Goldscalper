#ifndef GOLD_SCALP_AI_SMART_MONEY_ANALYZER_MQH
#define GOLD_SCALP_AI_SMART_MONEY_ANALYZER_MQH

#include "Enums.mqh"
#include "PriceActionAnalyzer.mqh"

class CGSASmartMoneyAnalyzer
  {
private:
   CGSAPriceActionAnalyzer m_price_action;

public:
   ENUM_GSA_MARKET_STRUCTURE Analyze(const MqlRates &bars[],const int bar_count,
                                     const int swing_strength) const
     {
      if(bar_count<=0)
         return GSA_STRUCTURE_UNKNOWN;

      double swing_high=0.0;
      double swing_low=0.0;
      const bool has_swing_high=m_price_action.FindLatestSwingHigh(bars,bar_count,
                                                                    swing_strength,swing_high);
      const bool has_swing_low=m_price_action.FindLatestSwingLow(bars,bar_count,
                                                                  swing_strength,swing_low);
      if(!has_swing_high || !has_swing_low)
         return GSA_STRUCTURE_UNKNOWN;

      if(bars[0].close>swing_high)
         return GSA_STRUCTURE_BULLISH_BREAK;
      if(bars[0].close<swing_low)
         return GSA_STRUCTURE_BEARISH_BREAK;
      return GSA_STRUCTURE_RANGE;
     }
  };

#endif
