#property copyright "GoldScalper"
#property version   "0.2.0"
#property strict
#property description "Professional MT5 Gold Scalping EA foundation"

#include <GoldScalpAI/Config.mqh>
#include <GoldScalpAI/Constants.mqh>
#include <GoldScalpAI/Enums.mqh>
#include <GoldScalpAI/Logger.mqh>
#include <GoldScalpAI/MarketGuard.mqh>
#include <GoldScalpAI/RiskManager.mqh>
#include <GoldScalpAI/SessionManager.mqh>

input group "General"
input long   InpMagicNumber       = GSA_DEFAULT_MAGIC;
input bool   InpAllowTrading      = false;
input group "Risk Management"
input double InpRiskPerTradePct   = 1.00;
input int    InpMaxSpreadPoints   = 500;
input group "Trading Session (server time)"
input int    InpSessionStartHour  = 7;
input int    InpSessionEndHour    = 20;

CGSAConfig        g_config;
CGSALogger        g_logger;
CGSAMarketGuard   g_market_guard;
CGSARiskManager   g_risk_manager;
CGSASessionManager g_session_manager;
ENUM_GSA_EA_STATE g_state=GSA_STATE_INITIALIZING;

int OnInit()
  {
   if(!g_config.Initialize(InpMagicNumber,InpRiskPerTradePct,InpMaxSpreadPoints,InpAllowTrading))
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("Invalid input configuration. EA initialization stopped.");
      return INIT_PARAMETERS_INCORRECT;
     }

   if(!g_session_manager.Initialize(InpSessionStartHour,InpSessionEndHour))
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("Invalid trading-session configuration. EA initialization stopped.");
      return INIT_PARAMETERS_INCORRECT;
     }

   if(!g_market_guard.IsSymbolTradable())
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("The selected symbol is not tradable.");
      return INIT_FAILED;
     }

   g_state=GSA_STATE_READY;
   g_logger.Info(StringFormat("Initialized v%s for %s. Trading=%s, Risk=%.2f%%, Session=%02d:00-%02d:59.",
                              GSA_VERSION,_Symbol,
                              g_config.AllowTrading() ? "enabled" : "disabled",
                              g_config.RiskPercent(),InpSessionStartHour,InpSessionEndHour));
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
   if(!g_session_manager.IsActive())
      return;
   if(!g_market_guard.IsSpreadAcceptable(g_config))
      return;

   // Execution remains disabled until entry and exit engines are implemented.
   // No orders are sent by the v0.2.0-alpha foundation.
  }
