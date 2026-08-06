#property copyright "GoldScalper"
#property version   "0.4.0"
#property strict
#property description "Professional MT5 Gold Scalping EA foundation"

#include <GoldScalpAI/BrokerManager.mqh>
#include <GoldScalpAI/Config.mqh>
#include <GoldScalpAI/Constants.mqh>
#include <GoldScalpAI/DailyLossGuard.mqh>
#include <GoldScalpAI/Enums.mqh>
#include <GoldScalpAI/IndicatorManager.mqh>
#include <GoldScalpAI/Logger.mqh>
#include <GoldScalpAI/MarketData.mqh>
#include <GoldScalpAI/MarketGuard.mqh>
#include <GoldScalpAI/RiskManager.mqh>
#include <GoldScalpAI/SessionManager.mqh>
#include <GoldScalpAI/TradeManager.mqh>
#include <GoldScalpAI/TrendAnalyzer.mqh>

input group "General"
input long   InpMagicNumber       = GSA_DEFAULT_MAGIC;
input bool   InpAllowTrading      = false;
input group "Risk Management"
input double InpRiskPerTradePct   = 1.00;
input double InpMaxDailyLossPct   = 3.00;
input int    InpMaxOpenPositions  = 1;
input int    InpMaxSpreadPoints   = 500;
input group "Trading Session (server time)"
input int    InpSessionStartHour  = 7;
input int    InpSessionEndHour    = 20;
input group "Market Analysis"
input ENUM_TIMEFRAMES InpSignalTimeframe = PERIOD_M5;
input int    InpFastEmaPeriod     = 20;
input int    InpSlowEmaPeriod     = 50;
input int    InpAtrPeriod         = 14;

CGSABrokerManager    g_broker_manager;
CGSAConfig           g_config;
CGSADailyLossGuard   g_daily_loss_guard;
CGSAIndicatorManager g_indicator_manager;
CGSALogger           g_logger;
CGSAMarketData       g_market_data;
CGSAMarketGuard      g_market_guard;
CGSARiskManager      g_risk_manager;
CGSASessionManager   g_session_manager;
CGSATradeManager     g_trade_manager;
CGSATrendAnalyzer    g_trend_analyzer;
ENUM_GSA_EA_STATE    g_state=GSA_STATE_INITIALIZING;

int OnInit()
  {
   if(!g_config.Initialize(InpMagicNumber,InpRiskPerTradePct,InpMaxDailyLossPct,
                           InpMaxSpreadPoints,InpMaxOpenPositions,InpAllowTrading))
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

   if(!g_indicator_manager.Initialize(InpSignalTimeframe,InpFastEmaPeriod,
                                      InpSlowEmaPeriod,InpAtrPeriod))
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("Indicator initialization failed.");
      return INIT_FAILED;
     }

   if(!g_market_guard.IsSymbolTradable())
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("The selected symbol is not tradable.");
      return INIT_FAILED;
     }

   if(g_config.AllowTrading() && !g_broker_manager.IsTradeEnvironmentReady())
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("The terminal or account does not permit trading.");
      return INIT_FAILED;
     }

   g_state=GSA_STATE_READY;
   g_logger.Info(StringFormat("Initialized v%s for %s. Signal timeframe=%s.",
                              GSA_VERSION,_Symbol,EnumToString(InpSignalTimeframe)));
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   g_indicator_manager.Release();
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
   if(!g_daily_loss_guard.IsWithinLimit(g_config))
      return;
   if(!g_trade_manager.HasCapacity(g_config))
      return;
   if(g_config.AllowTrading() && !g_broker_manager.IsTradeEnvironmentReady())
      return;

   MqlRates latest_closed_bar={};
   if(!g_market_data.GetLatestClosedBar(InpSignalTimeframe,latest_closed_bar))
      return;

   const ENUM_GSA_MARKET_TREND trend=g_trend_analyzer.GetTrend(g_indicator_manager);
   if(trend==GSA_TREND_UNKNOWN)
      return;

   // Execution remains disabled until entry and exit engines are implemented.
   // No orders are sent by the v0.4.0-alpha foundation.
  }
