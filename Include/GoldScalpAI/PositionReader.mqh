#ifndef GOLD_SCALP_AI_POSITION_READER_MQH
#define GOLD_SCALP_AI_POSITION_READER_MQH

#include "Config.mqh"
#include "Enums.mqh"

class CGSAPositionReader
  {
public:
   bool GetFirstOwnedPosition(const CGSAConfig &config,GSA_POSITION_SNAPSHOT &position) const
     {
      position.valid=false;
      for(int index=PositionsTotal()-1;index>=0;index--)
        {
         const ulong ticket=PositionGetTicket(index);
         if(ticket==0 || !PositionSelectByTicket(ticket))
            continue;
         if(PositionGetString(POSITION_SYMBOL)!=_Symbol)
            continue;
         if((long)PositionGetInteger(POSITION_MAGIC)!=config.MagicNumber())
            continue;

         const ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if(type!=POSITION_TYPE_BUY && type!=POSITION_TYPE_SELL)
            continue;

         position.valid=true;
         position.ticket=ticket;
         position.direction=(type==POSITION_TYPE_BUY ? GSA_DIRECTION_BUY : GSA_DIRECTION_SELL);
         position.entry_price=PositionGetDouble(POSITION_PRICE_OPEN);
         position.stop_loss=PositionGetDouble(POSITION_SL);
         position.take_profit=PositionGetDouble(POSITION_TP);
         position.volume=PositionGetDouble(POSITION_VOLUME);
         return true;
        }
      return false;
     }
  };

#endif
