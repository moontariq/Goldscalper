#property copyright "GoldScalper"
#property version   "0.1.0"
#property strict
#property description "Professional MT5 Gold Scalping EA foundation"

#include <GoldScalpAI/Config.mqh>
#include <GoldScalpAI/Constants.mqh>
#include <GoldScalpAI/Enums.mqh>
#include <GoldScalpAI/Logger.mqh>

input group "General"
input long   InpMagicNumber       = GSA_DEFAULT_MAGIC;
input bool   InpAllowTrading      = false;
input group "Risk Management"
input double InpRiskPerTradePct   = 1.00;
input int    InpMaxSpreadPoints   = 500;

CGSAConfig       g_config;
CGSALogger       g_logger;
ENUM_GSA_EA_STATE g_state=GSA_STATE_INITIALIZING;

int OnInit()
  {
   if(!g_config.Initialize(InpMagicNumber,InpRiskPerTradePct,InpMaxSpreadPoints,InpAllowTrading))
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("Invalid input configuration. EA initialization stopped.");
      return INIT_PARAMETERS_INCORRECT;
     }

   g_state=GSA_STATE_READY;
   g_logger.Info(StringFormat("Initialized v%s for %s. Trading=%s, Risk=%.2f%%.",
                              GSA_VERSION,_Symbol,
                              g_config.AllowTrading() ? "enabled" : "disabled",
                              g_config.RiskPercent()));
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   g_logger.Info(StringFormat("EA stopped. Reason code=%d.",reason));
  }

void OnTick()
  {
   if(g_state!=GSA_STATE_READY)
      return;

   // Execution remains disabled until risk, market-analysis, and entry modules are implemented.
   // No orders are sent by the v0.1.0-alpha foundation.
  }
