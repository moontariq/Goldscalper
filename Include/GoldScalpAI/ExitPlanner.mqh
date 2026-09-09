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

   GSA_EXIT_RECOMMENDATION BuildRecommendation(const GSA_POSITION_SNAPSHOT &position,
                                               const double atr,const double break_even_risk_multiple,
                                               const double trailing_atr_multiplier) const
     {
      GSA_EXIT_RECOMMENDATION recommendation;
      recommendation.valid=false;
      recommendation.move_to_break_even=false;
      recommendation.trail_stop=false;
      recommendation.trigger_price=0.0;
      recommendation.suggested_stop_loss=0.0;

      if(!position.valid || position.entry_price<=0.0 || position.stop_loss<=0.0)
         return recommendation;

      const double initial_risk=MathAbs(position.entry_price-position.stop_loss);
      if(initial_risk<=0.0)
         return recommendation;

      MqlTick tick={};
      if(!SymbolInfoTick(_Symbol,tick))
         return recommendation;
      const double current_price=(position.direction==GSA_DIRECTION_BUY ? tick.bid : tick.ask);
      if(current_price<=0.0)
         return recommendation;

      recommendation.trigger_price=(position.direction==GSA_DIRECTION_BUY ?
                                    position.entry_price+(initial_risk*break_even_risk_multiple) :
                                    position.entry_price-(initial_risk*break_even_risk_multiple));
      const bool trigger_reached=(position.direction==GSA_DIRECTION_BUY ?
                                  current_price>=recommendation.trigger_price :
                                  current_price<=recommendation.trigger_price);
      if(!trigger_reached)
         return recommendation;

      recommendation.valid=true;
      recommendation.move_to_break_even=true;
      recommendation.suggested_stop_loss=position.entry_price;

      double trailing_distance=0.0;
      if(!CalculateTrailingDistance(atr,trailing_atr_multiplier,trailing_distance))
         return recommendation;

      const double trailing_stop=(position.direction==GSA_DIRECTION_BUY ?
                                  current_price-trailing_distance :
                                  current_price+trailing_distance);
      const bool improves_stop=(position.direction==GSA_DIRECTION_BUY ?
                                trailing_stop>recommendation.suggested_stop_loss :
                                trailing_stop<recommendation.suggested_stop_loss);
      if(improves_stop)
        {
         recommendation.trail_stop=true;
         recommendation.suggested_stop_loss=trailing_stop;
        }
      return recommendation;
     }
  };

#endif
