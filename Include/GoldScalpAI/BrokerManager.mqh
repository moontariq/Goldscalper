#ifndef GOLD_SCALP_AI_BROKER_MANAGER_MQH
#define GOLD_SCALP_AI_BROKER_MANAGER_MQH

#include "Enums.mqh"

class CGSABrokerManager
  {
public:
   bool IsSymbolConfigurationValid(void) const
     {
      if(!SymbolSelect(_Symbol,true) || _Point<=0.0 || _Digits<=0)
         return false;
      if(SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE)<=0.0 ||
         SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE)<=0.0 ||
         SymbolInfoDouble(_Symbol,SYMBOL_TRADE_CONTRACT_SIZE)<=0.0)
         return false;
      const double minimum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      const double maximum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
      const double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
      return (minimum>0.0 && maximum>=minimum && step>0.0);
     }

   bool IsDirectionAllowed(const ENUM_GSA_TRADE_DIRECTION direction) const
     {
      const ENUM_SYMBOL_TRADE_MODE mode=(ENUM_SYMBOL_TRADE_MODE)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE);
      if(direction==GSA_DIRECTION_BUY)
         return (mode==SYMBOL_TRADE_MODE_FULL || mode==SYMBOL_TRADE_MODE_LONGONLY);
      if(direction==GSA_DIRECTION_SELL)
         return (mode==SYMBOL_TRADE_MODE_FULL || mode==SYMBOL_TRADE_MODE_SHORTONLY);
      return false;
     }
   bool IsTradeEnvironmentReady(void) const
     {
      return (TerminalInfoInteger(TERMINAL_CONNECTED)!=0 &&
              TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)!=0 &&
              MQLInfoInteger(MQL_TRADE_ALLOWED)!=0);
     }

   bool IsStopDistanceValid(const double entry_price,const double stop_loss_price) const
     {
      if(entry_price<=0.0 || stop_loss_price<=0.0 || _Point<=0.0)
         return false;

      const long minimum_points=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
      const double minimum_distance=(double)minimum_points*_Point;
      return (MathAbs(entry_price-stop_loss_price)>=minimum_distance);
     }

   bool HasSufficientMargin(const ENUM_GSA_TRADE_DIRECTION direction,const double volume,
                            const double price,const double safety_buffer_percent=10.0) const
     {
      if(!IsDirectionAllowed(direction) || volume<=0.0 || price<=0.0 || safety_buffer_percent<0.0)
         return false;
      double margin=0.0;
      const ENUM_ORDER_TYPE type=(direction==GSA_DIRECTION_BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
      if(!OrderCalcMargin(type,_Symbol,volume,price,margin) || margin<=0.0)
         return false;
      return (AccountInfoDouble(ACCOUNT_FREEMARGIN)>=margin*(1.0+safety_buffer_percent/100.0));
     }
  };

#endif
