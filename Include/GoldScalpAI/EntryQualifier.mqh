#ifndef GOLD_SCALP_AI_ENTRY_QUALIFIER_MQH
#define GOLD_SCALP_AI_ENTRY_QUALIFIER_MQH

#include "Enums.mqh"

class CGSAEntryQualifier
  {
public:
   bool IsQualified(const GSA_SIGNAL_SCORE &score,const double minimum_confidence) const
     {
      if(minimum_confidence<GSA_MIN_CONFIDENCE || minimum_confidence>GSA_MAX_CONFIDENCE)
         return false;
      if(score.direction==GSA_DIRECTION_NONE)
         return false;

      return (score.confidence>=minimum_confidence);
     }
  };

#endif
