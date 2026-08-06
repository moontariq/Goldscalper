#ifndef GOLD_SCALP_AI_TRADE_PLANNER_MQH
#define GOLD_SCALP_AI_TRADE_PLANNER_MQH

#include "BrokerManager.mqh"
#include "Config.mqh"
#include "Enums.mqh"
#include "RiskManager.mqh"

class CGSATradePlanner
  {
public:
   GSA_TRADE_PLAN Create(const CGSAConfig &config,const CGSABrokerManager &broker_manager,
                         const CGSARiskManager &risk_manager,const GSA_SIGNAL_SCORE &score,
                         const double atr,const double stop_atr_multiplier,
                         const double risk_reward_ratio) const
     {
      GSA_TRADE_PLAN plan;
      plan.valid=false;
      plan.direction=GSA_DIRECTION_NONE;
      plan.entry_price=0.0;
      plan.stop_loss=0.0;
      plan.take_profit=0.0;
      plan.volume=0.0;
      plan.confidence=score.confidence;

      if(score.direction==GSA_DIRECTION_NONE || atr<=0.0 ||
         stop_atr_multiplier<GSA_MIN_ATR_MULTIPLIER ||
         risk_reward_ratio<GSA_MIN_RISK_REWARD)
         return plan;

      MqlTick tick={};
      if(!SymbolInfoTick(_Symbol,tick))
         return plan;

      const double stop_distance=atr*stop_atr_multiplier;
      plan.direction=score.direction;
      plan.entry_price=(score.direction==GSA_DIRECTION_BUY ? tick.ask : tick.bid);
      if(plan.entry_price<=0.0 || stop_distance<=0.0)
         return plan;

      if(score.direction==GSA_DIRECTION_BUY)
        {
         plan.stop_loss=plan.entry_price-stop_distance;
         plan.take_profit=plan.entry_price+(stop_distance*risk_reward_ratio);
        }
      else
        {
         plan.stop_loss=plan.entry_price+stop_distance;
         plan.take_profit=plan.entry_price-(stop_distance*risk_reward_ratio);
        }

      if(!broker_manager.IsStopDistanceValid(plan.entry_price,plan.stop_loss))
         return plan;

      plan.volume=risk_manager.CalculateVolume(config,plan.direction,plan.entry_price,plan.stop_loss);
      if(plan.volume<=0.0)
         return plan;

      plan.valid=true;
      return plan;
     }
  };

#endif
