#ifndef GOLD_SCALP_AI_SIGNAL_SCORER_MQH
#define GOLD_SCALP_AI_SIGNAL_SCORER_MQH

#include "Enums.mqh"

class CGSASignalScorer
  {
public:
   GSA_SIGNAL_SCORE Score(const ENUM_GSA_MARKET_TREND trend,
                          const ENUM_GSA_MARKET_STRUCTURE structure,
                          const bool has_valid_atr) const
     {
      GSA_SIGNAL_SCORE result;
      result.direction=GSA_DIRECTION_NONE;
      result.confidence=0.0;

      if(!has_valid_atr)
         return result;

      if(trend==GSA_TREND_BULLISH && structure==GSA_STRUCTURE_BULLISH_BREAK)
        {
         result.direction=GSA_DIRECTION_BUY;
         result.confidence=85.0;
        }
      else if(trend==GSA_TREND_BEARISH && structure==GSA_STRUCTURE_BEARISH_BREAK)
        {
         result.direction=GSA_DIRECTION_SELL;
         result.confidence=85.0;
        }
      else if((trend==GSA_TREND_BULLISH && structure==GSA_STRUCTURE_RANGE) ||
              (trend==GSA_TREND_BEARISH && structure==GSA_STRUCTURE_RANGE))
        {
         result.direction=(trend==GSA_TREND_BULLISH ? GSA_DIRECTION_BUY : GSA_DIRECTION_SELL);
         result.confidence=45.0;
        }

      return result;
     }
  };

#endif
