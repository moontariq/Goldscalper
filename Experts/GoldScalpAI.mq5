#property copyright "GoldScalper"
#property version   "0.8.0"
#property strict
#property description "Professional MT5 Gold Scalping EA foundation"

#include <GoldScalpAI/BrokerManager.mqh>
#include <GoldScalpAI/ClosedBarGate.mqh>
#include <GoldScalpAI/Config.mqh>
#include <GoldScalpAI/Constants.mqh>
#include <GoldScalpAI/DailyLossGuard.mqh>
#include <GoldScalpAI/EntryQualifier.mqh>
#include <GoldScalpAI/Enums.mqh>
#include <GoldScalpAI/ExitPlanner.mqh>
#include <GoldScalpAI/IndicatorManager.mqh>
#include <GoldScalpAI/Logger.mqh>
#include <GoldScalpAI/MarketData.mqh>
#include <GoldScalpAI/MarketGuard.mqh>
#include <GoldScalpAI/PositionReader.mqh>
#include <GoldScalpAI/RiskManager.mqh>
#include <GoldScalpAI/SessionManager.mqh>
#include <GoldScalpAI/SignalScorer.mqh>
#include <GoldScalpAI/SmartMoneyAnalyzer.mqh>
#include <GoldScalpAI/TradeManager.mqh>
#include <GoldScalpAI/TradePlanner.mqh>
#include <GoldScalpAI/TrendAnalyzer.mqh>

input group "General"
input long   InpMagicNumber       = GSA_DEFAULT_MAGIC;
input bool   InpAllowTrading      = false;
input bool   InpLogTradePlans     = true;
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
input group "Price Action"
input int    InpSwingStrength     = 3;
input int    InpStructureLookback = 100;
input group "Entry Qualification"
input double InpMinimumConfidence = 75.00;
input group "Trade Planning"
input double InpStopLossAtrMultiplier = 1.50;
input double InpRiskRewardRatio        = 1.50;
input group "Exit Planning"
input double InpBreakEvenRiskMultiple  = 1.00;
input double InpTrailingStopAtrMultiplier = 1.00;

CGSABrokerManager      g_broker_manager;
CGSAClosedBarGate      g_closed_bar_gate;
CGSAConfig             g_config;
CGSADailyLossGuard     g_daily_loss_guard;
CGSAEntryQualifier     g_entry_qualifier;
CGSAExitPlanner        g_exit_planner;
CGSAIndicatorManager   g_indicator_manager;
CGSALogger             g_logger;
CGSAMarketData         g_market_data;
CGSAMarketGuard        g_market_guard;
CGSAPositionReader     g_position_reader;
CGSARiskManager        g_risk_manager;
CGSASessionManager     g_session_manager;
CGSASignalScorer       g_signal_scorer;
CGSASmartMoneyAnalyzer g_smart_money_analyzer;
CGSATradeManager       g_trade_manager;
CGSATradePlanner       g_trade_planner;
CGSATrendAnalyzer      g_trend_analyzer;
ENUM_GSA_EA_STATE      g_state=GSA_STATE_INITIALIZING;

int OnInit()
  {
   if(!g_config.Initialize(InpMagicNumber,InpRiskPerTradePct,InpMaxDailyLossPct,
                           InpMaxSpreadPoints,InpMaxOpenPositions,InpAllowTrading))
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("Invalid input configuration. EA initialization stopped.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(InpSwingStrength<1 || InpStructureLookback<(InpSwingStrength*2+1) ||
      InpMinimumConfidence<GSA_MIN_CONFIDENCE || InpMinimumConfidence>GSA_MAX_CONFIDENCE ||
      InpStopLossAtrMultiplier<GSA_MIN_ATR_MULTIPLIER ||
      InpRiskRewardRatio<GSA_MIN_RISK_REWARD || InpBreakEvenRiskMultiple<=0.0 ||
      InpTrailingStopAtrMultiplier<GSA_MIN_ATR_MULTIPLIER)
     {
      g_state=GSA_STATE_ERROR;
      g_logger.Error("Invalid analysis, trade-plan, or exit-plan configuration.");
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
   g_logger.Info(StringFormat("Initialized v%s for %s. Planning and exit recommendations are dry-run only.",
                              GSA_VERSION,_Symbol));
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
   if(!g_session_manager.IsActive() || !g_market_guard.IsSpreadAcceptable(g_config))
      return;
   if(!g_daily_loss_guard.IsWithinLimit(g_config))
      return;

   MqlRates bars[];
   if(!g_market_data.GetClosedBars(InpSignalTimeframe,InpStructureLookback,bars))
      return;
   if(!g_closed_bar_gate.IsNew(bars[0].time))
      return;

   double atr=0.0;
   if(!g_indicator_manager.GetAtr(atr) || atr<=0.0)
      return;

   GSA_POSITION_SNAPSHOT position={};
   if(g_position_reader.GetFirstOwnedPosition(g_config,position))
     {
      const GSA_EXIT_RECOMMENDATION recommendation=g_exit_planner.BuildRecommendation(
         position,atr,InpBreakEvenRiskMultiple,InpTrailingStopAtrMultiplier);
      if(InpLogTradePlans && recommendation.valid)
         g_logger.Info(StringFormat("EXIT DRY RUN #%I64u | trigger=%.5f | suggested SL=%.5f | break-even=%s | trailing=%s",
                                    position.ticket,recommendation.trigger_price,
                                    recommendation.suggested_stop_loss,
                                    recommendation.move_to_break_even ? "yes" : "no",
                                    recommendation.trail_stop ? "yes" : "no"));
      return;
     }

   if(!g_trade_manager.HasCapacity(g_config))
      return;
   if(g_config.AllowTrading() && !g_broker_manager.IsTradeEnvironmentReady())
      return;

   const ENUM_GSA_MARKET_TREND trend=g_trend_analyzer.GetTrend(g_indicator_manager);
   const ENUM_GSA_MARKET_STRUCTURE structure=g_smart_money_analyzer.Analyze(
      bars,ArraySize(bars),InpSwingStrength);
   const GSA_SIGNAL_SCORE score=g_signal_scorer.Score(trend,structure,true);
   if(!g_entry_qualifier.IsQualified(score,InpMinimumConfidence))
      return;

   const GSA_TRADE_PLAN plan=g_trade_planner.Create(
      g_config,g_broker_manager,g_risk_manager,score,atr,
      InpStopLossAtrMultiplier,InpRiskRewardRatio);
   if(!plan.valid)
      return;

   if(InpLogTradePlans)
      g_logger.Info(StringFormat("DRY RUN %s | confidence=%.1f | entry=%.5f | SL=%.5f | TP=%.5f | volume=%.2f",
                                 plan.direction==GSA_DIRECTION_BUY ? "BUY" : "SELL",
                                 plan.confidence,plan.entry_price,plan.stop_loss,
                                 plan.take_profit,plan.volume));

   // No order, position-modification, or close request is sent by v0.8.0-alpha.
  }
