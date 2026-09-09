#property copyright "GoldScalper"
#property version   "0.10.0"
#property strict
#property description "Professional MT5 Gold Scalping EA foundation"

#include <GoldScalpAI/AlertLogger.mqh>
#include <GoldScalpAI/BrokerManager.mqh>
#include <GoldScalpAI/ClosedBarGate.mqh>
#include <GoldScalpAI/Config.mqh>
#include <GoldScalpAI/Constants.mqh>
#include <GoldScalpAI/DailyLossGuard.mqh>
#include <GoldScalpAI/Dashboard.mqh>
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
#include <GoldScalpAI/StatisticsManager.mqh>
#include <GoldScalpAI/TradeManager.mqh>
#include <GoldScalpAI/TradePlanner.mqh>
#include <GoldScalpAI/TrendAnalyzer.mqh>

input group "General"
input long   InpMagicNumber       = GSA_DEFAULT_MAGIC;
input bool   InpAllowTrading      = false;
input bool   InpLogTradePlans     = true;
input bool   InpShowDashboard     = true;
input bool   InpLogStatistics     = true;
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

CGSAAlertLogger        g_alert_logger;
CGSABrokerManager      g_broker_manager;
CGSAClosedBarGate      g_closed_bar_gate;
CGSAConfig             g_config;
CGSADailyLossGuard     g_daily_loss_guard;
CGSADashboard          g_dashboard;
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
CGSAStatisticsManager  g_statistics_manager;
CGSATradeManager       g_trade_manager;
CGSATradePlanner       g_trade_planner;
CGSATrendAnalyzer      g_trend_analyzer;
ENUM_GSA_EA_STATE      g_state=GSA_STATE_INITIALIZING;

int OnInit()
  {
   if(!g_config.Initialize(InpMagicNumber,InpRiskPerTradePct,InpMaxDailyLossPct,
                           InpMaxSpreadPoints,InpMaxOpenPositions,InpAllowTrading))
     return INIT_PARAMETERS_INCORRECT;
   if(InpSwingStrength<1 || InpStructureLookback<(InpSwingStrength*2+1) ||
      InpMinimumConfidence<GSA_MIN_CONFIDENCE || InpMinimumConfidence>GSA_MAX_CONFIDENCE ||
      InpStopLossAtrMultiplier<GSA_MIN_ATR_MULTIPLIER || InpRiskRewardRatio<GSA_MIN_RISK_REWARD ||
      InpBreakEvenRiskMultiple<=0.0 || InpTrailingStopAtrMultiplier<GSA_MIN_ATR_MULTIPLIER)
      return INIT_PARAMETERS_INCORRECT;
   if(!g_session_manager.Initialize(InpSessionStartHour,InpSessionEndHour))
      return INIT_PARAMETERS_INCORRECT;
   if(!g_indicator_manager.Initialize(InpSignalTimeframe,InpFastEmaPeriod,InpSlowEmaPeriod,InpAtrPeriod))
      return INIT_FAILED;
   if(!g_market_guard.IsSymbolTradable())
      return INIT_FAILED;
   if(g_config.AllowTrading() && !g_broker_manager.IsTradeEnvironmentReady())
      return INIT_FAILED;

   g_alert_logger.Initialize(g_logger);
   g_state=GSA_STATE_READY;
   g_logger.Info(StringFormat("Initialized v%s for %s. All trade behavior remains dry-run only.",GSA_VERSION,_Symbol));
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   g_indicator_manager.Release();
   if(InpShowDashboard)
      g_dashboard.Clear();
   g_logger.Info(StringFormat("EA stopped. Reason code=%d.",reason));
  }

void OnTick()
  {
   if(g_state!=GSA_STATE_READY || !g_session_manager.IsActive() ||
      !g_market_guard.IsSpreadAcceptable(g_config) || !g_daily_loss_guard.IsWithinLimit(g_config))
      return;

   MqlRates bars[];
   if(!g_market_data.GetClosedBars(InpSignalTimeframe,InpStructureLookback,bars) ||
      !g_closed_bar_gate.IsNew(bars[0].time))
      return;

   double atr=0.0;
   if(!g_indicator_manager.GetAtr(atr) || atr<=0.0)
      return;

   GSA_TRADE_STATISTICS statistics={};
   if(InpLogStatistics && g_statistics_manager.GetToday(g_config,statistics))
      g_logger.Info(StringFormat("STATS TODAY | closed=%d | wins=%d | losses=%d | net=%.2f",
                                 statistics.closed_trades,statistics.wins,statistics.losses,statistics.net_profit));

   GSA_POSITION_SNAPSHOT position={};
   if(g_position_reader.GetFirstOwnedPosition(g_config,position))
     {
      const GSA_EXIT_RECOMMENDATION recommendation=g_exit_planner.BuildRecommendation(position,atr,
         InpBreakEvenRiskMultiple,InpTrailingStopAtrMultiplier);
      if(recommendation.valid)
        {
         const string detail=StringFormat("ticket=%I64u | suggested SL=%.5f",position.ticket,recommendation.suggested_stop_loss);
         g_alert_logger.Emit("EXIT_RECOMMENDATION",detail);
        }
      if(InpShowDashboard)
        {
         GSA_SIGNAL_SCORE empty_score={};
         GSA_TRADE_PLAN empty_plan={};
         g_dashboard.Render(g_state,GSA_TREND_UNKNOWN,GSA_STRUCTURE_UNKNOWN,empty_score,true,empty_plan);
        }
      return;
     }

   if(!g_trade_manager.HasCapacity(g_config) ||
      (g_config.AllowTrading() && !g_broker_manager.IsTradeEnvironmentReady()))
      return;

   const ENUM_GSA_MARKET_TREND trend=g_trend_analyzer.GetTrend(g_indicator_manager);
   const ENUM_GSA_MARKET_STRUCTURE structure=g_smart_money_analyzer.Analyze(bars,ArraySize(bars),InpSwingStrength);
   const GSA_SIGNAL_SCORE score=g_signal_scorer.Score(trend,structure,true);
   GSA_TRADE_PLAN plan={};
   if(g_entry_qualifier.IsQualified(score,InpMinimumConfidence))
      plan=g_trade_planner.Create(g_config,g_broker_manager,g_risk_manager,score,atr,
                                  InpStopLossAtrMultiplier,InpRiskRewardRatio);

   if(InpShowDashboard)
      g_dashboard.Render(g_state,trend,structure,score,false,plan);
   if(!plan.valid)
      return;

   g_alert_logger.Emit("QUALIFIED_PLAN",StringFormat("%s | confidence=%.1f | volume=%.2f",
                      plan.direction==GSA_DIRECTION_BUY ? "BUY" : "SELL",plan.confidence,plan.volume));

   // No order, position-modification, or close request is sent by v0.10.0-alpha.
  }
