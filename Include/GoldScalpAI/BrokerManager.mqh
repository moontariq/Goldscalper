#ifndef GOLD_SCALP_AI_BROKER_MANAGER_MQH
#define GOLD_SCALP_AI_BROKER_MANAGER_MQH

class CGSABrokerManager
  {
public:
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
  };

#endif
