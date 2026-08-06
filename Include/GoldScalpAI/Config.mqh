#ifndef GOLD_SCALP_AI_CONFIG_MQH
#define GOLD_SCALP_AI_CONFIG_MQH

#include "Constants.mqh"

class CGSAConfig
  {
private:
   long   m_magic_number;
   double m_risk_percent;
   int    m_max_spread_points;
   bool   m_allow_trading;

public:
   CGSAConfig(void) : m_magic_number(GSA_DEFAULT_MAGIC),m_risk_percent(1.0),m_max_spread_points(500),m_allow_trading(false) {}

   bool Initialize(const long magic_number,const double risk_percent,
                   const int max_spread_points,const bool allow_trading)
     {
      if(magic_number<=0)
         return false;
      if(risk_percent<GSA_MIN_RISK_PERCENT || risk_percent>GSA_MAX_RISK_PERCENT)
         return false;
      if(max_spread_points<=0 || max_spread_points>GSA_MAX_SPREAD_POINTS)
         return false;

      m_magic_number=magic_number;
      m_risk_percent=risk_percent;
      m_max_spread_points=max_spread_points;
      m_allow_trading=allow_trading;
      return true;
     }

   long MagicNumber(void) const { return m_magic_number; }
   double RiskPercent(void) const { return m_risk_percent; }
   int MaxSpreadPoints(void) const { return m_max_spread_points; }
   bool AllowTrading(void) const { return m_allow_trading; }
  };

#endif
