#ifndef GOLD_SCALP_AI_POSITION_READER_MQH
#define GOLD_SCALP_AI_POSITION_READER_MQH

#include "Config.mqh"
#include "Enums.mqh"

class CGSAPositionReader
  {
public:
   int GetOwnedPositions(const CGSAConfig &config,GSA_POSITION_SNAPSHOT &positions[]) const
     {
      ArrayResize(positions,0);
      for(int index=PositionsTotal()-1;index>=0;index--)
        {
         const ulong ticket=PositionGetTicket(index);
         if(ticket==0 || !PositionSelectByTicket(ticket) ||
            PositionGetString(POSITION_SYMBOL)!=_Symbol ||
            (long)PositionGetInteger(POSITION_MAGIC)!=config.MagicNumber())
            continue;
         const ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if(type!=POSITION_TYPE_BUY && type!=POSITION_TYPE_SELL)
            continue;
         const int next=ArraySize(positions);
         ArrayResize(positions,next+1);
         positions[next].valid=true;
         positions[next].ticket=ticket;
         positions[next].direction=(type==POSITION_TYPE_BUY ? GSA_DIRECTION_BUY : GSA_DIRECTION_SELL);
         positions[next].entry_price=PositionGetDouble(POSITION_PRICE_OPEN);
         positions[next].stop_loss=PositionGetDouble(POSITION_SL);
         positions[next].take_profit=PositionGetDouble(POSITION_TP);
         positions[next].volume=PositionGetDouble(POSITION_VOLUME);
        }
      return ArraySize(positions);
     }

   bool GetFirstOwnedPosition(const CGSAConfig &config,GSA_POSITION_SNAPSHOT &position) const
     {
      GSA_POSITION_SNAPSHOT positions[];
      if(GetOwnedPositions(config,positions)<=0)
        {
         position.valid=false;
         return false;
        }
      position=positions[0];
      return true;
     }
  };

#endif
