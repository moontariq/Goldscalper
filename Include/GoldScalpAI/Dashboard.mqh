#ifndef GOLD_SCALP_AI_DASHBOARD_MQH
#define GOLD_SCALP_AI_DASHBOARD_MQH

#include "Enums.mqh"

class CGSADashboard
  {
private:
   string StateName(const ENUM_GSA_EA_STATE state) const
     {
      switch(state)
        {
         case GSA_STATE_INITIALIZING: return "Initializing";
         case GSA_STATE_READY:        return "Ready";
         case GSA_STATE_PAUSED:       return "Paused";
         case GSA_STATE_ERROR:        return "Error";
        }
      return "Unknown";
     }

   string TrendName(const ENUM_GSA_MARKET_TREND trend) const
     {
      switch(trend)
        {
         case GSA_TREND_BULLISH: return "Bullish";
         case GSA_TREND_BEARISH: return "Bearish";
         case GSA_TREND_NEUTRAL: return "Neutral";
        }
      return "Unknown";
     }

   string StructureName(const ENUM_GSA_MARKET_STRUCTURE structure) const
     {
      switch(structure)
        {
         case GSA_STRUCTURE_BULLISH_BREAK: return "Bullish break";
         case GSA_STRUCTURE_BEARISH_BREAK: return "Bearish break";
         case GSA_STRUCTURE_RANGE:         return "Range";
        }
      return "Unknown";
     }

public:
   void Render(const ENUM_GSA_EA_STATE state,const ENUM_GSA_MARKET_TREND trend,
               const ENUM_GSA_MARKET_STRUCTURE structure,const GSA_SIGNAL_SCORE &score,
               const bool has_position,const GSA_TRADE_PLAN &plan) const
     {
      const string direction=(score.direction==GSA_DIRECTION_BUY ? "BUY" :
                              score.direction==GSA_DIRECTION_SELL ? "SELL" : "NONE");
      const string plan_status=(plan.valid ? "Validated (dry-run)" : "No validated plan");
      Comment(StringFormat("GoldScalper %s\nState: %s\nTrend: %s | Structure: %s\nSignal: %s (%.1f)\nPosition: %s\nPlan: %s",
                           GSA_VERSION,StateName(state),TrendName(trend),StructureName(structure),
                           direction,score.confidence,has_position ? "Open" : "None",plan_status));
     }

   void Clear(void) const
     {
      Comment("");
     }
  };

#endif
