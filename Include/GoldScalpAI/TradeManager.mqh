#ifndef GOLD_SCALP_AI_TRADE_MANAGER_MQH
#define GOLD_SCALP_AI_TRADE_MANAGER_MQH

#include "Config.mqh"

class CGSATradeManager
  {
public:
   int OpenPositionCount(const CGSAConfig &config) const
     {
      int count=0;
      for(int index=PositionsTotal()-1;index>=0;index--)
        {
         const ulong ticket=PositionGetTicket(index);
         if(ticket==0)
            continue;
         if(PositionGetString(POSITION_SYMBOL)!=_Symbol)
            continue;
         if((long)PositionGetInteger(POSITION_MAGIC)!=config.MagicNumber())
            continue;
         count++;
        }
      return count;
     }

   bool HasCapacity(const CGSAConfig &config) const
     {
      return (OpenPositionCount(config)<config.MaxOpenPositions());
     }
  };

#endif
