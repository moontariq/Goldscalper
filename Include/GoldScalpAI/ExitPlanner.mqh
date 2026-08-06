#ifndef GOLD_SCALP_AI_EXIT_PLANNER_MQH
#define GOLD_SCALP_AI_EXIT_PLANNER_MQH

#include "Enums.mqh"

class CGSAExitPlanner
  {
public:
   bool CalculateBreakEvenTrigger(const GSA_TRADE_PLAN &plan,const double risk_multiple,
                                  double &trigger_price) const
     {
      if(!plan.valid || risk_multiple<=0.0)
         return false;

      const double initial_risk=MathAbs(plan.entry_price-plan.stop_loss);
      if(initial_risk<=0.0)
         return false;

      trigger_price=(plan.direction==GSA_DIRECTION_BUY ?
                     plan.entry_price+(initial_risk*risk_multiple) :
                     plan.entry_price-(initial_risk*risk_multiple));
      return true;
     }

   bool CalculateTrailingDistance(const double atr,const double atr_multiplier,
                                  double &distance) const
     {
      if(atr<=0.0 || atr_multiplier<=0.0)
         return false;

      distance=atr*atr_multiplier;
      return (distance>0.0);
     }
  };

#endif
